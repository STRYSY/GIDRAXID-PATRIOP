-- [] GIDRAX mode
-- GIDRAXID | v4 | + FUN tab (Speedhack / Fly / Icon Changer)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- ЛОКАЛИЗАЦИЯ
-- ============================================================

local Lang = "ru"
local L = {
    ru = { title="GIDRAXID", farm="ФЕРМА", fun="FUN", misc="РАЗНОЕ",
        farmTitle="ФЕРМА | СБОР РЕСУРСОВ", scan="Сканировать участок",
        collectAll="Собрать ВСЁ", autoFarm="Авто-сбор", antiAfk="Анти-АФК",
        noneFound="Ресурсы не найдены.",
        funTitle="FUN | ФУНКЦИИ",
        speedHack="Спидхак", speedValue="Скорость (число):",
        applySpeed="Применить скорость", fly="Полёт", flySpeed="Скорость полёта:",
        iconChoose="Иконка меню",
        miscTitle="РАЗНОЕ | НАСТРОЙКИ", strokeColor="Цвет интерфейса",
        rainbow="Радужный", red="Красный", blue="Синий", orange="Оранжевый",
        green="Зелёный", yellow="Жёлтый", white="Белый", purple="Фиолетовый",
        azure="Лазурный", cyan="Голубой", language="Язык",
        on="ВКЛ", off="ВЫКЛ" },
    en = { title="GIDRAXID", farm="FARM", fun="FUN", misc="MISC",
        farmTitle="FARM | RESOURCE COLLECTION", scan="Scan plot",
        collectAll="Collect ALL", autoFarm="Auto-farm", antiAfk="Anti-AFK",
        noneFound="No resources found.",
        funTitle="FUN | FEATURES",
        speedHack="Speedhack", speedValue="Speed (number):",
        applySpeed="Apply speed", fly="Fly", flySpeed="Fly speed:",
        iconChoose="Menu icon",
        miscTitle="MISC | SETTINGS", strokeColor="UI color",
        rainbow="Rainbow", red="Red", blue="Blue", orange="Orange",
        green="Green", yellow="Yellow", white="White", purple="Purple",
        azure="Azure", cyan="Cyan", language="Language",
        on="ON", off="OFF" },
    uk = { title="GIDRAXID", farm="ФЕРМА", fun="FUN", misc="РІЗНЕ",
        farmTitle="ФЕРМА | ЗБІР РЕСУРСІВ", scan="Сканувати ділянку",
        collectAll="Зібрати ВСЕ", autoFarm="Авто-збір", antiAfk="Анти-АФК",
        noneFound="Ресурси не знайдено.",
        funTitle="FUN | ФУНКЦІЇ",
        speedHack="Спідхак", speedValue="Швидкість (число):",
        applySpeed="Застосувати", fly="Політ", flySpeed="Швидкість польоту:",
        iconChoose="Іконка меню",
        miscTitle="РІЗНЕ | НАЛАШТУВАННЯ", strokeColor="Колір інтерфейсу",
        rainbow="Веселковий", red="Червоний", blue="Синій", orange="Помаранчевий",
        green="Зелений", yellow="Жовтий", white="Білий", purple="Фіолетовий",
        azure="Лазурний", cyan="Блакитний", language="Мова",
        on="УВІМК", off="ВИКЛ" },
    be = { title="GIDRAXID", farm="ФЕРМА", fun="FUN", misc="РОЗНАЕ",
        farmTitle="ФЕРМА | ЗБОР РЭСУРСАЎ", scan="Сканаваць участк",
        collectAll="Сабраць УСЁ", autoFarm="Аўта-збор", antiAfk="Анты-АФК",
        noneFound="Рэсурсы не знойдзены.",
        funTitle="FUN | ФУНКЦЫІ",
        speedHack="Спідхак", speedValue="Хуткасць (лік):",
        applySpeed="Прымяніць", fly="Паход", flySpeed="Хуткасць паходу:",
        iconChoose="Іконка меню",
        miscTitle="РОЗНАЕ | НАЛАДЫ", strokeColor="Колер інтэрфейсу",
        rainbow="Вясёлкавы", red="Чырвоны", blue="Сіні", orange="Аранжавы",
        green="Зялёны", yellow="Жоўты", white="Белы", purple="Фіялетавы",
        azure="Лазурны", cyan="Блакітны", language="Мова",
        on="УКЛ", off="ВЫКЛ" },
}
local function T(k) return L[Lang][k] or k end

