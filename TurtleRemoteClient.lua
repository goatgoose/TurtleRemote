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
	turtle.forward()
end

function moveBack()
	turtle.back()
end

function moveUp()
	turtle.up()
end

function moveDown()
	turtle.down()
end

function turnLeft()
	if turtle.turnLeft() then
		facing = (facing - 1) % 4

		sendData(textiutils.serialize({
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

		sendData(textiutils.serialize({
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

		elseif message == "moveForward" then
			moveForward()

		end
	end

end

function getInput()
	while true do
		clear()
		print("PRESS ENTER TO SCAN")
		local kEvent, param = os.pullEvent("key")
		if kEvent == "key" then
			if param == 28 then -- enter - http://computercraft.info/wiki/index.php?title=Raw_key_events
				scan()
			end
		end

	end
end

clear()
parallel.waitForAny(rednetListen, getInput)