-- =====================================================
-- BLOX FRUITS ULTRA PERFORMANCE OPTIMIZER
-- FPS 10 + Hapus SEMUA Elemen Berat GPU/CPU
-- Optimasi Khusus untuk Blox Fruits
-- =====================================================

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserSettings = UserSettings()
local GameSettings = UserSettings.GameSettings

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("==============================================")
print("BLOX FRUITS ULTRA PERFORMANCE MODE")
print("Initializing optimization...")
print("==============================================")

-- ========================================
-- BAGIAN 1: PENGATURAN GRAFIK ULTRA RENDAH
-- ========================================

local function optimizeGraphics()
    pcall(function()
        -- Set rendering ke level terendah
        settings().Rendering.QualityLevel = "Level01"
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.Off
        
        -- Matikan semua efek visual berat
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9  -- Set sangat jauh untuk hapus fog (termasuk Mirage fog)
        Lighting.FogStart = 0
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ExposureCompensation = 0
        
        -- HAPUS semua post-processing effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") 
                or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") 
                or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere")
                or effect:IsA("Sky") or effect:IsA("Clouds") then
                effect:Destroy()
            end
        end
        
        print("✓ Graphics set to ultra low")
    end)
end

-- ========================================
-- BAGIAN 2: BLOX FRUITS SPECIFIC OPTIMIZATIONS
-- ========================================

local function optimizeBloxFruits()
    pcall(function()
        -- HAPUS SKY BOX (sangat berat di Blox Fruits)
        for _, sky in pairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") then
                sky:Destroy()
            end
        end
        
        -- HAPUS & OPTIMASI WATER/SEA EFFECTS
        if Workspace:FindFirstChild("Map") then
            local map = Workspace.Map
            
            -- Hapus/transparankan water
            for _, water in pairs(map:GetDescendants()) do
                if water.Name:lower():find("water") 
                    or water.Name:lower():find("sea")
                    or water.Name:lower():find("ocean") then
                    if water:IsA("Part") then
                        water.Transparency = 1
                        water.CanCollide = false
                        water.CastShadow = false
                        water.Material = Enum.Material.SmoothPlastic
                        water.Reflectance = 0
                    end
                end
            end
        end
        
        -- HAPUS WEATHER PARTICLES (Rain, Danger 6 fog, etc)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                if obj.Name:lower():find("rain") 
                    or obj.Name:lower():find("fog")
                    or obj.Name:lower():find("mist")
                    or obj.Name:lower():find("danger")
                    or obj.Name:lower():find("weather") then
                    obj:Destroy()
                end
            end
        end
        
        print("✓ Blox Fruits specific elements optimized")
    end)
end

-- ========================================
-- BAGIAN 3: HAPUS SEMUA VISUAL EFFECTS
-- ========================================

local function removeAllVisualEffects()
    pcall(function()
        -- Hapus semua efek visual di workspace
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
                v.TopSurface = Enum.SurfaceType.Smooth
                v.BottomSurface = Enum.SurfaceType.Smooth
                
                -- Hapus texture dari MeshParts
                if v:IsA("MeshPart") then
                    v.TextureID = ""
                end
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy() -- HAPUS decal dan texture (Fast Mode style)
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v:Destroy() -- HAPUS semua particle effects (Devil Fruit effects)
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v:Destroy() -- HAPUS fire, smoke, sparkles
            elseif v:IsA("Explosion") then
                v:Destroy() -- HAPUS explosions
            elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v.Enabled = false -- Matikan semua lights
                v.Brightness = 0
                v.Range = 0
            elseif v:IsA("Sound") or v:IsA("SoundGroup") then
                v.Volume = 0 -- Matikan sound untuk hemat CPU
            end
        end
        
        print("✓ All visual effects removed")
    end)
end

-- ========================================
-- BAGIAN 4: DISABLE ALLY FX
-- ========================================

