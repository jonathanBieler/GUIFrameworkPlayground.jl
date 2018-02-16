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

G = GUIFrameworkPlayground

b = G.SDL2GUIBackend()
win = G.window(b,800,600)

G.rectangle(win,100,100,200,100)
G.update!(win)

sleep(1.0)

G.destroy(win)