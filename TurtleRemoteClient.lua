scanner = peripheral.wrap("left")

brain_id = -1

facing = 0

function clear()
	term.clear()
	term.setCursorPos(1,1)
end

function sendData(data)
	if brain_id ~= -1 then
		rednet.send(brain_id, data)
	end
end

function moveForward()
	if turtle.forward() then
		sleep(0.3)
		scan()
	end
end

function moveBack()
	if turtle.back() then
		sleep(0.3)
		scan()
	end
end

function moveUp()
	if turtle.up() then
		sleep(0.3)
		scan()
	end
end

function moveDown()
	if turtle.down() then
		sleep(0.3)
		scan()
	end
end

function turnLeft()
	if turtle.turnLeft() then
		facing = (facing - 1) % 4

		sendData(textutils.serialize({
			dataType = "facing",
			data = {
				facing = facing
			}
		}))
	end
end

function turnRight()
	if turtle.turnRight() then
		facing = (facing + 1) % 4

		sendData(textutils.serialize({
			dataType = "facing",
			data = {
				facing = facing
			}
		}))
	end
end

function scan()
	local scan = scanner.sonicScan()
	local players = scanner.getPlayers()

	sendData(textutils.serialize({
		dataType = "scan",
		data = {
			scan = scan,
			players = players,
			facing = facing
		}
	}))
end

function rednetListen()
	rednet.open("right")
	while true do
		local id, message = rednet.receive()

		if message == "brain_id" then
			brain_id = id
			sendData(textutils.serialize({
				dataType = "register",
				data = {}
			}))
			scan()
		else
			local dataTable = textutils.unserialize(message)
			local dataType = dataTable.dataType

			if dataType == "moveForward" then
				moveForward()

			elseif dataType == "moveBack" then
				moveBack()

			elseif dataType == "turnLeft" then
				turnLeft()

			elseif dataType == "turnRight" then
				turnRight()

			elseif dataType == "moveUp" then
				moveUp()

			elseif dataType == "moveDown" then
				moveDown()

			end
		end
	end

end

function getInput()
	while true do
		clear()
		local kEvent, param = os.pullEvent("key")
		if kEvent == "key" then

		end

	end
end

clear()
parallel.waitForAny(rednetListen, getInput)