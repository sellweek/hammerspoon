spotifyItem = hs.menubar.new()

function getSongString()
	return hs.spotify.getCurrentArtist() .. " - " .. hs.spotify.getCurrentTrack()
end

function spotifyTimerCallback()
	apps = hs.application.applicationsForBundleID("com.spotify.client")
	if #apps > 0 then
		state = hs.spotify.getPlaybackState()
		-- The string.match functions have to be used because in Hammerspoon
		-- 0.9.46, Spotify extension includes quotes in constant state names
		-- and I don't want the menubar item to break when updating.
		if string.match(hs.spotify.state_stopped, state) ~= nil then
			spotifyItem:removeFromMenuBar()
			spotifyItem = nil
			print("in A")
		elseif string.match(hs.spotify.state_paused, state) ~= nil then
			spotifyItem:returnToMenuBar()
			spotifyItem:setTitle("⏸ " .. getSongString())
			print("in B")
		elseif string.match(hs.spotify.state_playing, state) ~= nil then
			spotifyItem:returnToMenuBar()
			spotifyItem:setTitle("▶️ " .. getSongString())
			print(getSongString())
		end
	else
		spotifyItem:removeFromMenuBar()
	end
end

hs.timer.doEvery(5, spotifyTimerCallback)
