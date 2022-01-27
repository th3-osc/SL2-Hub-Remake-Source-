local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/th3-osc/lib/main/SzNPPuVX4AhMTIhL.lua"))()

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character
local humanoid = character.Humanoid
local camera = workspace.CurrentCamera
local tool = character:FindFirstChildWhichIsA("Tool")

local sayMessageRemote = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local doorService = ReplicatedStorage.DoorService

local game_mt = getrawmetatable(game)
local game_nc = game_mt.__namecall
local game_ix = game_mt.__index

local Apartments = {
	"Premium Apartments",
	"Exclusive Apartments",
	"Apartments",
}

local Blocks = {
	"OO Block",
	"060 House"
}

local Dealers = {
	"Car Dealer",
}

--Code is bad cuz i wanted to throw this together quick and ruin these skids

local door = function(place)
    doorService:FireServer(place)
end

local click = function(position)
    VirtualInputManager:SendMouseButtonEvent(position.X + position.X / 2, position.Y + 50, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(position.X + position.X / 2, position.Y + 50, 0, false, game, 1)
end

local saymessage = function(message)
	sayMessageRemote:FireServer(message, "All")
end

local partremove = function(partType)
    if partType == "Arms" then
    elseif partType == "Legs" then
    elseif partType == "Face" then
    elseif partType == "" then
    end
end

local skiploading = function()
    local menu = player.PlayerGui:FindFirstChild("Menu")
    
    if menu then 
        menu:Destroy()
        wait(0.1)
        
        camera.CameraType = Enum.CameraType.Custom
        player.PlayerGui.Agreement.Enabled = false
		player.PlayerGui.Stats.Enabled = true
		camera.AGREEMENT.Enabled = false
    end
end

local hookremote = function(methodName, name)
    game_mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if method == methodName and tostring(self) == name then
            return
        end
        return game_nc(self, table.unpack(args))
    end 
end

local hookindex = function(location, name, value)
	game_mt.__index = function(t, k)
		if t == location and k == name then
			return value
		end
		return game_ix(t, k)
	end
end
	

local antijam = function()
	if not tool then return print("Equip The Tool To Apply Mods") end
	
	local script = tool:FindFirstChild("Pistol")

	if script then
		local senv = getsenv(script)
		
        debug.setconstant(senv.OnFire, 15, -1)
	end
end

local infstamina = function()
    player.Valuestats.Stamina.Value = 100
end

local infhunger = function()
    player.Valuestats.Hunger.Value = 100
end

local infammo = function()
    local instance = character:FindFirstChildWhichIsA("Tool") do
		if not instance then return end
	end

    local script = instance:FindFirstChild("Pistol") do
		if not script then return end
	end

	setreadonly(game_mt, false)

	hookremote("FireServer", "Shot")
	hookremote("FireServer", "Bullet1")

	script.Parent.ClipSize.Value = tonumber("inf")
	script.Parent.MaxAmmo.Value = tonumber("inf")

	setreadonly(game_mt, true)
end

local removeragdoll = function()
    local hurtSystem = character:FindFirstChild("HurtSystem")
    local ragdoll = character:FindFirstChild("Ragdoller")

    if hurtSystem then hurtSystem:Destroy() end
    if ragdoll then ragdoll:Destroy() end
   
    workspace.ChildAdded:Connect(function(child)
       if child.ClassName == "Model" and Players:FindFirstChild(child.Name) then
            local hurtSystem = character:FindFirstChild("HurtSystem")
            local ragdoll = character:FindFirstChild("Ragdoller")

            if hurtSystem then hurtSystem:Destroy() end
            if ragdoll then ragdoll:Destroy() end
        end
    end)
end

local infkarma = function()
    local ticket = player.PlayerGui:FindFirstChild("Ticket")

    if ticket then ticket:Destroy() end

	player.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "Ticket" then
            child:Destroy()
        end
    end)
end

local scream = function()
    for i = 1, 5, 1 do
        saymessage("Anonymous Hub")
        task.wait(.5)
    end
end

local firerate = function(number)
	if not tool then return print("Equip The Tool To Apply Mods!") end
	
	local script = tool:FindFirstChild("Pistol")

	if script then
		local senv = getsenv(script)
				
		debug.setconstant(senv.OnFire, 70, number)	
	end
end

