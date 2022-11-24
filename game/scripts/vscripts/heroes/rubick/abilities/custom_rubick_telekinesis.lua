-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
custom_rubick_telekinesis = class({})
LinkLuaModifier( "custom_modifier_rubick_telekinesis", 
    "heroes/modifiers/custom_modifier_rubick_telekinesis", 
    LUA_MODIFIER_MOTION_BOTH 
)
LinkLuaModifier( "modifier_generic_stunned_lua", 
    "generic/modifier_generic_stunned_lua", 
    LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Init Abilities
function custom_rubick_telekinesis:Precache( context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_custom_rubick_telekinesis.vsndevts", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_custom_rubick_telekinesis/custom_rubick_telekinesis.vpcf", context )
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_rubick_telekinesis:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "lift_duration" )

	-- logic
    target:AddNewModifier(
        caster,
        self,
        "custom_modifier_rubick_telekinesis"
        {duration = duration}
    )
end
--------------------------------------------------------------------------------
-- Projectile
function custom_rubick_telekinesis:OnProjectileHit( target, location )
end

--------------------------------------------------------------------------------
-- Effects
function custom_rubick_telekinesis:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
-- Ability Channeling
function custom_rubick_telekinesis:GetChannelTime()

end

function custom_rubick_telekinesis:OnChannelFinish( bInterrupted )

end

--------------------------------------------------------------------------------
-- Hero Events
function custom_rubick_telekinesis:OnOwnerSpawned()

end

function custom_rubick_telekinesis:OnOwnerDied()

end

function custom_rubick_telekinesis:OnHeroLevelUp()

end

function custom_rubick_telekinesis:OnHeroCalculateStatBonus()

end

--------------------------------------------------------------------------------
-- Ability Events
function custom_rubick_telekinesis:OnUpgrade()

end

--------------------------------------------------------------------------------
-- Item Events
function custom_rubick_telekinesis:OnInventoryContentsChanged()

end

function custom_rubick_telekinesis:OnItemEquipped( item )

end

--------------------------------------------------------------------------------
-- Other Events
function custom_rubick_telekinesis:OnHeroDiedNearby( unit, attacker, data )

end