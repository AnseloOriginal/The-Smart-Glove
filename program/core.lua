core = {}

function core.An()
	local dir = "HMT"
	--print(dir)
	--assuming that our path is full of lovely files (it should at least contain main.lua in this case)
	local files = love.filesystem.getDirectoryItems(dir)
	for k, file in ipairs(files) do
		print(k .. ". " .. file) --outputs something like "1. main.lua"
	end
end

function core.on_load()
	love.filesystem.setIdentity("Smart Glove")
	love.window.setMode(1280,720,{fullscreen=true,resizable=false})
	love.graphics.setDefaultFilter("nearest","nearest")
	local r, g, b = love.math.colorFromBytes(57, 84, 34)
	love.graphics.setBackgroundColor(r,g,b)
	local profileloaded= love.filesystem.read("Profiles.json")
	local profiles
	if profileloaded == nil then 
		profiles = {}
	else
		profiles = json.decode(profileloaded)
	end
	settings.profiles.all = profiles
end

function core.start_scale(ui)
	love.graphics.push()
	local scaleX = love.graphics.getWidth()/1280
	local scaleY = love.graphics.getHeight()/720
	love.graphics.scale(scaleX, scaleY)
	ui:scale(scaleX, scaleY)
end

function core.end_scale()
	love.graphics.pop()
end

function core.on_runtime(ui)
	ui:frameBegin()
	if settings.layout.CurrentMode == "Profiles" then
		styles.draw("Profiles",ui)
	elseif settings.layout.CurrentMode == "General" then
		styles.draw("General",ui)
	elseif settings.layout.CurrentMode == "Device Test Home" then
		if not settings.DeviceStatus then
			if not api.timer.exists("DeviceStatus") then
				core.CheckDeviceStatus()
				api.timer.start("DeviceStatus")
				if ansel_debug then print("Tested for Keyboard -- Ansel Debug") end
			end
			if api.timer.value("DeviceStatus") > 5 then
				core.CheckDeviceStatus()
				api.timer.start("DeviceStatus")
				if ansel_debug then print("Tested for Keyboard -- Ansel Debug") end
			end

		end
		styles.draw("Device Test Home",ui)
	elseif settings.layout.CurrentMode == "Device Test Running" then
		local TestTime = settings.DeviceTest.TestTime - api.timer.value("Device Test Time")
		if TestTime > 0 or TestTime == 0 then
			styles.draw("Device Test Running",ui)
			core.RuntimeDeviceTest()
		else
			settings.DeviceTest.status = true
			core.DeviceTestPrepareResult()
			core.select_option("Device Test Results")
		end
	elseif settings.layout.CurrentMode == "Device Test Results" then
		if settings.DeviceTest.status then
			styles.draw("Device Test Result Display",ui)
		else
			styles.draw("Device Test Result Quit",ui)
		end
	elseif settings.layout.CurrentMode == "FST Home" then
		if not settings.DeviceStatus then
			if not api.timer.exists("DeviceStatus") then
				core.CheckDeviceStatus()
				api.timer.start("DeviceStatus")
				if ansel_debug then print("Tested for Keyboard -- Ansel Debug") end
			end
			if api.timer.value("DeviceStatus") > 5 then
				core.CheckDeviceStatus()
				api.timer.start("DeviceStatus")
				if ansel_debug then print("Tested for Keyboard -- Ansel Debug") end
			end
		end
		styles.draw("FST Home",ui)
	elseif settings.layout.CurrentMode == "Countdown" then
		if not api.timer.exists("Countdown") then
			api.timer.start("Countdown")
		end
		local time = api.timer.value("Countdown")
		local endtime = settings.countdown.time
		local option = settings.countdown.option
		if time < endtime then
			styles.draw("Countdown",ui)
		else
			settings.layout.CurrentMode = option
			api.timer.delete("Countdown")
		end
	elseif settings.layout.CurrentMode == "FST Running" then
		local IsDone = settings.FST.IsDone
		if not api.timer.exists("FST") then
			api.timer.start("FST")
		else
			if not IsDone then
				core.RuntimeFST()
				styles.draw("FST Running",ui)
			else
				print("Ran this")
				core.select_option("FST Results")
			end
		end
	elseif settings.layout.CurrentMode == "FST Results" then
		if settings.FST.IsDone then
			if settings.FST.ResultMode == 1 then
				styles.draw("FST Results Display Raw",ui)
			end
		else
			styles.draw("FST Results Quit",ui)
		end
	elseif settings.layout.CurrentMode == "HST Home" then
		styles.draw("HST Home", ui)
	elseif settings.layout.CurrentMode == "HST Running" then
		styles.draw("HST Running",ui)
		if settings.DeviceStatus == false then
			settings.HST.mode = 4
			settings.HST.Autopause = true
			if not api.timer.exists("HST Device Check") then
				core.CheckDeviceStatus()
				api.timer.start("HST Device Check")
			else
				if api.timer.value("HST Device Check") > 5 then
					core.CheckDeviceStatus()
					api.timer.start("HST Device Check")
				end
			end
		else
			if settings.HST.Autopause then
				settings.HST.mode = 2
				settings.HST.Autopause = false
			end
			--print("Ran Runtime")
			if settings.HST.mode ~= 2 then
				core.HSTRuntime()
				--print("Ran Runtime")
			end
		end
	elseif settings.layout.CurrentMode == "FileLoader" then
		local path = api.getProfileDir().."/"..settings.FileLoader.Path 
		local pathfiles = love.filesystem.getDirectoryItems(path)
		local option = settings.FileLoader.option
		settings.FileLoader.FilesTemp = pathfiles
		if #pathfiles > 0 and option == 0 then
			settings.FileLoader.option = 1
			settings.FileLoader.NameTemp = settings.FileLoader.FilesTemp[1]
		end
		styles.draw("FileLoader", ui)
	elseif settings.layout.CurrentMode == "HST Preload" then
		local completed = settings.FileLoader.Completed
		local file = settings.FileLoader.FileTemp
		if completed then
			settings.HST = json.decode(file, position, null, nil)
			--print(api.printtable(settings.HST))
			settings.layout.CurrentMode = "HST Running"
		else
			settings.layout.CurrentMode = "HST Home"
		end
	end
	ui:frameEnd()
