-- TEMP
scanner = peripheral.wrap("left")

scan = scanner.sonicScan()

players = nil

function clear()
	term.clear()
	term.setCursorPos(1,1)
end

function getBlockCharacter(block)
	if block == "SOLID" then
		return "+"
	elseif block == "LIQUID" then
		return "~"
	elseif block == "AIR" then
		return "="
	else 
		return "0"
	end
end

function drawHorizontalMap(x1, y1, x2, y2)
	local offset = 0
	for i = 1, #scan do
		local block = scan[i]
		if block.x > offset then
			offset = block.x
		end
	end

	local xDistance = x2 - x1 -- even
	local yDistance = y2 - y1 -- even

	-- local xOffset = offset + x1 + (xDistance / 2)
	-- local yOffset = offset + y1 + (yDistance / 2)

	local xOffset = offset + x1
	local yOffset = offset + y1

	for i = 1, #scan do
		local block = scan[i]
		local screenX = block.x + xOffset
		local screenY = block.z + yOffset

		if screenX >= x1 and screenX <= x2 and screenY >= y1 and screenY <= y2 then
			term.setCursorPos(screenX, screenY)
			term.write(getBlockCharacter(block.type))
		end
	end

end

function drawVerticalMap(x1, y1, x2, y2)

end

function drawPlayerList(x1, y1, x2, y2)

end

function updateInterface()
	-- 51 x 19 computer
	-- 26 x 20 portable computer
	clear()
	drawHorizontalMap(1, 1, 51, 19)

end

function rednetListen()

end

function getInput()

end

-- parallel.waitForAny(rednetListen, getInput)

updateInterface()