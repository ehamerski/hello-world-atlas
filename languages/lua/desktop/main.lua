-- main.lua - Lua desktop: open a window that shows "Hello, World!".
--
-- Run it with:  ./run.sh   (or: love .   from this folder, if LÖVE is installed)
--
-- LÖVE is a framework for 2D games written in Lua. It is not a library
-- that your program calls: LÖVE is the program, and it calls YOUR functions
-- at the right moments. You only define the functions with the names
-- below. This is a different style from tkinter (Python) or Swing (Java),
-- where your code builds a tree of widgets (labels, buttons) once. A game
-- loop redraws everything many times per second instead.
--
-- Which Lua is this? LÖVE embeds LuaJIT, so this file runs in the Lua 5.1
-- dialect, while ../cli and ../web use Lua 5.5. The hello code is the same
-- in both. The first line of output (see love.load) shows the real runtime.

-- os.getenv reads an environment variable (nil if it is not set). It is
-- used only by the self-check of ./run.sh --verify.
local verify = os.getenv("TF_VERIFY") == "1"

-- The seconds since the program started (only used in verify mode), and a
-- flag so that we print the greeting once, not on every frame.
local elapsed = 0
local printed = false
local font

-- love.load is called once, at the start, after the window has been created.
function love.load()
    -- _VERSION is the Lua language version. "jit" exists only in LuaJIT: on
    -- a plain Lua it is nil, and "a and b" is nil then, so print shows nil.
    -- LÖVE prints:  Lua 5.1  LuaJIT 2.1....
    print(_VERSION, jit and jit.version)
    -- A bigger font than the default (12 pixels), so the text is easy to read.
    font = love.graphics.newFont(32)
    love.graphics.setFont(font)
end

-- love.update is called on every frame with dt, the seconds since the last
-- frame. Game logic goes here; the greeting needs none, except for the
-- self-check, which closes the window after about 2 seconds.
function love.update(dt)
    if verify then
        elapsed = elapsed + dt
        if elapsed >= 2 then
            -- Asks LÖVE to stop its loop and exit, like clicking the close button.
            love.event.quit()
        end
    end
end

-- love.draw is called on every frame, after love.update. Everything drawn
-- here appears in the window. The window is cleared first, so each frame
-- starts from an empty background.
function love.draw()
    local width, height = love.graphics.getDimensions()
    -- printf draws text inside a box that starts at x = 0, y, is "width" pixels
    -- wide, and aligns the text in it ("center"). The y value centers one line.
    love.graphics.printf("Hello, World!", 0, (height - font:getHeight()) / 2, width, "center")

    -- Self-check used by ./run.sh --verify: the first frame has been drawn, so
    -- the window is shown. Print the greeting once to the terminal. (flush
    -- sends it now instead of when the program ends.)
    if verify and not printed then
        printed = true
        print("Hello, World!")
        io.stdout:flush()
    end
end