end

function core.move_option(option)
	if settings.layout.CurrentMode == "General" then
		local MinSel = 1
		local MaxSel = #settings.operations.Available
		if settings.operations.Selection < MaxSel and option == "next" then
			settings.operations.Selection = settings.operations.Selection + 1
		elseif settings.operations.Selection > MinSel and option == "previous" then
			settings.operations.Selection = settings.operations.Selection - 1
		end 
	end
end

function core.select_option(option)
	if settings.layout.CurrentMode == "General" then
		if option == "Device Test" then
			settings.layout.CurrentMode = "Device Test Home"
		elseif option == "Finger Strength Test" then
			settings.layout.CurrentMode = "FST Home"
		elseif option == "Hand Monitoring Test" then
			settings.layout.CurrentMode = "HST Home"
		end
	elseif settings.layout.CurrentMode == "Device Test Home" then
		if option == "General" then
			settings.layout.CurrentMode = "General"
			api.timer.delete("DeviceStatus")
			settings.DeviceStatus = false
		elseif option == "Device Test Running" then
			settings.layout.CurrentMode = "Device Test Running"
			api.timer.start("Device Test Time")
		end
	elseif settings.layout.CurrentMode == "Device Test Running" then
		if option == "Device Test Results" then
			settings.layout.CurrentMode = "Device Test Results"
			api.timer.delete("Device Test Time")
		end
	elseif settings.layout.CurrentMode == "Device Test Results" then
		if option == "Device Test Restart" then
			settings.layout.CurrentMode = "Device Test Running"
			api.timer.start("Device Test Time")
		elseif option == "General" then
			settings.layout.CurrentMode = "General"
		end
	elseif settings.layout.CurrentMode == "FST Home" then
		if option == "General" then
			settings.layout.CurrentMode = "General"
			api.timer.delete("DeviceStatus")
			settings.DeviceStatus = false
		elseif option == "Countdown" then
			settings.countdown.time = 5
			settings.countdown.option = "FST Running"
			settings.countdown.quit = "General"
			settings.layout.CurrentMode = "Countdown"
		elseif option == "quit" then
			settings.layout.CurrentMode = "General"
		end
	elseif settings.layout.CurrentMode == "Countdown" then
		if option == "quit" then
			local nextmode = settings.countdown.quit
			api.timer.delete("Countdown")
			settings.layout.CurrentMode = nextmode
		end
	elseif settings.layout.CurrentMode == "FST Running" then
		if option == "FST Results" then
			core.FSTPrepareResults()
			settings.layout.CurrentMode = "FST Results"
		elseif option == "quit" then	
			settings.layout.CurrentMode = "FST Results"
		end
	elseif settings.layout.CurrentMode == "FST Results" then
		if option == "FST Restart" then
			core.FSTResetAll()
			settings.layout.CurrentMode = "Countdown"
		elseif option == "General" then
			core.FSTResetAll()
			settings.layout.CurrentMode = "General"
		end
	elseif settings.layout.CurrentMode == "HST Home"then
		if option == "New" then
			core.HSTNew() 
			settings.layout.CurrentMode = "HST Running"
		elseif option == "load" then
			core.FileLoaderFlush()
			settings.layout.CurrentMode = "FileLoader"
			settings.FileLoader.Path  = "HMT"
			settings.FileLoader.success = "HST Preload"
			settings.FileLoader.quit = "HST Home"
		end
	elseif settings.layout.CurrentMode == "HST Running" then
		if option == "Quit" then
			settings.layout.CurrentMode = "General"
		end
	elseif settings.layout.CurrentMode == "FileLoader" then
		if option == "quit" then
			settings.layout.CurrentMode = settings.FileLoader.quit
			core.FileLoaderFlush()
		end
	elseif settings.layout.CurrentMode == "Profiles" then
		if option == "Add" then
			settings.profiles.state = 2
		elseif option == "create" then
			core.createprofile(settings.profiles.createtemp.name)
			settings.profiles.state = 1
		elseif option == "quit" then
			settings.profiles.state = 1
		elseif option == "Select" then
			core.loadprofile()
			print("Loaded: "..settings.profiles.loaded)
			settings.layout.CurrentMode = "General"
		elseif option == "delete"  then
			settings.profiles.state = 3
		elseif option == "Delete-Return" then
			settings.profiles.state = 1
		elseif option == "Deleted" then
			local profile = settings.profiles.loaded
			core.deleteprofile(profile)
			settings.profiles.loaded = ""
			settings.profiles.state = 1
		end
	end

