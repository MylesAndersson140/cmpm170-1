-- conf.lua
-- Configuration file for your Love2D game

function love.conf(t)
    -- Game identity
    t.identity = "mygame"                   -- The name of the save directory
    t.version = "11.4"                      -- The LÖVE version this game was made for (string)
    t.console = false                       -- Attach a console (boolean, Windows only)

    -- Window settings
    t.window.title = "My Game"              -- The window title (string)
    t.window.width = 800                    -- The window width (number)
    t.window.height = 600                   -- The window height (number)
    t.window.borderless = false             -- Remove all border visuals from the window (boolean)
    t.window.resizable = false              -- Let the window be user-resizable (boolean)
    t.window.minwidth = 800                 -- Minimum window width if the window is resizable (number)
    t.window.minheight = 600                -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false             -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop"     -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = 1                      -- Vertical sync mode (number)
    t.window.msaa = 0                       -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.depth = nil                    -- The number of bits per sample in the depth buffer
    t.window.stencil = nil                  -- The number of bits per sample in the stencil buffer
    t.window.display = 1                    -- Index of the monitor to show the window in (number)
    
    -- Modules settings
    t.modules.audio = true                  -- Enable the audio module (boolean)
    t.modules.data = true                   -- Enable the data module (boolean)
    t.modules.event = true                  -- Enable the event module (boolean)
    t.modules.font = true                   -- Enable the font module (boolean)
    t.modules.graphics = true               -- Enable the graphics module (boolean)
    t.modules.image = true                  -- Enable the image module (boolean)
    t.modules.joystick = true               -- Enable the joystick module (boolean)
    t.modules.keyboard = true               -- Enable the keyboard module (boolean)
    t.modules.math = true                   -- Enable the math module (boolean)
    t.modules.mouse = true                  -- Enable the mouse module (boolean)
    t.modules.physics = true                -- Enable the physics module (boolean)
    t.modules.sound = true                  -- Enable the sound module (boolean)
    t.modules.system = true                 -- Enable the system module (boolean)
    t.modules.thread = true                 -- Enable the thread module (boolean)
    t.modules.timer = true                  -- Enable the timer module (boolean)
    t.modules.touch = true                  -- Enable the touch module (boolean)
    t.modules.video = true                  -- Enable the video module (boolean)
    t.modules.window = true                 -- Enable the window module (boolean)
end