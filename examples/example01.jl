using GUIFrameworkPlayground
const G = GUIFrameworkPlayground

#b = G.SDL2GUIBackend()
b = G.OpenGLGUIBackend()

win = G.window(b,800,600)

for i=1:300

    x,y = G.mouse_position(win)  
    
    G.clear!(win)
    G.rectangle(win,x,y,200,100)
    G.text(win,x,y,"rectangle")

    ev = G.events(win)
    for i=1:length(ev)
        G.text(win,10,20*i+10,string(ev[i]))
        if typeof(ev[i]) == SDL2.KeyboardEvent 
           
        end
    end

    G.update!(win)
    sleep(1/30)
end

G.destroy(win)
