settings = {}

settings.layout = {}
settings.layout.CurrentMode = "Profiles"

settings.operations = {}
settings.operations.All = {"Device Test", "Finger Strength Test", "Hand Monitoring Test"}
settings.operations.Tooltips = {}
settings.operations.Tooltips["Device Test"] = "Test if Device operations are functioning properly and test speed."
settings.operations.Tooltips["Finger Strength Test"] = "Perform tests on various fingers to check for problems."
settings.operations.Tooltips["Hand Monitoring Test"] = "Monitor the finger for long period of time for movements."
settings.operations.Available = {1,2,3}
settings.operations.Selection = 1

---Device Test Settings and Result storage
settings.DeviceTest = {}
settings.DeviceTest.TestTime = 1000
settings.DeviceTest.JointStatus = {}
settings.DeviceTest.jointframecount = {}
settings.DeviceTest.Results = {}
for i=1,14 do
	settings.DeviceTest.JointStatus[i] = nil
	settings.DeviceTest.jointframecount[i] = 0
end
settings.DeviceTest.framecount = 0
settings.DeviceTest.status = false

--FST Setting and Storage
settings.FST = {}
settings.FST.IsDone = false
settings.FST.CurrentMode = 1 -- 1 is testing individual fingers, 2 is testing palm.
settings.FST.UnitTestMode = 1 --1 is dowm, 2 is up.
settings.FST.CurrentTestingKey = 1 --1-5 represents Thumb - Pinky
settings.FST.Mode1Time = 4 
settings.FST.Mode2Time = 4
settings.FST.Mode1Laps = 5
settings.FST.Mode2Laps = 3
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

---------HST Settings
settings.HST = {}
settings.HST.Result = {}
settings.HST.config = {}
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
settings.HST.name = "Default"
settings.HST.lastname = "Default"
settings.HST.lastsave = "Never"
settings.HST.mode = 1
settings.HST.status = {"Running","Paused","Saving to Disk","Device Unplugged...Paused"}
settings.HST.windows = {}
settings.HST.windows.settings = {view=false,x=10,y=10}
settings.HST.windows.quickview = {view=true,x=1100,y=10,name="Quick View"}
settings.HST.windows.graphicmonitor = {view=true,x=400,y=10,name="Graphic Monitor"}
settings.HST.windows.jointview = {view=true,x=10,y=10,name="Joint View"}
settings.HST.windows.fullview = {view=false,x=500,y=500,name="Full View"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Finger
----------------------------------------------------------------------------------------------------------------------------------------------------------
settings.finger = {}
settings.finger.finger1={}
settings.finger.finger2={}
settings.finger.finger3={}
settings.finger.finger4={}
settings.finger.finger5={}
settings.finger.finger1.Joint1 = "c" --1
settings.finger.finger1.Joint2 = "c" --2
settings.finger.finger2.Joint1 = "m" --3
settings.finger.finger2.Joint2 = "m" --4
settings.finger.finger2.Joint3 = "m" --5l
settings.finger.finger3.Joint1 = "z" --6
settings.finger.finger3.Joint2 = "z" --7
settings.finger.finger3.Joint3 = "z" --8ol
settings.finger.finger4.Joint1 = "z" --9
settings.finger.finger4.Joint2 = "z" --10
settings.finger.finger4.Joint3 = "z" --11
settings.finger.finger5.Joint1 = "m" --12
settings.finger.finger5.Joint2 = "m" --13
settings.finger.finger5.Joint3 = "m" --14
settings.finger.keymap = ""
settings.finger.joints = {}
for i=1,5 do
	local times = 3
	if i == 1 then
		times = 2
	end
	for f=1,times do
		local finger = settings.finger["finger"..i]
		settings.finger.keymap = settings.finger.keymap..finger["Joint"..f]
	end
end
--Joint to Key
local count = 1
for i=1,5 do
	local times = 3
	if i==1 then times = 2 end
	for f=1,times do
		local finger = settings.finger["finger"..i]
		local key = finger["Joint"..f]
		settings.finger.joints[count] = key
		count = count + 1
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
settings.countdown = {}
settings.countdown.time = 5
settings.countdown.option = "General"
settings.countdown.quit = "General"

settings.FileLoader = {}
settings.FileLoader.option = 0
settings.FileLoader.FilesTemp = {}
settings.FileLoader.FileTemp = ""
settings.FileLoader.Completed = false
settings.FileLoader.quit = ""
settings.FileLoader.success = ""
settings.FileLoader.Path = ""
settings.FileLoader.NameTemp = ""
--settings.selected = false

settings.DeviceStatus = false
settings.version = "BETA V2025.6.3 "

settings.profiles = {}
settings.profiles.loaded = ""
settings.profiles.all = {}
settings.profiles.state = 1
settings.profiles.createtemp = {}
settings.profiles.createtemp.name = "Name"
settings.profiles.createtemp.gender = {"Male","Female","N/A"}
settings.profiles.createtemp.gendersel = 1
settings.profiles.createtemp.age = 20
settings.profiles.createtemp.phonenum = "08142731185"
settings.profiles.current = {}

return settings