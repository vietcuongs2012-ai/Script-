-- =============================================
-- GAME FARM MOB + RAID BOSS + EXP + LEVEL + RƯƠNG
-- Đặt script này vào ServerScriptService
-- =============================================

local SPAWN_TIME = 3
local MAX_MOBS = 10

local mobsFolder = workspace:FindFirstChild("Mobs") or Instance.new("Folder")
mobsFolder.Name = "Mobs"
mobsFolder.Parent = workspace

local chestsFolder = workspace:FindFirstChild("Chests") or Instance.new("Folder")
chestsFolder.Name = "Chests"
chestsFolder.Parent = workspace

-- Drop Table
local dropTable = {
    {name = "Beli", value = 50, color = Color3.fromRGB(255, 215, 0)},
    {name = "Gem", value = 10, color = Color3.fromRGB(0, 191, 255)},
}

-- Tạo Leaderstats khi player join
game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local level = Instance.new("IntValue")
    level.Name = "Level"
    level.Value = 1
    level.Parent = leaderstats

    local exp = Instance.new("IntValue")
    exp.Name = "EXP"
    exp.Value = 0
    exp.Parent = leaderstats

    local beli = Instance.new("IntValue")
    beli.Name = "Beli"
    beli.Value = 200
    beli.Parent = leaderstats

    print(player.Name .. " đã tham gia!")
end)

local function addEXP(player, amount)
    local ls = player:FindFirstChild("leaderstats")
    if not ls then return end

    local expVal = ls.EXP
    local level = ls.Level

    expVal.Value += amount

    while expVal.Value >= level.Value * 100 do
        expVal.Value = expVal.Value - (level.Value * 100)
        level.Value += 1
        print(player.Name .. " lên Level " .. level.Value .. "!")
    end
end

local function createDrop(position, item)
    local drop = Instance.new("Part")
    drop.Shape = Enum.PartType.Ball
    drop.Size = Vector3.new(2.8, 2.8, 2.8)
    drop.Position = position + Vector3.new(0, 4, 0)
    drop.Material = Enum.Material.Neon
    drop.BrickColor = BrickColor.new("White")
    drop.Anchored = false
    drop.CanCollide = false
    drop.Parent = workspace

    local light = Instance.new("PointLight", drop)
    light.Color = item.color
    light.Brightness = 3
    light.Range = 20

    local gui = Instance.new("BillboardGui", drop)
    gui.Adornee = drop
    gui.Size = UDim2.new(0, 120, 0, 45)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = item.name .. " +" .. item.value
    label.TextColor3 = item.color
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    drop.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            local ls = player.leaderstats
            local stat = ls:FindFirstChild(item.name) or Instance.new("IntValue")
            stat.Name = item.name
            stat.Value += item.value
            stat.Parent = ls
            drop:Destroy()
        end
    end)

    task.delay(25, function()
        if drop and drop.Parent then drop:Destroy() end
    end)
end

local function spawnNormalMob()
    if #mobsFolder:GetChildren() >= MAX_MOBS then return end

    local mob = Instance.new("Part")
    mob.Name = "Mob"
    mob.Size = Vector3.new(4, 6, 4)
    mob.Position = Vector3.new(math.random(-70,70), 10, math.random(-70,70))
    mob.BrickColor = BrickColor.new("Really red")
    mob.Material = Enum.Material.Neon
    mob.Parent = mobsFolder

    local bb = Instance.new("BillboardGui", mob)
    bb.Adornee = mob
    bb.Size = UDim2.new(0,100,0,35)
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "Mob"
    txt.TextColor3 = Color3.new(1,0,0)
    txt.TextScaled = true

    mob.Destroying:Connect(function()
        if math.random() < 0.75 then
            createDrop(mob.Position, dropTable[1])
        end
    end)
end

local function spawnChest()
    local chest = Instance.new("Part")
    chest.Name = "TreasureChest"
    chest.Size = Vector3.new(4, 3, 4)
    chest.Position = Vector3.new(math.random(-80,80), 8, math.random(-80,80))
    chest.BrickColor = BrickColor.new("Bright yellow")
    chest.Material = Enum.Material.Wood
    chest.Parent = chestsFolder

    local gui = Instance.new("BillboardGui", chest)
    gui.Adornee = chest
    gui.Size = UDim2.new(0,110,0,40)
    local txt = Instance.new("TextLabel", gui)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "🪙 RƯƠNG"
    txt.TextColor3 = Color3.new(1,1,0)
    txt.TextScaled = true

    chest.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            addEXP(player, 100)
            createDrop(chest.Position, {name = "Beli", value = 200, color = Color3.fromRGB(255,215,0)})
            createDrop(chest.Position, {name = "Gem", value = 20, color = Color3.fromRGB(0,191,255)})
            chest:Destroy()
        end
    end)

    task.delay(45, function() if chest.Parent then chest:Destroy() end end)
end

local function spawnRaidBoss()
    print("🔥 RAID BOSS ĐÃ XUẤT HIỆN! 🔥")
    local boss = Instance.new("Part")
    boss.Name = "RAID_BOSS"
    boss.Size = Vector3.new(9, 14, 9)
    boss.Position = Vector3.new(0, 25, 0)
    boss.BrickColor = BrickColor.new("Really black")
    boss.Material = Enum.Material.ForceField
    boss.Parent = mobsFolder

    local bb = Instance.new("BillboardGui", boss)
    bb.Adornee = boss
    bb.Size = UDim2.new(0, 250, 0, 70)
    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "🔥 RAID BOSS 🔥"
    txt.TextColor3 = Color3.new(1,0,0)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBlack

    boss.Destroying:Connect(function()
        for i = 1, 4 do
            createDrop(boss.Position, dropTable[math.random(1, #dropTable)])
        end
        print("Boss đã bị tiêu diệt!")
    end)

    task.delay(80, function() if boss.Parent then boss:Destroy() end end)
end

-- Spawn loops
task.spawn(function()
    while true do
        wait(SPAWN_TIME)
        spawnNormalMob()
    end
end)

task.spawn(function()
    while true do
        wait(22)
        spawnChest()
    end
end)

task.spawn(function()
    while true do
        wait(150)  -- Raid boss mỗi 2.5 phút
        spawnRaidBoss()
    end
end)