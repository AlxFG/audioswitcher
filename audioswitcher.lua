#!/usr/bin/luajit

local function osExecute(cmd)
	local fileHandle     = assert(io.popen(cmd, 'r'))
	local commandOutput  = assert(fileHandle:read('*a'))
	return commandOutput
end

local function main()
	local devicestr = osExecute("pactl list short sinks")
	local devices = {}
	local current = osExecute("pactl get-default-sink"):gsub("%s+", "")
	local new = ""
	for substring in devicestr:gmatch("%S+") do
	   if string.find(substring, "alsa") then
		   table.insert(devices, substring)
	   end
	end

	for i = 1, #devices, 1 do
		if devices[i] == current then
			new = devices[i % #devices + 1]
		end
	end
	os.execute("pactl set-default-sink "..new)
	os.execute("notify-send 'Audio Device' 'Switched to '"..new.." -t 1000")
end

main()