-- ============================================================
-- АКЦЕНТ
-- ============================================================

local AccentColor = Color3.fromRGB(170, 0, 255)
local RainbowMode = false
local rainbowConn

local function GetAccent()
    if RainbowMode then return Color3.fromHSV((tick() * 0.18) % 1, 1, 1) end
    return AccentColor
end

-- ============================================================
-- GUI
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GIDRAXID"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Splash = Instance.new("ImageLabel")
Splash.Size = UDim2.fromScale(1, 1)
Splash.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Splash.BorderSizePixel = 0
Splash.Image = "rbxassetid://70416372811875"
Splash.ScaleType = Enum.ScaleType.Stretch
Splash.ZIndex = 5000
Splash.Parent = ScreenGui

local splashTween = TweenService:Create(Splash, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, ImageTransparency = 1})
task.delay(4, function()
    splashTween:Play()
    splashTween.Completed:Connect(function() Splash:Destroy() end)
end)

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = GetAccent()
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Visible = false
Overlay.ZIndex = 900
Overlay.Parent = ScreenGui

local ParticleLayer = Instance.new("Frame")
ParticleLayer.Size = UDim2.fromScale(1, 1)
ParticleLayer.BackgroundTransparency = 1
ParticleLayer.ClipsDescendants = true
ParticleLayer.Visible = false
ParticleLayer.ZIndex = 910
ParticleLayer.Parent = ScreenGui

local particleList = {}
local particlesActive = false

local function CreateParticle()
    local size = math.random(4, 10)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, size, 0, size)
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = GetAccent()
    p.BackgroundTransparency = math.random(20, 55) / 100
    p.BorderSizePixel = 0
    p.ZIndex = 911
    p.Parent = ParticleLayer
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = p
    table.insert(particleList, p)
    task.spawn(function()
        while p.Parent and particlesActive do
            local dur = math.random(4, 9)
            local newX = math.clamp(p.Position.X.Scale + (math.random() - 0.5) * 0.25, 0, 1)
            local tw = TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Position = UDim2.new(newX, 0, -0.15, 0)})
            tw:Play(); tw.Completed:Wait()
            if p.Parent and particlesActive then
                p.Position = UDim2.new(math.random(), 0, 1.1, 0)
            end
        end
    end)
end

local function StartParticles(count)
    particlesActive = true
    ParticleLayer.Visible = true
    for i = 1, (count or 28) do CreateParticle() end
end

local function StopParticles()
    particlesActive = false
    for _, p in ipairs(particleList) do if p and p.Parent then p:Destroy() end end
    particleList = {}
    ParticleLayer.Visible = false
end

local Icon = Instance.new("ImageButton")
Icon.Size = UDim2.new(0, 48, 0, 48)
Icon.Position = UDim2.new(0, 20, 0.5, -24)
Icon.Image = "rbxassetid://70416372811875"
Icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Icon.BorderSizePixel = 0
Icon.ZIndex = 1100
Icon.Parent = ScreenGui
local IconStroke = Instance.new("UIStroke"); IconStroke.Thickness = 3; IconStroke.Parent = Icon
local IconCorner = Instance.new("UICorner"); IconCorner.CornerRadius = UDim.new(0, 8); IconCorner.Parent = Icon

local MENU_W, MENU_H = 560, 340
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, MENU_W, 0, MENU_H)
Menu.Position = UDim2.new(0.5, -MENU_W/2, 0.5, -MENU_H/2)
Menu.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.ClipsDescendants = true
Menu.ZIndex = 1000
Menu.Parent = ScreenGui

local MenuStroke = Instance.new("UIStroke"); MenuStroke.Thickness = 3; MenuStroke.Parent = Menu
local MenuCorner = Instance.new("UICorner"); MenuCorner.CornerRadius = UDim.new(0, 12); MenuCorner.Parent = Menu

local Deco1 = Instance.new("Frame")
Deco1.Size = UDim2.fromScale(1, 0.5); Deco1.BackgroundColor3 = Color3.fromRGB(30,0,60); Deco1.BorderSizePixel = 0; Deco1.ZIndex = 1001; Deco1.Parent = Menu
local Deco1Grad = Instance.new("UIGradient")
Deco1Grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.55),NumberSequenceKeypoint.new(1,1)})
Deco1Grad.Rotation = 45; Deco1Grad.Parent = Deco1

