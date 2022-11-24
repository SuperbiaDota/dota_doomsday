custom_modifier_arcane_blink = class({})

function custom_modifier_arcane_blink:IsHidden()
    return true 
end

function custom_modifier_arcane_blink:IsPurgable() 
    return false 
end

function custom_modifier_arcane_blink:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE
end

function custom_modifier_arcane_blink:RemoveOnDeath() 
    return false 
end

function custom_modifier_arcane_blink:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.int_bonus = self:GetAbility():GetSpecialValueFor("int_bonus")
    self.cdr = self:GetAbility():GetSpecialValueFor("cdr_per_cast")
end

function custom_modifier_arcane_blink:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
       MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
    }
end

function custom_modifier_arcane_blink:GetModifierBonusStats_Intellect()
    return self.int_bonus
end

function custom_modifier_arcane_blink:OnAbilityFullyCast( event )
    if event.unit == self:GetParent() and not event.ability:IsItem() then
        local item = self:GetAbility()
        item:StartCooldown(item:GetCooldownTimeRemaining() - self.cdr)
    end
end