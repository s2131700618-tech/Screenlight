local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local playerGui = script.Parent
local UserInputService = game:GetService("UserInputService")
 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DynamicUI"
screenGui.Parent = playerGui
 
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 150, 0, 60)
frame.Position = UDim2.new(0.25, -75, 0.4, -15)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Active = true 
frame.Parent = screenGui
 
local textLabel = Instance.new("TextLabel")
textLabel.Name = "TitleLabel"
textLabel.Size = UDim2.new(1, 0, 0, 30)
textLabel.Text = "Ultra 螢幕中央照明燈 V1.0"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 12
textLabel.BackgroundTransparency = 1
textLabel.Parent = frame
 
local lightButton = Instance.new("TextButton")
lightButton.Name = "TitleButton"
lightButton.Position = UDim2.new(0, 0, 0, 30)
lightButton.Size = UDim2.new(1, 0, 0, 30)
lightButton.Text = "啟用螢幕照明燈"
lightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lightButton.BackgroundColor3 = Color3.fromRGB(64, 192, 255)
lightButton.TextSize = 14
lightButton.BackgroundTransparency = 0
lightButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Name = "TitleButton"
closeButton.Position = UDim2.new(0, 0, 0, -30)
closeButton.Size = UDim2.new(0, 45, 0, 30)
closeButton.Text = "關閉"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextSize = 16
closeButton.BackgroundTransparency = 0
closeButton.Parent = frame
 
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local MAX_DISTANCE = 500 

local currentHitPosition = Vector3.zero
local hasHit = false
 
local part = Instance.new("Part")
part.Size = Vector3.new(1, 1, 1)
part.Position = Vector3.new(0, -5000, 0)
part.Color = Color3.fromRGB(255, 255, 255) 
part.Material = Enum.Material.Neon
part.Anchored = true
part.CanCollide = false
part.Parent = Workspace
 
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(255, 255, 255)
light.Range = 80
light.Brightness = 3
light.Shadows = true
light.Enabled = false
light.Parent = part
 
local isLightEnabled = false
 
RunService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    
    local cameraOrigin = camera.CFrame.Position
    local cameraDirection = camera.CFrame.LookVector * MAX_DISTANCE
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, part}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = Workspace:Raycast(cameraOrigin, cameraDirection, raycastParams)
    
    if raycastResult then
        hasHit = true
        currentHitPosition = raycastResult.Position
        part.Position = currentHitPosition + Vector3.new(0, 0.5, 0)
    else
        hasHit = false
        part.Position = Vector3.new(0, -5000, 0)
    end
end)

local function spawnBlockAtPlayer(player)
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if isLightEnabled and hasHit then
        light.Enabled = true
    else
        light.Enabled = false
    end
end

local dragging = false
local dragStart, startPos
 
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = frame.AbsolutePosition
        local frameSize = frame.AbsoluteSize
        
        local topbarInset = 36 
        local adjustedMouseY = mousePos.Y - topbarInset
        
        if mousePos.X >= framePos.X and mousePos.X <= (framePos.X + frameSize.X) and
            adjustedMouseY >= framePos.Y and adjustedMouseY <= (framePos.Y + frameSize.Y) then
            
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end
end)
 
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
        )
    end
end)
 
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
 
local function onClick()
    isLightEnabled = not isLightEnabled
    
    if isLightEnabled then
        lightButton.Text = "停用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(255, 64, 64) 
    else
        lightButton.Text = "啟用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(64, 192, 255)
    end
end
 
lightButton.MouseButton1Click:Connect(onClick)

task.defer(function()
    while true do
        spawnBlockAtPlayer(player)
        task.wait(0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if screenGui then
        screenGui:Destroy()
        part:Destroy()
    end
end)
