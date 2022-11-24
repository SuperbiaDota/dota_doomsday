custom_lifestealer_open_wounds = class({})
LinkLuaModifier( "custom_modifier_lifestealer_open_wounds", "heroes/lifestealer/modifiers/custom_modifier_lifestealer_open_wounds", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function custom_lifestealer_open_wounds:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor("duration")

	-- apply modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"custom_modifier_lifestealer_open_wounds", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	local sound_cast = "Hero_LifeStealer.OpenWounds.Cast"
	local sound_target = "Hero_LifeStealer.OpenWounds"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( sound_target, target )
end