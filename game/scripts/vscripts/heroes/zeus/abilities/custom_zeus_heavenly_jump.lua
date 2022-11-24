-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Spell Immune/Invulnerable/Invisible behavior
- Stolen behavior
]]

--------------------------------------------------------------------------------
custom_zeus_heavenly_jump = class({})
LinkLuaModifier("custom_modifier_zeus_heavenly_jump", "abilities/zeus/modifiers/custom_zeus_heavenly_jump.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("custom_modifier_zeus_heavenly_jump_slow", "abilities/zeus/modifiers/custom_modifier_zeus_heavenly_jump.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_arc_lua", "abilities/generic/modifier_generic_arc_lua.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Init Abilities
function custom_zeus_heavenly_jump:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_template.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_template/template.vpcf", context )
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_zeus_heavenly_jump:OnSpellStart()

	-- load data

    local caster = self:GetCaster()

    local vision_range    = self:GetSpecialValueFor( "vision_radius" )
    local vision_duration = self:GetSpecialValueFor( "vision_duration" )
    local hop_height      = self:GetSpecialValueFor( "hop_height" )
    local hop_distance    = self:GetSpecialValueFor( "hop_distance" )
    local hop_duration    = self:GetSpecialValueFor( "hop_duration" )
    local hop_speed       = hop_distance / hop_duration

    local debuff_duration = self:GetSpecialValueFor( "duration" )
    local move_slow       = self:GetSpecialValueFor( "move_slow" )
    local aspd_slow       = self:GetSpecialValueFor( "aspd_slow" )
    local delay           = self:GetSpecialValueFor( "zap_delay" )
    local range           = self:GetLevelSpecialValueFor( "range", (ability:GetLevel()-1) )
    local damage          = self:GetAbilityDamage()

	-- logic

    AddFOWViewer( caster:GetTeamNumber(), caster:GetOrigin(), vision_range, vision_duration, false )

    if caster:IsMoving then
        caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_generic_arc_lua", -- modifier name
            {
                distance = hop_distance,
                speed = hop_speed,
                height = hop_height,
                fix_end = false,
                isForward = true,
            } -- kv
        )
    else
        caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_generic_arc_lua", -- modifier name
            {
                distance = 0,
                speed = hop_speed,
                height = hop_height,
                fix_end = false,
                isForward = true,
            } -- kv
        )
    end

    local mod = caster:AddNewModifier(
        caster,
        self, 
        "custom_modifier_zeus_heavenly_jump",
        {
            point = caster:GetAbsOrigin()
            range = range
            all_heroes = caster:HasTalent("custom_zeus_special_bonus_unique_3")

            damage = damage
            debuff_duration = debuff_duration
            move_slow = move_slow
            aspd_slow = aspd_slow
        }
    )

    mod:StartIntervalThink(delay)

    self:PlayEffects()

end

--------------------------------------------------------------------------------
-- Effects
function custom_zeus_heavenly_jump:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_zuus/zuus_heavenly_jump.vpcf"
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

