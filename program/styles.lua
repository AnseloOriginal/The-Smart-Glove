styles = {}

function styles.on_load(ui)
	local colorTable = {
		['text'] = '#068b29',
		['window'] = '#abec9d',
		['header'] = '#48872B',
		['border'] = '#293325',
		['button'] = '#323232',
		['button hover'] = '#282828',
		['button active'] = '#232323',
		['toggle'] = '#646464',
		['toggle hover'] = '#787878',
		['toggle cursor'] = '#2d2d2d',
		['select'] = '#2d2d2d',
		['select active'] = '#232323',
		['slider'] = '#262626',
		['slider cursor'] = '#646464',
		['slider cursor hover'] = '#787878',
		['slider cursor active'] = '#969696',
		['property'] = '#262626',
		['edit'] = '#262626',
		['edit cursor'] = '#afafaf',
		['combo'] = '#2d2d2d',
		['chart'] = '#787878',
		['chart color'] = '#2d2d2d',
		['chart color highlight'] = '#ff0000',
		['scrollbar'] = '#282828',
		['scrollbar cursor'] = '#646464',
		['scrollbar cursor hover'] = '#787878',
		['scrollbar cursor active'] = '#969696',
		['tab header'] = '#282828'
	}
	local style = {
		['selectable'] = {
			['normal'] = '#abec9d',
			['hover'] = "#7dd87d",
			['pressed'] = "#5bbe75"
		}
	}
	ui:styleLoadColors(colorTable)
	ui:stylePush(style)
	styles.font = {}
	styles.font.Header = styles.fonts.request("Bold",24,"Roboto-Bold",true)
	styles.font.Normal = styles.fonts.request("Normal",16,"Roboto-Regular",true)
	styles.font.NormalBold = styles.fonts.request("Bold",15,"Roboto-Bold",true)
	styles.defaultVerticalSpacing = 30
	styles.defaultHorizontalSpacing = 5
	styles.images = {}
	styles.images.hand = love.graphics.newImage("hand.png")
	styles.images.Thumb = love.graphics.newImage("thumb.png")
	styles.images.Index = love.graphics.newImage("index.png")
	styles.images.Middle = love.graphics.newImage("middle.png")
	styles.images.Ring = love.graphics.newImage("ring.png")
	styles.images.Pinky = love.graphics.newImage("pinky.png")
	styles.images.Circle = love.graphics.newImage("Circle.png")
	styles.images.Default = love.graphics.newImage("Default.png")
	styles.images.Add = love.graphics.newImage("Add.png")
end

