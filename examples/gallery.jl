scene, layout = layoutscene() 
lscene = layout[1:4,2:4] = Axis(scene)

timeslider = Slider(scene, range = collect(1:50), startvalue = 1)
timenode = timeslider.value
state = @lift(ut[:, 60, $timenode])
scatter!(lscene, state)
@lift(GLMakie.AbstractPlotting.ylims!(lscene, extrema($state)))
layout[2,1] = vgrid!(
    Label(scene, "My slider"), 
    timeslider,
)
display(scene)




## MiniTemplate
scene, layout = layoutscene()
lscene = layout[1:4,2:4] = Axis(scene) 
times = [1, 25, 50]
timenode = Node(times[1]) # timeslider.value
state = @lift(ut[:, 60, $timenode])
scatter!(lscene, state)
@lift(GLMakie.AbstractPlotting.ylims!(lscene, extrema($state)))
timemenu = Menu(scene, options = zip(string.(times), times))
on(timemenu.selection) do s
    timenode[] = s
end
layout[1,1] = vgrid!(
    Label(scene, "My Menu"), 
    timemenu,
)
display(scene)
