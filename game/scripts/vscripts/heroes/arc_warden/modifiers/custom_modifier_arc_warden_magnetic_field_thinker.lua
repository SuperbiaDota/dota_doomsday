
LinkLuaModifier( "custom_modifier_arc_warden_magnetic_field_aura", "heroes/arc_warden/modifiers/custom_modifier_arc_warden_magnetic_field_thinker.lua",LUA_MODIFIER_MOTION_NONE )

custom_modifier_arc_warden_magnetic_field_thinker = class({})

function arc_warden_magnetic_field_thinker:OnCreated(event)
	local thinker = self:GetParent()
	local ability = self:GetAbility()
	self.thinker_ability = thinker:AddAbility(ability:GetAbilityName())
	self.thinker_ability:SetLevel(ability:GetLevel())
	
	thinker:AddNewModifier(
		thinker, -- player source
		thinker_ability, -- ability source
		"custom_modifier_arc_warden_magnetic_field_aura", -- modifier name
		{
			team_number = thinker:GetTeamNumber(),
			radius = thinker_ability:GetSpecialValueFor("radius")
		} -- kv
	)
end

------------------------------------------------------------------------

custom_modifier_arc_warden_magnetic_field_aura = class({})

function custom_modifier_arc_warden_magnetic_field_aura:OnCreated(event)
	self.team_number = event.team_number
	self.radius = event.radius
end


function custom_modifier_arc_warden_magnetic_field_aura:IsAura()
	return true
end

function custom_modifier_arc_warden_magnetic_field_aura:GetAuraRadius()
	return self.radius
end

function custom_modifier_arc_warden_magnetic_field_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function custom_modifier_arc_warden_magnetic_field_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO
end

function custom_modifier_arc_warden_magnetic_field_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function custom_modifier_arc_warden_magnetic_field_aura:GetModifierAura()
	return "custom_modifier_arc_warden_magnetic_field"
end
