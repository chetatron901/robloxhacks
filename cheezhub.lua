local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local spinning = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "CheezHub"

-- Create Frame
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 400, 0, 340)
frame.Position = UDim2.new(0.5, -200, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Input Box for Commands
local commandInput = Instance.new("TextBox")
commandInput.Parent = frame
commandInput.Size = UDim2.new(1, -20, 0, 40)
commandInput.Position = UDim2.new(0, 10, 0, 10)
commandInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
commandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInput.Font = Enum.Font.Gotham
commandInput.TextSize = 18
commandInput.PlaceholderText = "Enter Command Here"
commandInput.ClearTextOnFocus = false
commandInput.Text = ""

-- Explanation Box
local explanationFrame = Instance.new("Frame")
explanationFrame.Parent = frame
explanationFrame.Size = UDim2.new(1, -20, 0, 100)
explanationFrame.Position = UDim2.new(0, 10, 0, 60)
explanationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local explanationText = Instance.new("TextLabel")
explanationText.Parent = explanationFrame
explanationText.Size = UDim2.new(1, 0, 0, 40)
explanationText.Position = UDim2.new(0, 0, 0, 0)
explanationText.BackgroundTransparency = 1
explanationText.TextColor3 = Color3.fromRGB(255, 255, 255)
explanationText.Font = Enum.Font.Gotham
explanationText.TextSize = 16
explanationText.TextWrapped = true
explanationText.Text = "Type a command above to see its explanation."

-- Scrolling Command List
local commandListFrame = Instance.new("ScrollingFrame")
commandListFrame.Parent = frame
commandListFrame.Size = UDim2.new(1, -20, 0, 140)
commandListFrame.Position = UDim2.new(0, 10, 0, 170)
commandListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
commandListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
commandListFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = commandListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Command System with Name, Description, and Function
local commands = {
    ["reset"] = {
        description = "Kills your character.",
        execute = function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    },
    ["stop"] = {
        description = "Closes the GUI.",
        execute = function()
            screenGui:Destroy()
        end
    },
    ["givetool"] = {
        description = "Gives you a tool.",
        execute = function()
            if not player.Backpack:FindFirstChild("ExampleTool") then
                local tool = Instance.new("Tool")
                tool.Name = "ExampleTool"
                tool.Parent = player.Backpack
            end
        end
    },
    ["spin"] = {
        description = "Usage: spin [speed] - Makes your character spin.",
        execute = function(args)
            local speed = tonumber(args[2])
            if speed and speed > 0 then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    spinning = true
                    while spinning and char.Parent do  -- Check if character is still alive
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(speed), 0)
                        task.wait() -- To prevent freezing
                    end
                end
            else
                explanationText.Text = "Invalid speed. Usage: spin [number]"
            end
        end
    },
    ["unspin"] = {
        description = "Stops spinning.",
        execute = function()
            spinning = false
        end
    },
    ["fly"] = {
        description = "Makes your character fly.",
        execute = function()
            if player:GetAttribute("Flying") then
                return -- Prevent multiple BodyVelocity instances if already flying
            end

            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Parent = char.HumanoidRootPart

                player:SetAttribute("Flying", true)

                local userInputConnection
                userInputConnection = userInputService.InputBegan:Connect(function(input)
                    if not player:GetAttribute("Flying") then return end
                    if input.KeyCode == Enum.KeyCode.Space then
                        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                    elseif input.KeyCode == Enum.KeyCode.LeftShift then
                        bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                    end
                end)

                player:SetAttribute("FlyConnection", userInputConnection)
                player:SetAttribute("FlyVelocity", bodyVelocity)
            end
        end
    },
    ["unfly"] = {
        description = "Stops flying.",
        execute = function()
            player:SetAttribute("Flying", false)

            local flyVelocity = player:GetAttribute("FlyVelocity")
            local flyConnection = player:GetAttribute("FlyConnection")

            if flyVelocity then flyVelocity:Destroy() end
            if flyConnection then flyConnection:Disconnect() end
        end
    }
}

-- Execute Commands
local function executeCommand(command)
    local args = command:split(" ")
    local cmd = args[1]

    if commands[cmd] then
        commands[cmd].execute(args)
    else
        explanationText.Text = "Unknown command."
    end

    commandInput.Text = "" -- Clears the textbox
end

player.Chatted:Connect(function(message)
    if message:sub(1, 1) == "." then
        local command = message:sub(2) -- Remove the dot
        executeCommand(command)
    end
end)

commandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        executeCommand(commandInput.Text:lower())
    end
end)

-- Create Command Buttons
local function createCommandButton(command, description)
    local button = Instance.new("TextButton")
    button.Parent = commandListFrame
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Text = command

    button.MouseButton1Click:Connect(function()
        commandInput.Text = command
        explanationText.Text = description
        task.wait(0.05)
        commandInput:CaptureFocus()
    end)
end

-- Generate buttons for all commands
for command, data in pairs(commands) do
    createCommandButton(command, data.description)
end

-- Adjust the scrolling frame to fit the buttons
commandListFrame.CanvasSize = UDim2.new(0, 0, 0, #commands * 35)
