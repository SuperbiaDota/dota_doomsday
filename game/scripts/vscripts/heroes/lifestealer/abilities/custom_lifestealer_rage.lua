custom_lifestealer_rage = class({})
LinkLuaModifier( "custom_modifier_lifestealer_rage", "heroes/lifestealer/modifiers/custom_modifier_lifestealer_rage", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

function custom_lifestealer_rage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

	-- dispel
	caster:Purge( false, true, false, false, false )

	-- apply modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"custom_modifier_lifestealer_rage", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	local sound_cast = "Hero_LifeStealer.Rage"
	EmitSoundOn( sound_cast, caster )
end