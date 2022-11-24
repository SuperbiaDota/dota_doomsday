custom_modifier_ethereal_blade_slow = class({})

function custom_modifier_ethereal_blade_slow:IsHidden()
    return false 
end

function custom_modifier_ethereal_blade_slow:IsDebuff()
    return true 
end

function custom_modifier_ethereal_blade_slow:IsPurgable() 
    return true 
end

function custom_modifier_ethereal_blade_slow:OnCreated( kv )
    self.ms_slow = kv.ms_slow
    self.magic_reduce = kv.magic_reduce

    --self.damage_percent = (100 + kv.magic_reduce) / 100

    --self:GetParent():AddNewModifier(
    --    self:GetParent(),
    --    self:GetAbility(),
    --    "modifier_generic_damage_modification",
    --    {
    --        priority = 0,
    --        damage_type = DAMAGE_TYPE_MAGICAL,
    --        callback = "percent"
    --    }
    --)
end

function custom_modifier_ethereal_blade_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function custom_modifier_ethereal_blade_slow:GetModifierMagicalResistanceBonus()
    return self.magic_reduce
end

function custom_modifier_ethereal_blade_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow
end