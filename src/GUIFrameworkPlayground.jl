module GUIFrameworkPlayground

    using SDL2, GLVisualize, Cairo, ColorTypes, Graphics

    import Cairo: rectangle
    import Graphics: width, height
    
    abstract AbstractGUIBackend 

    window(b::AbstractGUIBackend) = error("This method must be implemented.")
    init!(b::AbstractGUIBackend) = error("This method must be implemented.")

    abstract AbstractGUIWindow 

    include("backends/SDL2GUIBackend.jl")
    
end # module

##

G = GUIFrameworkPlayground

b = G.SDL2GUIBackend()
win = G.window(b,800,600)

#G.clear!(win)

for i=1:100

    x,y = G.mouse_position(win)  

    G.rectangle(win,x,y,200,100)
    G.text(win,"hellow world",x,y)

    G.update!(win)
    sleep(1/30)
end

G.destroy(win)
##

e = SDL2.Event(ntuple(i->0,56))
SDL2.PollEvent(pointer_from_objref(e))
e
#e(1) is event type

##