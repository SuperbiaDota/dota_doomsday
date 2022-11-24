LinkLuaModifier( "custom_modifier_arc_warden_magnetic_field_thinker", "heroes/arc_warden/modifiers/custom_modifier_arc_warden_magnetic_field_thinker.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "custom_modifier_arc_warden_magnetic_field", "heroes/arc_warden/modifiers/custom_modifier_arc_warden_magnetic_field.lua",LUA_MODIFIER_MOTION_NONE )

arc_warden_magnetic_field = class({})

function arc_warden_magnetic_field:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()
	local team_id = caster:GetTeamNumber()
	local duration = self:GetSpecialValueFor("field_duration")
	local thinker = CreateModifierThinker(
		caster, 
		self, 
		"custom_modfiier_arc_warden_magnetic_field_thinker", 
		{["duration"] = duration}, 
		point, 
		team_id, 
		false
	)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_ABSORIGIN, thinker)
	local radius = self:GetSpecialValueFor("radius")
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(duration, duration, duration))
end

function arc_warden_magnetic_field:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end