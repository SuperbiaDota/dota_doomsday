modifier_custom_arc_warden_tempest_double = class({})

function modifier_custom_arc_warden_tempest_double:DeclareFunctions()
	return {
	}
end

function modifier_custom_arc_warden_tempest_double:GetStatusEffectName()
	return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_custom_arc_warden_tempest_double:IsHidden()
	return true
end

function modifier_custom_arc_warden_tempest_double:IsPurgable()
	return false
end

function modifier_custom_arc_warden_tempest_double:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
