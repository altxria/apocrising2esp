--maybe ar2 esp???
-- // services
local run_service = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localplayer = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
-- // tables
local settings = {
      location = {enabled = true, color = Color3.new(1,1,1), distance = 1000},
      zombie = {enabled = true, color = Color3.new(1,0,0), distance = 1000},
      player = {enabled = true, color = Color3.new(128,0,128), distance = 1000},
      randomevents = {enabled = true, color = Color3.new(255,255,0), distance = 2500},
      vehicles = {enabled = true, color = Color3.new(0,255,0), distance = 1000}
}
--
local location_drawings = {}
local zombie_drawings = {}
local player_drawings = {}
local randomevent_drawings = {}
local vehicle_drawings = {}
-- // functions
function draw(instance, properties)
      local drawing = Drawing.new(instance)
      for i,v in pairs(properties) do
            drawing[i] = v
      end
      return drawing
end
--
function createtext(type, table)
      if not table[type] then
            table[type] = draw('Text', {Size = 13, Font = 2, Center = true, Outline = true, Color = Color3.new(1,1,1)})
      end
end
--
function removetext(type, table)
      if table[type] then
            table[type]:Remove()
            table[type] = nil
      end
end
-- // location script
for _,v in next, workspace.Locations:GetChildren() do
      createtext(v, location_drawings)
end
-- // zombie script
for _,v in next, workspace.Zombies.Mobs:GetChildren() do
      createtext(v, zombie_drawings)
end
-- // player scwipt altxria#7302 from here :moai:
for _,v in next, workspace.Characters:GetChildren() do 
      createtext(v, player_drawings)
end
-- // Random events scwipt 
for _,v in next, workspace.Map.Shared.Randoms:GetChildren() do 
      createtext(v, randomevent_drawings)
end
--// Vehicle scwipt
for _,v in next, workspace.Vehicles.Spawned:GetChildren() do
      createtext(v, vehicle_drawings)
end


-- // add and delete espiesies
--zombies
workspace.Zombies.Mobs.ChildAdded:Connect(function(v)
      createtext(v, zombie_drawings)
end)

workspace.Zombies.Mobs.ChildRemoved:Connect(function(v)
      removetext(v, zombie_drawings)
end)
--ppl
workspace.Characters.ChildAdded:Connect(function(v)
      createtext(v, player_drawings)
end)

workspace.Characters.ChildRemoved:Connect(function(v)
      removetext(v, player_drawings)
end)
--events
workspace.Map.Shared.Randoms.ChildAdded:Connect(function(v)
      createtext(v, randomevent_drawings)
end)

workspace.Map.Shared.Randoms.ChildRemoved:Connect(function(v)
      removetext(v, randomevent_drawings)
end)
--vehicles
workspace.Vehicles.Spawned.ChildAdded:Connect(function(v)
      createtext(v, vehicle_drawings)
end)
workspace.Vehicles.Spawned.ChildRemoved:Connect(function(v)
      removetext(v, vehicle_drawings)
end)

-- // runservice shit (bad methods :sob:)
run_service.RenderStepped:Connect(function()
      for _,v in next, location_drawings do
            local pos, visible = camera:WorldToViewportPoint(_.CFrame.p)
            local mag = math.floor((_.CFrame.p - camera.CFrame.p).magnitude)
            v.Visible = visible and settings.location.enabled and (mag <= settings.location.distance) and localplayer.Character ~= nil or false
            if v.Visible then
                  v.Position = Vector2.new(pos.X,pos.Y)
                  v.Text = tostring(_.Name ..' ['..mag..' studs]')
                  v.Color = settings.location.color or Color3.new(1,1,1)
            end
      end
      --
      for _,v in next, zombie_drawings do
            if _:FindFirstChild("HumanoidRootPart") then
                  local hrp = _.HumanoidRootPart.Parent.Name
                  local pos, visible = camera:WorldToViewportPoint(_.HumanoidRootPart.Position)
                  local mag = math.floor((_.HumanoidRootPart.CFrame.p - camera.CFrame.p).magnitude)
                  v.Visible = visible and settings.zombie.enabled and (mag <= settings.zombie.distance) and localplayer.Character ~= nil or false
                  if v.Visible then
                        v.Position = Vector2.new(pos.X,pos.Y)
                        v.Text = tostring(hrp ..' ['..mag..' studs]')
                        v.Color = settings.zombie.color or Color3.new(1,0,0)
                  end
            end
      end
      for _,v in next, player_drawings do 
            if _:FindFirstChild("HumanoidRootPart") then
                local pos, visible = camera:WorldToViewportPoint(_.HumanoidRootPart.Position)
                local playerIdentify = _.HumanoidRootPart.Parent
                local playerID = players:getPlayerFromCharacter(playerIdentify)
                if playerID then
                  local playername = playerID.Name
                else 
                  local playername = "Opposition"
                end
              	
                local mag = math.floor((_.HumanoidRootPart.CFrame.p - camera.CFrame.p).magnitude)
                v.Visible = visible and settings.player.enabled and (mag <= settings.player.distance) and localplayer.Character ~= nil or false
                if v.Visible and playerID ~= localplayer then
                        v.Position = Vector2.new(pos.X,pos.Y)
                        if playername then
                        	v.Text = tostring(playername ..' ['..mag..' studs]')
                        else 
                        	v.Text = tostring("opposition" ..' ['..mag..' studs]')
                        end
                        v.Color = Color3.new(128,0,128)
                end
            end
      end
      for _,v in next, randomevent_drawings do
            local pos, visible = camera:WorldToViewportPoint(_.Value.Position)
            local mag = math.floor((_.Value.Position - camera.CFrame.p).magnitude)
            v.Visible = visible and settings.randomevents.enabled and (mag <= settings.randomevents.distance) and localplayer.Character ~= nil or false
            if v.Visible then
                  v.Position = Vector2.new(pos.X,pos.Y)
                  v.Text = tostring(_.Name ..' ['..mag..' studs]')
                  v.Color = Color3.new(255,255,0)
            end
      end
      for _,v in next, vehicle_drawings do
            if _:FindFirstChild("Base") then
                  local pos, visible = camera:WorldToViewportPoint(_.Base.CFrame.Position)
                  local mag = math.floor((_.Base.CFrame.Position - camera.CFrame.p).magnitude)
                  v.Visible = visible and settings.vehicles.enabled and (mag <= settings.vehicles.distance) and localplayer.Character ~= nil or false
                  if v.Visible then
                        v.Position = Vector2.new(pos.X,pos.Y)
                        v.Text = tostring(_.Name ..' ['..mag..' studs]')
                        v.Color = Color3.new(0,255,0)
                  end
            end
      end
end)
