custom_modifier_silver_edge = class({})

function custom_modifier_silver_edge:IsHidden()
    return true
end

function custom_modifier_silver_edge:IsPurgable() 
    return false 
end

function custom_modifier_silver_edge:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_silver_edge:RemoveOnDeath() 
    return false 
end

function custom_modifier_silver_edge:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.chance = self:GetAbility():GetSpecialValueFor("crit_chance")
    self.crit = self:GetAbility():GetSpecialValueFor("crit_multiplier")
end

function custom_modifier_silver_edge:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
    return funcs
end

function custom_modifier_silver_edge:GetModifierPreAttack_BonusDamage()
    return self.damage
end

function custom_modifier_silver_edge:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

function custom_modifier_silver_edge:GetModifierPreAttack_CriticalStrike( event )
    if RollPercentage(self.chance) then
        return self.crit
    end
end