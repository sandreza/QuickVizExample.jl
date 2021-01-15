include(pwd() * "/src/vizinanigans.jl")
states = [randn(10,10,10)]
statenames = ["Random Data"]
volumeslice(states, statenames = statenames)