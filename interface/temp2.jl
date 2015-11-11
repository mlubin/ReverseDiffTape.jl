#temp2.jl
include("test_xxxlarge.jl") 
 jd = m.internalModel.evaluator.jd
 ex=MathProgBase.obj_expr(jd);
 using ReverseDiffTape
 tt = Tape{Int}()
 p = TV_TYPE()
 tapeBuilder(ex,tt,p)
x=rand(m.numCols);

@time ReverseDiffTape.feval(tt,x,p)
@time MathProgBase.eval_f(jd,x)

Profile.clear_malloc_data()
@time ReverseDiffTape.feval(tt,x,p)
@time MathProgBase.eval_f(jd,x)


gI = Array{Int,1}()
sizehint!(gI, tt.nvnode)
@time ReverseDiffTape.grad_structure(tt,gI)
g = Array{Float64,1}(length(x));
@time ReverseDiffTape.grad_reverse(tt,x,p,g)

jg = Array{Float64,1}(length(x));
@time MathProgBase.eval_grad_f(jd,jg,x)

TapeInterface.assertArrayEqualEps(g,jg)

Profile.clear_malloc_data()
gtuple = Array{Tuple{Int,Float64},1}();
sizehint!(gtuple, tt.nvnode)
@time ReverseDiffTape.grad_reverse(tt,x,p,gtuple)




imm = Array{Float64,1}()
@time ReverseDiffTape.forward_pass(tt,x,p,imm)
g=Array{Tuple{IDX_TYPE,VV_TYPE},1}()
ReverseDiffTape.reverse_pass(tt,imm,g)
ReverseDiffTape.grad_structure(tt,ilist)


sum{ 0.5*h*(u[i+1]^2 + u[i]^2) + 0.5*alpha*h*(cos(    t[i+1]) + cos(t[i])), i = 1:ni}

# julia> ex.args
# 3-element Array{Any,1}:
#  :+                                
#  :(0.5 * x[1] * x[2] - x[1] / x[2])
#  :(x[1] * x[3] * x[4])             
function prepend_test(n)
	t = 0.0
	tic()
	a = Array{Float64,1}()
	for i=1:n
		prepend!(a,[1.1])
	end
	t += toq()
	return t
end

function append_test(n)
	t = 0.0
	tic()
	a = Array{Float64,1}()
	for i=1:n
		append!(a,[1.1])
	end
	t += toq()
	return t
end

function push_pop_test(n)
	t=0.0
	tic()
	a = Array{Float64,1}()
	for i=1:n
		push!(a,1.1)
		v = pop!(a)
	end
	t += toq()
	return t
end

function reverse_test(n)
	t = 0.0
	tic()
	a = Array{Float64,1}(n)
	reverse(a)
	t += toq()
	return t
end

function getll(n)
	t = length(n)
	return t
end


@generated function bar{T}(x::Array{T,1})
	# @show x,n
	args = Array{Any,1}()
	push!(args,:+)
	# @show args

	n = 10
	# ex = :(esc(n))
	for i=1:1:(:($n))
		xargs = Array{Any,1}()
		# @show xargs
		# @show :x
		push!(xargs,:x)
		# @show xargs
		# @show i
		push!(xargs,i)
		# @show xargs
		ex = Expr(:ref, xargs...)
		# @show ex
		push!(args,ex)
	end
	@show args
	return Expr(:call,args...)
end




function mysum(x)
	result = 0.0
	for i in x
		result += i
	end
	return result
end


@generated function foo(x)

return :((0.5 * 0.2 * (x[14] ^ 2 + x[13] ^ 2) + 0.5 * 350 * 0.2 * (cos(x[2]) + cos(x[1]))) + (0.5 * 0.2 * (x[15] ^ 2 + x[14] ^ 2) + 0.5 * 350 * 0.2 * (cos(x[3]) + cos(x[2]))) + (0.5 * 0.2 * (x[16] ^ 2 + x[15] ^ 2) + 0.5 * 350 * 0.2 * (cos(x[4]) + cos(x[3]))) + (0.5 * 0.2 * (x[17] ^ 2 + x[16] ^ 2) + 0.5 * 350 * 0.2 * (cos(x[5]) + cos(x[4]))) + (0.5 * 0.2 * (x[18] ^ 2 + x[17] ^ 2) + 0.5 * 350 * 0.2 * (cos(x[6]) + cos(x[5]))))

end

@generated function foo(x)