local Deco2 = Instance.new("Frame")
Deco2.Size = UDim2.fromScale(1, 0.5); Deco2.Position = UDim2.fromScale(0, 0.5); Deco2.BackgroundColor3 = Color3.fromRGB(10,0,30); Deco2.BorderSizePixel = 0; Deco2.ZIndex = 1001; Deco2.Parent = Menu
local Deco2Grad = Instance.new("UIGradient")
Deco2Grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.55)})
Deco2Grad.Rotation = 45; Deco2Grad.Parent = Deco2

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38); Header.BackgroundTransparency = 1; Header.ZIndex = 1010; Header.Parent = Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = T("title")
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.ZIndex = 1011; Title.Parent = Header

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 110, 1, -50); TabBar.Position = UDim2.new(0, 10, 0, 42)
TabBar.BackgroundTransparency = 1; TabBar.ZIndex = 1010; TabBar.Parent = Menu
local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 6); TabLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabLayout.Parent = TabBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -130, 1, -50); Content.Position = UDim2.new(0, 120, 0, 42)
Content.BackgroundColor3 = Color3.fromRGB(12, 12, 16); Content.BackgroundTransparency = 0.25
Content.BorderSizePixel = 0; Content.ZIndex = 1010; Content.Parent = Menu
local ContentCorner = Instance.new("UICorner"); ContentCorner.CornerRadius = UDim.new(0, 8); ContentCorner.Parent = Content
local ContentStroke = Instance.new("UIStroke"); ContentStroke.Thickness = 2; ContentStroke.Parent = Content

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -8, 1, -8); ContentScroll.Position = UDim2.new(0, 4, 0, 4)
ContentScroll.BackgroundTransparency = 1; ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4; ContentScroll.CanvasSize = UDim2.new(0,0,0,0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.ZIndex = 1011; ContentScroll.Parent = Content
local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 5); ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder; ScrollLayout.Parent = ContentScroll

-- Открытие/закрытие
local isOpen = false
Icon.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        Overlay.Visible = true
        Overlay.BackgroundTransparency = 1
        Overlay.BackgroundColor3 = GetAccent()
        TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.55}):Play()
        StartParticles(30)
        Menu.Visible = true
        Menu.Size = UDim2.new(0, MENU_W, 0, 0)
        Menu.BackgroundTransparency = 1
        TweenService:Create(Menu, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, MENU_W, 0, MENU_H), BackgroundTransparency = 0}):Play()
    else
        local tw1 = TweenService:Create(Overlay, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        tw1:Play()
        tw1.Completed:Connect(function() Overlay.Visible = false; StopParticles() end)
        local tw2 = TweenService:Create(Menu, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Size = UDim2.new(0, MENU_W, 0, 0), BackgroundTransparency = 1})
        tw2:Play()
        tw2.Completed:Connect(function() Menu.Visible = false end)
    end
end)

-- Drag иконки
local dragIcon, iconStart, iconPos
Icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true; iconStart = i.Position; iconPos = Icon.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragIcon and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - iconStart
        Icon.Position = UDim2.new(iconPos.X.Scale, iconPos.X.Offset + d.X, iconPos.Y.Scale, iconPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragIcon = false end
end)

-- Drag меню
local dragMenu, menuStart, menuPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragMenu = true; menuStart = i.Position; menuPos = Menu.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragMenu and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - menuStart
        Menu.Position = UDim2.new(menuPos.X.Scale, menuPos.X.Offset + d.X, menuPos.Y.Scale, menuPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragMenu = false end
end)

-- ============================================================
-- ПЕРСИСТЕНТНЫЕ СОСТОЯНИЯ
-- ============================================================

local AutoFarmRunning = false
local AutoFarmTask = nil
local AntiAfkRunning = false
local AntiAfkConn = nil

local SpeedHackValue = 16
local FlyEnabled = false
local FlySpeed = 60
local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyKeys = {}
local MobileFlyDir = Vector3.zero

-- ============================================================
-- УТИЛИТЫ GUI
-- ============================================================

local CurrentTabBtn = nil
local AllTabButtons = {}

