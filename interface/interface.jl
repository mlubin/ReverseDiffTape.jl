
module TapeInterface

using ReverseDiffTape

import MathProgBase

const EPS=1e-10

###############################################################
#
#  TapeSolver
#
################################################################
type TapeSolver <: MathProgBase.AbstractMathProgSolver
	s::MathProgBase.AbstractMathProgSolver
end
export TapeSolver

type TapeData <: MathProgBase.AbstractMathProgModel
    evaluator   ##cannot be typed ? why
    m::MathProgBase.AbstractMathProgModel
end


function MathProgBase.model(solver::TapeSolver)
	println("TapeSolver model")
	return TapeData(nothing,MathProgBase.model(solver.s))
end 

function MathProgBase.setwarmstart!(m::TapeData, x) 
    return MathProgBase.setwarmstart!(m.m,x)
end

function MathProgBase.status(m::TapeData)
    # @show m.evaluator
    # @show m.evaluator.eval_f_timer
    # @show m.evaluator.eval_g_timer
    # @show m.evaluator.eval_grad_f_timer
    # @show m.evaluator.eval_jac_g_timer
    # @show m.evaluator.eval_hesslag_timer
    
    # @show m.evaluator.jd.eval_f_timer
    # @show m.evaluator.jd.eval_g_timer
    # @show m.evaluator.jd.eval_grad_f_timer
    # @show m.evaluator.jd.eval_jac_g_timer
    # @show m.evaluator.jd.eval_hesslag_timer
    
    return MathProgBase.status(m.m)
end

function MathProgBase.getobjval(m::TapeData)
    return MathProgBase.getobjval(m.m)
end

function MathProgBase.getsolution(m::TapeData)
    return MathProgBase.getsolution(m.m)
end

function MathProgBase.getreducedcosts(m::TapeData)
    return MathProgBase.getreducedcosts(m.m)
end

function MathProgBase.getconstrduals(m::TapeData)
    return MathProgBase.getconstrduals(m.m)
end

function MathProgBase.loadnonlinearproblem!(m::TapeData, numVar, numConstr, l, u, lb, ub, sense, jd::MathProgBase.AbstractNLPEvaluator)
    println("TapeData - loadnonlinearproblem")
    # if(jd.eval_f_timer>0.0)
    #     @show typeof(m.evaluator)
    #     @show m.evaluator
    #     tape_evaluator::MathProgBase.SolverInterface.AbstractNLPEvaluator = m.evaluator
    #     println("tape_evaluator arleady set")
    # else
        tape_evaluator = TapeNLPEvaluator(jd,numVar,numConstr)
        m.evaluator = tape_evaluator
        println("tape_evaluator is set")
    # end
    MathProgBase.loadnonlinearproblem!(m.m,numVar,numConstr,l,u,lb,ub,sense,tape_evaluator)
end

function MathProgBase.optimize!(m::TapeData)
    MathProgBase.optimize!(m.m)
end

###############################################################
#
#  TapeEvaluator
#
################################################################
type TapeNLPEvaluator <: MathProgBase.AbstractNLPEvaluator
    jd::MathProgBase.AbstractNLPEvaluator
    numVar::Int
    numConstr::Int
    pvals::TV_TYPE
    obj_tt::TT_TYPE
    constr_tt::Array{TT_TYPE,1}

    jac_I::Array{Int,1}
    jac_J::Array{Int,1}
    jac_nnz::Int

    laghess_I::Array{Int,1}
    laghess_J::Array{Int,1}
    laghess_nnz::Bool

    # timers
    eval_f_timer::Float64
    eval_g_timer::Float64
    eval_grad_f_timer::Float64
    eval_jac_g_timer::Float64
    eval_hesslag_timer::Float64

    jeval_f_timer::Float64
    jeval_g_timer::Float64
    jeval_grad_f_timer::Float64
    jeval_jac_g_timer::Float64
    jeval_hesslag_timer::Float64


end

