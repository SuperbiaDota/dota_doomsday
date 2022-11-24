custom_ability_craft = class({})

function custom_ability_craft:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end

function custom_ability_craft:GetChannelTime()
    return tonumber(self.duration)
end

function custom_ability_craft:OnSpellStart()
    if not IsServer() then return end

    if self.duration == nil or self.item == nil then
        print("error: item/duration not loaded")
        return
    end
    --EmitSoundOnEntityForPlayer("CustomCraftSound", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())

    self:GetCaster():StartGesture(ACT_DOTA_TELEPORT)
end

function custom_ability_craft:OnChannelFinish(bInterrupted)
    if not IsServer() or bInterrupted then return end

    local caster = self:GetCaster()
    local craftRecipe = DeepCopyTable(GameMode.craft_recipes[self.duration][self.item])

    local availableItemSlots = {}
    for i=0, 8 do
      availableItemSlots[i] = 0
    end

    for component, _ in pairs(craftRecipe) do
        local foundComponent = false
        -- assert(count > 0)
        for itemSlotIndex, _ in pairs(availableItemSlots) do
            local hItem = caster:GetItemInSlot(itemSlotIndex)
            if hItem 
                and (hItem:GetPurchaser() == caster or hItem:GetPurchaser() == nil)
                and hItem:GetName() == component then
                availableItemSlots[itemSlotIndex] = nil
                craftRecipe[component] = craftRecipe[component]-1
                hItem:Kill()
                if craftRecipe[component] <= 0 then 
                    foundComponent = true 
                    break 
                end
            end
        end
        if foundComponent == false then 
            print("error, component " .. component .. " not found")
            return
        end
    end

    caster:AddItem(CreateItem(self.item, caster, caster))
    caster:StartGesture(ACT_DOTA_TELEPORT_END)
end