end

function core.CheckDeviceStatus()
	-- Define your target VID and PID
	local vid = "VID_413C"
	local pid = "PID_2113"

	-- Format the WMIC command
	local query = string.format(
	  [[wmic path Win32_Keyboard get Name,DeviceID]],
	  vid, pid
	)

	-- Run the command
	local handle = io.popen(query)
	local result = handle:read("*a")
	handle:close()

	-- Check if result includes our VID/PID
	if result and result:match(vid) and result:match(pid) then
		settings.DeviceStatus = true
	else
		settings.DeviceStatus = false
	end
end

function core.RuntimeDeviceTest()
	settings.DeviceTest.framecount = settings.DeviceTest.framecount + 1
	local keys = settings.finger.joints
	for i=1,14 do
		if settings.DeviceTest.jointframecount[i] > 0 then
			settings.DeviceTest.JointStatus[i] = false
		end
		if love.keyboard.isDown(keys[i]) then
			settings.DeviceTest.JointStatus[i] = true
			settings.DeviceTest.jointframecount[i] = settings.DeviceTest.jointframecount[i] + 1
		end
	end
end

function core.DeviceTestPrepareResult()
	local framecount = settings.DeviceTest.framecount 
	local jointframecount = {}
	settings.DeviceTest.Results.Joint = {}
	local AllTrue = true
	local TotalAccuracy = 0
	for i=1,14 do
		local status = settings.DeviceTest.JointStatus[i]
		local accuracy = math.floor((settings.DeviceTest.jointframecount[i]/framecount)*100)
		local newtable = {status=status, accuracy=accuracy}
		settings.DeviceTest.Results.Joint[i] = newtable
		if status == nil then
			AllTrue = false
		end
		TotalAccuracy = accuracy + TotalAccuracy
	end
	settings.DeviceTest.Results.FC = framecount
	settings.DeviceTest.Results.AllTrue = AllTrue
	settings.DeviceTest.Results.TotalAccuracy = math.floor(TotalAccuracy/14)
end

function core.DeviceTestResetAll()
	settings.DeviceTest.JointStatus = {}
	settings.DeviceTest.jointframecount = {}
	settings.DeviceTest.Results = {}
	for i=1,14 do
		settings.DeviceTest.JointStatus[i] = nil
		settings.DeviceTest.jointframecount[i] = 0
	end
	settings.DeviceTest.framecount = 0
	settings.DeviceTest.status = false
end

