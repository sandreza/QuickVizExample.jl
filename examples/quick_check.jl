# include(pwd() * "/src/vizinanigans.jl")
using QuickVizExample
states = [randn(10,10,10)]
statenames = ["Random Data"]
volumeslice(states, statenames = statenames)