local function RefreshAccentEverywhere()
    local c = GetAccent()
    for _, d in ipairs(Menu:GetDescendants()) do
        if d:IsA("UIStroke") then d.Color = c end
    end
    IconStroke.Color = c
    Title.TextColor3 = c
    ContentScroll.ScrollBarImageColor3 = c
    if Overlay.Visible then Overlay.BackgroundColor3 = c end
    for _, p in ipairs(particleList) do
        if p and p.Parent then p.BackgroundColor3 = c end
    end
    for _, tb in ipairs(AllTabButtons) do
        if tb == CurrentTabBtn then
            tb.BackgroundColor3 = Color3.new(c.R*0.25, c.G*0.25, c.B*0.25)
            tb.TextColor3 = c
        else
            tb.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            tb.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end

local function ClearContent()
    for _, c in ipairs(ContentScroll:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function CreateSectionTitle(text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 26)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    lbl.BackgroundTransparency = 0.3
    lbl.Text = "  " .. text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = GetAccent()
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.LayoutOrder = order; lbl.ZIndex = 1012; lbl.Parent = ContentScroll
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,4); c.Parent = lbl
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = GetAccent(); s.Parent = lbl
    return lbl
end

local function CreateButton(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    btn.Text = text; btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.LayoutOrder = order; btn.ZIndex = 1012; btn.Parent = ContentScroll
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = GetAccent(); s.Parent = btn
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40,40,55)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22,22,28)}):Play() end)
    btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then warn("[GIDRAX] " .. tostring(err)) end
    end)
    return btn
end

local function CreateToggle(text, order, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = default and Color3.fromRGB(40, 10, 60) or Color3.fromRGB(22, 22, 28)
    btn.Text = text .. ": " .. (default and T("on") or T("off"))
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.LayoutOrder = order; btn.ZIndex = 1012; btn.Parent = ContentScroll
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = GetAccent(); s.Parent = btn
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and T("on") or T("off"))
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 10, 60) or Color3.fromRGB(22, 22, 28)
        local ok, err = pcall(callback, state)
        if not ok then warn("[GIDRAX] " .. tostring(err)) end
    end)
    return btn
end

local function CreateTextBox(placeholder, order, default, onCommit)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    box.Text = default or ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    box.Font = Enum.Font.Gotham; box.TextSize = 12
    box.ClearTextOnFocus = false
    box.LayoutOrder = order; box.ZIndex = 1012; box.Parent = ContentScroll
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = box
    local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = GetAccent(); s.Parent = box
    box.FocusLost:Connect(function()
        local ok, err = pcall(onCommit, box.Text)
        if not ok then warn("[GIDRAX] " .. tostring(err)) end
    end)
    return box
end

local function CreateTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    btn.Text = name; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    btn.LayoutOrder = order; btn.ZIndex = 1011; btn.Parent = TabBar
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = btn
    local s = Instance.new("UIStroke"); s.Thickness = 1.5; s.Color = GetAccent(); s.Parent = btn
    table.insert(AllTabButtons, btn)
    return btn
end

-- ============================================================
-- FARM ЛОГИКА
-- ============================================================

local ResourceList = {
    "Wheat","Corn","Coal","Wood","Flour","Carrot","Books",
    "Oil","Iron","Cement","Gold","Coin Bag","Research",
    "Diamond","Uranium Ore","Stable Uranium","Data Cube",
    "Dark Matter","Alien Essence","Antimatter","Robo Heads",
    "Quantum Core","Supernova Charge","Gamma Ray","Event Plant"
}

local function ScanForResources()
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            for _, res in ipairs(ResourceList) do
                if string.find(string.lower(obj.Name), string.lower(res)) then
                    found[res] = found[res] or {}
                    table.insert(found[res], obj)
                end
            end
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                local pn = string.lower((prompt.ActionText or "") .. " " .. (prompt.ObjectText or ""))
                for _, res in ipairs(ResourceList) do
                    if string.find(pn, string.lower(res)) then
                        found[res] = found[res] or {}
                        table.insert(found[res], obj)
                    end
                end
            end
        end
    end
    return found
end

local function CollectResource(obj)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt)
            else prompt:InputHoldBegin(); task.wait(0.1); prompt:InputHoldEnd() end
        end)
        return
    end
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local n = string.lower(remote.Name)
            if string.find(n, "collect") or string.find(n, "harvest") or string.find(n, "gather") then
                pcall(function() remote:FireServer(obj) end)
            end
        end
    end