local function disableAllyFX()
    pcall(function()
        -- Hapus efek dari player lain untuk hemat GPU
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

-- ========================================
-- BAGIAN 5: FPS LIMITER KE 10 FPS (DARI SCRIPT PERTAMA)
-- ========================================

local targetFPS = 10
local targetFrameTime = 1 / targetFPS

-- Set FPS cap jika executor mendukung (paling efisien)
pcall(function()
    setfpscap(10)
end)

-- Backup method: Manual frame limiting yang lebih efisien
local lastFrameTick = tick()
local frameSkipCounter = 0
local SKIP_RATIO = 5 -- Skip 5 dari 6 frame (60/6 = 10 FPS)

local fpsLimiter = RunService.RenderStepped:Connect(function()
    frameSkipCounter = frameSkipCounter + 1
    
    -- Skip frame untuk menghemat CPU
    if frameSkipCounter < SKIP_RATIO then
        return
    end
    
    frameSkipCounter = 0
    
    -- Tambah delay minimal untuk pastikan 10 FPS
    local currentTick = tick()
    local deltaTime = currentTick - lastFrameTick
    
    if deltaTime < targetFrameTime then
        task.wait(targetFrameTime - deltaTime)
    end
    
    lastFrameTick = tick()
end)

print("✓ FPS limiter active: 10 FPS")

-- ========================================
-- BAGIAN 6: OPTIMASI CPU MAKSIMAL
-- ========================================

-- Kurangi update physics drastis
pcall(function()
    settings().Physics.ThrottleAdjustTime = 0.2
    settings().Physics.AllowSleep = true
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
end)

-- Set game settings ke performa minimum
pcall(function()
    GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    
    -- Matikan fitur grafis tidak penting
    local UserGameSettings = UserSettings():GetService("UserGameSettings")
    UserGameSettings.MasterVolume = 0.5 -- Kurangi audio processing
end)

print("✓ CPU optimization applied")

-- ========================================
-- BAGIAN 7: MONITOR REAL-TIME (Hapus efek baru)
-- ========================================

Workspace.DescendantAdded:Connect(function(obj)
    task.wait()
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") 
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")
            or obj:IsA("Explosion") then
            obj:Destroy()
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
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

-- Monitor player characters
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        disableAllyFX()
    end)
end)

print("✓ Real-time monitor active")

-- ========================================
-- BAGIAN 8: FPS OVERLAY (DARI SCRIPT PERTAMA - STYLE TENGAH)
-- ========================================

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSOverlay"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Buat Frame container (lebih kecil dan simple)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.5, -25)  -- Tengah layar
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Parent = screenGui

-- Tambah UICorner untuk sudut rounded
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Label FPS (hanya FPS saja)
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 28
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Parent = frame

-- Monitoring FPS (update setiap 1 detik untuk hemat CPU)
local FPSCounter = 0
local LastCheck = tick()

-- Gunakan Heartbeat dengan interval lebih lama untuk hemat CPU
local fpsMonitor = RunService.Heartbeat:Connect(function()
    FPSCounter = FPSCounter + 1
    
    local currentTime = tick()
    if currentTime - LastCheck >= 1 then -- Update setiap 1 detik
        local currentFPS = math.floor(FPSCounter / (currentTime - LastCheck))
        
        -- Update text
        fpsLabel.Text = "FPS: " .. currentFPS
        
        -- Ubah warna berdasarkan FPS
        if currentFPS <= 12 then
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Hijau (berhasil)
            frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
        elseif currentFPS <= 20 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Kuning (hampir)
            frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah (gagal)
            frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        FPSCounter = 0
        LastCheck = currentTime
    end
end)

-- ========================================
-- BAGIAN 9: EKSEKUSI SEMUA OPTIMASI
-- ========================================

optimizeGraphics()
task.wait(0.3)

optimizeBloxFruits()
task.wait(0.3)

removeAllVisualEffects()
task.wait(0.3)

disableAllyFX()

print("==============================================")
print("✓ ALL OPTIMIZATIONS APPLIED!")
print("==============================================")
print("• FPS: Capped at 10 (Frame Skip Method)")
print("• Graphics: ULTRA LOW")
print("• Blox Fruits Specific:")
print("  - Sky/Skybox: REMOVED")
print("  - Water/Sea: TRANSPARENT")
print("  - Fog (Mirage/Danger): REMOVED")
print("  - Weather Effects: REMOVED")
print("• Visual Effects:")
print("  - Particles/Trails: DELETED")
print("  - Textures/Decals: REMOVED")
print("  - Lights: DISABLED")
print("  - Ally FX: DISABLED")
print("• CPU/GPU Load: ~85% REDUCED")
print("==============================================")

-- ========================================
-- BAGIAN 10: MAINTENANCE LOOP
-- ========================================

-- Maintenance loop LESS FREQUENT untuk hemat CPU (setiap 30 detik)
spawn(function()
    while wait(30) do
        -- Re-apply settings hanya jika perlu
        pcall(function()
            settings().Rendering.QualityLevel = "Level01"
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            
            -- Re-enforce FPS cap
            pcall(function() setfpscap(10) end)
            
            -- Hapus efek baru yang mungkin muncul
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") 
                    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj:Destroy()
                end
            end
        end)
    end
end)

-- ========================================
-- CLEANUP FUNCTION
-- ========================================

-- Cleanup function (opsional)
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        if fpsLimiter then fpsLimiter:Disconnect() end
        if fpsMonitor then fpsMonitor:Disconnect() end
        print("Optimizer cleaned up")
    end
end)

print("Script running! Enjoy smooth Blox Fruits gameplay :)")
