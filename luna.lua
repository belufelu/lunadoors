local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

local friends = {}
local LocalPlayer = game.Players.LocalPlayer
local epiklistofpeople = {}
local LXUser = {}
local SendChat = game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
-- detection thingy
SendChat:SendAsync("", "Ineedtheepikrespond")
local Detection = game:GetService("TextChatService").MessageReceived:Connect(function(yeah)
    if yeah.Metadata == "usinglolhax" then
        if game:GetService("Players")[yeah.TextSource.Name] ~= LocalPlayer.Name then
            game:GetService("Players")[yeah.TextSource.Name]:SetAttribute("USINGLOLHAX", true)
        end
    elseif yeah.Metadata == "Ineedtheepikrespond" then
        if game:GetService("Players")[yeah.TextSource.Name] ~= LocalPlayer.Name then
            SendChat:SendAsync("", "usinglolhax")
            game:GetService("Players")[yeah.TextSource.Name]:SetAttribute("USINGLOLHAX", true)
        end
    end
end)

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")

if not fireproximityprompt then
    OrionLib:MakeNotification({
        Name = "Error!",
        Content = "Your executor doesn't support fireproximityprompt!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
    error("no prox") 
end

-- ESP Function
function esp(what,color,core,name)
    local parts
    
    if typeof(what) == "Instance" then
        if what:IsA("Model") then
            parts = what:GetChildren()
        elseif what:IsA("BasePart") then
            parts = {what,table.unpack(what:GetChildren())}
        end
    elseif typeof(what) == "table" then
        parts = what
    end
    
    local bill
    local boxes = {}
    
    for i,v in pairs(parts) do
        if v:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.AdornCullingMode = Enum.AdornCullingMode.Never
            box.Color3 = color
            box.Transparency = 0.7
            box.Adornee = v
            box.Parent = game.CoreGui
            
            table.insert(boxes,box)
            
            task.spawn(function()
                while box do
                    if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                        box.Adornee = nil
                        box.Visible = false
                        box:Destroy()
                    end  
                    task.wait()
                end
            end)
        end
    end
    
    if core and name then
        bill = Instance.new("BillboardGui",game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0,400,0,100)
        bill.Adornee = core
        bill.MaxDistance = 2000
        
        local mid = Instance.new("Frame",bill)
        mid.AnchorPoint = Vector2.new(0.5,0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0,8,0,8)
        mid.Position = UDim2.new(0.5,0,0.5,0)
        Instance.new("UICorner",mid).CornerRadius = UDim.new(1,0)
        Instance.new("UIStroke",mid)
        
        local txt = Instance.new("TextLabel",bill)
        txt.AnchorPoint = Vector2.new(0.5,0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1,0,0,20)
        txt.Position = UDim2.new(0.5,0,0.7,0)
        txt.Text = name
        Instance.new("UIStroke",txt)
        
        task.spawn(function()
            while bill do
                if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy() 
                end  
                task.wait()
            end
        end)
    end
    
    local ret = {}
    
    ret.delete = function()
        for i,v in pairs(boxes) do
            v.Adornee = nil
            v.Visible = false
            v:Destroy()
        end
        
        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy() 
        end
    end
    
    return ret 
end



local flags = {
    speed = 16,
    espdoors = false,
    espkeys = false,
    espitems = false,
    espbooks = false,
    esprush = false,
    espchest = false,
    esplocker = false,
    esphumans = false,
    espgold = false,
    goldespvalue = 25,
    hintrush = false,
    light = false,
    instapp = false,
    noseek = false,
    nogates = false,
    nopuzzle = false,
    noa90 = false,
    noskeledoors = false,
    noscreech = false,
    getcode = false,
    roomsnolock = false,
    draweraura = false,
    autorooms = false,
}

local esptable = {doors={},keys={},items={},books={},entity={},chests={},lockers={},people={},gold={}}
local entitynames = {"RushMoving","AmbushMoving","Snare","A60","A120"}

local NotifyLuna = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/dxhooknotify/src.lua", true))()

local Window = Library:CreateWindow({

	Title = " LUNAHAX ALPHA V1┃"..LocalPlayer.Name,
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	-- Creates a new tab titled Main
	General = Window:AddTab('General'),
    Visuals = Window:AddTab('Visuals'),
	ESP = Window:AddTab('ESP'),
	Exploits = Window:AddTab('Exploits'),
	['Config'] = Window:AddTab('Config'),
}

NotifyLuna:Notify("[LUNAHAX]","Welcome",5)

local LeftGroupBox = Tabs.ESP:AddLeftGroupbox('ESP')

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Door ESP',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
flags.espdoors = Value
        
        if Value then
            local function setup(room)
                local door = room:WaitForChild("Door"):WaitForChild("Door")
                
                task.wait(0.1)
                local h = esp(door,Color3.fromRGB(0,207,0),door,"Door")
                table.insert(esptable.doors,h)
                
                door:WaitForChild("Open").Played:Connect(function()
                    h.delete()
                end)
                
                door.AncestryChanged:Connect(function()
                    h.delete()
                end)
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end
            
            repeat task.wait() until not flags.espdoors
            addconnect:Disconnect()
            
            for i,v in pairs(esptable.doors) do
                v.delete()
            end 
        end
    end
})

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Key/Lever ESP',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
flags.espkeys = Value
        
        if Value then
            local function check(v)
                if v:IsA("Model") and (v.Name == "LeverForGate" or v.Name == "KeyObtain") then
                    task.wait(0.1)
                    if v.Name == "KeyObtain" then
                        local hitbox = v:WaitForChild("Hitbox")
                        local parts = hitbox:GetChildren()
                        table.remove(parts,table.find(parts,hitbox:WaitForChild("PromptHitbox")))
                        
                        local h = esp(parts,Color3.fromRGB(90,255,40),hitbox,"Key")
                        table.insert(esptable.keys,h)
                        
                    elseif v.Name == "LeverForGate" then
                        local h = esp(v,Color3.fromRGB(0,0,255),v.PrimaryPart,"Lever")
                        table.insert(esptable.keys,h)
                        
                        v.PrimaryPart:WaitForChild("SoundToPlay").Played:Connect(function()
                            h.delete()
                        end) 
                    end
                end
            end
            
            local function setup(room)
                local assets = room:WaitForChild("Assets")
                
                assets.DescendantAdded:Connect(function(v)
                    check(v) 
                end)
                    
                for i,v in pairs(assets:GetDescendants()) do
                    check(v)
                end 
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end
            
            repeat task.wait() until not flags.espkeys
            addconnect:Disconnect()
            
            for i,v in pairs(esptable.keys) do
                v.delete()
            end 
        end
    end
})

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Book/Breaker ESP',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
flags.espbooks = Value
        
        if Value then
            local function check(v)
                if v:IsA("Model") and (v.Name == "LiveHintBook" or v.Name == "LiveBreakerPolePickup") then
                    task.wait(0.1)
                    
                    local h = esp(v,Color3.fromRGB(160,190,255),v.PrimaryPart,"Book")
                    table.insert(esptable.books,h)
                    
                    v.AncestryChanged:Connect(function()
                        if not v:IsDescendantOf(workspace) then
                            h.delete() 
                        end
                    end)
                end
            end
            
            local function setup(room)
                if room.Name == "50" or room.Name == "100" then
                    room.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i,v in pairs(room:GetDescendants()) do
                        check(v)
                    end
                end
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
                setup(room) 
            end
            
            repeat task.wait() until not flags.espbooks
            addconnect:Disconnect()
            
            for i,v in pairs(esptable.books) do
                v.delete()
            end 
        end
    end
})

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Item ESP',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
flags.espitems = Value
        
        if Value then
            local function check(v)
                if v:IsA("Model") and (v:GetAttribute("Pickup") or v:GetAttribute("PropType")) then
                    task.wait(0.1)
                    
                    local part = (v:FindFirstChild("Handle") or v:FindFirstChild("Prop"))
                    local h = esp(part,Color3.fromRGB(160,190,255),part,v.Name)
                    table.insert(esptable.items,h)
                end
            end
            
            local function setup(room)
                local assets = room:WaitForChild("Assets")
                
                if assets then  
                    local subaddcon
                    subaddcon = assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i,v in pairs(assets:GetDescendants()) do
                        check(v)
                    end
                    
                    task.spawn(function()
                        repeat task.wait() until not flags.espitems
                        subaddcon:Disconnect()  
                    end) 
                end 
            end
            
            local addconnect
            addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Assets") then
                    setup(room) 
                end
            end
            
            repeat task.wait() until not flags.espitems
            addconnect:Disconnect()
            
            for i,v in pairs(esptable.items) do
                v.delete()
            end 
        end
    end    
})

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Entity ESP',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
flags.esprush = Value
        
        if Value then
            local addconnect
            addconnect = workspace.ChildAdded:Connect(function(v)
                if table.find(entitynames,v.Name) then
                    task.wait(0.1)
                    
                    local h = esp(v,Color3.fromRGB(255,25,25),v.PrimaryPart,v.Name:gsub("Moving",""))
                    table.insert(esptable.entity,h)
                end
            end)
            
            local function setup(room)
                if room.Name == "50" or room.Name == "100" then
                    local figuresetup = room:WaitForChild("FigureSetup")
                
                    if figuresetup then
                        local fig = figuresetup:WaitForChild("FigureRagdoll")
                        task.wait(0.1)
                        
                        local h = esp(fig,Color3.fromRGB(255,25,25),fig.PrimaryPart,"Figure")
                        table.insert(esptable.entity,h)
                    end 
                else
                    local assets = room:WaitForChild("Assets")
                    
                    local function check(v)
                        if v:IsA("Model") and table.find(entitynames,v.Name) then
                            task.wait(0.1)
                            
                            local h = esp(v:WaitForChild("Base"),Color3.fromRGB(255,25,25),v.Base,"Snare")
                            table.insert(esptable.entity,h)
                        end
                    end
                    
                    assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                    
                    for i,v in pairs(assets:GetDescendants()) do
                        check(v)
                    end
                end 
            end
            
            local roomconnect
            roomconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setup(room)
            end)
            
            for i,v in pairs(workspace.CurrentRooms:GetChildren()) do
                setup(v) 
            end
            
            repeat task.wait() until not flags.esprush
            addconnect:Disconnect()
            roomconnect:Disconnect()
            
            for i,v in pairs(esptable.entity) do
                v.delete()
            end 
        end
    end
})

