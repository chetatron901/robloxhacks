local tool = Instance.new("Tool")
tool.Name = "HugTool"
tool.RequiresHandle = false

tool.Parent = game.Players.LocalPlayer.Backpack

local play1, play2

local function playHugAnimation()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local anim1 = Instance.new("Animation")
            anim1.AnimationId = "rbxassetid://283545583" -- Hug animation 1
            play1 = humanoid:LoadAnimation(anim1)
            
            local anim2 = Instance.new("Animation")
            anim2.AnimationId = "rbxassetid://225975820" -- Hug animation 2
            play2 = humanoid:LoadAnimation(anim2)
            
            play1:Play()
            play2:Play()
        else
            warn("HugTool only supports R6 rigs!")
        end
    end
end

local function stopHugAnimation()
    if play1 and play2 then
        play1:Stop()
        play2:Stop()
    end
end

tool.Equipped:Connect(playHugAnimation)
tool.Unequipped:Connect(stopHugAnimation)
