local VehiclesWithNeons = {}

local function HasNeon(vehicle)
    if VehiclesWithNeons[vehicle] ~= nil then
        return true
    end

    if IsVehicleNeonLightEnabled(vehicle) then
        VehiclesWithNeons[vehicle] = true
        return true
    end

end

local function LightLogic()
	local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

	if not vehicle or not IsPedInAnyVehicle(playerPed, false) or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then return end -- ignore if not in car or driver seat
	
	local hasNeons = HasNeon(vehicle)

	if not hasNeons then return end
    
    local neonsOn = (VehiclesWithNeons[vehicle] ~= nil and VehiclesWithNeons[vehicle] or false)

	SetVehicleNeonLightEnabled(vehicle, 0, not neonsOn)
	SetVehicleNeonLightEnabled(vehicle, 1, not neonsOn)
	SetVehicleNeonLightEnabled(vehicle, 2, not neonsOn)
	SetVehicleNeonLightEnabled(vehicle, 3, not neonsOn)
    VehiclesWithNeons[vehicle] = not neonsOn
end

RegisterCommand(Config.ChatCommand, function()
    if antiSpam then return end

	local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
	if not vehicle or not IsPedInAnyVehicle(playerPed, false) or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then return end

	LightLogic()
	antiSpam = true

	Wait(Config.Delay)
	antiSpam = false
end, false)

if Config.UseKeybind then
    RegisterKeyMapping(Config.ChatCommand, 'Toggle Underglow', 'keyboard', 'g')
end

local function CheckVehicles()
    for k,v in pairs(VehiclesWithNeons) do
        local valid = DoesEntityExist(k)

        if not valid or valid == nil then
            VehiclesWithNeons[k] = nil
            return
        end
    end

    Wait(300000)
    CheckVehicles()
end