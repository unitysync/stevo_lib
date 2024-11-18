local Ox = require '@ox_core.lib.init' --[[@as OxServer]]
local ox_inventory = GetResourceState('ox_inventory') == 'started'
if not lib.checkDependency('ox_inventory', '2.43.2') then
    lib.print.error('ox_inventory is a required dependency when using ox_core with stevo_lib.')
    return
end

---@param source number
---@return string
function stevo_lib.GetIdentifier(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    return OxPlayer.stateId
end

---@param source number
---@return string
function stevo_lib.GetName(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    return OxPlayer.get('name')
end

---@param job string
---@return number
function stevo_lib.GetJobCount(_, job) --[[`source` replaced with `_` as to not break the function]]
    return #Ox.GetPlayers(job)
end


---@param source number
---@return string, false
function stevo_lib.GetPlayerGroups(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    return OxPlayer.get('activeGroup'), false
end

---@param source number
---@return table
function stevo_lib.GetPlayerJobInfo(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    local activeGroup = OxPlayer.get('activeGroup')
    local job = OxPlayer.getGroup(activeGroup)
    local groupState = GlobalState['group.' .. activeGroup]
    return {
        name = activeGroup,
        label = groupState?.label or 'Unknown',
        grade = job,
        gradeName = groupState?.grades?[job] or 'Unknown',
    }
end

---@return false
function stevo_lib.GetPlayerGangInfo()
    return false -- Not a default feature in ox_core.
end

---@return table[]
function stevo_lib.GetPlayers()
    local OxPlayers = Ox.GetPlayers() --[[@as OxPlayerServer[] ]]
    local formattedPlayers = {}
    for _, v in pairs(OxPlayers) do
        local player = {
            job = v.get('activeGroup'),
            gang = false,
            source = v.source
        }
        table.insert(formattedPlayers, player)
    end
    return formattedPlayers
end

---@param source number
---@return string
function stevo_lib.GetDob(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    return OxPlayer.get('dateOfBirth')
end

---@param source number
---@return string
function stevo_lib.GetSex(source)
    local OxPlayer = Ox.GetPlayer(source) --[[@as OxPlayerServer]]
    return OxPlayer.get('gender')
end

---@param source number
---@param item string
---@param count number
---@return boolean
function stevo_lib.RemoveItem(source, item, count)
    return exports.ox_inventory:RemoveItem(source, item, count)
end

---@param source number
---@param item string
---@param count number
---@return boolean
function stevo_lib.AddItem(source, item, count)
    return exports.ox_inventory:AddItem(source, item, count)
end

---@param source number
---@param item string
---@return boolean
function stevo_lib.HasItem(source, item)
    return exports.ox_inventory:GetItemCount(source, item) > 0
end

---@param source number
---@return table[]
function stevo_lib.GetInventory(source)
    local items = {}
    local data = ox_inventory and exports.ox_inventory:GetInventoryItems(source)
    for i = 1, #data do
        local item = data?[i]
        items[#items + 1] = {
            name = item.name,
            label = item.label,
            count = ox_inventory and item.count or item.amount,
            weight = item.weight,
            metadata = ox_inventory and item.metadata or item.info
        }
    end
    return items
end

function stevo_lib.RegisterUsableItem()
    lib.print.warn('RegisterUsableItem is not supported in ox_core. Please modify data/items.lua in ox_inventory.')
    return false
end