function TapeNLPEvaluator(nlpe::MathProgBase.AbstractNLPEvaluator,numVar,numConstr)
 	return TapeNLPEvaluator(nlpe, 
        numVar,numConstr,TV_TYPE(), TT_TYPE(), 
        Array{TT_TYPE,1}(), 
        Array{Int,1}(), Array{Int,1}(),-1,
        Array{Int,1}(), Array{Int,1}(),false, 
        0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0)
end

function MathProgBase.initialize(d::TapeNLPEvaluator, requested_features::Vector{Symbol})
	println("TapeNLPEvaluator - initialize")
	@show d.eval_f_timer
    @show d.eval_grad_f_timer
    @show d.eval_g_timer
    @show d.eval_jac_g_timer 
    @show d.eval_hesslag_timer

    jd = d.jd
    MathProgBase.initialize(jd,[:Grad,:Jac,:ExprGraph,:Hess])
    @show jd.eval_f_timer
    @show jd.eval_grad_f_timer
    @show jd.eval_g_timer
    @show jd.eval_jac_g_timer 
    @show jd.eval_hesslag_timer

    # if(d.eval_f_timer > 0.0)
    #     println("return - already init")
    #     return  #already initialized
    # end
    # @show requested_features

	
    # @show jd.eval_f_timer
    # @show jd.eval_grad_f_timer
    # @show jd.eval_g_timer
    # @show jd.eval_jac_g_timer 
    # @show jd.eval_hesslag_timer

	#let's building up the tape
    tic()

	objexpr = MathProgBase.obj_expr(jd)
    # @show objexpr
   
	assert(length(d.pvals) == 0)  ## assume no values in pvals
	tapeBuilder(objexpr,d.obj_tt,d.pvals)

    for i =1:1:d.numConstr
	   conexpr = MathProgBase.constr_expr(jd,i)
       # @show conexpr.args[1]
       tt = TT_TYPE()
       tapeBuilder(conexpr.args[1],tt,d.pvals)
       push!(d.constr_tt,tt)
       # @show d.constr_tt[i]
    end
    assert(length(d.constr_tt) == d.numConstr)
    tprep = toq()
    println("TapeNLPEvaluator - initialize takes ",tprep)
    
    # reset timers
    d.eval_f_timer = 0.0
    d.eval_grad_f_timer = 0.0
    d.eval_g_timer = 0.0
    d.eval_jac_g_timer = 0.0
    d.eval_hesslag_timer = 0.0

    d.jeval_f_timer = 0.0
    d.jeval_grad_f_timer = 0.0
    d.jeval_g_timer = 0.0
    d.jeval_jac_g_timer = 0.0
    d.jeval_hesslag_timer = 0.0

    nothing
end

MathProgBase.features_available(d::TapeNLPEvaluator) = [:Grad, :Jac, :Hess, :HessVec]

#evaluate the objective function given on iterate x
function MathProgBase.eval_f(d::TapeNLPEvaluator, x)
    tic()
    v = feval(d.obj_tt,x,d.pvals)
    d.eval_f_timer += toq()
    
    tic()
    jv = MathProgBase.eval_f(d.jd,x)
    d.jeval_f_timer += toq()
    assert(jv == v)
    return v
end

#evaluate the objective gradient on given iterate x. Results is set to g
function MathProgBase.eval_grad_f(d::TapeNLPEvaluator, g, x)
    # @show x
    assert(length(g) == length(x))
    fill!(g,0.0)
    tic()
    grad = Array{Tuple{Int, Float64},1}()
    grad_reverse(d.obj_tt,x,d.pvals,grad)
    for i=1:length(grad)
        (idx,v) = grad[i]
        g[idx] += v
    end

    d.eval_grad_f_timer += toq()
    # @show g
   
    tic()
    jg = Array{Float64,1}(length(x))
    MathProgBase.eval_grad_f(d.jd,jg,x)
    d.jeval_grad_f_timer += toq()
    # @show jg
    
    # temp = Array{Float64,1}(length(g))
    # fill!(temp,EPS)
    assertArrayEqualEps(g,jg)
    return