end

local function SetAutoFarm(state)
    AutoFarmRunning = state
    if AutoFarmTask then
        pcall(task.cancel, AutoFarmTask)
        AutoFarmTask = nil
    end
    if state then
        AutoFarmTask = task.spawn(function()
            while AutoFarmRunning do
                local ok, found = pcall(ScanForResources)
                if ok and found then
                    for _, objs in pairs(found) do
                        for _, obj in ipairs(objs) do
                            if not AutoFarmRunning then break end
                            pcall(CollectResource, obj)
                        end
                        if not AutoFarmRunning then break end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

local function SetAntiAfk(state)
    AntiAfkRunning = state
    if AntiAfkConn then AntiAfkConn:Disconnect(); AntiAfkConn = nil end
    if state then
        AntiAfkConn = LocalPlayer.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController(); vu:ClickButton2(Vector2.new())
        end)
    end
end

-- ============================================================
-- FUN ЛОГИКА
-- ============================================================

-- Спидхак
local function ApplySpeedHack(value)
    local num = tonumber(value)
    if not num then return end
    num = math.clamp(num, 0, 500)
    SpeedHackValue = num
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = num end
    end
end

-- Полёт
local function StopFly()
    FlyEnabled = false
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    if FlyBodyVelocity then pcall(function() FlyBodyVelocity:Destroy() end); FlyBodyVelocity = nil end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.WalkSpeed = SpeedHackValue
        end
    end
    MobileFlyDir = Vector3.zero
end

local function StartFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    StopFly()
    FlyEnabled = true
    hum.PlatformStand = true
    hum.WalkSpeed = 0

    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    FlyBodyVelocity.Parent = hrp

    -- клавиатура
    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.UserInputType == Enum.UserInputType.Keyboard then
            FlyKeys[i.KeyCode] = true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Keyboard then
            FlyKeys[i.KeyCode] = false
        end
    end)

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyEnabled then return end
        local c = LocalPlayer.Character
        if not c then StopFly(); return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then StopFly(); return end

        local dir = Vector3.zero
        if FlyKeys[Enum.KeyCode.W] then dir += Camera.CFrame.LookVector end
        if FlyKeys[Enum.KeyCode.S] then dir -= Camera.CFrame.LookVector end
        if FlyKeys[Enum.KeyCode.A] then dir -= Camera.CFrame.RightVector end
        if FlyKeys[Enum.KeyCode.D] then dir += Camera.CFrame.RightVector end
        if FlyKeys[Enum.KeyCode.Space] then dir += Vector3.new(0,1,0) end
        if FlyKeys[Enum.KeyCode.LeftControl] then dir -= Vector3.new(0,1,0) end
        if FlyKeys[Enum.KeyCode.LeftShift] then dir += Camera.CFrame.LookVector end

        -- мобильные кнопки
        if MobileFlyDir.Magnitude > 0 then
            dir += MobileFlyDir
        end

        if dir.Magnitude > 0 then
            dir = dir.Unit
            FlyBodyVelocity.Velocity = dir * FlySpeed
        else
            FlyBodyVelocity.Velocity = Vector3.zero
        end
    end)
end

local function SetFly(state)
    if state then StartFly() else StopFly() end
end

