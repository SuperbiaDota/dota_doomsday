custom_modifier_flicker = class({})

function custom_modifier_flicker:IsHidden()
    return true
end

function custom_modifier_flicker:IsPurgable() 
    return false 
end

function custom_modifier_flicker:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_flicker:RemoveOnDeath() 
    return false 
end

function custom_modifier_flicker:OnCreated()
    self.str_bonus = self:GetAbility():GetSpecialValueFor("str_bonus")
    self.agi_bonus = self:GetAbility():GetSpecialValueFor("agi_bonus")
    self.int_bonus = self:GetAbility():GetSpecialValueFor("int_bonus")
    self.ms_bonus_pct = self:GetAbility():GetSpecialValueFor("ms_bonus_pct")
    self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
end

function custom_modifier_flicker:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function custom_modifier_flicker:GetModifierBonusStats_Strength()
    return self.str_bonus
end

function custom_modifier_flicker:GetModifierBonusStats_Agility()
    return self.agi_bonus
end

function custom_modifier_flicker:GetModifierBonusStats_Intellect()
    return self.int_bonus
end

function custom_modifier_flicker:GetModifierMoveSpeedBonus_Percentage_Unique()
    return self.ms_bonus_pct
end

function custom_modifier_flicker:GetModifierAttackSpeedBonus_Constant()
    return self.as_bonus
end