end

#constraint evaluation
function MathProgBase.eval_g(d::TapeNLPEvaluator, g, x)
    assert(length(g) == d.numConstr)
    tic()
    for i=1:1:d.numConstr
        g[i]=feval(d.constr_tt[i],x,d.pvals)
    end
    d.eval_g_timer += toq()
    # @show g

    tic()
    jg = Array{Float64,1}(length(g))
    MathProgBase.eval_g(d.jd,jg,x)
    d.jeval_g_timer += toq()
    # @show jg

    # temp = Array{Float64,1}(length(g))
    # fill!(temp,EPS)
    assertArrayEqualEps(g,jg)
    return
end


function MathProgBase.jac_structure(d::TapeNLPEvaluator)
    # @show "MathProgBase.jac_structure"
    if(d.jac_nnz != -1) 
        return d.jac_I, d.jac_J
    end

    I = Array{Int, 1}()
    J = Array{Int, 1}()
    idxes = Array{Int,1}()
    for i=1:1:d.numConstr
        grad_structure(d.constr_tt[i],idxes)
        state = start(idxes)
        while !done(idxes,state)
            (j,state) = next(idxes,state)
            push!(I,i)
            push!(J,j)
        end
        empty!(idxes)
    end
    # @show I
    # @show J
    
    assert(length(I) == length(J))
    V = ones(Float64,length(I))
    csc = sparse(I,J,V)

    (jI, jJ) = MathProgBase.jac_structure(d.jd)
    assert(length(jI) == length(jJ))
    jV = ones(Float64,length(jI))
    jcsc = sparse(jI,jJ,jV)
    # @show jI
    # @show jJ

    # @show csc
    # @show jcsc
    # @show csc.colptr
    # @show jcsc.colptr
    assert(csc.colptr == jcsc.colptr)
    assert(csc.rowval == jcsc.rowval)
    assert(csc.m == jcsc.m)
    assert(csc.n == jcsc.n)

    d.jac_nnz = length(I)
    d.jac_I = I
    d.jac_J = J
    return d.jac_I, d.jac_J
end

function MathProgBase.eval_jac_g(d::TapeNLPEvaluator, J, x)
    # @show x
    assert(d.jac_nnz != -1)
    assert(length(d.jac_I) == length(d.jac_J))
    assert(length(J) == d.jac_nnz)

    tic()
    g = Array{Tuple{Int,Float64},1}()
    prev_row = 0
    for i = 1:1:length(d.jac_I)
        row = d.jac_I[i]
        if(row!=prev_row) 
            grad_reverse(d.constr_tt[row],x,d.pvals,g) #sparse version
        end
        prev_row = row
    end   

    for i =1:length(g)
        (idx,v) = g[i]
        J[i] = v
    end
    d.eval_jac_g_timer += toq()
    

    csc = sparse(d.jac_I,d.jac_J,J)

    tic()
    jJ = zeros(Float64,length(d.jd.jac_I))
    MathProgBase.eval_jac_g(d.jd,jJ,x)
    d.jeval_jac_g_timer += toq()

    jcsc = sparse(d.jd.jac_I,d.jd.jac_J,jJ)

    
    assert(csc.colptr == jcsc.colptr)
    assert(csc.rowval == jcsc.rowval)
    # @show csc.nzval
    # @show jcsc.nzval
    assertArrayEqualEps(csc.nzval,jcsc.nzval)
    assert(csc.m == jcsc.m)
    assert(csc.n == jcsc.n)

    # @show d.eval_jac_g_timer
    # @show d.jd.eval_jac_g_timer
    return
end

function MathProgBase.eval_hesslag_prod(
    d::TapeNLPEvaluator,
    h::Vector{Float64}, # output vector
    x::Vector{Float64}, # current solution
    v::Vector{Float64}, # rhs vector
    σ::Float64,         # multiplier for objective
    μ::Vector{Float64}) # multipliers for each constraint

    assert(false)    
    MathProgBase.eval_hesslag_prod(d,h,x,v,σ,μ)
