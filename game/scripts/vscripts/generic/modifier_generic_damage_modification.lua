-- NOTE: Damage block is handled the normal way. Damage block only blocks damage from attacks and works against wards. 
-- TODO: make custom ward modifier

--[[

Must be the only incoming damage modifier.
Damage calculated in order of lowest priority value first and oldest modifier first. Refreshing the modifier updates its order.
Callbacks are in the format of (incoming damage, hmod) -> modified damage

to use: create this modifier in the associated modifier's OnCreated(), then call RemoveMod() in the associated modifier's OnDestroy()

table structure:
mod_table
{
    handle
    {
        callback (incoming_damage, context) -> damage_excess
        priority
        damage_type
        next
        prev
    }
}

Table is arranged in linked list
(sequential array won't be faster than a linked list because lua uses hash tables)

]]

--------------------------------------------------------------------------------
modifier_generic_damage_modification = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_damage_modification:IsHidden()
    return true
end

function modifier_generic_damage_modification:IsDebuff()
    return false
end

function modifier_generic_damage_modification:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_damage_modification:OnCreated( kv )
    if IsServer() then
        -- init table
        self.mod_table[kv.hmod] = {}
        self.mod_table = {
            [kv.hmod] = {
                priority = kv.priority,
                damage_type = kv.damage_type
            }
        }

        if kv.callback then
            self:SetOnDamageCallback(kv.hmod, kv.callback)
        end
        
        self.first = self.mod_table[kv.hmod]



        -- increment stack
        self:IncrementStackCount()
    end
end

function modifier_generic_damage_modification:OnRefresh( kv ) -- TODO: make sure short duration barriers dont overwrite long duration
    if IsServer() then

        -- if entry already exists then remove from the table order
        local entry = self.mod_table[kv.hmod]
        if entry then 
            self:RemoveFromTable(kv.hmod)
        end

        entry = {
            priority = kv.priority,
            damage_type = kv.damage_type
        }

        if kv.callback then
            self:SetOnDamageCallback(kv.hmod, kv.callback)
        end

        -- set next and prev
        local find = self.first
        while find do
            if find.priority > entry.priority then
                entry.prev = find.prev
                find.prev = entry
                entry.next = find
                return
            elseif find.next == nil then
                find.next = entry
                return
            else
                find = find.next
            end
        end

        -- increment stack
        self:IncrementStackCount()
    end
end

--function modifier_generic_damage_modification:SetTablePosition( entry )
--    local find = self.first
--    while find do
--        if find.priority > entry.priority then
--            entry.prev = find.prev
--            find.prev = entry
--            entry.next = find
--            return
--        elseif find.next == nil then
--            find.next = entry
--            return
--        else
--            find = find.next
--        end
--    end
--end

function modifier_generic_damage_modification:OnRemoved()
end

function modifier_generic_damage_modification:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_damage_modification:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
    }

    return funcs
end

function modifier_generic_damage_modification:GetModifierIncomingDamage_Percentage( params )
-- TODO: dont trigger with hp removal
    local excess_dmg = params.original_damage
    local damage_type = params.damage_type
    for hmod, v in pairs(self.mod_table) do
        if damage_type == v.damage_type or v.damage_type == DAMAGE_TYPE_ALL then
            excess_dmg = v.callback(excess_dmg, hmod)
        end
    end
    return (excess_dmg / params.original_damage * 100) - 100
end

--------------------------------------------------------------------------------
-- Helpers
function modifier_generic_damage_modification:BarrierTakeDamage( excess, context )
    if excess >= context.block then
        excess = excess - context.block
        context:Destroy()
    else
        excess = 0
        context.block = context.block - excess
    end
    return excess
end

function modifier_generic_damage_modification:PercentModify( excess, context )
    return context.damage_percent * excess
end

function modifier_generic_damage_modification:AbsoluteNoDamage( excess, context )
    return 0
end

function modifier_generic_damage_modification:RemoveMod( hmod )
    if IsServer() then
        local entry = self.mod_table[hmod]
        entry.prev.next = entry.next
        entry.next.prev = entry.prev
        entry = nil
    end
end

function modifier_generic_damage_modification:SetOnDamageCallback( hmod, callback )
    local internal_LUT = {
        ["barrier"] = self.BarrierTakeDamage,
        ["percent"] =  self.PercentModify,
        ["no_damage"] = self.AbsoluteNoDamage
    }
    local lookup = internal_LUT(callback)
    if lookup then
        self.mod_table[hmod]["callback"] = lookup
    else
        self.mod_table[hmod]["callback"] = callback
    end
end

--------------------------------------------------------------------------------
-- Stack
function modifier_generic_damage_modification:OnStackCountChanged( old_count )
    if self:GetStackCount() == 0 then
        self:Destroy()
    end
end