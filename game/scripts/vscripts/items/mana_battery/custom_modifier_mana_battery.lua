custom_modifier_mana_battery = class({})

function custom_modifier_mana_battery:IsHidden()
    return true 
end

function custom_modifier_mana_battery:IsPurgable() 
    return false 
end

function custom_modifier_mana_battery:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE
end

function custom_modifier_mana_battery:RemoveOnDeath() 
    return false 
end

function custom_modifier_mana_battery:OnCreated(kv)
    self.mana_bonus = self:GetAbility():GetSpecialValueFor("custom_modifier_mana_battery")
    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
    self.mana_loss_reduction_pct = self:GetAbility():GetSpecialValueFor("mana_loss_reduction_pct")
end

function custom_modifier_mana_battery:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT ,
        MODIFIER_PROPERTY_MANA_DRAIN_AMPLIFY_PERCENTAGE 
    }
end

function custom_modifier_mana_battery:GetModifierExtraManaBonus()
    return self.mana_bonus
end

function custom_modifier_mana_battery:GetModifierConstantHealthRegen()
    return self.health_regen
end

function custom_modifier_mana_battery:GetModifierManaDrainAmplify_Percentage() -- TODO: test
    return -self.mana_loss_reduction_pct
end