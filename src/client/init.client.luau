local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ismoving = false
local reloadtime = 1
local reloadtime2 = .1
local canattack = true
local canmove = true
local radius = 1

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
local function Raycastvisible(origin, hitPosition)
	local midpoint = (origin + hitPosition) / 2
	local part = Instance.new("Part")
	part.Parent = workspace
	part.Anchored = true
	part.CanCollide = false
	part.Size = Vector3.new(0.2, 0.2, (hitPosition - origin).Magnitude)
	part.CFrame = CFrame.new(midpoint, hitPosition)
	part.Material = Enum.Material.Neon
	part.BrickColor = BrickColor.new("Really red")

	--remove after 1 second
	task.delay(1, function()
		part:Destroy()
	end)
end

local function OnInputBegan2(inputObject, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		if canattack == true then
			local lookVector = workspace.CurrentCamera.CFrame.LookVector
			local origin = rootPart.Position
			local direction = lookVector * 100 
			canattack = false
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = {character}
			local rayresult = workspace:Raycast(origin, direction, params)
			if rayresult then
				print("hit", rayresult.Instance)
				Raycastvisible(origin, rayresult.Position)
			else
				print("nothing")
				Raycastvisible(origin, origin + direction) 
			end
			task.delay(reloadtime2, function()
					canattack = true
				end)
		end
	end
end
UIS.InputBegan:Connect(OnInputBegan)
UIS.InputBegan:Connect(OnInputBegan2)
