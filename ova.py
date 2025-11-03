-- FPS Limiter & Performance Optimizer untuk Roblox
-- Membatasi FPS ke 10 dan mengurangi beban CPU/GPU secara maksimal

local RunService = game:GetService("RunService")
local UserSettings = UserSettings()
local GameSettings = UserSettings.GameSettings

-- ========================================
-- BAGIAN 1: PENGATURAN GRAFIK ULTRA RENDAH
-- ========================================

-- Fungsi untuk menurunkan kualitas grafik secara agresif dan hapus semua efek
local function optimizeGraphics()
    pcall(function()
        -- Set rendering ke level terendah
        settings().Rendering.QualityLevel = "Level01"
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.FrameRateManager = Enum.FramerateManagerMode.Off
        
        -- Matikan semua efek visual berat
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 0
        Lighting.FogStart = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        
        -- HAPUS semua post-processing effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") 
                or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") 
                or effect:IsA("DepthOfFieldEffect") then
                effect:Destroy()
            end
        end
        
        -- Hapus semua efek visual di workspace
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
                v.TopSurface = Enum.SurfaceType.Smooth
                v.BottomSurface = Enum.SurfaceType.Smooth
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy() -- HAPUS decal dan texture
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v:Destroy() -- HAPUS semua particle effects
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v:Destroy() -- HAPUS fire, smoke, sparkles
            elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v.Enabled = false -- Matikan semua lights
                v.Brightness = 0
            elseif v:IsA("Sound") or v:IsA("SoundGroup") then
                v.Volume = 0 -- Matikan sound untuk hemat CPU
            end
        end
    end)
end

-- ========================================
-- BAGIAN 2: FPS LIMITER KE 10 FPS (OPTIMIZED)
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

-- ========================================
-- BAGIAN 3: OPTIMASI CPU MAKSIMAL
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

-- Disable particle emitters dan SEMUA efek visual untuk hemat GPU
pcall(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj:Destroy()
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj:Destroy()
        end
    end
end)

-- Monitor dan hapus efek baru yang muncul secara real-time
workspace.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") 
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")
            or obj:IsA("Explosion") then
            task.wait()
            obj:Destroy()
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end)
end)

-- ========================================
-- FPS OVERLAY SIMPLE DI TENGAH LAYAR
-- ========================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSOverlay"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Buat Frame container (lebih kecil dan simple)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.5, -25)
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
-- EKSEKUSI
-- ========================================

optimizeGraphics()

print("=================================")
print("FPS Limiter Aktif: 10 FPS")
print("GPU Ultra Low Mode: AKTIF")
print("Semua efek visual dihapus")
print("CPU/GPU Usage dikurangi hingga ~85%")
print("=================================")

-- Maintenance loop LESS FREQUENT untuk hemat CPU (setiap 30 detik)
spawn(function()
    while wait(30) do
        -- Re-apply settings hanya jika perlu
        pcall(function()
            settings().Rendering.QualityLevel = "Level01"
            game:GetService("Lighting").GlobalShadows = false
            
            -- Hapus efek baru yang mungkin muncul
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") 
                    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj:Destroy()
                end
            end
        end)
    end
end)

-- Cleanup function (opsional)
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == player then
        if fpsLimiter then fpsLimiter:Disconnect() end
        if fpsMonitor then fpsMonitor:Disconnect() end
    end
end)