return :((0.5 * 0.005 * (x[404] ^ 2 + x[403] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[2]) + cos(x[1]))) + (0.5 * 0.005 * (x[405] ^ 2 + x[404] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[3]) + cos(x[2]))) + (0.5 * 0.005 * (x[406] ^ 2 + x[405] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[4]) + cos(x[3]))) + (0.5 * 0.005 * (x[407] ^ 2 + x[406] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[5]) + cos(x[4]))) + (0.5 * 0.005 * (x[408] ^ 2 + x[407] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[6]) + cos(x[5]))) + (0.5 * 0.005 * (x[409] ^ 2 + x[408] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[7]) + cos(x[6]))) + (0.5 * 0.005 * (x[410] ^ 2 + x[409] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[8]) + cos(x[7]))) + (0.5 * 0.005 * (x[411] ^ 2 + x[410] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[9]) + cos(x[8]))) + (0.5 * 0.005 * (x[412] ^ 2 + x[411] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[10]) + cos(x[9]))) + (0.5 * 0.005 * (x[413] ^ 2 + x[412] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[11]) + cos(x[10]))) + (0.5 * 0.005 * (x[414] ^ 2 + x[413] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[12]) + cos(x[11]))) + (0.5 * 0.005 * (x[415] ^ 2 + x[414] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[13]) + cos(x[12]))) + (0.5 * 0.005 * (x[416] ^ 2 + x[415] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[14]) + cos(x[13]))) + (0.5 * 0.005 * (x[417] ^ 2 + x[416] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[15]) + cos(x[14]))) + (0.5 * 0.005 * (x[418] ^ 2 + x[417] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[16]) + cos(x[15]))) + (0.5 * 0.005 * (x[419] ^ 2 + x[418] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[17]) + cos(x[16]))) + (0.5 * 0.005 * (x[420] ^ 2 + x[419] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[18]) + cos(x[17]))) + (0.5 * 0.005 * (x[421] ^ 2 + x[420] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[19]) + cos(x[18]))) + (0.5 * 0.005 * (x[422] ^ 2 + x[421] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[20]) + cos(x[19]))) + (0.5 * 0.005 * (x[423] ^ 2 + x[422] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[21]) + cos(x[20]))) + (0.5 * 0.005 * (x[424] ^ 2 + x[423] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[22]) + cos(x[21]))) + (0.5 * 0.005 * (x[425] ^ 2 + x[424] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[23]) + cos(x[22]))) + (0.5 * 0.005 * (x[426] ^ 2 + x[425] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[24]) + cos(x[23]))) + (0.5 * 0.005 * (x[427] ^ 2 + x[426] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[25]) + cos(x[24]))) + (0.5 * 0.005 * (x[428] ^ 2 + x[427] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[26]) + cos(x[25]))) + (0.5 * 0.005 * (x[429] ^ 2 + x[428] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[27]) + cos(x[26]))) + (0.5 * 0.005 * (x[430] ^ 2 + x[429] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[28]) + cos(x[27]))) + (0.5 * 0.005 * (x[431] ^ 2 + x[430] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[29]) + cos(x[28]))) + (0.5 * 0.005 * (x[432] ^ 2 + x[431] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[30]) + cos(x[29]))) + (0.5 * 0.005 * (x[433] ^ 2 + x[432] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[31]) + cos(x[30]))) + (0.5 * 0.005 * (x[434] ^ 2 + x[433] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[32]) + cos(x[31]))) + (0.5 * 0.005 * (x[435] ^ 2 + x[434] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[33]) + cos(x[32]))) + (0.5 * 0.005 * (x[436] ^ 2 + x[435] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[34]) + cos(x[33]))) + (0.5 * 0.005 * (x[437] ^ 2 + x[436] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[35]) + cos(x[34]))) + (0.5 * 0.005 * (x[438] ^ 2 + x[437] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[36]) + cos(x[35]))) + (0.5 * 0.005 * (x[439] ^ 2 + x[438] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[37]) + cos(x[36]))) + (0.5 * 0.005 * (x[440] ^ 2 + x[439] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[38]) + cos(x[37]))) + (0.5 * 0.005 * (x[441] ^ 2 + x[440] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[39]) + cos(x[38]))) + (0.5 * 0.005 * (x[442] ^ 2 + x[441] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[40]) + cos(x[39]))) + (0.5 * 0.005 * (x[443] ^ 2 + x[442] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[41]) + cos(x[40]))) + (0.5 * 0.005 * (x[444] ^ 2 + x[443] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[42]) + cos(x[41]))) + (0.5 * 0.005 * (x[445] ^ 2 + x[444] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[43]) + cos(x[42]))) + (0.5 * 0.005 * (x[446] ^ 2 + x[445] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[44]) + cos(x[43]))) + (0.5 * 0.005 * (x[447] ^ 2 + x[446] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[45]) + cos(x[44]))) + (0.5 * 0.005 * (x[448] ^ 2 + x[447] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[46]) + cos(x[45]))) + (0.5 * 0.005 * (x[449] ^ 2 + x[448] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[47]) + cos(x[46]))) + (0.5 * 0.005 * (x[450] ^ 2 + x[449] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[48]) + cos(x[47]))) + (0.5 * 0.005 * (x[451] ^ 2 + x[450] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[49]) + cos(x[48]))) + (0.5 * 0.005 * (x[452] ^ 2 + x[451] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[50]) + cos(x[49]))) + (0.5 * 0.005 * (x[453] ^ 2 + x[452] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[51]) + cos(x[50]))) + (0.5 * 0.005 * (x[454] ^ 2 + x[453] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[52]) + cos(x[51]))) + (0.5 * 0.005 * (x[455] ^ 2 + x[454] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[53]) + cos(x[52]))) + (0.5 * 0.005 * (x[456] ^ 2 + x[455] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[54]) + cos(x[53]))) + (0.5 * 0.005 * (x[457] ^ 2 + x[456] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[55]) + cos(x[54]))) + (0.5 * 0.005 * (x[458] ^ 2 + x[457] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[56]) + cos(x[55]))) + (0.5 * 0.005 * (x[459] ^ 2 + x[458] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[57]) + cos(x[56]))) + (0.5 * 0.005 * (x[460] ^ 2 + x[459] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[58]) + cos(x[57]))) + (0.5 * 0.005 * (x[461] ^ 2 + x[460] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[59]) + cos(x[58]))) + (0.5 * 0.005 * (x[462] ^ 2 + x[461] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[60]) + cos(x[59]))) + (0.5 * 0.005 * (x[463] ^ 2 + x[462] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[61]) + cos(x[60]))) + (0.5 * 0.005 * (x[464] ^ 2 + x[463] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[62]) + cos(x[61]))) + (0.5 * 0.005 * (x[465] ^ 2 + x[464] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[63]) + cos(x[62]))) + (0.5 * 0.005 * (x[466] ^ 2 + x[465] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[64]) + cos(x[63]))) + (0.5 * 0.005 * (x[467] ^ 2 + x[466] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[65]) + cos(x[64]))) + (0.5 * 0.005 * (x[468] ^ 2 + x[467] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[66]) + cos(x[65]))) + (0.5 * 0.005 * (x[469] ^ 2 + x[468] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[67]) + cos(x[66]))) + (0.5 * 0.005 * (x[470] ^ 2 + x[469] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[68]) + cos(x[67]))) + (0.5 * 0.005 * (x[471] ^ 2 + x[470] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[69]) + cos(x[68]))) + (0.5 * 0.005 * (x[472] ^ 2 + x[471] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[70]) + cos(x[69]))) + (0.5 * 0.005 * (x[473] ^ 2 + x[472] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[71]) + cos(x[70]))) + (0.5 * 0.005 * (x[474] ^ 2 + x[473] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[72]) + cos(x[71]))) + (0.5 * 0.005 * (x[475] ^ 2 + x[474] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[73]) + cos(x[72]))) + (0.5 * 0.005 * (x[476] ^ 2 + x[475] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[74]) + cos(x[73]))) + (0.5 * 0.005 * (x[477] ^ 2 + x[476] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[75]) + cos(x[74]))) + (0.5 * 0.005 * (x[478] ^ 2 + x[477] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[76]) + cos(x[75]))) + (0.5 * 0.005 * (x[479] ^ 2 + x[478] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[77]) + cos(x[76]))) + (0.5 * 0.005 * (x[480] ^ 2 + x[479] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[78]) + cos(x[77]))) + (0.5 * 0.005 * (x[481] ^ 2 + x[480] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[79]) + cos(x[78]))) + (0.5 * 0.005 * (x[482] ^ 2 + x[481] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[80]) + cos(x[79]))) + (0.5 * 0.005 * (x[483] ^ 2 + x[482] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[81]) + cos(x[80]))) + (0.5 * 0.005 * (x[484] ^ 2 + x[483] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[82]) + cos(x[81]))) + (0.5 * 0.005 * (x[485] ^ 2 + x[484] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[83]) + cos(x[82]))) + (0.5 * 0.005 * (x[486] ^ 2 + x[485] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[84]) + cos(x[83]))) + (0.5 * 0.005 * (x[487] ^ 2 + x[486] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[85]) + cos(x[84]))) + (0.5 * 0.005 * (x[488] ^ 2 + x[487] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[86]) + cos(x[85]))) + (0.5 * 0.005 * (x[489] ^ 2 + x[488] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[87]) + cos(x[86]))) + (0.5 * 0.005 * (x[490] ^ 2 + x[489] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[88]) + cos(x[87]))) + (0.5 * 0.005 * (x[491] ^ 2 + x[490] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[89]) + cos(x[88]))) + (0.5 * 0.005 * (x[492] ^ 2 + x[491] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[90]) + cos(x[89]))) + (0.5 * 0.005 * (x[493] ^ 2 + x[492] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[91]) + cos(x[90]))) + (0.5 * 0.005 * (x[494] ^ 2 + x[493] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[92]) + cos(x[91]))) + (0.5 * 0.005 * (x[495] ^ 2 + x[494] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[93]) + cos(x[92]))) + (0.5 * 0.005 * (x[496] ^ 2 + x[495] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[94]) + cos(x[93]))) + (0.5 * 0.005 * (x[497] ^ 2 + x[496] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[95]) + cos(x[94]))) + (0.5 * 0.005 * (x[498] ^ 2 + x[497] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[96]) + cos(x[95]))) + (0.5 * 0.005 * (x[499] ^ 2 + x[498] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[97]) + cos(x[96]))) + (0.5 * 0.005 * (x[500] ^ 2 + x[499] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[98]) + cos(x[97]))) + (0.5 * 0.005 * (x[501] ^ 2 + x[500] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[99]) + cos(x[98]))) + (0.5 * 0.005 * (x[502] ^ 2 + x[501] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[100]) + cos(x[99]))) + (0.5 * 0.005 * (x[503] ^ 2 + x[502] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[101]) + cos(x[100]))) + (0.5 * 0.005 * (x[504] ^ 2 + x[503] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[102]) + cos(x[101]))) + (0.5 * 0.005 * (x[505] ^ 2 + x[504] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[103]) + cos(x[102]))) + (0.5 * 0.005 * (x[506] ^ 2 + x[505] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[104]) + cos(x[103]))) + (0.5 * 0.005 * (x[507] ^ 2 + x[506] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[105]) + cos(x[104]))) + (0.5 * 0.005 * (x[508] ^ 2 + x[507] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[106]) + cos(x[105]))) + (0.5 * 0.005 * (x[509] ^ 2 + x[508] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[107]) + cos(x[106]))) + (0.5 * 0.005 * (x[510] ^ 2 + x[509] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[108]) + cos(x[107]))) + (0.5 * 0.005 * (x[511] ^ 2 + x[510] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[109]) + cos(x[108]))) + (0.5 * 0.005 * (x[512] ^ 2 + x[511] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[110]) + cos(x[109]))) + (0.5 * 0.005 * (x[513] ^ 2 + x[512] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[111]) + cos(x[110]))) + (0.5 * 0.005 * (x[514] ^ 2 + x[513] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[112]) + cos(x[111]))) + (0.5 * 0.005 * (x[515] ^ 2 + x[514] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[113]) + cos(x[112]))) + (0.5 * 0.005 * (x[516] ^ 2 + x[515] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[114]) + cos(x[113]))) + (0.5 * 0.005 * (x[517] ^ 2 + x[516] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[115]) + cos(x[114]))) + (0.5 * 0.005 * (x[518] ^ 2 + x[517] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[116]) + cos(x[115]))) + (0.5 * 0.005 * (x[519] ^ 2 + x[518] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[117]) + cos(x[116]))) + (0.5 * 0.005 * (x[520] ^ 2 + x[519] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[118]) + cos(x[117]))) + (0.5 * 0.005 * (x[521] ^ 2 + x[520] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[119]) + cos(x[118]))) + (0.5 * 0.005 * (x[522] ^ 2 + x[521] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[120]) + cos(x[119]))) + (0.5 * 0.005 * (x[523] ^ 2 + x[522] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[121]) + cos(x[120]))) + (0.5 * 0.005 * (x[524] ^ 2 + x[523] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[122]) + cos(x[121]))) + (0.5 * 0.005 * (x[525] ^ 2 + x[524] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[123]) + cos(x[122]))) + (0.5 * 0.005 * (x[526] ^ 2 + x[525] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[124]) + cos(x[123]))) + (0.5 * 0.005 * (x[527] ^ 2 + x[526] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[125]) + cos(x[124]))) + (0.5 * 0.005 * (x[528] ^ 2 + x[527] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[126]) + cos(x[125]))) + (0.5 * 0.005 * (x[529] ^ 2 + x[528] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[127]) + cos(x[126]))) + (0.5 * 0.005 * (x[530] ^ 2 + x[529] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[128]) + cos(x[127]))) + (0.5 * 0.005 * (x[531] ^ 2 + x[530] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[129]) + cos(x[128]))) + (0.5 * 0.005 * (x[532] ^ 2 + x[531] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[130]) + cos(x[129]))) + (0.5 * 0.005 * (x[533] ^ 2 + x[532] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[131]) + cos(x[130]))) + (0.5 * 0.005 * (x[534] ^ 2 + x[533] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[132]) + cos(x[131]))) + (0.5 * 0.005 * (x[535] ^ 2 + x[534] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[133]) + cos(x[132]))) + (0.5 * 0.005 * (x[536] ^ 2 + x[535] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[134]) + cos(x[133]))) + (0.5 * 0.005 * (x[537] ^ 2 + x[536] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[135]) + cos(x[134]))) + (0.5 * 0.005 * (x[538] ^ 2 + x[537] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[136]) + cos(x[135]))) + (0.5 * 0.005 * (x[539] ^ 2 + x[538] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[137]) + cos(x[136]))) + (0.5 * 0.005 * (x[540] ^ 2 + x[539] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[138]) + cos(x[137]))) + (0.5 * 0.005 * (x[541] ^ 2 + x[540] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[139]) + cos(x[138]))) + (0.5 * 0.005 * (x[542] ^ 2 + x[541] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[140]) + cos(x[139]))) + (0.5 * 0.005 * (x[543] ^ 2 + x[542] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[141]) + cos(x[140]))) + (0.5 * 0.005 * (x[544] ^ 2 + x[543] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[142]) + cos(x[141]))) + (0.5 * 0.005 * (x[545] ^ 2 + x[544] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[143]) + cos(x[142]))) + (0.5 * 0.005 * (x[546] ^ 2 + x[545] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[144]) + cos(x[143]))) + (0.5 * 0.005 * (x[547] ^ 2 + x[546] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[145]) + cos(x[144]))) + (0.5 * 0.005 * (x[548] ^ 2 + x[547] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[146]) + cos(x[145]))) + (0.5 * 0.005 * (x[549] ^ 2 + x[548] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[147]) + cos(x[146]))) + (0.5 * 0.005 * (x[550] ^ 2 + x[549] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[148]) + cos(x[147]))) + (0.5 * 0.005 * (x[551] ^ 2 + x[550] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[149]) + cos(x[148]))) + (0.5 * 0.005 * (x[552] ^ 2 + x[551] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[150]) + cos(x[149]))) + (0.5 * 0.005 * (x[553] ^ 2 + x[552] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[151]) + cos(x[150]))) + (0.5 * 0.005 * (x[554] ^ 2 + x[553] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[152]) + cos(x[151]))) + (0.5 * 0.005 * (x[555] ^ 2 + x[554] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[153]) + cos(x[152]))) + (0.5 * 0.005 * (x[556] ^ 2 + x[555] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[154]) + cos(x[153]))) + (0.5 * 0.005 * (x[557] ^ 2 + x[556] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[155]) + cos(x[154]))) + (0.5 * 0.005 * (x[558] ^ 2 + x[557] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[156]) + cos(x[155]))) + (0.5 * 0.005 * (x[559] ^ 2 + x[558] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[157]) + cos(x[156]))) + (0.5 * 0.005 * (x[560] ^ 2 + x[559] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[158]) + cos(x[157]))) + (0.5 * 0.005 * (x[561] ^ 2 + x[560] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[159]) + cos(x[158]))) + (0.5 * 0.005 * (x[562] ^ 2 + x[561] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[160]) + cos(x[159]))) + (0.5 * 0.005 * (x[563] ^ 2 + x[562] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[161]) + cos(x[160]))) + (0.5 * 0.005 * (x[564] ^ 2 + x[563] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[162]) + cos(x[161]))) + (0.5 * 0.005 * (x[565] ^ 2 + x[564] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[163]) + cos(x[162]))) + (0.5 * 0.005 * (x[566] ^ 2 + x[565] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[164]) + cos(x[163]))) + (0.5 * 0.005 * (x[567] ^ 2 + x[566] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[165]) + cos(x[164]))) + (0.5 * 0.005 * (x[568] ^ 2 + x[567] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[166]) + cos(x[165]))) + (0.5 * 0.005 * (x[569] ^ 2 + x[568] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[167]) + cos(x[166]))) + (0.5 * 0.005 * (x[570] ^ 2 + x[569] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[168]) + cos(x[167]))) + (0.5 * 0.005 * (x[571] ^ 2 + x[570] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[169]) + cos(x[168]))) + (0.5 * 0.005 * (x[572] ^ 2 + x[571] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[170]) + cos(x[169]))) + (0.5 * 0.005 * (x[573] ^ 2 + x[572] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[171]) + cos(x[170]))) + (0.5 * 0.005 * (x[574] ^ 2 + x[573] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[172]) + cos(x[171]))) + (0.5 * 0.005 * (x[575] ^ 2 + x[574] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[173]) + cos(x[172]))) + (0.5 * 0.005 * (x[576] ^ 2 + x[575] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[174]) + cos(x[173]))) + (0.5 * 0.005 * (x[577] ^ 2 + x[576] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[175]) + cos(x[174]))) + (0.5 * 0.005 * (x[578] ^ 2 + x[577] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[176]) + cos(x[175]))) + (0.5 * 0.005 * (x[579] ^ 2 + x[578] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[177]) + cos(x[176]))) + (0.5 * 0.005 * (x[580] ^ 2 + x[579] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[178]) + cos(x[177]))) + (0.5 * 0.005 * (x[581] ^ 2 + x[580] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[179]) + cos(x[178]))) + (0.5 * 0.005 * (x[582] ^ 2 + x[581] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[180]) + cos(x[179]))) + (0.5 * 0.005 * (x[583] ^ 2 + x[582] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[181]) + cos(x[180]))) + (0.5 * 0.005 * (x[584] ^ 2 + x[583] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[182]) + cos(x[181]))) + (0.5 * 0.005 * (x[585] ^ 2 + x[584] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[183]) + cos(x[182]))) + (0.5 * 0.005 * (x[586] ^ 2 + x[585] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[184]) + cos(x[183]))) + (0.5 * 0.005 * (x[587] ^ 2 + x[586] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[185]) + cos(x[184]))) + (0.5 * 0.005 * (x[588] ^ 2 + x[587] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[186]) + cos(x[185]))) + (0.5 * 0.005 * (x[589] ^ 2 + x[588] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[187]) + cos(x[186]))) + (0.5 * 0.005 * (x[590] ^ 2 + x[589] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[188]) + cos(x[187]))) + (0.5 * 0.005 * (x[591] ^ 2 + x[590] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[189]) + cos(x[188]))) + (0.5 * 0.005 * (x[592] ^ 2 + x[591] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[190]) + cos(x[189]))) + (0.5 * 0.005 * (x[593] ^ 2 + x[592] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[191]) + cos(x[190]))) + (0.5 * 0.005 * (x[594] ^ 2 + x[593] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[192]) + cos(x[191]))) + (0.5 * 0.005 * (x[595] ^ 2 + x[594] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[193]) + cos(x[192]))) + (0.5 * 0.005 * (x[596] ^ 2 + x[595] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[194]) + cos(x[193]))) + (0.5 * 0.005 * (x[597] ^ 2 + x[596] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[195]) + cos(x[194]))) + (0.5 * 0.005 * (x[598] ^ 2 + x[597] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[196]) + cos(x[195]))) + (0.5 * 0.005 * (x[599] ^ 2 + x[598] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[197]) + cos(x[196]))) + (0.5 * 0.005 * (x[600] ^ 2 + x[599] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[198]) + cos(x[197]))) + (0.5 * 0.005 * (x[601] ^ 2 + x[600] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[199]) + cos(x[198]))) + (0.5 * 0.005 * (x[602] ^ 2 + x[601] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[200]) + cos(x[199]))) + (0.5 * 0.005 * (x[603] ^ 2 + x[602] ^ 2) + 0.5 * 350 * 0.005 * (cos(x[201]) + cos(x[200]))))

end