function core.RuntimeFST()
	local mode = settings.FST.CurrentMode
	local unitmode = settings.FST.UnitTestMode
	local keys = settings.finger
	local MaxLap = 0
	local dt = love.timer.getDelta()
	if mode == 1 then
		MaxLap = settings.FST.Mode1Laps
	else
		MaxLap = settings.FST.Mode2Laps
	end
	local lap = settings.FST.CurrentLap
	local HLS = settings.FST.HighLevelScore
	local LLS = settings.FST.LowLevelScore
	local ELS = settings.FST.ErrorLevelScore
	local ElaspedTime = settings.FST.ElaspedTime
	if mode == 1 then
		local Difference = api.timer.value("FST")-ElaspedTime
		local MaxTime = settings.FST.Mode1Time
		if Difference < MaxTime then
			if unitmode == 1 then
				if lap == 1 then
					local CurHLS = settings.FST.finger["finger"..lap].Joint2.Score
					local CurLLS = settings.FST.finger["finger"..lap].Joint1.Score
					local HighKey = keys["finger"..lap].Joint2
					local LowKey = keys["finger"..lap].Joint1
					if love.keyboard.isDown(HighKey) then
						settings.FST.finger["finger"..lap].Joint2.Score = CurHLS + (HLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
					if love.keyboard.isDown(LowKey) then
						settings.FST.finger["finger"..lap].Joint1.Score = CurLLS + (LLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
				else
					local HighKey = keys["finger"..lap].Joint1
					local LowKey = keys["finger"..lap].Joint2
					local CurHLS = settings.FST.finger["finger"..lap].Joint1.Score
					local CurLLS = settings.FST.finger["finger"..lap].Joint2.Score
					if love.keyboard.isDown(HighKey) then
						settings.FST.finger["finger"..lap].Joint2.Score = CurHLS + (HLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
					if love.keyboard.isDown(LowKey) then
						settings.FST.finger["finger"..lap].Joint1.Score = CurLLS + (LLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
				end
			elseif unitmode == 2 then
				if lap == 1 then
					local CurHLS = settings.FST.finger["finger"..lap].Joint2.Score
					local CurLLS = settings.FST.finger["finger"..lap].Joint1.Score
					local HighKey = keys["finger"..lap].Joint2
					local LowKey = keys["finger"..lap].Joint1
					if not love.keyboard.isDown(HighKey) then
						settings.FST.finger["finger"..lap].Joint2.Score = CurHLS + (HLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
					if not love.keyboard.isDown(LowKey) then
						settings.FST.finger["finger"..lap].Joint1.Score = CurLLS + (LLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
				else
					local HighKey = keys["finger"..lap].Joint1
					local LowKey = keys["finger"..lap].Joint2
					local CurHLS = settings.FST.finger["finger"..lap].Joint1.Score
					local CurLLS = settings.FST.finger["finger"..lap].Joint2.Score
					if not love.keyboard.isDown(HighKey) then
						settings.FST.finger["finger"..lap].Joint2.Score = CurHLS + (HLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
					if not love.keyboard.isDown(LowKey) then
						settings.FST.finger["finger"..lap].Joint1.Score = CurLLS + (LLS*dt)
						settings.FST.finger["finger"..lap].Joint1.Pressed = true
					end
				end
			end
		else
			if lap < MaxLap then
				if unitmode == 1 then
					settings.FST.UnitTestMode = 2
					settings.FST.ElaspedTime = api.timer.value("FST")
				elseif unitmode == 2 then
					settings.FST.CurrentLap = lap + 1
					settings.FST.UnitTestMode = 1
					settings.FST.ElaspedTime = api.timer.value("FST")
				end
			else
				settings.FST.CurrentMode = 2
				settings.FST.CurrentLap = 1
				settings.FST.UnitTestMode = 1
				settings.FST.ElaspedTime = api.timer.value("FST")
			end
		end
	elseif mode == 2 then
		local Difference = api.timer.value("FST")-ElaspedTime
		local MaxTime = settings.FST.Mode2Time
		if Difference < MaxTime then
			if unitmode == 1 then
				local pressednow = {}
				local pressedbefore = {}
				for no=2,5 do
					local keystr = settings.finger["finger"..no].Joint3
					local score = settings.FST.finger["finger"..no].Joint3.Score
					if love.keyboard.isDown(keystr) then
						settings.FST.finger["finger"..no].Joint3.Score = score + (1*dt)
						settings.FST.finger["finger"..no].Joint3.Pressed = true
						pressednow[no] = true
					else
						pressednow[no] = false
					end
					pressedbefore = settings.FST.finger["finger"..no].Joint3.Pressed
					if not pressednow and pressedbefore then
						settings.FST.finger["finger"..no].Joint3.Score = score+(0.5*dt)
					end
				end
			end
			if unitmode == 2 then
				for no=2,5 do
					local keystr = settings.finger["finger"..no].Joint3
					local score = settings.FST.finger["finger"..no].Joint3.Score
					if not love.keyboard.isDown(keystr) then
						settings.FST.finger["finger"..no].Joint3.Score = score + (1*dt)
					end
				end
			end
		else
			if lap < MaxLap then
				if unitmode == 1 then
					settings.FST.UnitTestMode = 2
					settings.FST.ElaspedTime = api.timer.value("FST")
				elseif unitmode == 2 then
					settings.FST.CurrentLap = lap + 1
					settings.FST.UnitTestMode = 1
					settings.FST.ElaspedTime = api.timer.value("FST")
				end
			else
				settings.FST.IsDone = true
			end
		end
	end
end

function core.FSTPrepareResults()
	local result = {}
	local Average = 0
	local AverageNo = 0
	for no=1,5 do
		local storage = {}
		if no == 1 then
			storage.Joint1Score = math.floor(settings.FST.finger["finger"..no].Joint1.Score)
			storage.Joint2Score = math.floor(settings.FST.finger["finger"..no].Joint2.Score)
			storage.TotalScore = storage.Joint1Score + storage.Joint2Score
		else
			storage.Joint1Score = math.floor(settings.FST.finger["finger"..no].Joint1.Score)
			storage.Joint2Score = math.floor(settings.FST.finger["finger"..no].Joint2.Score)
			storage.Joint3Score = math.floor(settings.FST.finger["finger"..no].Joint3.Score)
			storage.TotalScore = storage.Joint1Score + storage.Joint2Score + storage.Joint3Score
		end
		AverageNo = AverageNo + 1
		Average = Average + storage.TotalScore
		result["finger"..no] = storage
	end
	result.Average = math.floor(Average/AverageNo)
	result.Time =  api.GetFormattedTime()
	result.Version = settings.version
	result.Type = "Result Data"
	result.TrueType = "FST"
	settings.FST.Results = result
	settings.FST.ResultString = json.encode(result,{ indent = true })
	--print(settings.FST.ResultString)
end

function core.FSTResetAll()
	api.timer.delete("FST")
	settings.FST.IsDone = false
	settings.FST.CurrentMode = 1 -- 1 is testing individual fingers, 2 is testing palm.
	settings.FST.UnitTestMode = 1 --1 is dowm, 2 is down.
	settings.FST.CurrentTestingKey = 1 --1-5 represents Thumb - Pinky
	settings.FST.Mode1Time = 4 
	settings.FST.Mode2Time = 4
	settings.FST.Mode1Laps = 5
	settings.FST.CurrentMode = 1
	settings.FST.LowLevelScore = 1
	settings.FST.HighLevelScore = 2
	settings.FST.ErrorLevelScore = 0.5
	settings.FST.ElaspedTime = 0
	settings.FST.Mode1Status1 = false
	settings.FST.Mode1Status2 = false
	settings.FST.finger = {}
	for i=1,5 do
		settings.FST.finger["finger"..i]={}
		settings.FST.finger["finger"..i].Joint1={}
		settings.FST.finger["finger"..i].Joint1.Score = 0
		settings.FST.finger["finger"..i].Joint1.Pressed = false
		settings.FST.finger["finger"..i].Joint2={}
		settings.FST.finger["finger"..i].Joint2.Score = 0
		settings.FST.finger["finger"..i].Joint2.Pressed = false
		settings.FST.finger["finger"..i].Joint3={}
		settings.FST.finger["finger"..i].Joint3.Score = 0
		settings.FST.finger["finger"..i].Joint3.Pressed = false 
	end
	settings.FST.CurrentLap = 1
	settings.FST.Results = {}
	settings.FST.ResultString = {}
	settings.FST.ResultMode = 1
	settings.FST.SaveLog = ""
end

function core.FSTToDisk()
	local result = settings.FST.Results
	local save = settings.FST.ResultString
	local name = api.getProfileDir().."/FST/"..result.Time.." Finger Strength Test.json"
	local SaveLog = api.savetest(name,save)
	settings.FST.SaveLog = SaveLog
end

--Depreciated (TO BE REMOVED)
function core.FSTToClipboard()
	local location = api.getDir()
	love.system.setClipboardText(location)
end 										
-------------------------------------------

function core.HSTNew()
	local newname = "HST"..os.date("%Y%m%d%H%M%S", t)
	settings.HST.Result = {}
	for i=1,5 do
		settings.HST.config["finger"..i] = {}
		settings.HST.config["finger"..i].Tracked = true
		if i>1 then settings.HST.config["finger"..i].JointNo = 3 end
		if i==1 then settings.HST.config["finger"..i].JointNo = 2 end
	end
	settings.HST.config.DeviceCheckInterval = 10
	settings.HST.config.AutomaticSaveInterval = 10
	settings.HST.config.FingerCheckInterval = 200
	settings.HST.config.ResetInterval = 10
	settings.HST.config.JointView = "Thumb"
	settings.HST.name = newname
	settings.HST.mode = 1
	settings.HST.lastsave = "Never"
	settings.HST.Autopause = true
end

function core.HSTUpdateWindows(name,x,y)
	local getWindows = settings.HST.windows[name]
	local realx = x or getWindows["x"]
	local realy = y or getWindows["y"]
	if getWindows then
		settings.HST.windows[name]["x"] = realx
		settings.HST.windows[name]["y"] = realy
	end
end

function core.HSTToggleWindows(name)
	local getWindows = settings.HST.windows[name]
	if type(getWindows) == "table" then
		if getWindows["view"] then
			getWindows["view"] = false
		else
			getWindows["view"] = true
		end
	end
end

function core.GetBtnName(name)
	if settings.HST.windows[name]==nil then
		return "Invalid Window"
	else
		local win = settings.HST.windows[name]
		local displayname = win.name or name
		if win["view"] then
			return "Close "..displayname
		else
			return "Open "..displayname
		end
	end
end


function core.HSTRuntime()
	local mode = settings.HST.mode
	if mode == 1 then
		if not api.timer.exists("HST Finger Check") then
			api.timer.start("HST Finger Check")
			core.CreateResultTemplate()
		else
			local timer = api.timer.value("HST Finger Check","ms")
			--print(timer)
			local interval = settings.HST.config.FingerCheckInterval
			if timer > interval then
				local config = settings.HST.config
				local keys = settings.finger
				local temp = settings.HST.Result.Current
				for i=1,5 do
					if config["finger"..i].Tracked then
						local no=config["finger"..i].JointNo
						local curtotalint = temp[api.fingertotext(i)].TotalInteraction
						local totalint = 0
						for k=1,no do
							local curkey = keys["finger"..i]["Joint"..k]
							local curint = temp[api.fingertotext(i)]["Joint"..k].Interaction
							if love.keyboard.isDown(curkey) then
								settings.HST.Result.Current[api.fingertotext(i)]["Joint"..k].Interaction = curint + 1
								totalint = totalint + 1
								settings.HST.Result.Current[api.fingertotext(i)]["Joint"..k].Status = true
							else
								settings.HST.Result.Current[api.fingertotext(i)]["Joint"..k].Status = false
							end
						end
						settings.HST.Result.Current[api.fingertotext(i)].TotalInteraction =curtotalint+totalint
					end
				end
				api.timer.start("HST Finger Check")
				--print("HST: Checked Fingers at "..timer.." using interval "..settings.HST.config.FingerCheckInterval)
			end
		end
		if not api.timer.exists("HST Finger Logging") then
			api.timer.start("HST Finger Logging")
		else
			local timer = api.timer.value("HST Finger Logging")
			local interval = settings.HST.config.ResetInterval
			if timer>interval then
				--Please note due to my difficulties in coding (referencing) this function is unstable. LastInteraction is saved here not CurrentSave
				local CurrentSave = settings.HST.Result.Current
				core.HSTResetCurrent()
				core.HSTPushLastInteraction(CurrentSave)
				local Save = settings.HST.Result.LastInteraction
				core.HSTLog(CurrentSave)
				api.timer.start("HST Finger Logging")
				print("Ran Reset")
			end
		end
	end
	if api.timer.exists("HST Device Check") then
		local timer = api.timer.value("HST Device Check")
		local int = settings.HST.config.DeviceCheckInterval*60
		if timer>int then
			core.CheckDeviceStatus()
			api.timer.start("HST Device Check")
		end
	end
	if api.timer.exists("HST Auto Save") then
		local timer = api.timer.value("HST Auto Save")
		local int = settings.HST.config.AutomaticSaveInterval*60
		local mode = settings.HST.mode
		if timer > int then
			core.HSTFileSave(mode)
		end
	else
		api.timer.start("HST Auto Save")
	end
end

function core.togglepause()
	local mode = settings.HST.mode 
	if mode == 1 then
		settings.HST.mode = 2
		api.timer.delete("HST Finger Check")
		api.timer.delete("HST Finger Logging")
	else
		settings.HST.mode = 1
	end
end

function core.HSTValues(name)
	if name == "quickview" then
		local result = {}
		local getResult=settings.HST.Result
		if getResult.Current == nil then
			result.lastinteraction = 0
			result.curinteraction = 0
		else
			local count1 = 0
			local count2 = 0
			for i=1,5 do
				count1 = getResult.Current[api.fingertotext(i)].TotalInteraction + count1
				count2 = getResult.LastInteraction[api.fingertotext(i)].TotalInteraction + count2
			end
			result.lastinteraction = count2
			result.curinteraction = count1
		end
		return result
	elseif name == "handimage" then
		local data = {}
		local datano = 1
		local Jointno = 1
		for i=1,14 do
			if settings.HST.Result.Current and settings.HST.mode == 1 then
				if settings.HST.config["finger"..datano].Tracked then
					data[i]=settings.HST.Result.Current[api.fingertotext(datano)]["Joint"..Jointno].Status
				else
					data[i]=nil
				end
			else
				data[i] = nil
			end
			if i == 2 then
				datano=2
			elseif i == 5 then
				datano =  3
			elseif i == 8 then
				datano = 4
			elseif i == 11 then
				datano = 5
			end
			Jointno = Jointno + 1
			if datano == 1 and Jointno > 2 then Jointno = 1 end
			if datano > 1 and Jointno > 3 then Jointno = 1 end
		end
		return data
	elseif name == "jointview" then
		local finger = settings.HST.config.JointView
		local ret = {}
		local no = 0
		if api.texttofinger(finger) == 1 then
			no = 2
		else
			no = 3
		end
		if settings.HST.Result.Current then
			for i=1,no do
				ret["Joint"..i] = settings.HST.Result.Current[finger]["Joint"..i].Interaction
			end
			ret.Interaction = settings.HST.Result.Current[finger].TotalInteraction
		else
			ret.Joint1 = 0
			ret.Joint2 = 0
			ret.Joint3 = 0
			ret.Interaction =0
		end
		ret.no = no
		return ret
	end
end

function core.CreateResultTemplate()
	local result = {}
	result.Current = {}
	result.LastInteraction = {}
	for i=1,5 do
		result.Current[api.fingertotext(i)] = {}
		result.Current[api.fingertotext(i)].TotalInteraction = 0
		result.LastInteraction[api.fingertotext(i)] = {}
		result.LastInteraction[api.fingertotext(i)].TotalInteraction = 0
		local no = settings.HST.config["finger"..i].JointNo
		for k=1,no do
			result.Current[api.fingertotext(i)]["Joint"..k] = {Interaction=0,Status=false}
			result.LastInteraction[api.fingertotext(i)]["Joint"..k] = 0
		end
	end
	settings.HST.Result = result
end

function core.HSTResetCurrent()
	local Current = {}
	for i=1,5 do
		Current[api.fingertotext(i)] = {}
		Current[api.fingertotext(i)].TotalInteraction = 0
		local no = settings.HST.config["finger"..i].JointNo
		for k=1,no do
			Current[api.fingertotext(i)]["Joint"..k]={Interaction=0,Status=false}
		end
	end
	settings.HST.Result.Current = Current
end

function core.HSTPushLastInteraction(data)
	local lastinteraction = settings.HST.Result.LastInteraction
	for i=1,5 do
		lastinteraction[api.fingertotext(i)].TotalInteraction = data[api.fingertotext(i)].TotalInteraction
		local no = settings.HST.config["finger"..i].JointNo
		for k=1,no do
			data[api.fingertotext(i)]["Joint"..k] = data[api.fingertotext(i)]["Joint"..k].Interaction
		end
	end
	settings.HST.Result.LastInteraction = lastinteraction
end

function core.HSTLog(data)
	local Year = os.date("D%Y-%m-%d T%H-%M-%S", t)
	local Year = os.date("%Y")
	local Month = os.date("%m")
	local Day = os.date("%d")
	local Hour = os.date("%H")
	local Minute = os.date("%M")
	local Second = os.date("%S")
	if not api.isTable(settings.HST.Result.Log) then
		settings.HST.Result.Log = {}
	end
	if not api.isTable(settings.HST.Result.Log[Year]) then
		settings.HST.Result.Log[Year] = {}
	end
	if not api.isTable(settings.HST.Result.Log[Year][Month]) then
		settings.HST.Result.Log[Year][Month] = {}
	end
	if not api.isTable(settings.HST.Result.Log[Year][Month][Day]) then
		settings.HST.Result.Log[Year][Month][Day] = {}
	end
	if not api.isTable(settings.HST.Result.Log[Year][Month][Day][Hour]) then
		settings.HST.Result.Log[Year][Month][Day][Hour] = {}
	end
	if not api.isTable(settings.HST.Result.Log[Year][Month][Day][Hour][Minute]) then
		settings.HST.Result.Log[Year][Month][Day][Hour][Minute] = {}
	end
	settings.HST.Result.Log[Year][Month][Day][Hour][Minute][Second] = api.deepcopy(data)

end
function core.HSTFileSave(mode)
	settings.HST.mode = 3 
	local name = api.getProfileDir().."/HMT/"..settings.HST.name..".json"
	local file = json.encode(settings.HST,{ indent = true })
	local msg = api.GetFormattedTime()
	local log = api.savetest(name,file)
	local log2 = api.savetest(name,file,1)
	local a
	if log2 then a="Success" else a="Failed!" end
	print("Save Log: "..log)
	api.timer.start("HST Auto Save")
	if settings.HST.mode == 3 then settings.HST.mode = mode end
	settings.HST.lastsave = msg.." ,"..a
end

function core.fileSystemLoad()
	local filename = api.getProfileDir().."/"..settings.FileLoader.Path.."/"..settings.FileLoader.NameTemp
	--print(filename)
	local contents, size = love.filesystem.read( filename, size )
	--print(filename,size)
	if type(size)=="number" then
		settings.FileLoader.Completed = true
		settings.FileLoader.FileTemp = contents
	else
		settings.FileLoader.Completed = false
	end
	--print(contents)
	settings.layout.CurrentMode = settings.FileLoader.success
	--core.FileLoaderFlush()
	--print(size,type(size))
end

function core.FileLoaderFlush()
	settings.FileLoader.option = 0
	settings.FileLoader.FilesTemp = {}
	settings.FileLoader.FileTemp = ""
	settings.FileLoader.Completed = false
	settings.FileLoader.quit = ""
	settings.FileLoader.success = ""
	settings.FileLoader.Path = ""
	settings.FileLoader.NameTemp = ""
end

function core.profileexists(name)
	local exist = false
	if name then
		exist = love.filesystem.exists("Profiles/"..name)
	end
	return exist
end

function core.createprofile(name)
	local Dir = "Profiles/"..name
	local success = love.filesystem.createDirectory(Dir)
	if success then
		local no = settings.profiles.all 
		love.filesystem.createDirectory(Dir.."/HMT")
		love.filesystem.createDirectory(Dir.."/FST")
		local savejson = json.encode(settings.profiles.createtemp)
		love.filesystem.write(Dir.."/profile.json",savejson)
		settings.profiles.all[#no+1] = name
		savejson = json.encode(settings.profiles.all)
		love.filesystem.write("Profiles.json",savejson)
	else

	end

end

function core.loadprofile()
	local name = settings.profiles.loaded
	local dir = "Profiles/"..name.."/profile.json"
	print(dir)
	local loadedjson, error = love.filesystem.read(dir)
	if loadedjson == nil then
		settings.profiles.current = settings.profiles.createtemp
	else
		settings.profiles.current = json.decode(loadedjson)
		print("Error in loading profiles: "..error)
	end
end

function  core.deleteprofile(name)
	if core.profileexists(name) then
		local oldtable = settings.profiles.all
		local found = false
		local newtable  = {}
		for id,profilename in pairs(oldtable) do
			if not found then
				if profilename == name then
					newtable[id] = nil
					found = true
				else
					newtable[id] = profilename
				end
			else
				newtable[id-1] = oldtable[id]
			end
		end
		local profilejson = json.encode(newtable)
		local success1 = love.filesystem.write("Profiles.json",profilejson)
		if success1 then
			settings.profiles.all = newtable
		else
			print("Profile System: Unable to save new profile after deletion")
		end
	end
end

return core
