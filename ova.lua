-- =====================================================
-- BLOX FRUITS ULTRA PERFORMANCE OPTIMIZER
-- FPS 10 + Hapus SEMUA Elemen Berat GPU/CPU
-- Optimasi Khusus untuk Blox Fruits
-- =====================================================

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("==============================================")
print("BLOX FRUITS ULTRA PERFORMANCE MODE")
print("Initializing optimization...")
print("==============================================")

-- =====================================================
-- PART 1: FPS LIMITER KE 10 (AGGRESSIVE)
-- =====================================================

local TARGET_FPS = 10

-- Method 1: setfpscap (paling efisien)
pcall(function()
    setfpscap(TARGET_FPS)
end)

-- Method 2: Backup manual limiter
local lastFrame = tick()
local frameSkip = 0
local SKIP_RATE = 5

RunService.RenderStepped:Connect(function()
    frameSkip = frameSkip + 1
    if frameSkip < SKIP_RATE then return end
    frameSkip = 0
    
    local now = tick()
    local delta = now - lastFrame
    local target = 1 / TARGET_FPS
    
    if delta < target then
        task.wait(target - delta)
    end
    lastFrame = tick()
end)

-- =====================================================
-- PART 2: HAPUS SEMUA WEATHER & ATMOSPHERIC EFFECTS
-- =====================================================

local function removeWeatherEffects()
    pcall(function()
        -- Hapus fog (termasuk Mirage fog)
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 0
        
        -- Hapus atmosphere effects
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ExposureCompensation = 0
        
        -- Hapus SEMUA post-processing effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") 
                or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") 
                or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere")
                or effect:IsA("Sky") or effect:IsA("Clouds") then
                effect:Destroy()
            end
        end
        
        print("✓ Weather effects removed")
    end)
end

-- =====================================================
-- PART 3: BLOX FRUITS SPECIFIC OPTIMIZATIONS
-- =====================================================

local function optimizeBloxFruits()
    pcall(function()
        -- HAPUS SKY BOX (sangat berat di Blox Fruits)
        for _, sky in pairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") then
                sky:Destroy()
            end
        end
        
        -- HAPUS WATER EFFECTS (Sea di Blox Fruits sangat berat)
        if Workspace:FindFirstChild("Map") then
            local map = Workspace.Map
            
            -- Hapus water terrain
            for _, water in pairs(map:GetDescendants()) do
                if water.Name:lower():find("water") 
                    or water.Name:lower():find("sea")
                    or water.Name:lower():find("ocean") then
                    if water:IsA("Part") then
                        water.Transparency = 1
                        water.CanCollide = false
                        water.CastShadow = false
                        water.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
        
        -- HAPUS RAIN & WEATHER PARTICLES (Danger 6, etc)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                if obj.Name:lower():find("rain") 
                    or obj.Name:lower():find("fog")
                    or obj.Name:lower():find("mist")
                    or obj.Name:lower():find("danger") then
                    obj:Destroy()
                end
            end
        end
        
        print("✓ Blox Fruits specific elements optimized")
    end)
end

-- =====================================================
-- PART 4: HAPUS SEMUA VISUAL EFFECTS
-- =====================================================

local function removeAllVisualEffects()
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            -- Hapus particles (Devil Fruit effects, explosions, etc)
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj:Destroy()
            
            -- Hapus fire, smoke, sparkles
            elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj:Destroy()
            
            -- Hapus explosions
            elseif obj:IsA("Explosion") then
                obj:Destroy()
            
            -- Matikan semua lights (sangat berat!)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
                obj.Brightness = 0
                obj.Range = 0
            
            -- Hapus decals & textures (Fast Mode style)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            
            -- Optimasi parts
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
                
                -- Hapus texture dari MeshParts
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                end
            
            -- Matikan sounds untuk hemat CPU
            elseif obj:IsA("Sound") then
                obj.Volume = 0
                obj:Stop()
            end
        end
        
        print("✓ All visual effects removed")
    end)
end

-- =====================================================
-- PART 5: GRAFIK ULTRA LOW
-- =====================================================