local removeblur = function()
	for _, v in pairs(camera:GetChildren()) do
		if v.ClassName == "BlurEffect" then
			v.Enabled = false

            v:GetPropertyChangedSignal("Enabled"):Connect(function()
                v.Enabled = false
            end)
		end
	end
    
    camera.ChildAdded:Connect(function(child)
        if child.ClassName == "BlurEffect" then
            child.Enabled = false
        end
    end)
end

local bighead = function()
    for _, v in pairs(workspace:GetChildren()) do
        if v.ClassName == "Model" and Players:FindFirstChild(tostring(v)) and v ~= player.Character then
            v.Head.Transparency = 0.5
            v.Head.CanCollide = false
            v.Head.Size = Vector3.new(3, 3, 3)
        end
    end
end

local autofarm = function(bool)
    if _G.data.autofarm.enabled and bool then return print("Autofarm Already Running...") end

    if _G.data.autofarm.enabled and not bool then
        _G.data.autofarm.enabled = false
    elseif not _G.data.autofarm.enabled and bool then
        teleport("Outside", "Urban")
        task.wait(.2)
        door("Urban")
        task.wait(1)

        _G.data.autofarm.enabled = true
    end
end

local removename = function()
    local ui = character.Head:FindFirstChild("Gui")

    if ui then
        ui:Destroy()
    end
end

teleport = function(...)
    local args = {...}

    if not table.find(ttype, string.lower(args[1])) then return end

    if string.lower(args[1]) == "player" then
        local findplayer = Players:FindFirstChild(args[2])
        
        if findplayer then
           character.HumanoidRootPart.CFrame = findplayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
        end
    elseif string.lower(args[1]) == "outside" then
        local teleports = workspace.TeleportsBack
        local findlocation = teleports:FindFirstChild(args[2])
        
        if findlocation then
            character.HumanoidRootPart.CFrame = findlocation.CFrame
        end
    elseif string.lower(args[1]) == "inside" then
        local teleports = workspace.Teleports
        local location = teleports:FindFirstChild(args[2])

        if location then
            local getBool = location:FindFirstChild("register")

            if getBool then
                character.HumanoidRootPart.CFrame = location.CFrame
            else
                local create = Instance.new("BoolValue")
                create.Name = "register"
                create.Value = true
                create.Parent = location

                teleport("Outside", args[2])
                door(args[2])
            end
        end
    elseif string.lower(args[1]) == "autofarm" then
    	character.HumanoidRootPart.CFrame = workspace.UrbanWorker.Head.CFrame * CFrame.new(0, 0, -5)
    end
end
--[[
_G.data.autofarm.ran = 0

while true do
    teleport("Autofarm")
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(1)

    local urbanGui = player.PlayerGui:FindFirstChild("UrbanGui")
    if urbanGui then
        local container = urbanGui.Frame
        local hiredAbsPosition = container.Hired.AbsolutePosition

		task.wait(4)
		click(hiredAbsPosition)
		task.wait(3)
		character.HumanoidRootPart.CFrame = workspace.CrateZone.Part.CFrame * CFrame.new(0, 3, 0)
		task.wait(3)
		humanoid:EquipTool(player.Backpack.Crate)
		task.wait(2)
		character.Crate.Script.RemoteEvent:FireServer()
        task.wait(1.5)
    end
end--]]

local lib = library.new("Anonymous Hub | syv#1458")

local HomePage = lib:addPage("Home") do
	local section = HomePage:addSection("Welcome, " .. player.Name .. "!") 
	
	local button = section:addButton("Skip Loading Screen", function()
		skiploading()
	end)
	
	local keybind = section:addKeybind("Window Open/Close", Enum.KeyCode.Q, function()
		lib:toggle()
	end)
end

