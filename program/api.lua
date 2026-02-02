api = {}

function api.text(ui,type,text,var1,var2,var3)
	local NormalFont = styles.font.Normal 
	local HeaderFont = styles.font.Header
	local BoldFont = styles.font.NormalBold 
	if type == "normal" then
		local VSep = var1 or styles.defaultVerticalSpacing
		local HSep = var2 or styles.defaultHorizontalSpacing
		ui:styleSetFont(NormalFont)
		ui:layoutRow("dynamic",VSep,1)
		ui:label(text)
	elseif type == "bold" then
		local VSep = var1 or styles.defaultVerticalSpacing
		local HSep = var2 or styles.defaultHorizontalSpacing
		ui:styleSetFont(BoldFont)
		ui:layoutRow("dynamic",VSep,1)
		ui:label(text)
	elseif type == "header" then
		local VSep = var1 or styles.defaultVerticalSpacing
		local HSep = var2 or styles.defaultHorizontalSpacing
		ui:styleSetFont(HeaderFont)
		ui:layoutRow("dynamic",VSep,1)
		ui:label(text)
	elseif type == "label" then
		local label = var1 or "Label"
		local VSep = var2 or styles.defaultVerticalSpacing
		local HSep = var3 or styles.defaultHorizontalSpacing
		ui:layoutRow('dynamic', VSep, {0.25, 0.75})
		ui:styleSetFont(BoldFont)
		ui:label(label..":","left")
		ui:styleSetFont(NormalFont)
		ui:label(text)
	elseif type == "label-custom" then
		local label = var1 or "Label"
		local VSep = var2 or styles.defaultVerticalSpacing
		local HSep = var3 or styles.defaultHorizontalSpacing
		ui:layoutRow('dynamic', VSep, HSep)
		ui:styleSetFont(BoldFont)
		ui:label(label..":","left")
		ui:styleSetFont(NormalFont)
		ui:label(text)
	end
end

function api.simpletext(ui,text,size,bold,allignment)
	local font
	local align
	if bold then
		font = styles.fonts.request("Bold",size,"Roboto-Bold")
	else
		font = styles.fonts.request("Normal",size,"Roboto-Regular")
	end
	if allignment == "left" or allignment == nil then
		align = "left"
	elseif allignment == "center" then
		align = "centered"
	elseif allignment == "right" then
		allign = "right"
	else
		align = "left"
	end
	local spacing = styles.defaultVerticalSpacing*(size/15)
	ui:layoutRow("dynamic",spacing,1)
	if font then
		ui:styleSetFont(font)
	else
		print("Error has occured in simpletext api")
	end
	ui:label(text,align)
end

api.timer = {}
api.timers = {}

function api.timer.start(name)
	if name then
		api.timers[name] = love.timer.getTime()
	end
end

function api.timer.exists(name)
	if api.timers[name] and name then
		return true
	else
		return false
	end
end

function api.timer.delete(name)
	if api.timer.exists(name) then
		api.timers[name] = nil
		return true
	else
		return false
	end
end

function api.timer.value(name,type)
	local mul = 0
	if type == "sec" then
		mul = 1
	elseif type == "ms" then
		mul = 1000
	else
		mul = 1
	end
	if api.timer.exists(name) then
		local timer = api.timers[name]
		local current = love.timer.getTime()
		local result =  math.floor((current - timer)*mul)
		return result
	else
		return 0
	end
end

function api.ColoredCircle(ui,value,x,y,r)
	--love.graphics.push()
	if value == true then
		love.graphics.setColor(love.math.colorFromBytes(213, 86, 0))
	elseif value == false  then
		love.graphics.setColor(love.math.colorFromBytes(153, 229, 80))
	elseif value == nil then
		love.graphics.setColor(love.math.colorFromBytes(165, 5, 5))
	end
	ui:circle('fill', x, y, r)
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
	--love.graphics.pop()
end

function api.tostring(boolean)
	if boolean then
		return "true"
	else
		return "false"
	end
end

function api.tostring2(boolean)
	if boolean == nil then
		return "false"
	else
		return "true"
	end
end

function api.fingertotext(option)
	if option == 1 then
		return "Thumb"
	elseif option == 2 then
		return "Index"
	elseif option == 3 then
		return "Middle"
	elseif option == 4 then
		return "Ring"
	elseif option == 5 then
		return "Pinky"
	end
end

function api.texttofinger(option)
	if option == "Thumb" then
		return 1
	elseif option == "Index" then
		return 2
	elseif option == "Middle" then
		return 3
	elseif option == "Ring" then
		return 4
	elseif option == "Pinky" then
		return 5
	end
end

function api.GetFormattedTime()
   return os.date("D%Y-%m-%d T%H-%M-%S", t)
end

function api.savetest(name,file,format)
	if file and name then
		success, message = love.filesystem.write(name,file)
		if success then
			if format == nil then
				return name.." saved successfully"
			elseif format == 1 then
				return success
			end
		else
			if format == nil then
				print("Error in save: "..name.."not saved: "..message)
				return name.."not saved: "..message
			elseif format == 1 then
				return success
			end
		end
	else
		return "Unable to save: nil values"
	end
end

function api.formatbol(boolean,type)
	if type == "number" then
		if boolean then
			return 1
		else
			return 2
		end
	elseif boolean == "string" then
		if boolean then
			return "true"
		else
			return "false"
		end
	elseif boolean == "table" then
		return {true,false}
	elseif boolean == "string table" then
		return {"true","false"}
	else
		return boolean
	end
end

function api.tobol(value)
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	elseif value==1 then
		return true
	elseif value == 2 or value == 0 then
		return false
	end
end

function api.isTable(tab)
	if type(tab) == "table" then
		return true
	else
		return false
	end
end

function api.deepcopy(data)
	if api.isTable(data) then
		local ret = {}
		for name, info in pairs(data) do
			if not api.isTable(info) then
				ret[name] = info
			else
				ret[name] = api.deepcopy(info)
			end
		end
		return ret
	end
end

function api.printtable(data,printv)
	local toprint = ""
	if api.isTable(data) then
		for i,v in pairs(data) do
			if not api.isTable(v) then
				if toprint == "" then
					toprint = "{"..tostring(v)
				else
					toprint = toprint..","..tostring(v)
				end
			else
				toprint = toprint..","..i.."="..api.printtable(v,true)
			end
		end
		if not printv then print(toprint.."}") end
		return(toprint.."}")
	else
		if not printv then print(data) end
		return(data)
	end
end

function api.clamp(number,min,max)
	local result = 0
	if type(number) == "number" and type(min) == "number" and type(max) == "number" then
		if number > max then
			result = max
		elseif number < min then
			result = min
		else
			result = number
		end
		return result
	end
end

function api.opendir(dir)
	if type(dir) == "string" then
		print("Before: "..dir)
		local path = "\""..string.gsub(dir,"/","\\").."\""
		--os.execute("start explorer \""..dir.."\"")
		print("After: "..path)
		os.execute("start explorer "..path)
	end
end

function api.getDir(OptionalString)
	local Option
	if OptionalString then Option = OptionalString else Option = "" end 
	local ret = love.filesystem.getAppdataDirectory().."/love/"..love.filesystem.getIdentity().."/"..Option
	--local path = "\""..string.gsub(ret,"/","\\").."\""
	return ret
end

function api.getProfileDir()
	local profile = settings.profiles.loaded
	local dir = "Profiles/"..profile
	return dir
end

return api