-- Мобильные кнопки управления полётом
local function CreateMobileFlyControls()
    local pad = Instance.new("Frame")
    pad.Name = "MobileFlyPad"
    pad.Size = UDim2.new(0, 180, 0, 180)
    pad.Position = UDim2.new(1, -200, 1, -200)
    pad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pad.BackgroundTransparency = 0.6
    pad.BorderSizePixel = 0
    pad.ZIndex = 1200
    pad.Visible = false
    pad.Parent = ScreenGui

    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 12); pc.Parent = pad
    local ps = Instance.new("UIStroke"); ps.Thickness = 2; ps.Color = GetAccent(); ps.Parent = pad

    local function makeBtn(text, pos, onDown, onUp)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 50, 0, 50)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        b.ZIndex = 1201
        b.Parent = pad
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 10); bc.Parent = b
        local bs = Instance.new("UIStroke"); bs.Thickness = 1.5; bs.Color = GetAccent(); bs.Parent = b
        b.MouseButton1Down:Connect(onDown)
        b.MouseButton1Up:Connect(onUp)
        b.MouseLeave:Connect(onUp)
        b.TouchLongPress:Connect(function() end)
        return b
    end

    -- крест: W / S / A / D / Up / Down
    makeBtn("▲", UDim2.new(0, 65, 0, 5), function() MobileFlyDir += Camera.CFrame.LookVector end, function() MobileFlyDir -= Camera.CFrame.LookVector end)
    makeBtn("▼", UDim2.new(0, 65, 0, 125), function() MobileFlyDir -= Camera.CFrame.LookVector end, function() MobileFlyDir += Camera.CFrame.LookVector end)
    makeBtn("◀", UDim2.new(0, 5, 0, 65), function() MobileFlyDir -= Camera.CFrame.RightVector end, function() MobileFlyDir += Camera.CFrame.RightVector end)
    makeBtn("▶", UDim2.new(0, 125, 0, 65), function() MobileFlyDir += Camera.CFrame.RightVector end, function() MobileFlyDir -= Camera.CFrame.RightVector end)
    makeBtn("↑", UDim2.new(0, 65, 0, 65), function() MobileFlyDir += Vector3.new(0,1,0) end, function() MobileFlyDir -= Vector3.new(0,1,0) end)

    return pad
end

local MobileFlyPad = CreateMobileFlyControls()

-- ============================================================
-- ВКЛАДКИ
-- ============================================================

local TabFarm, TabFun, TabMisc
local BuildMiscTabRef

local function BuildFarmTab()
    ClearContent()
    CreateSectionTitle(T("farmTitle"), 1)
    local order = 2

    CreateButton(T("scan"), order, function()
        for _, ch in ipairs(ContentScroll:GetChildren()) do
            if ch:GetAttribute("IsResBtn") then ch:Destroy() end
        end
        local found = ScanForResources()
        local keys = {}
        for k in pairs(found) do table.insert(keys, k) end
        table.sort(keys)
        for _, res in ipairs(keys) do
            order = order + 1
            local btn = CreateButton(res .. "  ×" .. #found[res], order, function()
                for _, obj in ipairs(found[res]) do CollectResource(obj) end
            end)
            btn:SetAttribute("IsResBtn", true)
        end
        if #keys == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.Text = T("noneFound")
            lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11
            lbl.LayoutOrder = order + 1; lbl.ZIndex = 1012
            lbl:SetAttribute("IsResBtn", true); lbl.Parent = ContentScroll
        end
    end)
    order = order + 1

    CreateButton(T("collectAll"), order, function()
        local found = ScanForResources()
        for _, objs in pairs(found) do
            for _, obj in ipairs(objs) do CollectResource(obj); task.wait(0.05) end
        end
    end)
    order = order + 1

    CreateToggle(T("autoFarm"), order, AutoFarmRunning, SetAutoFarm)
    order = order + 1

    CreateToggle(T("antiAfk"), order, AntiAfkRunning, SetAntiAfk)
end

-- === FUN ===
local IconPresetIDs = {
    "121475011102153",
    "113291566352727",
    "98847893535543",
    "121830354147863",
    "92191612727880",
    "98415300202655",
    "92578209609345",
    "87110821698730",
    "104990937064232",
}

local function BuildFunTab()
    ClearContent()
    CreateSectionTitle(T("funTitle"), 1)
    local order = 2

    -- Спидхак
    CreateSectionTitle(T("speedHack"), order); order = order + 1
    CreateTextBox(T("speedValue"), order, tostring(SpeedHackValue), function(text)
        ApplySpeedHack(text)
    end)
    order = order + 1
    CreateButton(T("applySpeed"), order, function()
        ApplySpeedHack(tostring(SpeedHackValue))
    end)
    order = order + 1

    -- Fly
    CreateSectionTitle(T("fly"), order); order = order + 1
    CreateTextBox(T("flySpeed"), order, tostring(FlySpeed), function(text)
        local n = tonumber(text)
        if n then FlySpeed = math.clamp(n, 5, 500) end
    end)
    order = order + 1
    CreateToggle(T("fly"), order, FlyEnabled, function(state)
        SetFly(state)
        MobileFlyPad.Visible = state
    end)
    order = order + 1

    -- Иконка
    CreateSectionTitle(T("iconChoose"), order); order = order + 1
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, -10, 0, 0)
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.BackgroundTransparency = 1
    grid.LayoutOrder = order
    grid.ZIndex = 1012
    grid.Parent = ContentScroll

    local gl = Instance.new("UIGridLayout")
    gl.CellSize = UDim2.new(0, 42, 0, 42)
    gl.CellPadding = UDim2.new(0, 5, 0, 5)
    gl.SortOrder = Enum.SortOrder.LayoutOrder
    gl.Parent = grid

    for i, id in ipairs(IconPresetIDs) do
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 42, 0, 42)
        btn.Image = "rbxassetid://" .. id
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        btn.LayoutOrder = i
        btn.ZIndex = 1013
        btn.Parent = grid
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
        local bs = Instance.new("UIStroke"); bs.Thickness = 1.5; bs.Color = GetAccent(); bs.Parent = btn
        btn.MouseButton1Click:Connect(function()
            Icon.Image = "rbxassetid://" .. id
        end)
    end
