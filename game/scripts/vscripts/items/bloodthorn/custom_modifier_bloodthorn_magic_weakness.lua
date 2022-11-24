custom_modifier_bloodthorn_magic_weakness = class({})

function custom_modifier_bloodthorn_magic_weakness:IsHidden()
    return false
end

function custom_modifier_bloodthorn_magic_weakness:IsDebuff()
    return true
end

function custom_modifier_bloodthorn_magic_weakness:IsPurgable()
    return true
end

function custom_modifier_bloodthorn_magic_weakness:OnCreated()
    self.magic_resist_pct = self:GetAbility():GetSpecialValueFor("magic_weakness_pct")
end

function custom_modifier_bloodthorn_magic_weakness:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function custom_modifier_bloodthorn_magic_weakness:GetModifierMagicalResistanceBonus()
    return -self.magic_resist_pct
end