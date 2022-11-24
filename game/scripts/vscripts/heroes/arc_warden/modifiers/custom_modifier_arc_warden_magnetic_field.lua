

custom_modifier_arc_warden_magnetic_field = class({})

function custom_modifier_arc_warden_magnetic_field:IsBuff()
	return true
end

function custom_modifier_arc_warden_magnetic_field:OnCreated( event )
	local ability = self:GetAbility()
	self.evasion = ability:GetSpecialValueFor("evasion")
	self.as = ability:GetSpecialValueFor("bonus_attack_speed")
end

function custom_modifier_arc_warden_magnetic_field:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function custom_modifier_arc_warden_magnetic_field:GetModifierEvasion_Constant()
	return self.evasion
end

function custom_modifier_arc_warden_magnetic_field:GetModifierAttackSpeedBonus_Constant()
	return self.as
end