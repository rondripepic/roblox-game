local UIS = game:GetService("UserInputService")

local ismoving = false
local reloadtime = 1
local canmove = true

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local attachment = Instance.new("Attachment")
attachment.Parent = rootPart

local vectorForce = Instance.new("VectorForce")
vectorForce.Attachment0 = attachment
vectorForce.Force = Vector3.new(0, 0, 0)
vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
vectorForce.Parent = rootPart

local function OnInputBegan(inputObject, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		if inputObject.KeyCode == Enum.KeyCode.E then
			local lookVector = workspace.CurrentCamera.CFrame.LookVector
			if ismoving == false and canmove == true then
				ismoving = true
				canmove = false
				vectorForce.Force = lookVector * 50000
				task.delay(.1, function()
					vectorForce.Force = Vector3.new(0, 0, 0)
					ismoving = false
					rootPart.Velocity = Vector3.new(0, 0, 0)
					rootPart.RotVelocity = Vector3.new(0, 0, 0)
				end)
				task.delay(reloadtime, function()
					canmove = true
				end)
			end
		end
	end
end

UIS.InputBegan:Connect(OnInputBegan)