function styles.draw(Name,ui)
	local Width = 1280
	local Height = 720
	local spacing = 10
	local ProfileWidth = 1200
	local ProfileHeight = 640
	local startX = (Width-ProfileWidth)
	local startY = (Height-ProfileHeight)/2
	if Name == "Profiles" then
		local profiles = settings.profiles.all
		local no = #profiles+1
		--print("no: "..no)
		local rows = math.ceil(no/3)
		--print("Rows: "..rows)
		local count = 1
		local Add = styles.images.Add
		local account = styles.images.Default
		local newwidth = ProfileWidth 		
		local imgWidth = 100
		local imagespace = imgWidth/newwidth
		local spacing = (1-((imagespace)*3))/4
		local sizes = {spacing,imagespace,spacing,imagespace,spacing,imagespace,spacing}
		local deb = (spacing*4)+(imagespace*3)
		local state = settings.profiles.state
		--print("Deb: "..deb)
		if state == 1 then
			if ui:windowBegin("Profiles", startX, startY, ProfileWidth, ProfileHeight, 'border') then
				api.simpletext(ui,"Select a profile",48,true,"center")
				ui:layoutRow("dynamic",450,1)
				if ui:groupBegin("Profile Display","scrollbar") then
					api.simpletext(ui,"",15,true,"center")
					for rowcount = 1,rows do
						local maxcol = no - ((rowcount-1)*3)
						maxcol = api.clamp(maxcol,1,3)
						ui:layoutRow("dynamic",100,sizes)
						for countno = 1,maxcol do
							ui:spacing(1)
							if countno == 1 and count == 1 then ui:image(Add) else ui:image(account) end
							--if countno == maxcol then ui:spacing(1) end
						end
						ui:layoutRow("dynamic",15,sizes)
						for countno = 1,maxcol do
							local id = (((rowcount-1)*3)+countno)-1
							--print("ID: "..id)
							local profilename = profiles[id] or "Error"
							if count == 1 and countno == 1 then
								ui:spacing(1)
								if ui:selectable("Add Profile",nil,"centered",false) then
									core.select_option("Add")
								end
							else 
								ui:spacing(1) 
								if ui:selectable(profilename,nil,"centered",false) then
									settings.profiles.loaded = profilename
									core.select_option("Select")
								end
							end
							if countno == maxcol then 
								--ui:spacing(1) 
							end
						end
						ui:layoutRow("dynamic",15,sizes)
						count = count + 3
					end
					ui:spacing(1)
					--print(api.printtable(sizes))
					--local selected = false
					--ui:selectable("a",circle,selected)
					ui:groupEnd()
					ui:layoutRow("dynamic",30,1)
					ui:spacing(1)
					if ui:button("Delete Profile") then
						core.select_option("delete")
					end
					ui:spacing(1)
				end
				ui:windowEnd()
			end
		elseif state == 3 then
			if ui:windowBegin("Profiles", startX, startY, ProfileWidth, ProfileHeight, 'border') then
				api.simpletext(ui,"Select a profile to delete",48,true,"center")
				ui:layoutRow("dynamic",450,1)
				if ui:groupBegin("Profile Display","scrollbar") then
					api.simpletext(ui,"",15,true,"center")
					for rowcount = 1,rows do
						local maxcol = no - ((rowcount-1)*3)
						maxcol = api.clamp(maxcol,1,3)
						ui:layoutRow("dynamic",100,sizes)
						for countno = 1,maxcol do
							ui:spacing(1)
							if countno == 1 and count == 1 then ui:image(Add) else ui:image(account) end
							--if countno == maxcol then ui:spacing(1) end
						end
						ui:layoutRow("dynamic",15,sizes)
						for countno = 1,maxcol do
							local id = (((rowcount-1)*3)+countno)-1
							--print("ID: "..id)
							local profilename = profiles[id] or "Error"
							if count == 1 and countno == 1 then
								ui:spacing(1)
								if ui:selectable("Return back",nil,"centered",false) then
									core.select_option("Delete-Return")
								end
							else 
								ui:spacing(1) 
								if ui:selectable(profilename,nil,"centered",false) then
									settings.profiles.loaded = profilename
									core.select_option("Deleted")
								end
							end
							if countno == maxcol then 
								--ui:spacing(1) 
							end
						end
						ui:layoutRow("dynamic",15,sizes)
						count = count + 3
					end
					ui:spacing(1)
					--print(api.printtable(sizes))
					--local selected = false
					--ui:selectable("a",circle,selected)
					ui:groupEnd()
					ui:layoutRow("dynamic",30,1)
					ui:spacing(1)
					if ui:button("Return back") then
						core.select_option("Delete-Return")
					end
					ui:spacing(1)
				end
				ui:windowEnd()
			end
		elseif state == 2 then
			if ui:windowBegin("Profiles", startX, startY, ProfileWidth, ProfileHeight, 'border') then
				api.simpletext(ui,"Create a new profile",48,true,"center")
				ui:layoutRow("dynamic",450,1)
				if ui:groupBegin("Information","scrollbar") then
					api.simpletext(ui,"Fill all the neccessary details",20,true)
					local TS
					TS = {value=settings.profiles.createtemp.name}
					local state, changed = ui:edit('simple', TS)
					if changed then
						settings.profiles.createtemp.name = TS.value
					end
					if state == "inactive" then
							if TS.value == "" then
								settings.profiles.createtemp = ""
							elseif core.profileexists(TS.value) then
								settings.profiles.createtemp.name = "Already Existing"
							elseif TS.value == "/" then
								settings.profiles.createtemp.name = "Not Allowed"
							end
					end
					ui:label("")
					TS = {value=settings.profiles.createtemp.age}
					if ui:property("Age:", 3, TS, 99, 1, 1) then
						settings.profiles.createtemp.age = TS.value
					end
					ui:label("")
					TS = {value=settings.profiles.createtemp.phonenum}
					local state, changed = ui:edit('simple', TS)
					if changed then
						settings.profiles.createtemp.phonenum = TS.value
					end
					local combo = {value = settings.profiles.createtemp.gendersel , items = settings.profiles.createtemp.gender}
					ui:label("Gender: ")
					if ui:combobox(combo, combo.items) then
						settings.profiles.createtemp.gendersel = combo.value
					end
					ui:groupEnd()
				end
				ui:layoutRow("dynamic",50,5)
				ui:spacing(1)
				if ui:button("Create") then
					core.select_option("create")
				end
				ui:spacing(1)
				if ui:button("Back") then
					core.select_option("quit")
				end
				ui:spacing(1)
				ui:windowEnd()
			end
		end
	end
	local Windows1X = spacing
	local Windows1Y = spacing
	local Windows1Wid = (Width/2) - spacing
	local Windows1Hht = Height - (spacing/2)
	local Windows2X = Windows1X+Windows1Wid+spacing
	local Windows2Y = Windows1Y
	local Windows2Wid = Width - Windows1Wid + (4*spacing)
	local Windows2Hht = (0.6 * Height) - spacing
	local Windows3X = Windows2X
	local Windows3Y = Windows2Y + Windows2Hht + spacing
	local Windows3Wid = Windows2Wid
	local Windows3Hht = (0.4 * Height) - spacing

	if Name == "General" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			--ui:layoutRow("dynamic",30,1)
			--api.text(ui,"normal","SPE")
			api.text(ui,"header","PMA - Edo Craft 2025")
			api.text(ui,"normal", "This is project started in 2025. It primary aim was to provide a tool for Paralytic patients",15)
			api.text(ui,"normal", "to track monitor and track their progress.",30)
			api.text(ui,"normal", "The first prototype was created for Edo Craft Teens Competition 2025.",40)
			api.text(ui,"normal", "The Name of the Project is The SMART Glove with the following goals.",15)
			api.text(ui,"bold", "S - Sensitive")
			api.text(ui,"bold", "M - Modifiable")
			api.text(ui,"bold", "A - Accuarate")
			api.text(ui,"bold", "R - Retentive")
			api.text(ui,"bold", "T - Tough")
			api.simpletext(ui,"",25)
			ui:layoutRow("dynamic",300,1)
			if ui:groupBegin("Profile Details",'border','title') then
				local data = settings.profiles.current
				api.simpletext(ui,"Name: "..data.name,25,true)
				api.simpletext(ui,"Age: "..data.age,25,true)
				api.simpletext(ui,"Gender: "..data.gender[data.gendersel],25,true)
				api.simpletext(ui,"Phone number: "..data.phonenum,25,true)
				ui:groupEnd()
			end
			ui:windowEnd()
		else
			if Ansel_Debug then print("Error in Home scene, false Detected") end
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			local SelectionToAvailable = settings.operations.Available[settings.operations.Selection]
			local AvailableToAll = settings.operations.All[SelectionToAvailable]
			local Tip = settings.operations.Tooltips[AvailableToAll]
			ui:layoutRow("dynamic",30,1)
			api.text(ui,"label",AvailableToAll,"Selection")
			api.text(ui,"normal", "|	"..Tip,15)
			ui:layoutRow("dynamic",30,1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Previous") then
				core.move_option("previous")
			end
			ui:spacing(1)
			if ui:button("Next") then
				core.move_option("next")
			end
			ui:spacing(1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Start!") then
				core.select_option(AvailableToAll)
			end
			ui:spacing(1)
			if ui:button("Quit") then
				love.window.close()
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal", "Created by Uzebu Ansel and Olalekan Obatoyinbo")
			api.text(ui,"normal", "Under Active Brains Academy for Edo Teens Craft 2025")
			api.text(ui,"normal", "Uzebu Ansel (c) 2025. MIT License",40)
			api.text(ui,"normal", settings.version,40)
			ui:windowEnd()
		end
	end
	if Name == "Device Test Home" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.text(ui,"header","Device Test")
			api.text(ui,"normal","This test all the functionalities of the glove to ensure that they are working.")
			api.text(ui,"normal","Below are the requirement for running the Test")
			api.text(ui,"bold","- Device Plugged In")
			api.text(ui,"bold","- Smart Glove worn and ready for test.")
			api.text(ui,"bold","- Gloves worn to press all keys")
			api.text(ui,"bold","- Press start when ready!")
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Start") then
				if settings.DeviceStatus then
					core.select_option("Device Test Running")
				end
			end
			ui:spacing(1)
			if ui:button("Back") then
				core.select_option("General")
			end
			if ui:windowIsHovered() then
				if not settings.DeviceStatus then
					ui:tooltip("Error: Device Not Plugged")
				end
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","Keymap: ".. string.upper(settings.finger.keymap))
			api.text(ui,"normal","Keys: "..#settings.finger.keymap)
			ui:windowEnd()
		end
	end
	if Name == "Device Test Running" then
		local TestTime = settings.DeviceTest.TestTime
		local timer = TestTime - api.timer.value("Device Test Time")
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.text(ui,"header","Time Remaining: "..timer)
			local x, y, width, height = ui:windowGetBounds()
			local imgWidth = 287*2
			local imgHeight = 292*2
			local xstart = x + ((width- imgWidth)/2)
			local ystart = y+100
			local JointX = {49,68,81,93,107,142,143,143,211,198,190,255,240,224}
			local JointY = {180,217,71,106,148,45,82,137,62,102,137,103,131,157}
			local radius = 10
			ui:layoutRow("dynamic",((ystart-y)+imgHeight),1)
			ui:image(styles.images.hand, xstart, ystart, imgWidth, imgHeight)
			if #JointX == #JointY then
				local xscale = imgWidth/287
				local yscale = imgHeight/292
				for count=1,#JointX do
					local xpos = xstart+(JointX[count]*xscale)
					local ypos = ystart+(JointY[count]*yscale)
					local status = settings.DeviceTest.JointStatus[count]
					api.ColoredCircle(ui,status,xpos,ypos,radius)
				end
			end
			--
			ui:windowEnd()
		end

		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 3)
			ui:spacing(1)
			if ui:button("Quit") then
				core.select_option("Device Test Results")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","Keymap: ".. string.upper(settings.finger.keymap))
			api.text(ui,"normal","Keys: "..#settings.finger.keymap)
			api.text(ui,"label",settings.DeviceTest.framecount,"Frames Tested" )
			ui:windowEnd()
		end
	end
	if Name == "Device Test Result Quit" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.text(ui,"header","Device Test Aborted!")
			api.text(ui,"normal","The running device test was aborted by the User.")
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Restart") then
				if settings.DeviceStatus then
					core.DeviceTestResetAll()
					core.select_option("Device Test Restart")
				end
			end
			ui:spacing(1)
			if ui:button("Quit") then
				core.DeviceTestResetAll()
				core.select_option("General")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","In this cases, it is recommended you restart the test.")
			ui:windowEnd()
		end
	end
	if Name == "Device Test Result Display" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border', 'scrollbar') then
			api.text(ui,"header","Device Test Results:")
			api.text(ui,"normal","The Device was tested successfully for 10 seconds.")
			local Results = settings.DeviceTest.Results
			--local custom_Hsep = {0.1,0.9}
			ui:layoutRow("dynamic",50,1)
			api.text(ui,"bold","General Data:")
			api.text(ui,"normal","Total Frame Count: "..Results.FC)
			api.text(ui,"normal","All Fingers True: "..api.tostring(settings.DeviceTest.Results.AllTrue))
			api.text(ui,"normal","Device Accuracy: "..settings.DeviceTest.Results.TotalAccuracy.."%",50)
			api.text(ui,"bold","Thumb Finger Data (finger 1):")
			api.text(ui,"normal","Joint 1 Detected: "..api.tostring2(Results.Joint[1].status))
			api.text(ui,"normal","Joint 1 Accuracy: "..Results.Joint[1].accuracy.."%")
			api.text(ui,"normal","Joint 2 Detected: "..api.tostring2(Results.Joint[2].status))
			api.text(ui,"normal","Joint 2 Accuracy: "..Results.Joint[2].accuracy.."%")
			api.text(ui,"bold","Index Finger Data (finger 2):")
			api.text(ui,"normal","Joint 1 Detected: "..api.tostring2(Results.Joint[3].status))
			api.text(ui,"normal","Joint 1 Accuracy: "..Results.Joint[3].accuracy.."%")
			api.text(ui,"normal","Joint 2 Detected: "..api.tostring2(Results.Joint[4].status))
			api.text(ui,"normal","Joint 2 Accuracy: "..Results.Joint[4].accuracy.."%")
			api.text(ui,"normal","Joint 3 Detected: "..api.tostring2(Results.Joint[5].status))
			api.text(ui,"normal","Joint 3 Accuracy: "..Results.Joint[5].accuracy.."%")
			api.text(ui,"bold","Middle Finger Data (finger 3):")
			api.text(ui,"normal","Joint 1 Detected: "..api.tostring2(Results.Joint[6].status))
			api.text(ui,"normal","Joint 1 Accuracy: "..Results.Joint[6].accuracy.."%")
			api.text(ui,"normal","Joint 2 Detected: "..api.tostring2(Results.Joint[7].status))
			api.text(ui,"normal","Joint 2 Accuracy: "..Results.Joint[7].accuracy.."%")
			api.text(ui,"normal","Joint 3 Detected: "..api.tostring2(Results.Joint[8].status))
			api.text(ui,"normal","Joint 3 Accuracy: "..Results.Joint[8].accuracy.."%")
			api.text(ui,"bold","Ring Finger Data (finger 4):")
			api.text(ui,"normal","Joint 1 Detected: "..api.tostring2(Results.Joint[9].status))
			api.text(ui,"normal","Joint 1 Accuracy: "..Results.Joint[9].accuracy.."%")
			api.text(ui,"normal","Joint 2 Detected: "..api.tostring2(Results.Joint[10].status))
			api.text(ui,"normal","Joint 2 Accuracy: "..Results.Joint[10].accuracy.."%")
			api.text(ui,"normal","Joint 3 Detected: "..api.tostring2(Results.Joint[11].status))
			api.text(ui,"normal","Joint 3 Accuracy: "..Results.Joint[11].accuracy.."%")
			api.text(ui,"bold","Pinky Finger Data (finger 5):")
			api.text(ui,"normal","Joint 1 Detected: "..api.tostring2(Results.Joint[12].status))
			api.text(ui,"normal","Joint 1 Accuracy: "..Results.Joint[12].accuracy.."%")
			api.text(ui,"normal","Joint 2 Detected: "..api.tostring2(Results.Joint[13].status))
			api.text(ui,"normal","Joint 2 Accuracy: "..Results.Joint[13].accuracy.."%")
			api.text(ui,"normal","Joint 3 Detected: "..api.tostring2(Results.Joint[14].status))
			api.text(ui,"normal","Joint 3 Accuracy: "..Results.Joint[14].accuracy.."%")
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Restart") then
				if settings.DeviceStatus then
					core.DeviceTestResetAll()
					core.select_option("Device Test Restart")
				end
			end
			ui:spacing(1)
			if ui:button("Quit") then
				core.DeviceTestResetAll()
				core.select_option("General")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance issues.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","In this cases, it is recommended you restart the test.")
			ui:windowEnd()
		end
	end
	if Name == "FST Home" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.simpletext(ui,"Finger Strength Test",40,true)
			api.simpletext(ui,"This comprises of a series of physical test with the glove. Below are the guidelines:",16,false)
			api.simpletext(ui,"[-] Ensure the device is connected securely to the Device.",18,false)
			api.simpletext(ui,"[-] Wear the gloves and keep your fingers straight, if possible.",18,false)
			api.simpletext(ui,"[-] When ready press the start button.",18,false)
			api.simpletext(ui,"[-] After the countdown, follow the instructions given precisely.",18,false)
			api.simpletext(ui,"[-] The test lasts and average of 1 minute.",18,false)
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Start") then
				if settings.DeviceStatus then
					core.select_option("Countdown")
				end
			end
			ui:spacing(1)
			if ui:button("Back") then
				core.select_option("General")
			end
			if ui:windowIsHovered() then
				if not settings.DeviceStatus then
					ui:tooltip("Error: Device Not Plugged")
				end
			end
			ui:spacing(1)
			ui:windowEnd()
			ui:windowEnd()
		end
		--if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
		--	ui:windowEnd()
		--end
	end
	if Name == "Countdown" then
		local timer = settings.countdown.time - api.timer.value("Countdown")
		audio.play(timer,"beep")
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.simpletext(ui,timer,300,true,"center")
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 3)
			api.simpletext(ui,"",20,true,"center")
			if ui:button("Quit") then
				core.select_option("quit")
			end
			ui:spacing(1)		
			ui:windowEnd()
		end
		--[[if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","In this cases, it is recommended you restart the test.")
			ui:windowEnd()
		end]]
	end
	if Name == "FST Running" then
		local timer = api.timer.value("FST")
		local Mode = settings.FST.CurrentMode
		local UnitMode = settings.FST.UnitTestMode
		local Lap = settings.FST.CurrentLap 
		local ElaspedTime = settings.FST.ElaspedTime
		local InstrSize = 48
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.simpletext(ui,"FINGER STRENGTH TEST:",24,true)
			if Mode == 1 then
				audio.play(1,UnitMode,Lap)
				 if UnitMode == 1 then
				 	api.simpletext(ui,"Bend "..api.fingertotext(Lap).." finger",InstrSize,true,"center")
				 else
				 	api.simpletext(ui,"Straighten "..api.fingertotext(Lap).." finger",InstrSize,true,"center")
				 end
			else
				audio.play(Lap,"Long",UnitMode)
				if UnitMode == 1 then
					api.simpletext(ui,"Straighten four fingers",InstrSize,true,"center")
					api.simpletext(ui,"Then Move Down",InstrSize,true,"center")
				else
					api.simpletext(ui,"Straighten four fingers",InstrSize,true,"center")
					api.simpletext(ui,"Keep the straight",InstrSize,true,"center")
				end
			end
			local x, y, width, height = ui:windowGetBounds()
			local imgWidth = 287*1.5
			local imgHeight = 292*1.5
			local xstart = x + ((width- imgWidth)/2)
			local ystart
			if Mode == 1 then
				ystart = 200
			else
				ystart = 250
			end
			ui:image(styles.images.hand, xstart, ystart, imgWidth, imgHeight)

			love.graphics.setColor(love.math.colorFromBytes(153, 229, 80))
			if Mode == 1 then
				local images = styles.images[api.fingertotext(Lap)]
				ui:image(images, xstart, ystart, imgWidth, imgHeight)
			else
				for i=2,5 do
					local images = styles.images[api.fingertotext(i)]
					ui:image(images, xstart, ystart, imgWidth, imgHeight)
				end
			end
			love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			api.simpletext(ui,"",24)
			ui:layoutRow('dynamic', 30, 3)
			ui:spacing(1)
			if ui:button("Quit") then
				core.select_option("quit")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance issues.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","Elasped Time: "..timer)
			ui:windowEnd()
		end
	end
	if Name == "FST Results Display Raw" then
		local Results = settings.FST.Results
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border', 'scrollbar') then
			api.simpletext(ui,"Finger Test Raw Data Results: ",32,true)
			api.simpletext(ui,"Total Score:",48,true)
			api.simpletext(ui,Results.Average,72,true)
			local size = 16
			for i=1,5 do
				api.simpletext(ui,api.fingertotext(i).." Total Score: "..Results["finger"..i].TotalScore,size)
				api.simpletext(ui,api.fingertotext(i).." Joint 1 Score: "..Results["finger"..i].Joint1Score,size)
				api.simpletext(ui,api.fingertotext(i).." Joint 2 Score: "..Results["finger"..i].Joint2Score,size)
				if i > 1 then api.simpletext(ui,api.fingertotext(i).." Joint 3 Score: "..Results["finger"..i].Joint3Score,size) end
			end
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			local size = 30
			ui:layoutRow('dynamic', 1, 1)
			api.simpletext(ui,"",16)
			--[[
			ui:layoutRow('dynamic', size, 5)
			ui:spacing(1)
			if ui:button("Analysed View") then
			end
			ui:spacing(1)
			if ui:button("Graphic View") then
			end
			ui:spacing(1)
			ui:layoutRow('dynamic', size, 5)
			ui:spacing(1)
			]]
			ui:layoutRow('dynamic', size, 3)
			if ui:button("Save Result to Disk") then
				core.FSTToDisk()
			end
			ui:spacing(1)
			if ui:button("Open Save Location") then
				--Depreciated: core.FSTToClipboard()
				api.opendir(api.getDir(api.getProfileDir().."/FST"))
			end
			ui:layoutRow('dynamic', size, 1)
			api.simpletext(ui,settings.FST.SaveLog,16)
			ui:layoutRow('dynamic', size, 5)
			ui:spacing(1)
			if ui:button("Restart") then
				if settings.DeviceStatus then
					core.select_option("FST Restart")
				end
			end
			ui:spacing(1)
			if ui:button("Quit") then
				core.select_option("General")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","In this cases, it is recommended you restart the test.")
			ui:windowEnd()
		end
	end
	if Name == "FST Results Quit" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.text(ui,"header","Finger Strength Test Aborted!")
			api.text(ui,"normal","The running Finger Strength Test was aborted by the User.")
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			ui:layoutRow('dynamic', 30, 5)
			ui:spacing(1)
			if ui:button("Restart") then
				if settings.DeviceStatus then
					core.select_option("FST Restart")
				end
			end
			ui:spacing(1)
			if ui:button("Quit") then
				core.select_option("General")
			end
			ui:spacing(1)
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.text(ui,"normal","NOTICE: Unplugging of Device is not noticed during testing due to performance.")
			api.text(ui,"normal","Unplugging the device during testing can lead to incorrect results.")
			api.text(ui,"normal","In this cases, it is recommended you restart the test.")
			ui:windowEnd()
		end
	end
	if Name == "HST Home" then
		if ui:windowBegin("A", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
			api.simpletext(ui,"Hand Montitoring Test",40,true)
			api.simpletext(ui,"Hand Montitoring is an entire library and tools that enable professionals track",16,false)
			api.simpletext(ui,"complicated forms of Paralysis. This tests are optimised for people with ",18,false)
			api.simpletext(ui,"severe grades of paralysis (hyper-sensitive test).",18,false)
			api.simpletext(ui,"",18,false)
			api.simpletext(ui,"The Hand Montitoring Libraries are:",18,false)
			api.simpletext(ui,"1. Hyper-Sensitive Hand Montitor ",18,false)
			api.simpletext(ui,"2. Automatic saving to disk",18,false)
			api.simpletext(ui,"3. Precision control",18,false)
			api.simpletext(ui,"",18,false)
			api.simpletext(ui,"You can either start a new hand monitoring test or load a previous one.",18,false)
			ui:windowEnd()
		end
		if ui:windowBegin("B", Windows2X, Windows2Y, Windows2Wid, Windows2Hht, 'border') then
			ui:layoutRow('dynamic', 100, 1)
			if ui:button("Start New Hand Montitoring Test") then
				core.select_option("New")
			end
			if ui:button("Load a previously saved hand monitoring Test") then
				core.select_option("load")
			end
			if ui:button("Quit") then
				core.select_option("quit")
			end
			ui:windowEnd()
		end
		if ui:windowBegin("C", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border') then
			api.simpletext(ui,"Hand monitoring features graphs, automatic saves and full customization.",18,false)
			ui:windowEnd()
		end
	end
if Name == "HST Running" then 
	Windows3Wid = Windows3Wid*0.5
	Windows3X = Width - 0- Windows3Wid
	local mode = settings.HST.mode
	local status = settings.HST.status[mode] 
	local PauseBtnTxt = ""
	local config = settings.HST.windows.settings
	local quickview = settings.HST.windows.quickview
	local graphicmonitor = settings.HST.windows.graphicmonitor
	local jointview = settings.HST.windows.jointview
	local lastsave = settings.HST.lastsave
	if mode == 2 then PauseBtnTxt = "Unpause" else PauseBtnTxt = "Pause" end

	if config["view"] then
		if ui:windowBegin("Settings", config["x"], config["y"], 300, 500, 'border', 'movable', 'title', 'scrollbar') then
			local x, y = ui:windowGetPosition()
			core.HSTUpdateWindows("settings",x,y)
			--ui:layoutRow('dynamic', 5, 1)
			api.simpletext(ui,"Monitor Fingers:",20,true)
			ui:layoutRow("dynamic",30, 2)
			for i=1,5 do
				local fingerstatus = settings.HST.config["finger"..i].Tracked
				local combo = {value = api.formatbol(fingerstatus,"number"), items = {'true', 'false'}}
				ui:label(api.fingertotext(i))
				if ui:combobox(combo, combo.items) then
					settings.HST.config["finger"..i].Tracked = api.tobol(combo.value)
				end
			end
			ui:layoutRow("dynamic",30, 1)
			ui:label("")
			local TS = {value=settings.HST.config.FingerCheckInterval}
			if ui:property("Test Sensitivity (ms):", 50, TS, 1000, 1, 1) then
				settings.HST.config.FingerCheckInterval = TS.value
			end
			ui:label("")
			TS = {value=settings.HST.config.DeviceCheckInterval}
			if ui:property("Device Check (mins):", 1, TS, 10, 1, 1) then
				settings.HST.config.DeviceCheckInterval = TS.value
			end
			ui:label("")
			TS = {value=settings.HST.config.AutomaticSaveInterval}
			if ui:property("Auto Save (mins):", 1, TS, 10, 1, 1) then
				settings.HST.config.AutomaticSaveInterval = TS.value
			end
			ui:label("")
			ui:label("Filename:")
			TS = {value=settings.HST.name}
			local state, changed = ui:edit('simple', TS)
			if changed then
				settings.HST.name = TS.value
			end
			ui:label("")
			TS = {value=settings.HST.config.ResetInterval}
			if ui:property("Current Reset (sec):", 2, TS, 600, 1, 1) then
				settings.HST.config.ResetInterval = TS.value
			end
			ui:windowEnd()
		end
	end
	
	if quickview["view"] then
		if ui:windowBegin(quickview.name, quickview["x"], quickview["y"], 300, 300, 'border', 'movable', 'title') then
			local x, y = ui:windowGetPosition()
			core.HSTUpdateWindows("quickview",x,y)
			local info = core.HSTValues("quickview")
			local time = settings.HST.config.ResetInterval
			api.simpletext(ui,"Current Interaction:",20)
			api.simpletext(ui,"|"..info.curinteraction,30,true)
			api.simpletext(ui,"Last Interaction ("..time.."s ago)",20)
			api.simpletext(ui,"|"..info.lastinteraction,30,true)
			ui:windowEnd()
		end
	end

	if graphicmonitor["view"] then
		if ui:windowBegin(graphicmonitor.name, graphicmonitor["x"], graphicmonitor["y"], 500, 500, 'border', 'movable', 'title') then
			local x, y, width, height = ui:windowGetBounds()
			core.HSTUpdateWindows("graphicmonitor",x,y)
			local x, y, width, height = ui:windowGetBounds()
			local imgWidth = 287*1.5
			local imgHeight = 292*1.5
			local xstart = x + ((width- imgWidth)/2)
			local ystart = y+50
			local JointX = {49,68,81,93,107,142,143,143,211,198,190,255,240,224}
			local JointY = {180,217,71,106,148,45,82,137,62,102,137,103,131,157}
			local radius = 10
			local JointT =  core.HSTValues("handimage")
			ui:layoutRow("dynamic",((ystart-y)+imgHeight),1)
			ui:image(styles.images.hand, xstart, ystart, imgWidth, imgHeight)
			if #JointX == #JointY then
				local xscale = imgWidth/287
				local yscale = imgHeight/292
				for count=1,#JointX do
					local xpos = xstart+(JointX[count]*xscale)
					local ypos = ystart+(JointY[count]*yscale)
					local status = JointT[count]
					api.ColoredCircle(ui,status,xpos,ypos,radius)
				end
			end
			ui:windowEnd()
		end
	end
	
	if jointview["view"] then
		if ui:windowBegin(jointview.name, jointview["x"], jointview["y"], 300, 600, 'border', 'movable', 'title') then
			local x, y = ui:windowGetPosition()
			core.HSTUpdateWindows("jointview",x,y)
			local info = core.HSTValues("jointview")
			local Selection = settings.HST.config.JointView
			local combo = {value = api.texttofinger(Selection), items = {'Thumb', 'Index', 'Middle', 'Ring', 'Pinky'}}
			api.simpletext(ui,"Finger:",20,true)
			if ui:combobox(combo, combo.items) then
				settings.HST.config.JointView = api.fingertotext(combo.value)
			end
			
			api.simpletext(ui,"Joint 1:",20)
			api.simpletext(ui,"|"..info.Joint1,30,true)
			api.simpletext(ui,"Joint 2",20)
			api.simpletext(ui,"|"..info.Joint2,30,true)
			if info.no > 2 then
				api.simpletext(ui,"Joint 3:",20)
				api.simpletext(ui,"|"..info.Joint3,30,true)
			end
			api.simpletext(ui,"Interaction: ",20)
			api.simpletext(ui,"|"..info.Interaction,30,true)
			ui:windowEnd()
		end
	end

api.simpletext(ui,"Status: "..status,18,false)
	if ui:windowBegin("Control Panel", Windows3X, Windows3Y, Windows3Wid, Windows3Hht, 'border','title','scrollbar','movable') then
		ui:layoutRow('dynamic', 30, 1)
		api.simpletext(ui,"Status: "..status,18,false)
		api.simpletext(ui,"Last Saved: "..lastsave,15,false)
		ui:layoutRow('dynamic', 30, 1)
		if ui:button(PauseBtnTxt) then
			core.togglepause()
		end
		if ui:button("Save") then
			core.HSTFileSave(mode)
		end
		if ui:button("Open Save Directory") then
			api.opendir(api.getDir(api.getProfileDir().."/HMT"))
		end
		if ui:button("Save and Quit") then
			core.HSTFileSave(mode)
			core.select_option("Quit")
			--core.HSTFileSave(mode)
		end
		if ui:button(core.GetBtnName("settings")) then
			core.HSTToggleWindows("settings")
		end
		if ui:button(core.GetBtnName("quickview")) then
			core.HSTToggleWindows("quickview")
		end
		if ui:button(core.GetBtnName("graphicmonitor")) then
			core.HSTToggleWindows("graphicmonitor")
		end
		if ui:button(core.GetBtnName("jointview")) then
			core.HSTToggleWindows("jointview")
		end
		--[[
		if ui:button("Debug") then
			core.An()
		end]]
		ui:windowEnd()
	end
end
if Name == "FileLoader" then
	local option = settings.FileLoader.option
	local Files = settings.FileLoader.FilesTemp
	if ui:windowBegin("FileLoader", Windows1X, Windows1Y, Windows1Wid, Windows1Hht, 'border') then
		api.simpletext(ui,"Select a file below and click the load",20,true)
		local optioncount = 1
		ui:layoutRow("dynamic",300,1)
		if ui:groupBegin("Select Files","border","scrollbar") then
			if option == 0 then
				api.simpletext(ui,"No file to load.",15)
			else
				ui:layoutRow("dynamic",20,1)
				api.simpletext(ui,"",20,false)
				local s 
				for id, name in pairs(Files) do
					local text = id..". "..name
					if option == id then
						s = true
					else
						s = false
					end
					if ui:selectable(text,s) then
						if id ~= option then
							settings.FileLoader.option = id
							settings.FileLoader.NameTemp = name
						end
					end
				end
			end
			ui:groupEnd()
		end
		ui:layoutRow("dynamic",50,5)
		ui:spacing(1)
		if ui:button("Load") then
			core.fileSystemLoad()
		end
		ui:spacing(1)
		if ui:button("Back") then
			core.select_option("quit")
		end
		ui:windowEnd()
		ui:spacing(1)
	end
end

end



styles.fonts = {}
function styles.fonts.request(name,size,fontname,logging)
	local fontsize =  size or 16
	local requestname = name..fontsize
	if not fontname then fontname = "Roboto-Regular" end
	if not styles.font[requestname] then
		if fontname == "Roboto-Bold" then
			styles.font[requestname] = love.graphics.newFont("Fonts/Roboto-Bold.ttf", fontsize)
			if logging and styles.font[requestname] then print("successfully loaded "..requestname.." font using font "..fontname) elseif logging and not styles.font[requestname] then print("An error/lag occured while loading "..requestname.." from font "..fontname) end
			return styles.font[requestname]
		elseif fontname == "Roboto-Regular" then
			styles.font[requestname] = love.graphics.newFont("Fonts/Roboto-Regular.ttf",fontsize)
			if logging and styles.font[requestname] then print("successfully loaded "..requestname.." font using font "..fontname) elseif logging and not styles.font[requestname] then print("An error/lag occured while loading "..requestname.." from font "..fontname) end
			return styles.font[requestname]
		end
	else
		if logging then print("successfully returned "..requestname.." font using font "..fontname) end
		return styles.font[requestname]
	end
end



return styles