local LeftGroupBox = Tabs.General:AddLeftGroupbox('Functions')

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Fly',
    Default = true, -- Default value (true / false)
    Tooltip = 'Press F', -- Information shown when you hover over the toggle
    Callback = function(Value)
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50 -- Speed at which the player flies


local function startFlying()
    flying = true
    
 
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

 
    local userInputService = game:GetService("UserInputService")
    

    while flying do
        local moveDirection = Vector3.new(0, 0, 0)
        
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDirection * flySpeed
        wait(0.1)
    end
end


local function stopFlying()
    flying = false
    rootPart:FindFirstChild("BodyVelocity"):Destroy()
end

-- Toggle fly on and off with the "F" key
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end
end)
    end
})

local LeftGroupBox = Tabs.Exploits:AddLeftGroupbox('Exploits')

LeftGroupBox:AddSlider('MySlider', {
    Text = 'WalkSpeed Modifier',
    Default = 16,
    Min = 16,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
  local speed = Value

while true do
task.wait()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end
    end
})

local LeftGroupBox = Tabs.Visuals:AddLeftGroupbox('Visuals')

LeftGroupBox:AddSlider('MySlider', {
    Text = 'Field of View',
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
    _G.FOVChangerConnection = _G.FOVChangerConnection or nil
 
if _G.FOVChangerConnection then
    _G.FOVChangerConnection:Disconnect()
    _G.FOVChangerConnection = nil
end
 
local camera = workspace.Camera
 
_G.FOVChangerConnection = camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if camera.FieldOfView ~= Value then
        camera.FieldOfView = Value
    end
end)
 
camera.FieldOfView = Value
    end
})

LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Ambience',
    Default = true, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle
    Callback = function(Value)
pcall(function()
    local lighting = game:GetService("Lighting");
    lighting.Ambient = Color3.fromRGB(206, 173, 144);
    lighting.Brightness = 1;
    lighting.FogEnd = 1e10;
    for i, v in pairs(lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false;
        end;
    end;
    lighting.Changed:Connect(function()
        lighting.Ambient = Color3.fromRGB(255, 255, 255);
        lighting.Brightness = 1;
        lighting.FogEnd = 1e10;
    end);
    spawn(function()
        local character = game:GetService("Players").LocalPlayer.Character;
        while wait() do
            repeat wait() until character ~= nil;
            if not character.HumanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                local headlight = Instance.new("PointLight", character.HumanoidRootPart);
                headlight.Brightness = 1;
                headlight.Range = 60;
            end;
        end;
    end);
end)
    end
})

-- UI Settings
local MenuGroup = Tabs['Config']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['Config'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['Config'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

