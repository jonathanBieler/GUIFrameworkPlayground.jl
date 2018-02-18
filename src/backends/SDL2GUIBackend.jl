struct SDL2GUIBackend <: AbstractGUIBackend
    function SDL2GUIBackend()
        SDL2.init()
        new()
    end
end

struct SDL2Window <: AbstractGUIWindow
    win::SDL2.SDLWindow
    surfaces::SDL2.CairoSDLSurface

    function SDL2Window(w,h,name)
        win = SDL2.SDLWindow(w,h,name)
        surfaces = SDL2.CairoSDLSurface(w,h)
        new(win,surfaces)
    end
end

width(win::SDL2Window)  = win.surfaces.cairo_surface.width
height(win::SDL2Window) = win.surfaces.cairo_surface.height

window(b::SDL2GUIBackend,w,h,name) = SDL2Window(w,h,name)
window(b::SDL2GUIBackend,w,h) =  window(b,w,h,"")

destroy(win::SDL2Window) = SDL2.DestroyWindow(win.win.win)#nice

function update!(win::SDL2Window)

    w, h = width(win), height(win)

    renderer = win.win.renderer
    tex = SDL2.CreateTextureFromSurface(renderer,win.surfaces.SDL_surface)
    SDL2.RenderCopy(renderer, tex, C_NULL, pointer_from_objref(SDL2.Rect(0,0,w,h)))
    SDL2.RenderPresent(renderer)
end

function rectangle(win::SDL2Window,x,y,w,h,color=RGB(0.9,0.9,0.9))
    cr = win.surfaces.cairo_context
    sdl_surf = win.surfaces.SDL_surface

    save(cr)
    set_source_rgb(cr,color.r,color.g,color.b)
    rectangle(cr,x,y,w,h) 
    fill(cr)
    restore(cr)
end

function clear!(win::SDL2Window,color=RGB(1.0,1.0,1.0))
    w, h = width(win), height(win)
    rectangle(win,0,0,w,h,color)
end

function text(win::SDL2Window,str,x,y,color=RGB(0.0,0.0,0.0))

    cr = win.surfaces.cairo_context

    set_source_rgb(cr,color.r,color.g,color.b)
    select_font_face(cr, "monospace", Cairo.FONT_SLANT_NORMAL,Cairo.FONT_WEIGHT_NORMAL)
    set_font_size(cr, 12.0)

    move_to(cr, x, y)
    show_text(cr,str)
end

mouse_position(win::SDL2Window) = SDL2.mouse_position()



##
