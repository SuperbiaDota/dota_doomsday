item_custom_flicker = class({})

LinkLuaModifier(
	"custom_modifier_flicker",
	"items/flicker/custom_modifier_flicker",
	LUA_MODIFIER_MOTION_NONE
)

function item_custom_flicker:OnSpellStart()
	local caster = self:GetCaster()

	ProjectileManager:ProjectileDodge(caster)
	caster:Purge(false, true, false, false, false)

	-- TODO: figure out what these modifiers do
	caster:AddNewModifier(
		caster,
		self,
		"modifier_invulnerable",
		{duration = self:GetSpecialValueFor("invuln_duration")})
	)

	caster:AddNewModifier(
		caster,
		self,
		"modifier_manta_phase",
		{duration = self:GetSpecialValueFor("invuln_duration")}
	)
end