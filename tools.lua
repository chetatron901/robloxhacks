local player = game:GetService("Players").LocalPlayer

local function checkRig()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))();
        else
            
			loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))();
			loadstring(game:HttpGet("https://raw.githubusercontent.com/chetatron901/robloxhacks/refs/heads/main/hug.lua"))();
        end
    end
end

if player.Character then
    checkRig()
end

player.CharacterAdded:Connect(checkRig)
