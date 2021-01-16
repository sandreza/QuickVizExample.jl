module QuickVizExample

include("bigfileofstuff.jl")
export cellaverage, coordinates, GridHelper

include("vizinanigans.jl")
export volumeslice, visualize

include("scalarfields.jl")
export ScalarField

end # module
