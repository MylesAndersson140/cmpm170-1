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
end