end

-- === MISC ===
local StrokePresets = {
    {key="rainbow", rainbow=true},
    {key="red", color=Color3.fromRGB(255,0,0)},
    {key="blue", color=Color3.fromRGB(0,80,255)},
    {key="orange", color=Color3.fromRGB(255,120,0)},
    {key="green", color=Color3.fromRGB(0,255,80)},
    {key="yellow", color=Color3.fromRGB(255,255,0)},
    {key="white", color=Color3.fromRGB(255,255,255)},
    {key="purple", color=Color3.fromRGB(170,0,255)},
    {key="azure", color=Color3.fromRGB(0,200,255)},
    {key="cyan", color=Color3.fromRGB(0,255,255)},
}

local LangFlags = { ru="🇷🇺", en="🇬🇧", uk="🇺🇦", be="🇧🇾" }

local function RebuildAll()
    Title.Text = T("title")
    TabFarm.Text = T("farm")
    TabFun.Text = T("fun")
    TabMisc.Text = T("misc")
    if CurrentTabBtn == TabFarm then BuildFarmTab()
    elseif CurrentTabBtn == TabFun then BuildFunTab()
    else BuildMiscTabRef() end
    RefreshAccentEverywhere()
end

local function SetAccentPreset(preset)
    if preset.rainbow then
        RainbowMode = true
        if rainbowConn then rainbowConn:Disconnect() end
        rainbowConn = RunService.RenderStepped:Connect(RefreshAccentEverywhere)
    else
        RainbowMode = false
        if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
        AccentColor = preset.color
        RefreshAccentEverywhere()
    end
end

BuildMiscTabRef = function()
    ClearContent()
    CreateSectionTitle(T("miscTitle"), 1)
    local order = 2
    CreateSectionTitle(T("strokeColor"), order); order = order + 1
    for _, p in ipairs(StrokePresets) do
        local btn = CreateButton("●  " .. T(p.key), order, function() SetAccentPreset(p) end)
        if p.color then btn.TextColor3 = p.color end
        order = order + 1
    end
    CreateSectionTitle(T("language"), order); order = order + 1
    for _, code in ipairs({"ru","en","uk","be"}) do
        CreateButton(LangFlags[code] .. "   " .. code:upper(), order, function()
            Lang = code; RebuildAll()
        end)
        order = order + 1
    end
end

local function SelectTab(btn, builder)
    CurrentTabBtn = btn
    Content.Position = UDim2.new(0, 130, 0, 42)
    Content.BackgroundTransparency = 1
    builder()
    RefreshAccentEverywhere()
    TweenService:Create(Content, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 120, 0, 42), BackgroundTransparency = 0.25}):Play()
end

TabFarm = CreateTabButton(T("farm"), 1)
TabFun  = CreateTabButton(T("fun"), 2)
TabMisc = CreateTabButton(T("misc"), 3)

TabFarm.MouseButton1Click:Connect(function() SelectTab(TabFarm, BuildFarmTab) end)
TabFun.MouseButton1Click:Connect(function() SelectTab(TabFun, BuildFunTab) end)
TabMisc.MouseButton1Click:Connect(function() SelectTab(TabMisc, BuildMiscTabRef) end)

CurrentTabBtn = TabFarm
BuildFarmTab()
RefreshAccentEverywhere()

print("[GIDRAXID] v4 loaded | FUN: speedhack / fly / icon changer")
