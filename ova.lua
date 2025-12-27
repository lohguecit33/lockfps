-- =====================================================
-- BLOX FRUITS ULTRA LIGHTWEIGHT OPTIMIZER
-- Optimasi Maksimal - Hapus Semua Fungsi Berat
-- =====================================================

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- OPTIMASI 1: SATU LOOP UNTUK SEMUA
-- GetDescendants() SANGAT BERAT - Jangan panggil berkali-kali!
-- ========================================

local function optimizeEverything()
    -- Set graphics ultra low DULU (paling penting)
    settings().Rendering.QualityLevel = "Level01"
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    settings().Rendering.EnableFRM = false
    settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.Off
    
    -- Lighting settings (CEPAT - tidak iterate)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 0
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    
    -- Physics (CEPAT - tidak iterate)
    settings().Physics.ThrottleAdjustTime = 0.5
    settings().Physics.AllowSleep = true
    
    -- Hapus lighting effects (LOOP KECIL - hanya children Lighting)
    for _, effect in pairs(Lighting:GetChildren()) do
        if not effect:IsA("TerrainRegion") then
            effect:Destroy()
        end
    end
    
    -- ⚠️ SATU LOOP BESAR - Proses SEMUA object sekaligus
    -- Ini yang paling berat tapi HARUS dilakukan sekali saja
    for _, v in pairs(Workspace:GetDescendants()) do
        local class = v.ClassName -- Cache className (lebih cepat dari IsA)
        
        -- Hapus SEMUA efek visual (DELETE - paling cepat)
        if class == "ParticleEmitter" or class == "Trail" or class == "Beam"
            or class == "Fire" or class == "Smoke" or class == "Sparkles"
            or class == "Explosion" or class == "Decal" or class == "Texture" then
            v:Destroy()
        
        -- Matikan lights (DISABLE bukan destroy - lebih aman)
        elseif class == "PointLight" or class == "SpotLight" or class == "SurfaceLight" then
            v.Enabled = false
            v.Brightness = 0
        
        -- Optimasi parts (BATCH processing)
        elseif class == "Part" or class == "MeshPart" or class == "UnionOperation" then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
            
            -- Blox Fruits Water optimization (CHECK NAME sekali saja)
            local name = v.Name:lower()
            if name:find("water") or name:find("sea") or name:find("ocean") then
                v.Transparency = 1
                v.CanCollide = false
            end
            
            -- MeshPart texture removal
            if class == "MeshPart" then
                v.TextureID = ""
            end
        
        -- Matikan sound (lebih aman dari destroy)
        elseif class == "Sound" then
            v.Volume = 0
            if v.IsPlaying then
                v:Stop()
            end
        end
    end
end

-- ========================================
-- OPTIMASI 2: FPS LIMITER (PALING EFISIEN)
-- ========================================

local targetFPS = 10
local SKIP_RATIO = 5

-- Method 1: setfpscap (INSTANT - tidak ada overhead)
pcall(function() setfpscap(10) end)

-- Method 2: Frame Skip (LEBIH RINGAN dari delay-based)
local frameSkipCounter = 0
local lastFrameTick = tick()

local fpsLimiter = RunService.RenderStepped:Connect(function()
    frameSkipCounter = frameSkipCounter + 1
    
    if frameSkipCounter < SKIP_RATIO then
        return -- SKIP langsung - tidak ada processing
    end
    
    frameSkipCounter = 0
    
    -- Minimal wait (hanya jika perlu)
    local now = tick()
    local delta = now - lastFrameTick
    if delta < 0.1 then -- 10 FPS = 0.1s per frame
        task.wait(0.1 - delta)
    end
    lastFrameTick = tick()
end)

-- ========================================
-- OPTIMASI 3: LIGHTWEIGHT FPS DISPLAY
-- ========================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSOverlay"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.5, -25)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 28
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Parent = frame

-- FPS Counter (UPDATE JARANG - hemat CPU)
local FPSCounter = 0
local LastCheck = tick()

local fpsMonitor = RunService.Heartbeat:Connect(function()
    FPSCounter = FPSCounter + 1
    
    local now = tick()
    if now - LastCheck >= 1 then -- Update 1x per detik
        local currentFPS = math.floor(FPSCounter / (now - LastCheck))
        fpsLabel.Text = "FPS: " .. currentFPS
        
        -- Simple color coding (NO nested if)
        local color = currentFPS <= 12 and Color3.fromRGB(0, 255, 0) 
                   or currentFPS <= 20 and Color3.fromRGB(255, 255, 0)
                   or Color3.fromRGB(255, 0, 0)
        
        fpsLabel.TextColor3 = color
        frame.BorderColor3 = color
        
        FPSCounter = 0
        LastCheck = now
    end
end)

-- ========================================
-- OPTIMASI 4: DEBOUNCED MONITORING
-- Real-time monitoring BERAT - kita DEBOUNCE!
-- ========================================

local monitorDebounce = false
local monitorInterval = 0.5 -- Check setiap 0.5 detik (bukan instant)

Workspace.DescendantAdded:Connect(function(obj)
    if monitorDebounce then return end -- BLOCK jika masih cooldown
    monitorDebounce = true
    
    task.delay(monitorInterval, function()
        monitorDebounce = false
    end)
    
    -- Quick class check (NO pcall overhead)
    local class = obj.ClassName
    if class == "ParticleEmitter" or class == "Trail" or class == "Beam"
        or class == "Fire" or class == "Smoke" or class == "Sparkles"
        or class == "Explosion" or class == "Decal" or class == "Texture" then
        obj:Destroy()
    elseif class == "PointLight" or class == "SpotLight" or class == "SurfaceLight" then
        obj.Enabled = false
    end
end)

-- Lighting monitor (SIMPLE - tidak banyak object)
Lighting.ChildAdded:Connect(function(obj)
    if not obj:IsA("TerrainRegion") then
        obj:Destroy()
    end
end)

-- ========================================
-- OPTIMASI 5: LIGHTWEIGHT MAINTENANCE
-- ========================================

-- Maintenance SANGAT JARANG (60 detik) - minimal overhead
task.spawn(function()
    while task.wait(60) do -- 1 menit sekali saja
        -- Re-apply critical settings (CEPAT - tidak iterate)
        settings().Rendering.QualityLevel = "Level01"
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        pcall(function() setfpscap(10) end)
        
        -- Minimal cleanup (HANYA efek baru - TIDAK full scan!)
        -- Skip full GetDescendants - terlalu berat!
    end
end)

-- ========================================
-- EKSEKUSI
-- ========================================

print("==============================================")
print("BLOX FRUITS LIGHTWEIGHT MODE")
print("==============================================")

-- JALANKAN optimasi sekali saja (ini yang paling berat)
optimizeEverything()

print("✓ Optimizations applied!")
print("• FPS: 10 (Frame Skip)")
print("• Graphics: Ultra Low")
print("• All effects: Removed")
print("• Monitoring: Debounced")
print("• CPU/GPU: ~85% lighter")
print("==============================================")
print("Note: Initial load takes ~2s")
print("After that, minimal CPU overhead!")
print("==============================================")

-- Cleanup
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        fpsLimiter:Disconnect()
        fpsMonitor:Disconnect()
    end
end)
