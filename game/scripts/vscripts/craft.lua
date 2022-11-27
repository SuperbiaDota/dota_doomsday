function FormatItemAdded( event )
    
    UpdateCraftUI(
        {
            player_id = event.inventory_player_id,
            entindex = event.inventory_parent_entindex
        }
    )
end

function FormatItemChange( event )
    UpdateCraftUI(
        {
            player_id = event.player_id,
            entindex = event.hero_entindex
        }
    )
end

function UpdateCraftUI( event )
    if not IsServer() and PlayerResource ~= nil then return end
    local player_entity = PlayerResource:GetPlayer(event.player_id)
    local caster = EntIndexToHScript(event.entindex)
    local craft_list = {}
    local craft_count = 0

    for craftTime, itemTable in pairs(GameMode.craft_recipes) do
        for craftResult, craftRecipe in pairs(itemTable) do
            local craftRecipe_copy = DeepCopyTable(craftRecipe)
            local foundAllComponents = true
            local availableItemSlots = {}
            for i=0, 8 do
              availableItemSlots[i] = 0
            end
            --print("\nstarting search for: " .. craftResult)
            for component, _ in pairs(craftRecipe_copy) do
                -- assert( count > 0 )
                local foundComponent = false
                for itemSlotIndex, _ in pairs(availableItemSlots) do
                    local hItem = caster:GetItemInSlot(itemSlotIndex)
                    if hItem and hItem:GetName() == component then
                        availableItemSlots[itemSlotIndex] = nil
                        craftRecipe_copy[component] = craftRecipe_copy[component] - 1
                        if craftRecipe_copy[component] <= 0 then
                            foundComponent = true 
                            break 
                        end
                    end
                end
                if foundComponent == false then
                    foundAllComponents = false
                    --print("missing component: " .. component)
                    break
                end
            end
            if foundAllComponents == true then
                craft_list[craft_count] = {
                    item = craftResult,
                    duration = craftTime
                }
                craft_count = craft_count+1
            end
        end
    end
    CustomGameEventManager:Send_ServerToPlayer( player_entity, "update_craft_ui", craft_list )
    --DeepPrintTable( craft_list )
end

function OnCastCraft( player, event )
    local event_unit = EntIndexToHScript(event.unit)
    local craft_ability = event_unit:FindAbilityByName("custom_ability_craft")
    if craft_ability ~= nil then
        -- TODO: set channel icon to item icon

        craft_ability.item = event.item
        craft_ability.duration = event.duration
        event_unit:CastAbilityNoTarget(craft_ability, event.PlayerID)
    end
end