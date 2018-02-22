struct OpenGLGUIBackend <: AbstractGUIBackend
    function OpenGLGUIBackend()
        GLFW.Init()
        new()
    end
end

mutable struct OpenGLWindow <: AbstractGUIWindow
    screen::GLWindow.Screen
    events::Queue{Any}
    mouse_position::Tuple{Float64,Float64}
    
    function OpenGLWindow(w,h,name)
        screen =  GLWindow.Screen(name, resolution=(w,h))
        GLVisualize.add_screen(screen)
        GLWindow.add_complex_signals!(screen) #add the drag events and such
        GLFW.MakeContextCurrent(GLWindow.nativewindow(screen))

        events = Queue(Any)
        win = new(screen,events,(0.,0.))
        
        GLFW.SetKeyCallback(screen.glcontext.window, (_, key, scancode, action, mods) -> begin
            enqueue!(events,("Key", key, scancode, action, mods))
        end)
        GLFW.SetMouseButtonCallback(screen.glcontext.window, (_, button, action, mods) -> begin
            enqueue!(events,("Button", button, action, mods))
        end)
        GLFW.SetCursorPosCallback(screen.glcontext.window, (_, x, y) -> begin
            win.mouse_position = (x,y)
            enqueue!(events,("Cursor", x, y))
        end)

        win
    end
end

width(win::OpenGLWindow)  = GLWindow.widths(win.screen)[1]
height(win::OpenGLWindow) = GLWindow.widths(win.screen)[2]

window(b::OpenGLGUIBackend,w,h,name) = OpenGLWindow(w,h,name)
window(b::OpenGLGUIBackend,w,h) =  window(b,w,h,"")

destroy(win::OpenGLWindow) = GLFW.DestroyWindow(win.screen.glcontext.window)

function update!(win::OpenGLWindow)

    GLWindow.render_frame(win.screen)
    GLWindow.swapbuffers(win.screen)
    GLWindow.poll_glfw()
    yield()
end

function rectangle(win::OpenGLWindow,x,y,w,h,color=RGB(0.9,0.9,0.9))
    _view( visualize(GLVisualize.SimpleRectangle{Float32}(x,height(win)-y-h,w,h), color=color), win.screen )
end

function clear!(win::OpenGLWindow,color=RGB(1.0,1.0,1.0))
    
    ModernGL.glClearColor(red(color), green(color), blue(color), 1)
    GLWindow.clear_all!(win.screen)
    GLWindow.empty!(win.screen)
end

function text(win::OpenGLWindow,x,y,str::String,color=RGB(0.0,0.0,0.0))
    _view( visualize(
        str, color=color,
        model = GLAbstraction.translationmatrix(GeometryTypes.Vec3f0(x,height(win)-y,0)),
    ), win.screen )
end

mouse_position(win::OpenGLWindow) = win.mouse_position 

function events(win::OpenGLWindow)
    out = []
    ev = win.events
    while !isempty(ev)
        push!(out,dequeue!(ev))
    end
    out
end 



##
