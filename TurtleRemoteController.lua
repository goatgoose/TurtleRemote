turtle_id = -1

scan = nil

players = nil

facing = -1

function clear()
	term.clear()
	term.setCursorPos(1,1)
end

function sendData(data)
	if turtle_id ~= -1 then
		rednet.send(turtle_id, data)
	end
end

function notify(notification)
	term.setCursorPos(1,1)
	term.clearLine()
	term.write(notification)
end

function sendId()
	rednet.broadcast("brain_id")
	return "ID SENT"
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

function getFacingCharacter(facing)
	if facing == 0 then
		return "^"
	elseif facing == 1 then
		return ">"
	elseif facing == 2 then
		return "v"
	elseif facing == 3 then
		return "<"
	end
end

function drawHorizontalMap(x1, y1, x2, y2)
	local xDistance = x2 - x1 -- odd
	local yDistance = y2 - y1 -- odd

	local xOffset = x1 + (xDistance / 2)
	local yOffset = y1 + (yDistance / 2)

	for i = 1, #scan do
		local block = scan[i]
		local screenX = block.x + xOffset + block.x
		local screenY = block.z + yOffset

		if screenX >= x1 and screenX <= x2 and screenY >= y1 and screenY <= y2 and block.y == 0 then
			term.setCursorPos(screenX, screenY)
			term.write(getBlockCharacter(block.type))
		end
	end

	term.setCursorPos(xOffset, yOffset)
	term.write(getFacingCharacter(facing))

end

function drawVerticalMap(x1, y1, x2, y2)

end

function drawPlayerList(x1, y1, x2, y2)

end

function updateInterface()
	-- 51 x 19 computer
	-- 26 x 20 portable computer
	clear()
	drawHorizontalMap(1, 2, 51, 18)

end

function rednetListen()
	rednet.open("back")
	while true do
		local id, message = rednet.receive()
		local dataTable = textutils.unserialize(message)
		local dataType = dataTable.dataType

		if dataType == "register" then
			if turtle_id == -1 then
				turtle_id = id
			end

		elseif dataType == "scan" then
			scan = dataTable.data.scan
			players = dataTable.data.players
			facing = dataTable.data.facing
			updateInterface()

		elseif dataType == "facing" then
			facing = dataTable.data.facing
			updateInterface()

		end
	end
end

function getInput()
	while true do
		local kEvent, param = os.pullEvent("key")
		if kEvent == "key" then
			if param == keys.i then -- http://computercraft.info/wiki/Keys_(API)
				notify(sendId())
			elseif param == keys.up then
				sendData(textutils.serialize({
					dataType = "moveForward",
					data = {}
				}))
			elseif param == keys.down then
				sendData(textutils.serialize({
					dataType = "moveBack",
					data = {}
				}))
			elseif param == keys.left then
				sendData(textutils.serialize({
					dataType = "turnLeft",
					data = {}
				}))
			elseif param == keys.right then
				sendData(textutils.serialize({
					dataType = "turnRight",
					data = {}
				}))
			elseif param == keys.equals then
				sendData(textutils.serialize({
					dataType = "moveUp",
					data = {}
				}))
			elseif param == keys.minus then
				sendData(textutils.serialize({
					dataType = "moveDown",
					data = {}
				}))
			end
		end

	end
end

clear()
parallel.waitForAny(rednetListen, getInput)