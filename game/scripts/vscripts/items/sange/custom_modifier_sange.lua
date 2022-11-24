custom_modifier_sange = class({})

function custom_modifier_sange:IsHidden()
    return true 
end

function custom_modifier_sange:IsPurgable() 
    return false 
end

function custom_modifier_sange:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE
end

function custom_modifier_sange:RemoveOnDeath() 
    return false 
end

-- TODO: status resistance wrapper

function custom_modifier_sange:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.str_bonus = self:GetAbility():GetSpecialValueFor("str_bonus")
    self.damage = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.status_resist_pct = self:GetAbility():GetSpecialValueFor("status_resist_pct")
end

function custom_modifier_sange:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       MODIFIER_PROPERTY_STATUS_RESISTANCE,
    }
end

function custom_modifier_sange:GetModifierPreAttack_BonusDamage()
    return self.damage
end

function custom_modifier_sange:GetModifierBonusStats_Strength()
    return self.str_bonus
end

function custom_modifier_sange:GetModifierStatusResistance()
    return self.status_resist_pct
end