custom_modifier_octarine_core = class({})

function custom_modifier_octarine_core:IsHidden()
    return true 
end

function custom_modifier_octarine_core:IsPurgable() 
    return false 
end

function custom_modifier_octarine_core:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE
end

function custom_modifier_octarine_core:RemoveOnDeath() 
    return false 
end

function custom_modifier_octarine_core:OnCreated()
    self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
    self.mana_bonus = self:GetAbility():GetSpecialValueFor("mana_bonus")
    self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
    self.mana_loss_reduction_pct = self:GetAbility():GetSpecialValueFor("mana_loss_reduction_pct")
    self.cooldown_reduction_pct = self:GetAbility():GetSpecialValueFor("cooldown_reduction_pct")
end

function custom_modifier_octarine_core:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT ,
        MODIFIER_PROPERTY_MANA_DRAIN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end

function custom_modifier_octarine_core:GetModifierExtraHealthBonus()
    return self.health_bonus
end

function custom_modifier_octarine_core:GetModifierExtraManaBonus()
    return self.mana_bonus
end

function custom_modifier_octarine_core:GetModifierConstantHealthRegen()
    return self.health_regen
end

function custom_modifier_octarine_core:GetModifierManaDrainAmplify_Percentage() -- TODO: test
    return -self.mana_loss_reduction_pct
end

function custom_modifier_octarine_core:GetModifierPercentageCooldown()
    return 100 - self.cooldown_reduction_pct
end