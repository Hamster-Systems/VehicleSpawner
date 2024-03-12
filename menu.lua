_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Vehicle Spawner", "Spawner By Hamster-Systems")
_menuPool:Add(mainMenu)

-- Load the config file
function LoadConfigFile(resource, filename)
    local content = LoadResourceFile(resource, filename)
    if content then
        local chunk, err = load(content, "config", "t", {})
        if chunk then
            return chunk()
        else
            print("Error loading config file: " .. err)
        end
    else
        print("Error loading resource file: " .. filename)
    end
end

-- Load configuration
local config = LoadConfigFile(GetCurrentResourceName(), "config.lua")
local categoryNames = config.subCategoryNames or {}
local categoryDescriptions = config.categoryDescriptions or {}
local subcategoryDescriptions = config.subcategoryDescriptions or {}
local categories = config.categories or {}

local isMenuOpen = false

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

-- Function to create and refresh the menu
function CreateMenu()
    mainMenu:Clear()

    for mainCategory, subcategories in pairs(categories) do
        local mainSubmenu = _menuPool:AddSubMenu(mainMenu, " " .. (categoryNames[mainCategory] or mainCategory), categoryDescriptions[mainCategory])

        for subcategory, vehicles in pairs(subcategories) do
            local subSubmenu = _menuPool:AddSubMenu(mainSubmenu, " " .. (categoryNames[subcategory] or subcategory), subcategoryDescriptions[subcategory])

            if not subSubmenu then
                print("Subsubmenu not created for category: " .. subcategory)
            else
                for _, vehicle in ipairs(vehicles) do
                    -- print(vehicles)
                    print(vehicle["Name"])
                    print(vehicle["VehicleLivery"])
                    print_table(vehicle)
                    local vehicleItem = NativeUI.CreateItem(vehicle["Name"], "Press Enter to Spawn")
                    vehicleItem.Activated = function(sender, item)
                        SpawnVehicle(vehicle["VehicleModel"],vehicle["NumberPlate"],vehicle["VehicleLivery"])
                    end
                    subSubmenu:AddItem(vehicleItem)
                end
            end
        end
    end

    _menuPool:RefreshIndex()
    isMenuOpen = true -- Set isMenuOpen to true when creating the menu
end


-- Main loop to process menus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        _menuPool:ProcessMenus()

        if config.useKeybind and IsControlJustPressed(1, config.keybind) then
            isMenuOpen = not isMenuOpen
            mainMenu:Visible(isMenuOpen)

            if isMenuOpen then
                CreateMenu()
            end
        end
    end
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function SpawnVehicle(vehicle,plate,livery)
    local vehicleHash = GetHashKey(vehicle)

    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        RequestModel(vehicleHash)
        Citizen.Wait(50)
    end

    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed, false))
    
    -- Check if the player is in a vehicle
    if IsPedInAnyVehicle(playerPed, false) then
        notify("Error: Please exit the vehicle before spawning another.")
        return
    end

    local spawnedVehicle = CreateVehicle(vehicleHash, x + 2, y + 2, z + 1, GetEntityHeading(playerPed), true, false)

    if DoesEntityExist(spawnedVehicle) then
        SetPedIntoVehicle(playerPed, spawnedVehicle, -1)
        SetEntityAsNoLongerNeeded(spawnedVehicle)
        if (not(livery == nil)) then
            SetVehicleLivery(spawnedVehicle,tonumber(livery))
        end
        if (not(plate == nil)) then
            SetVehicleNumberPlateText(spawnedVehicle, plate)
        end
        notify("Spawned in a " .. vehicle)
    else
        notify("Error: Vehicle could not be spawned.")
        mainMenu:Visible(false)  -- Close the menu on error
    end
end

function OpenVehicleSpawnerMenu()
    isMenuOpen = not isMenuOpen
    mainMenu:Visible(isMenuOpen)

    if isMenuOpen then
        CreateMenu()
    end
end

print("Script loaded successfully")

-- Register the command
RegisterCommand(config.command or "vs", function()
    OpenVehicleSpawnerMenu()
end, false)
