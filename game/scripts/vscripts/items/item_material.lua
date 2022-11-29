if InitMaterials then
    return
else
    InitMaterials = true
end

--[[ 

TODO: make this a UI library
shift+click moves between inventory and backpack
ctrl+click takes one off an item stack (deprecate ctrl+cast)

drop item at random offset from hero position
dropping item does not interrupt current movement

test IsNeutralItem so items cant be searched

]]

FilterManager:AddExecuteOrderFilter(
    function(context, keys)
        local order = keys.order_type
        local unit
        if keys.units and keys.units["0"] then
            unit = EntIndexToHScript(keys.units["0"])
        end
        if order == DOTA_UNIT_ORDER_PURCHASE_ITEM then
            if unit and keys.shop_item_name then
                if string.sub(keys.shop_item_name, 1, 8) == "item_mat" then
                    return false
                end
            end
        elseif order == DOTA_UNIT_ORDER_DROP_ITEM then
            local item = EntIndexToHScript( keys.entindex_ability )
            if unit and unit:CanDropItems() then
                local unit_pos = unit:GetAbsOrigin()
                unit_pos.z = GetGroundHeight(unit_pos, nil)
                local target_pos = unit_pos + RandomVector(unit:BoundingRadius2D())
                math.random(360)
                unit:DropItemAtPositionImmediate( item, target_pos )
                FireGameEvent("item_dropped", {item = item})
            end
            return false
        end
        return true
    end,
    nil
)