local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- 建立 UI 介面
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DynamicUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0.25, -75, 0.4, -15)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TitleLabel"
textLabel.Size = UDim2.new(1, 0, 0, 30)
textLabel.Text = "Ultra 螢幕中央照明燈 V1.1ß"
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
settingBox.BackgroundTransparency = 0.3
settingBox.Visible = false
settingBox.ClipsDescendants = true
settingBox.Parent = frame

local lightText = Instance.new("TextLabel")
lightText.Name = "LightText"
lightText.Size = UDim2.new(0.5, 0, 0.5, 0)
lightText.Text = "擴散距離 : "
lightText.TextColor3 = Color3.fromRGB(255, 255, 255)
lightText.TextSize = 12
lightText.BackgroundTransparency = 1
lightText.Parent = settingBox

local lightTextBox = Instance.new("TextBox")
lightTextBox.Name = "LightTextBox"
lightTextBox.Position = UDim2.new(0.5, 0, 0, 0)
lightTextBox.Size = UDim2.new(0.5, 0, 0.5, 0)
lightTextBox.Text = "80"
lightTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
lightTextBox.TextSize = 12
lightTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lightTextBox.Parent = settingBox

local brightText = Instance.new("TextLabel")
brightText.Name = "BrightText"
brightText.Position = UDim2.new(0, 0, 0.5, 0)
brightText.Size = UDim2.new(0.5, 0, 0.5, 0)
brightText.Text = "亮度 : "
brightText.TextColor3 = Color3.fromRGB(255, 255, 255)
brightText.TextSize = 12
brightText.BackgroundTransparency = 1
brightText.Parent = settingBox

local brightTextBox = Instance.new("TextBox")
brightTextBox.Name = "BrightTextBox"
brightTextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
brightTextBox.Size = UDim2.new(0.5, 0, 0.5, 0)
brightTextBox.Text = "3"
brightTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
brightTextBox.TextSize = 12
brightTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
brightTextBox.Parent = settingBox

-- 變數設定
local MAX_DISTANCE = 100000
local isLightEnabled = false
local setting = false
local Height = 0

local currentRange = 80
local currentBrightness = 10

-- 建立照明燈零件
local part = Instance.new("Part")
part.Size = Vector3.new(0.2, 0.2, 0.2)
part.Position = Vector3.new(0, -5000, 0)
part.Transparency = 1
part.Anchored = true
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
part.Parent = Workspace

-- 建立 6 個方向的 SurfaceLight
local lightFaces = {
    Enum.NormalId.Front, Enum.NormalId.Back,
    Enum.NormalId.Left, Enum.NormalId.Right,
    Enum.NormalId.Top, Enum.NormalId.Bottom
}
local lights = {}

for _, face in ipairs(lightFaces) do
    local light = Instance.new("SurfaceLight")
    light.Face = face
    light.Color = Color3.fromRGB(255, 255, 255)
    light.Range = currentRange
    light.Brightness = currentBrightness
    light.Angle = 150
    light.Shadows = false
    light.Enabled = false
    light.Parent = part
    table.insert(lights, light)
end

local function updateAllLights()
    for _, light in ipairs(lights) do
        light.Range = currentRange
        light.Brightness = currentBrightness
        light.Enabled = isLightEnabled
    end
end

-- 影格刷新：射線定位與 UI 展開動畫
RunService.RenderStepped:Connect(function(deltaTime)
    local character = player.Character
    if character and camera then
        local cameraOrigin = camera.CFrame.Position
        local cameraDirection = camera.CFrame.LookVector * MAX_DISTANCE

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character, part}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        local raycastResult = Workspace:Raycast(cameraOrigin, cameraDirection, raycastParams)
        if raycastResult then
            part.Position = raycastResult.Position
        else
            part.Position = cameraOrigin + cameraDirection
        end
        
        for _, light in ipairs(lights) do
            light.Enabled = isLightEnabled
        end
    end
  
    local targetHeight = setting and 60 or 0
    Height = Height + ((targetHeight - Height) * (1 - math.exp(-15 * deltaTime)))
    if math.abs(Height - targetHeight) < 0.1 then Height = targetHeight end
    settingBox.Size = UDim2.new(1, 0, 0, Height)
    settingBox.Visible = (Height > 1)
end)
-- 按鈕事件
lightButton.MouseButton1Click:Connect(function()
    isLightEnabled = not isLightEnabled
    if isLightEnabled then
        lightButton.Text = "停用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(255, 64, 64)
    else
        lightButton.Text = "啟用螢幕照明燈"
        lightButton.BackgroundColor3 = Color3.fromRGB(64, 192, 255)
    end
    updateAllLights()
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    part:Destroy()
end)

setButton.MouseButton1Click:Connect(function()
    setting = not setting
end)

lightTextBox.FocusLost:Connect(function()
    local num = tonumber(lightTextBox.Text)
    if num then
        currentRange = math.max(num, 0)
        lightTextBox.Text = tostring(currentRange)
    else
        lightTextBox.Text = tostring(currentRange)
    end
    updateAllLights()
end)

brightTextBox.FocusLost:Connect(function()
    local num = tonumber(brightTextBox.Text)
    if num then
        currentBrightness = math.max(num, 0)
        brightTextBox.Text = tostring(currentBrightness)
    else
        brightTextBox.Text = tostring(currentBrightness)
    end
    updateAllLights()
end)
