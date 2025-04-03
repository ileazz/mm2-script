-- Murder Mystery 2 Ultimate Cheat by Colin (Survival Edition)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local ESP = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Murderer = Color3.fromRGB(255, 0, 0)
}

-- Движущийся и ресайзящийся GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabButtons = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local CombatTabBtn = Instance.new("TextButton")
local VisualsTabBtn = Instance.new("TextButton")
local CombatFrame = Instance.new("ScrollingFrame")
local VisualsFrame = Instance.new("ScrollingFrame")
local ResizeHandle = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MM2SurvivalCheat"
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Active = true

-- Функция перемещения
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Функция изменения размера
ResizeHandle.Parent = MainFrame
ResizeHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Text = "↘"
ResizeHandle.TextColor3 = Color3.fromRGB(200, 200, 200)

local resizing = false
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UIS:GetMouseLocation()
        MainFrame.Size = UDim2.new(0, math.clamp(mouse.X - MainFrame.AbsolutePosition.X, 250, 600), 
                         0, math.clamp(mouse.Y - MainFrame.AbsolutePosition.Y, 200, 500))
    end
end)

-- Вкладки
CombatTabBtn.Name = "CombatTabBtn"
CombatTabBtn.Parent = MainFrame
CombatTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CombatTabBtn.Position = UDim2.new(0, 10, 0, 10)
CombatTabBtn.Size = UDim2.new(0, 100, 0, 30)
CombatTabBtn.Text = "Убийства"
CombatTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

VisualsTabBtn.Name = "VisualsTabBtn"
VisualsTabBtn.Parent = MainFrame
VisualsTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
VisualsTabBtn.Position = UDim2.new(0, 120, 0, 10)
VisualsTabBtn.Size = UDim2.new(0, 100, 0, 30)
VisualsTabBtn.Text = "ESP"
VisualsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Фреймы контента
CombatFrame.Name = "CombatFrame"
CombatFrame.Parent = MainFrame
CombatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CombatFrame.BorderSizePixel = 0
CombatFrame.Position = UDim2.new(0, 10, 0, 50)
CombatFrame.Size = UDim2.new(1, -20, 1, -70)
CombatFrame.ScrollBarThickness = 5
CombatFrame.Visible = true

VisualsFrame.Name = "VisualsFrame"
VisualsFrame.Parent = MainFrame
VisualsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
VisualsFrame.BorderSizePixel = 0
VisualsFrame.Position = UDim2.new(0, 10, 0, 50)
VisualsFrame.Size = UDim2.new(1, -20, 1, -70)
VisualsFrame.ScrollBarThickness = 5
VisualsFrame.Visible = false

-- Переключение вкладок
CombatTabBtn.MouseButton1Click:Connect(function()
    CombatFrame.Visible = true
    VisualsFrame.Visible = false
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    VisualsTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

VisualsTabBtn.MouseButton1Click:Connect(function()
    CombatFrame.Visible = false
    VisualsFrame.Visible = true
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    VisualsTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

-- Элементы управления
local function CreateToggle(parent, name, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.Size = UDim2.new(1, -20, 0, 30)
    Toggle.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 35 + 10)
    Toggle.Text = name
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local state = false
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
    
    return Toggle
end

-- Функционал чита
CreateToggle(CombatFrame, "Убивать Мардера мгновенно", function(state)
    getgenv().AutoKillMurderer = state
    while AutoKillMurderer and task.wait(0.5) do
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Knife") then
                game:GetService("ReplicatedStorage").Events.Hit:FireServer(v.Character.Humanoid, true)
            end
        end
    end
end)

CreateToggle(CombatFrame, "Шериф: убивать Мардера при виде", function(state)
    getgenv().SheriffInstaKill = state
    while SheriffInstaKill and task.wait(0.5) do
        if Player.Character and Player.Character:FindFirstChild("Gun") then
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("Knife") then
                    game:GetService("ReplicatedStorage").Events.Hit:FireServer(v.Character.Humanoid, true)
                end
            end
        end
    end
end)

CreateToggle(VisualsFrame, "Включить ESP", function(state)
    getgenv().ESPToggle = state
    if not ESPToggle then
        for _, v in ipairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                v.Character.Highlight:Destroy()
            end
        end
        return
    end

    local function UpdateESP()
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= Player and v.Character then
                local highlight = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight")
                highlight.Parent = v.Character
                highlight.Adornee = v.Character
                highlight.FillTransparency = 0.5

                if v.Character:FindFirstChild("Knife") then
                    highlight.FillColor = ESP.Murderer
                elseif v.Character:FindFirstChild("Gun") then
                    highlight.FillColor = ESP.Sheriff
                else
                    highlight.FillColor = ESP.Innocent
                end
            end
        end
    end

    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        if not ESPToggle then conn:Disconnect() return end
        UpdateESP()
    end)
end)