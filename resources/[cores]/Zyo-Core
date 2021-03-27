ZyoCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ZyoCore == nil then
            TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
