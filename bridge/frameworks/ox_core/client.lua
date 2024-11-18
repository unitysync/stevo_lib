local OxPlayer = require '@ox_core.lib.client.player' --[[@as OxPlayerClient]]

---@param msg string
---@param type string
---@param duration number
function stevo_lib.bridgeNotify(msg, type, duration)
    lib.notify({
        ---@diagnostic disable-next-line: assign-type-mismatch
        type = type == 'info' and 'inform' or type,
        description = msg,
        duration = duration
    })
end

---@return string, false
function stevo_lib.GetPlayerGroups()
    return OxPlayer.get('activeGroup'), false
end

---@return table
function stevo_lib.GetPlayerGroupInfo()
    local activeGroup = OxPlayer.get('activeGroup')
    local jobInfo = {
        name = activeGroup,
        grade = OxPlayer.getGroup(activeGroup),
        label = GlobalState['group.' .. activeGroup]?.label or 'Unknown'
    }

    return jobInfo
end

---@return number
function stevo_lib.GetSex()
    return OxPlayer.get('gender'):lower() == 'male' and 1 or 2
end

---@return boolean
function stevo_lib.IsDead()
    return OxPlayer.state.isDead
end

function stevo_lib.SetOutfit()
    -- Not yet implemented (May come soon)
    return false
end

AddStateBagChangeHandler('isDead', 'player:' .. cache.serverId, function(_, __, isDead)
    if isDead then
        TriggerEvent('stevo_lib:playerDied')
        return
    end
end)

RegisterNetEvent('ox:playerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)
