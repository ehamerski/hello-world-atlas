-- conf.lua - Lua desktop: window settings, read by LÖVE before the window exists.
--
-- LÖVE runs this file first (if it exists). It must define a function
-- called love.conf; LÖVE calls it with a table "t" full of default
-- settings, and the function changes only what it wants to change. Here:
-- the title of the window and its size in pixels (the default is 800x600).
--
-- This file is Lua 5.1 code, because LÖVE runs it with LuaJIT. Nothing
-- here would change in Lua 5.5.
function love.conf(t)
    t.window.title = "Hello, World!"  -- the text in the window's title bar
    t.window.width = 480
    t.window.height = 200
end
