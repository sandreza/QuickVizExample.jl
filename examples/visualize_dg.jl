include(pwd() * "/examples/boiler_plate.jl")
# include(pwd() * "/src/bigfileofstuff.jl")
using QuickVizExample

jldfile = jldopen("example.jld2")
##
# reconstruct grid
Ω = jldfile["Ω"]
elements = jldfile["elements"]
polynomialorder = jldfile["polynomialorder"]
periodicity = (true, true, false)
dgΩ = DiscontinuousSpectralElementGrid(Ω, periodicity = periodicity, 
    elements = elements, polynomialorder = polynomialorder, 
    mpicomm=MPI.COMM_WORLD, array = Array)
# construct gridhelpers
gridhelper = GridHelper(dgΩ)
x, y, z = coordinates(dgΩ)
ϕ = ScalarField(copy(x), gridhelper)

# construct new grid
xnew = range(Ω[1][1], Ω[1][2], length = 128)
ynew = range(Ω[2][1], Ω[2][2], length = 128)
znew = range(Ω[3][1], Ω[3][1], length = 1)

# load data
u = jldfile["velocity_u"]
v = jldfile["velocity_v"]
η = jldfile["scalar_η"]
c = jldfile["scalar_c"]

# interpolate each moment in time to a new grid
nt = length(u) 
ut = zeros(length(xnew), length(ynew), nt)
vt = zeros(length(xnew), length(ynew), nt)
ηt = zeros(length(xnew), length(ynew), nt)
ct = zeros(length(xnew), length(ynew), nt)
tic = time()
trange = collect(1:nt)
for i in 1:nt
    ϕ .= u[i]
    ut[:, :, i] .= view(ϕ(xnew, ynew, znew), :, :, 1)
    ϕ .= v[i]
    vt[:, :, i] .= view(ϕ(xnew, ynew, znew), :, :, 1)
    ϕ .= η[i]
    ηt[:, :, i] .= view(ϕ(xnew, ynew, znew), :, :, 1)
    ϕ .= c[i]
    ct[:, :, i] .= view(ϕ(xnew, ynew, znew), :, :, 1)
end
toc = time()
println("interpolation time is $(toc - tic) seconds")
# visualize (z-axis is time here)
states = [ut, vt, ηt, ct]
statenames = ["u", "v", "η", "c"]
scene = volumeslice(states, statenames = statenames)
visualize(states)
visualize([ut[:,:,1]])

##
seconds = 5
fps = 30
frames = round(Int, fps * seconds )
record(scene, pwd() * "/example.mp4"; framerate = fps) do io
    for i = 1:frames
        sleep(1/fps)
        recordframe!(io)
    end
end