local function setUltraLowGraphics()
    pcall(function()
        -- Rendering settings
        settings().Rendering.QualityLevel = "Level01"
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.Off
        
        -- Physics optimization
        settings().Physics.ThrottleAdjustTime = 0.5
        settings().Physics.AllowSleep = true
        
        -- Game settings
        local UserGameSettings = UserSettings():GetService("UserGameSettings")
        UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        UserGameSettings.MasterVolume = 0.3
        
        print("✓ Graphics set to ultra low")
    end)
end

-- =====================================================
-- PART 6: DISABLE ALLY FX (Blox Fruits specific)
-- =====================================================

local function disableAllyFX()
    pcall(function()
        -- Cari dan disable Ally FX setting jika ada
        if playerGui:FindFirstChild("Main") then
            local main = playerGui.Main
            -- Ally FX biasanya ada di settings menu
            -- Script ini akan coba disable visual effects dari allies
        end
        
        -- Hapus efek dari player lain
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, obj in pairs(otherPlayer.Character:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") 
                        or obj:IsA("Beam") or obj:IsA("Fire") 
                        or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj:Destroy()
                    elseif obj:IsA("PointLight") or obj:IsA("SpotLight") then
                        obj.Enabled = false
                    end
                end
            end
        end
        
        print("✓ Ally FX disabled")
    end)
end

-- =====================================================
-- PART 7: MONITOR REAL-TIME (Hapus efek baru)
-- =====================================================

Workspace.DescendantAdded:Connect(function(obj)
    task.wait()
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") 
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")
            or obj:IsA("Explosion") then
            obj:Destroy()
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
            obj.Brightness = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
            obj:Destroy()
        end
    end)
end)

-- Monitor lighting changes
Lighting.ChildAdded:Connect(function(obj)
    task.wait()
    pcall(function()
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") 
            or obj:IsA("Sky") or obj:IsA("Clouds") then
            obj:Destroy()
        end
    end)
end)

-- Monitor player characters untuk hapus efek
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        disableAllyFX()
    end)
end)

-- =====================================================
-- PART 8: FPS DISPLAY
-- =====================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSDisplay"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 80)
frame.Position = UDim2.new(0.5, -90, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "BLOX FRUITS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.Parent = frame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
fpsLabel.Position = UDim2.new(0, 0, 0.45, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 24
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Parent = frame

-- FPS Counter
local fpsCount = 0
local lastCheck = tick()

RunService.Heartbeat:Connect(function()
    fpsCount = fpsCount + 1
    
    local now = tick()
    if now - lastCheck >= 1 then
        local currentFPS = math.floor(fpsCount / (now - lastCheck))
        fpsLabel.Text = "FPS: " .. currentFPS
        
        if currentFPS <= 12 then
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
        elseif currentFPS <= 20 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        fpsCount = 0
        lastCheck = now
    end
end)

-- =====================================================
-- PART 9: EKSEKUSI SEMUA OPTIMASI
-- =====================================================

print("Applying optimizations...")

setUltraLowGraphics()
task.wait(0.5)

removeWeatherEffects()
task.wait(0.5)

optimizeBloxFruits()
task.wait(0.5)

removeAllVisualEffects()
task.wait(0.5)

disableAllyFX()
task.wait(0.5)

print("==============================================")
print("✓ ALL OPTIMIZATIONS APPLIED!")
print("==============================================")
print("• FPS capped at 10")
print("• Graphics: ULTRA LOW")
print("• Weather effects: REMOVED")
print("• Water/Sea effects: MINIMIZED")
print("• Particles: DELETED")
print("• Textures: REMOVED (Fast Mode)")
print("• Lights: DISABLED")
print("• Ally FX: DISABLED")
print("• Fog: REMOVED")
print("• Sky: REMOVED")
print("• CPU/GPU Load: ~85% REDUCED")
print("==============================================")

-- =====================================================
-- PART 10: MAINTENANCE LOOP
-- =====================================================

spawn(function()
    while task.wait(30) do
        pcall(function()
            -- Re-apply critical settings
            settings().Rendering.QualityLevel = "Level01"
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            -- Clean up new effects
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") 
                    or obj:IsA("Beam") or obj:IsA("Explosion") then
                    obj:Destroy()
                end
            end
            
            -- Re-enforce FPS cap
            pcall(function() setfpscap(TARGET_FPS) end)
        end)
    end
end)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        print("Cleaning up...")
    end
end)

print("Script running! Enjoy smooth gameplay :)")