end

function MathProgBase.hesslag_structure(d::TapeNLPEvaluator)
    # @show "MathProgBase.hesslag_structure" 
    if(d.laghess_nnz)
        return d.laghess_I, d.laghess_J        
    end
    I = Array{Int,1}()
    J = Array{Int,1}()

    veset = Set{Edge}()
    # println("obj ",MathProgBase.obj_expr(d.jd))
    hess_structure(d.obj_tt,veset)

    for i=1:d.numConstr
        # println(i," ",MathProgBase.constr_expr(d.jd,i))
        hess_structure(d.constr_tt[i],veset)
    end
    
    state = start(veset)
    while !done(veset,state)
        (e,state) = next(veset,state)
        push!(I,e.lidx)
        push!(J,e.ridx)
    end

    assert(length(I) == length(J))
    V = ones(Float64,length(I))
    csc = sparse(I,J,V)
    # @show I
    # @show J


    (jI, jJ) = MathProgBase.hesslag_structure(d.jd)
    assert(length(jI) == length(jJ))
    jV = ones(Float64,length(jI))
    jcsc = sparse(jI,jJ,jV)
    # @show jI
    # @show jJ

    # @show csc
    # @show jcsc
    # @show csc.colptr
    # @show jcsc.colptr
    # assert(csc.colptr == jcsc.colptr)
    # assert(csc.rowval == jcsc.rowval)
    # assert(csc.m == jcsc.m)
    # assert(csc.n == jcsc.n)
    
    d.laghess_nnz = true
    d.laghess_I = I
    d.laghess_J = J
    return  d.laghess_I, d.laghess_J
end

function MathProgBase.eval_hesslag(
    d::TapeNLPEvaluator,
    H::Vector{Float64},         # Sparse hessian entry vector
    x::Vector{Float64},         # Current solution
    obj_factor::Float64,        # Lagrangian multiplier for objective
    lambda::Vector{Float64})    # Multipliers for each constraint
    
    assert(length(lambda) == d.numConstr)
    assert(length(H) == length(d.laghess_J))
    assert(length(H) == length(d.laghess_I))

    tic()
    eset = EdgeSet()
    reverse_hess_ep(d.obj_tt,x,d.pvals,obj_factor,eset)

    for i=1:d.numConstr
        reverse_hess_ep(d.constr_tt[i],x,d.pvals,lambda[i],eset)
    end

    j = 1
    state = start(eset)
    while !done(eset,state)
        (e,state) = next(eset,state)
        H[j] = e.second
        j += 1
    end

    ### or using BLAS function -- not sure
    # obj_hess = sparse(d.laghess_I,d.laghess_J)
    # 
    # 
    d.eval_hesslag_timer += toq()

    # csc = sparse(d.laghess_I,d.laghess_J,H)
    # @show csc

    tic()
    jH = Array{Float64,1}(length(d.jd.hess_I))
    MathProgBase.eval_hesslag(d.jd,jH,x,obj_factor,lambda)
    d.jeval_hesslag_timer += toq()


    # @show d.jd.hess_I
    # @show d.jd.hess_J
    # @show jH
    # jcsc = sparse(d.jd.hess_I,d.jd.hess_J,jH)
    # @show jcsc
    # assert(csc.colptr == jcsc.colptr)
    # assert(csc.rowval == jcsc.rowval)
    # assert(csc.m == jcsc.m)
    # assert(csc.n == jcsc.n)
    
    # @show d.eval_hesslag_timer
    # @show d.jd.eval_hesslag_timer
    return
end

function assertArrayEqualEps(a1,a2)
    assert(length(a1)==length(a2))
    for i=1:length(a1)
        assert(abs(a1[i]-a2[i])<EPS)
    end
end

end

#########

