---Ragdoll when jumping
Config.RagdollChance = 0.5
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPedOnFoot(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) and (IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId())) and not IsPedClimbing(PlayerPedId()) and IsPedJumping(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
            local Result = math.random()
            if Result < Config.RagdollChance then 
                Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                SetPedToRagdoll(PlayerPedId(), math.random(2500, 5000), 1, 2)
            else
                Citizen.Wait(2000)
            end
        end
    end
end)

--stop hat/glases falling off
local lastped = nil
Citizen.CreateThread(function()
    while true do
        if PlayerPedId() ~= lastped then
            lastped = PlayerPedId()
            SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)
        end
        Wait(100)
    end
end)

---- Requires Right MB to be pressed before punching
local RightClick = false
CreateThread(function()
    while true do
        DisableControlAction(0, 140, true)
		DisableControlAction(0, 263, true)
    if RightClick == false then
        DisableControlAction(0,24,true)
    end
    if IsControlPressed(0, 25) then
        RightClick = true
    end
    if IsControlJustReleased(0, 25) then
        RightClick = false
    end
        Wait(1)
    end
end)

----Stop dodgy animation after shooting
CreateThread(function()
    while true do
        Wait(500)
        ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            if IsPedUsingActionMode(ped) then
                SetPedUsingActionMode(ped, -1, -1, 1)
            end
        else
            Wait(3000)
        end
    end
end)

-- Stuck Props
RegisterNetEvent('RemoveStuckProps', function()
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)
