module GUIFrameworkPlayground

    using SDL2, GLVisualize, Cairo, ColorTypes, Graphics

    import Cairo: rectangle
    import Graphics: width, height
    
    abstract type AbstractGUIBackend end  

    window(b::AbstractGUIBackend) = error("This method must be implemented.")
    init!(b::AbstractGUIBackend) = error("This method must be implemented.")

    abstract type AbstractGUIWindow end 

    include("backends/SDL2GUIBackend.jl")
    
end # module

##


##