local PlayerPage = lib:addPage("Player") do
	local exploits = PlayerPage:addSection("Player Exploits") do
		local wsSlider = exploits:addSlider("WalkSpeed - Type If Slider Dont Work", 16, 16, 300, function(value)
			humanoid.WalkSpeed = value
		end)
		
		local jpSlider = exploits:addSlider("JumpPower - Type If Slider Dont Work", 50, 50, 300, function(value)
			humanoid.JumpPower = value
		end)
	end
	
	local stats = PlayerPage:addSection("Stats") do
		local stamina =  stats:addButton("Infinite Stamina", function()
			setreadonly(game_mt, false)
			
			hookindex(player.Valuestats.Stamina, "Value", 100)
			
			setreadonly(game_mt, true)
		end)
		local karma =  stats:addButton("Infinite Karma", function()
			infkarma()
		end)
	end
	
	local others = PlayerPage:addSection("Other Player Exploits") do
		local skittles =  others:addButton("Infinite Skittles", function()
			character.Resistance.Value = true
			player.PlayerGui.Run.Value.Value = true
		end)
		
		local name = others:addButton("Hide Name", function()
			removename()
		end)
		
		local face = others:addButton("Hide Face", function()
			local face = character.Head:FindFirstChildWhichIsA("Decal")
			
			if face then 
				face:Destroy()	
			end
		end)
		
		local btool = others:addButton("Btool", function()
			local hammer = Instance.new("HopperBin")
			hammer.BinType = Enum.BinType.Hammer
			hammer.Parent = player.Backpack
		end)
		
		local jump = others:addButton("Infinite Jump", function()
			UserInputService.JumpRequest:connect(function()
				humanoid:ChangeState("Jumping")
			end)
		end)
	end
end

local CombatPage = lib:addPage("Combat") do
	local others = CombatPage:addSection("Combat")
	
	local jam = others:addButton("Anti Gun Jam", function()
		antijam()
	end)
	
	local amoo = others:addButton("Infinite Ammo", function()
		infammo()
	end)
	
	local firerate = others:addButton("Low FireRate", function()
		firerate(0)
	end)
end

local TeleportsPage = lib:addPage("Teleports") do
	local ApartmentsPage = TeleportsPage:addSection("Apartments")
	local OthersPage = TeleportsPage:addSection("Others")
	local BlocksPage = TeleportsPage:addSection("Blocks")	
	local DealersPage = TeleportsPage:addSection("Dealers")	
	
	for _, v in pairs(workspace.TeleportsBack:GetChildren()) do
		if table.find(Apartments, v.Name) then
			local button = ApartmentsPage:addButton(v.Name, function()
				character.HumanoidRootPart.CFrame = v.CFrame
			end)
		elseif table.find(Blocks, v.Name) then
			local button = BlocksPage:addButton(v.Name, function()
				character.HumanoidRootPart.CFrame = v.CFrame
			end)
		elseif table.find(Dealers, v.Name) then
			local button = DealersPage:addButton(v.Name, function()
				character.HumanoidRootPart.CFrame = v.CFrame
			end)
		else
			local button = OthersPage:addButton(v.Name, function()
				character.HumanoidRootPart.CFrame = v.CFrame
			end)
		end 
	end
end
local OthersPage = lib:addPage("Others") do
	local others = OthersPage:addSection("Known Hubs")
	
	local infyield = others:addButton("Infinite Yield", function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end)
end

local CreditsPage = lib:addPage("Credits") do
	local section = CreditsPage:addSection("Credits - Click And Check Output For Info")
	local info = CreditsPage:addSection("Rushed...")
	local info2 = CreditsPage:addSection("Realized That This UI Library Is Broken But IDC Enough To Fix Or Change")
	
	local me = section:addButton("syv#1458 - Creator", function()
		print("Im the owner i made this cuz skids all around and cuz i felt like it enjoy free")
	end)
	
	local kur = section:addButton("antikur#1337 - Click For Info >:)", function()
		print("this dude is a huge skid one of the main reasons im releasing this, he is still working on a hub yet he cant finish fast enough cuz hes a skid..Fuck u...lol just realized they have the same id two skids..skidship")
	end)
	
	local phantomx = section:addButton("PhantomX#0833 - Click For Info >:)", function()
		print("retarded bozo might be a skid, but he def supports skids heavily idk.. Fuck u")
	end)
	
	local reaperhacks = section:addButton("ReaperHacks#1337 - Click For Info >:)", function()
		print("supports skids and might be a skid, kur 'called him out' but is still working with him i dont get it")
	end)
end

--infstamina()
--infhunger()
--removename()
--skiploading()
--teleport("Player", "bao545yy")
--antikarma()
--removeragdoll()
--scream()
--saymessage("freaking females")   
--character.Resistance.Value = true
--bighead()
--infammo()
--antijam()
--firerate(0.000003)
--removeblur()
--autofarm(true)
