module ReverseDiffTape

using DataStructures
using Logging
using Calculus

importall Base

# package code goes here
function __init__()
	Logging.configure(level=DEBUG)
	debug("loading ReverseDiffTape.jl")
end

export
#constant
	OP, OC_TO_OP,
#types
	IDX_TYPE, TT_TYPE, TV_TYPE, TV_STACK, VV_TYPE, TYPE_V, TYPE_P, TYPE_OU, TYPE_OB,
#Objects
	AD_O, AD_P, AD_V, Edge, EdgeSet,
#Functions
	tapeBuilder, #building tape from Julia expression 
	feval, grad_reverse, reverse_hess_ep, grad_structure, hess_structure


include("./types.jl")
include("./operator.jl")
include("./func_eval.jl")
include("./reverse_grad.jl")
include("./reverse_hess_ep.jl")


end # module
