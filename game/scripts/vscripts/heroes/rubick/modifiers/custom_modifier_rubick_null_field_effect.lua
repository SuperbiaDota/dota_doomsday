
custom_modifier_rubick_null_field_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_rubick_null_field_effect:IsHidden()
	return false
end

function custom_modifier_rubick_null_field_effect:IsDebuff()
	return false
end

function custom_modifier_rubick_null_field_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_rubick_null_field_effect:OnCreated( kv )
    self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
end

function custom_modifier_rubick_null_field_effect:OnRefresh( kv )
	self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
end

function custom_modifier_rubick_null_field_effect:OnRemoved()
end

function custom_modifier_rubick_null_field_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_rubick_null_field_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function custom_modifier_rubick_null_field_effect:GetModifierMagicalResistanceBonus()
    return self.magic_resist
end