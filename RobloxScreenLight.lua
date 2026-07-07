local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
 
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DynamicUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
 
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0.25, -75, 0.4, -15)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
 
local textLabel = Instance.new("TextLabel")
textLabel.Name = "TitleLabel"
textLabel.Size = UDim2.new(1, 0, 0, 30)
textLabel.Text = "Ultra 螢幕中央照明燈 V1.1"
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
lightButton.Parent = frame
 
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Position = UDim2.new(0, 0, 0, -30)
closeButton.Size = UDim2.new(0, 45, 0, 30)
closeButton.Text = "關閉"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextSize = 16
closeButton.Parent = frame
 
local setButton = Instance.new("TextButton")
setButton.Name = "SetButton"
setButton.Position = UDim2.new(0, -45, 0, 30)
setButton.Size = UDim2.new(0, 45, 0, 30)
setButton.Text = "設定"
setButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setButton.BackgroundColor3 = Color3.fromRGB(128, 128, 0)
setButton.TextSize = 16
setButton.Parent = frame
 
local settingBox = Instance.new("Frame")
settingBox.Name = "SettingsFrame"
settingBox.Position = UDim2.new(0, 0, 0, 60)
settingBox.Size = UDim2.new(1, 0, 0, 0)
settingBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
settingBox.BackgroundTransparency = 0.5
settingBox.Visible = true
settingBox.Parent = frame
 
local lightText = Instance.new("TextLabel")
lightText.Name = "LightText"
lightText.Size = UDim2.new(0.5, 0, 0.5, 0)
lightText.Text = "擴散距離 : "
lightText.TextColor3 = Color3.fromRGB(255, 255, 255)
lightText.TextSize = 14
lightText.BackgroundTransparency = 1
lightText.Parent = settingBox
 
local lightTextBox = Instance.new("TextBox")
lightTextBox.Name = "LightTextBox"
lightTextBox.Position = UDim2.new(0.5, 0, 0, 0)
lightTextBox.Size = UDim2.new(0.5, 0, 0.5, 0)
lightTextBox.Text = "80"
lightTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
lightTextBox.TextSize = 14
lightTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lightTextBox.Parent = settingBox
 
local brightText = Instance.new("TextLabel")
brightText.Name = "BrightText"
brightText.Position = UDim2.new(0, 0, 0.5, 0)
brightText.Size = UDim2.new(0.5, 0, 0.5, 0)
brightText.Text = "亮度 : "
brightText.TextColor3 = Color3.fromRGB(255, 255, 255)
brightText.TextSize = 14
brightText.BackgroundTransparency = 1
brightText.Parent = settingBox
 
local brightTextBox = Instance.new("TextBox")
brightTextBox.Name = "BrightTextBox"
brightTextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
brightTextBox.Size = UDim2.new(0.5, 0, 0.5, 0)
brightTextBox.Text = "3"
brightTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
brightTextBox.TextSize = 14
brightTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
brightTextBox.Parent = settingBox
 
local MAX_DISTANCE = 500
local isLightEnabled = false
 
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
 
RunService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    
    if isLightEnabled then
        local cameraOrigin = camera.CFrame.Position
        local cameraDirection = camera.CFrame.LookVector * MAX_DISTANCE
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character, part}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local raycastResult = Workspace:Raycast(cameraOrigin, cameraDirection, raycastParams)
        
        if raycastResult then
            part.Position = raycastResult.Position + Vector3.new(0, 0.5, 0)
        else
            part.Position = cameraOrigin + cameraDirection
        end
        
        light.Enabled = true
    else
        light.Enabled = false
        part.Position = Vector3.new(0, -5000, 0)
    end
end)
 
-- Button Events
lightButton.MouseButton1Click:Connect(function()
    isLightEnabled = not isLightEnabled
    if isLightEnabled then
        lightButton.Text = "停用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(255, 64, 64)
    else
        lightButton.Text = "啟用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(64, 192, 255)
    end
end)
 
closeButton.MouseButton1Click:Connect(function() 
    screenGui:Destroy()
    part:Destroy()
end)
 
setButton.MouseButton1Click:Connect(function()
    setting = not setting
end)
 
lightTextBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(lightTextBox.Text)
    if num then
        light.Range = num
    else
        lightTextBox.Text = tostring(light.Range)
    end
end)
 
brightTextBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(brightTextBox.Text)
    if num then
        light.Brightness = math.clamp(num, 0, 50)
    else
        brightTextBox.Text = tostring(light.Brightness)
    end
end)
 
local function setInterval(func, delay_seconds)
    return task.spawn(function()
        while true do
            task.wait(delay_seconds)
            func()
        end
    end)
end
 
local Height = 0

local function updateSettingBox()
    if setting then
        Height += ((60 - Height) / 10)
    else
        Height += ((0 - Height) / 10)
    end
    settingBox.Size = UDim2.new(settingBox.Size.X.Scale, settingBox.Size.X.Offset, settingBox.Size.Y.Scale, Height)
    
    if Height >= 1 then
        settingBox.Visible = true
    else
        settingBox.Visible = false
    end
end
 
local myInterval = setInterval(updateSettingBox, 0.05)
 
RunService.RenderStepped:Connect(updateSettingBox)
