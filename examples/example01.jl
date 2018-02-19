G = GUIFrameworkPlayground

b = G.SDL2GUIBackend()
win = G.window(b,800,600)

G.clear!(win)

for i=1:300

    x,y = G.mouse_position(win)  

    G.clear!(win)
    G.rectangle(win,x,y,200,100)

    ev = G.events(win)
    for i=1:length(ev)
        if typeof(ev[i]) == SDL2.KeyboardEvent 
            info(ev[i].keysym)
        end
    end

    G.update!(win)
    sleep(1/30)
end

G.destroy(win)
