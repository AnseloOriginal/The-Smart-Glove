audio = {}

function audio.init()
  audio.library = {}
  audio.library["beep"] = love.audio.newSource("sounds/beep.wav","static")
  audio.library["1 1"] = love.audio.newSource("sounds/Bend Thumb.ogg","static")
  audio.library["2 1"] = love.audio.newSource("sounds/Straighten Thumb.ogg","static")
  audio.library["1 2"] = love.audio.newSource("sounds/Bend Index.ogg","static")
  audio.library["2 2"] = love.audio.newSource("sounds/Straighten Index.ogg","static")
  audio.library["1 3"] = love.audio.newSource("sounds/Bend Middle.ogg","static")
  audio.library["2 3"] = love.audio.newSource("sounds/Straighten Middle.ogg","static")
  audio.library["1 4"] = love.audio.newSource("sounds/Bend Ring.ogg","static")
  audio.library["2 4"] = love.audio.newSource("sounds/Straighten Ring.ogg","static")
  audio.library["1 5"] = love.audio.newSource("sounds/Bend Pinky.ogg","static")
  audio.library["2 5"] = love.audio.newSource("sounds/Straighten Pinky.ogg","static")
  audio.library["Long 1"] = love.audio.newSource("sounds/Four Straighten.ogg","static")
  audio.library["Long 2`"] = love.audio.newSource("sounds/Four Move Down.ogg","static")
  audio.playlist = {}
  audio.library["beep"]:play()
end

function audio.play(once,sound,extra)
  local str = ""
  if (extra ~= nil) then
    str = tostring(sound) .. " " .. tostring(extra)
  else
    str = tostring(sound)
  end
  local last = audio.playlist[str]
  if (audio.library[str] ~= nil and last ~= once) then
    audio.library[str]:play()
    audio.playlist[str] = once
  else
    --print("Cannot play audio.Values: ",once,sound,extra,str)
  end
end

return audio