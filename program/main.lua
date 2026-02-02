---@diagnostic disable: duplicate-set-field
function love.load()
	ansel_debug = true
	json = require("dkjson")
	ffi = require("ffi")
	nuklear = require("nuklear")
	UI = nuklear.newUI()
	core = require("core")
	settings = require("settings")
	core.on_load()
	styles = require("styles")
	styles.on_load(UI)
	api = require("api")
	audio = require("audio")

	--Prepares audio files
	audio.init()

	--Create the Profiles directory
	love.filesystem.createDirectory("Profiles")
end

function love.update()
	--Main App loop
	core.on_runtime(UI)
end

function love.draw()
	--Main UI loop
	UI:draw()

end


function love.keypressed(key, scancode, isrepeat)
	UI:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	UI:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	UI:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	UI:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	UI:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
	UI:textinput(text)
end

function love.wheelmoved(x, y)
	UI:wheelmoved(x, y)
end