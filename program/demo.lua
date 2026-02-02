local nuklear = require 'nuklear'

local ui

function love.load()
	ui = nuklear.newUI()
end

local combo = {value = 1, items = {'A', 'B', 'C'}}

function love.update(dt)
	ui:frameBegin()
	if ui:windowBegin('Simple Example', 100, 100, 200, 160,
			'border', 'title', 'movable') then
		ui:layoutRow('dynamic', 30, 1)
		ui:label('Hello, world!')
		ui:layoutRow('dynamic', 30, 2)
		ui:label('Combo box:')
		if ui:combobox(combo, combo.items) then
			print('Combo!', combo.items[combo.value])
		end
		ui:layoutRow('dynamic', 30, 3)
		ui:label('Buttons:')
		if ui:button('Sample') then
			print('Sample!')
		end
		if ui:button('Button') then
			print('Button!')
		end
	end
	ui:windowEnd()
	ui:frameEnd()
end

function love.draw()
	ui:draw()
end

function love.keypressed(key, scancode, isrepeat)
	ui:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	ui:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	ui:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	ui:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	ui:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
	ui:textinput(text)
end

function love.wheelmoved(x, y)
	ui:wheelmoved(x, y)
end