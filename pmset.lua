local pmsetItem = hs.menubar.new()

function getPmsetStatus(cb)
	hs.task.new("/usr/bin/pmset", function(exitCode, stdOut, stdErr)
		if exitCode ~= 0 then
			hs.notify("pmset error", "Couldn't get pmset status", stdErr)
			return
		end
		local _, _, captures = string.find(stdOut, "hibernatemode +(%d+)")
		cb(tonumber(captures))
	end, {"-g"}):start()
end

function setPmsetStatus(status, cb)
	hs.task.new("/usr/local/bin/macsudo", function(exitCode, stdOut, stdErr)
		if exitCode ~= 0 then
			hs.notify.show("pmset error", "Couldn't set pmset attribute", stdOut)
			return
		else
			cb()
		end
	end, {"-p", "pmset", "pmset", "-a", "hibernatemode", tostring(status)}):start()
end

getPmsetStatus(function(status)
	pmsetItem:setTitle(tostring(status))
end)

pmsetItem:setClickCallback(function()
	getPmsetStatus(function(status)
		if status ~= 3 then
			setPmsetStatus(3, function()
				pmsetItem:setTitle("3")
			end)
		else
			setPmsetStatus(25, function()
				pmsetItem:setTitle("25")
			end)
		end
	end)
end)
