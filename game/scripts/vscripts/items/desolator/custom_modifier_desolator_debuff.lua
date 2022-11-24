custom_modifier_desolator_2_debuff = class({})

function custom_modifier_desolator_2_debuff:IsHidden() 
    return false 
end

function custom_modifier_desolator_2_debuff:IsDebuff() 
    return true 
end

function custom_modifier_desolator_2_debuff:IsPurgable() 
    return true 
end

function custom_modifier_desolator_2_debuff:RemoveOnDeath() 
    return true 
end

function custom_modifier_desolator_2_debuff:OnCreated()
    self.armor_corruption = self:GetAbility():GetSpecialValueFor("armor_corruption")
end

function custom_modifier_desolator_2_debuff:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
    return funcs
end

function custom_modifier_desolator_2_debuff:GetModifierPhysicalArmorBonus()
    return self.armor_corruption
end