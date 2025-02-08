local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CurrentPlayerIndex = 1
local PlayerList = {}
local SelectedPlayer = nil
local TrackingEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTrackerGUI"
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.1, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.9, 0)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local BackButton = Instance.new("TextButton")
BackButton.Size = UDim2.new(0.2, 0, 1, 0)
BackButton.Position = UDim2.new(0, 0, 0, 0)
BackButton.Text = "<"
BackButton.TextColor3 = Color3.new(1, 1, 1)
BackButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
BackButton.BackgroundTransparency = 0
BackButton.Font = Enum.Font.SourceSansBold
BackButton.TextSize = 20
BackButton.BorderSizePixel = 0
BackButton.Parent = MainFrame

local ForwardButton = Instance.new("TextButton")
ForwardButton.Size = UDim2.new(0.2, 0, 1, 0)
ForwardButton.Position = UDim2.new(0.8, 0, 0, 0)
ForwardButton.Text = ">"
ForwardButton.TextColor3 = Color3.new(1, 1, 1)
ForwardButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ForwardButton.BackgroundTransparency = 0
ForwardButton.Font = Enum.Font.SourceSansBold
ForwardButton.TextSize = 20
ForwardButton.BorderSizePixel = 0
ForwardButton.Parent = MainFrame

BackButton.TextColor3 = Color3.new(1, 0, 1)
ForwardButton.TextColor3 = Color3.new(1, 0, 1)

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Size = UDim2.new(0.6, 0, 1, 0)
PlayerNameLabel.Position = UDim2.new(0.2, 0, 0, 0)
PlayerNameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.TextColor3 = Color3.new(1, 1, 1)
PlayerNameLabel.Font = Enum.Font.SourceSansBold
PlayerNameLabel.TextSize = 20
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Center
PlayerNameLabel.BorderSizePixel = 0
PlayerNameLabel.Parent = MainFrame
PlayerNameLabel.Text = "Загрузка..."

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.3, 0, 0.5, 0)
ToggleButton.Position = UDim2.new(0.35, 0, -0.5, 0)
ToggleButton.Text = "Вкл. Слежку" ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ToggleButton.BackgroundTransparency = 0
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = MainFrame

local PlayerNameArrow = Instance.new("TextLabel")
PlayerNameArrow.Size = UDim2.new(0.1, 0, 1, 0)
PlayerNameArrow.Position = UDim2.new(0.55, 0, 1, 0)
PlayerNameArrow.BackgroundColor3 = Color3.new(1, 1, 1)
PlayerNameArrow.BackgroundTransparency = 1
PlayerNameArrow.TextColor3 = Color3.new(1, 1, 0)
PlayerNameArrow.Font = Enum.Font.SourceSansBold
PlayerNameArrow.TextSize = 20
PlayerNameArrow.TextXAlignment = Enum.TextXAlignment.Center
PlayerNameArrow.BorderSizePixel = 0
PlayerNameArrow.Parent = MainFrame
PlayerNameArrow.Text = ""

local function UpdatePlayerList()
    PlayerList = Players:GetPlayers()

    table.remove(PlayerList, table.find(PlayerList, LocalPlayer))

    if #PlayerList > 0 then
        CurrentPlayerIndex = math.clamp(CurrentPlayerIndex, 1, #PlayerList)
        SelectedPlayer = PlayerList[CurrentPlayerIndex]
        PlayerNameLabel.Text = SelectedPlayer.Name
    else
        PlayerNameLabel.Text = "Нет игроков"
        SelectedPlayer = nil
    end

 if TrackingEnabled and SelectedPlayer then
  PlayerNameArrow.Text = "->"
 else
  PlayerNameArrow.Text = ""
 end
end

local function FollowPlayer()
    if TrackingEnabled and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = CFrame.new(SelectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 10), SelectedPlayer.Character.HumanoidRootPart.Position)
    else
        Camera.CameraType = Enum.CameraType.Custom
        --print("Невозможно следить за игроком. Персонаж не найден.")
    end
end

BackButton.MouseButton1Click:Connect(function()
    CurrentPlayerIndex = CurrentPlayerIndex - 1
    if CurrentPlayerIndex < 1 then
        CurrentPlayerIndex = #PlayerList
    end
    UpdatePlayerList()
    FollowPlayer()
end)

ForwardButton.MouseButton1Click:Connect(function()
    CurrentPlayerIndex = CurrentPlayerIndex + 1
    if CurrentPlayerIndex > #PlayerList then
        CurrentPlayerIndex = 1
    end
    UpdatePlayerList()
    FollowPlayer()
end)

ToggleButton.MouseButton1Click:Connect(function()
    TrackingEnabled = not TrackingEnabled
    if TrackingEnabled then
        ToggleButton.Text = "Выкл. Слежку"
  if SelectedPlayer then
   PlayerNameArrow.Text = "->"
  end
    else
        ToggleButton.Text = "Вкл. Слежку"
  PlayerNameArrow.Text = ""
        Camera.CameraType = Enum.CameraType.Custom
    end
 UpdatePlayerList()
    FollowPlayer()
end)

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)


UpdatePlayerList()
--FollowPlayer()

game:GetService("RunService").RenderStepped:Connect(function()
    if TrackingEnabled then
        FollowPlayer()
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

local ScriptLabel = Instance.new("TextLabel")
ScriptLabel.Size = UDim2.new(0.2, 0, 0.05, 0)
ScriptLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
ScriptLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ScriptLabel.BackgroundTransparency = 1
ScriptLabel.TextColor3 = Color3.new(1, 0, 1)
ScriptLabel.Font = Enum.Font.SourceSansBold
ScriptLabel.TextSize = 14
ScriptLabel.Text = "Script by https://t.me/puchpi"
ScriptLabel.Parent = ScreenGui
