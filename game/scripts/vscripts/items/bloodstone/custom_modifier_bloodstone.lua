custom_modifier_bloodstone = class({})

function custom_modifier_bloodstone:IsHidden()
    return true 
end

function custom_modifier_bloodstone:IsPurgable() 
    return false 
end

function custom_modifier_bloodstone:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE
end

function custom_modifier_bloodstone:RemoveOnDeath() 
    return false
end

-- TODO: status resistance wrapper

function custom_modifier_bloodstone:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
    self.mana_bonus = self:GetAbility():GetSpecialValueFor("mana_bonus")
    self.spell_amp_pct = self:GetAbility():GetSpecialValueFor("spell_amp_pct")
    self.int_bonus = self:GetAbility():GetSpecialValueFor("int_bonus")
    self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
    self.spell_amp_pct_per_charge = self:GetAbility():GetSpecialValueFor("spell_amp_pct_per_charge")
    self.mana_regen_per_charge = self:GetAbility():GetSpecialValueFor("mana_regen_per_charge")
end

function custom_modifier_bloodstone:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
       MODIFIER_PROPERTY_EXTRA_MANA_BONUS ,
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
       MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
       MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function custom_modifier_bloodstone:GetModifierExtraHealthBonus()
    return self.health_bonus
end

function custom_modifier_bloodstone:GetModifierExtraManaBonus()
    return self.mana_bonus
end

function custom_modifier_bloodstone:GetModifierSpellAmplify_Percentage()
    return self.spell_amp_pct + self.spell_amp_pct_per_charge * self:GetAbility():GetCurrentCharges()
end

function custom_modifier_bloodstone:GetModifierBonusStats_Intellect()
    return self.int_bonus
end

function custom_modifier_bloodstone:GetModifierConstantManaRegen()
    return self.mana_regen + self.mana_regen_per_charge * self:GetAbility():GetCurrentCharges()
end