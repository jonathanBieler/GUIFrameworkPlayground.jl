module GUIFrameworkPlayground

    using SDL2, Cairo, ColorTypes, Graphics, DataStructures
    using GLVisualize


    import Cairo: rectangle
    import Graphics: width, height
    import GLVisualize: GLWindow, GLFW, ModernGL, GLAbstraction, GeometryTypes

    abstract type AbstractGUIBackend end  

    window(b::AbstractGUIBackend) = error("This method must be implemented.")
    init!(b::AbstractGUIBackend) = error("This method must be implemented.")

    abstract type AbstractGUIWindow end 

    include("backends/SDL2GUIBackend.jl")
    include("backends/OpenGLGUIBackend.jl")
    
end # module

##


##