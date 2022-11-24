
custom_modifier_kaya = class({})

function custom_modifier_kaya:IsHidden() return true end
function custom_modifier_kaya:IsPurgable() return false end
function custom_modifier_kaya:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function custom_modifier_kaya:RemoveOnDeath() return false end

function custom_modifier_kaya:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.int_bonus = self:GetAbility():GetSpecialValueFor("int_bonus")
    self.spell_amp_pct = self:GetAbility():GetSpecialValueFor("spell_amp_pct")
    self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")

function custom_modifier_kaya:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE ,
       MODIFIER_PROPERTY_MANA_REGEN_CONSTANT     
    }
end

function custom_modifier_kaya:GetModifierBonusStats_Intellect()
    return self.int_bonus
end

function custom_modifier_kaya:GetModifierSpellAmplify_Percentage()
    return self.spell_amp_pct
end

function custom_modifier_kaya:GetModifierConstantManaRegen()
    return self.mana_regen
end
