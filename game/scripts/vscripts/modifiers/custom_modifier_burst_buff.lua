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
custom_modifier_burst_buff = class({})

LinkLuaModifier(
	"custom_modifier_burst_recoil",
	"modifiers/custom_modifier_burst_recoil.lua",
	LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
	"custom_modifier_burst_slow",
	"modifiers/custom_modifier_burst_slow.lua",
	LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_burst_buff:IsHidden()
	return false
end

function custom_modifier_burst_buff:IsDebuff()
	return false
end

function custom_modifier_burst_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_burst_buff:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.recoil_duration = self:GetAbility():GetSpecialValueFor("recoil_duration")

    self:GetCaster():AddNewModifier(
        self:GetCaster(),
        self:GetAbility(),
        "modifier_generic_damage_modification",
        {
            priority = 0,
            damage_type = DAMAGE_TYPE_ALL,
            hmod = self,
            callback = "no_damage"
        }
    )
end

function custom_modifier_burst_buff:OnRefresh( kv )
	
end

function custom_modifier_burst_buff:OnRemoved()
end

function custom_modifier_burst_buff:OnDestroy()
	if not IsServer() then return end

	local caster = self:GetCaster()

	caster:AddNewModifier(
        caster, -- player source
        self:GetAbility(), -- ability source
        "custom_modifier_burst_recoil", -- modifier name
        { duration = self.recoil_duration } -- kv
    )

	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_burst_buff:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_burst_buff:CheckState()
	local state = {
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function custom_modifier_burst_buff:IsAura()
	return true
end

function custom_modifier_burst_buff:GetModifierAura()
	return "custom_modifier_burst_slow"
end

function custom_modifier_burst_buff:GetAuraRadius()
	return self.radius
end

function custom_modifier_burst_buff:GetAuraDuration()
	local caster = self:GetCaster()
	local intel = caster:GetIntellect()
	return self:GetAbility():GetSpecialValueFor("base_linger") + intel * self:GetAbility():GetSpecialValueFor( "int_multiplier" )
end

function custom_modifier_burst_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function custom_modifier_burst_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function custom_modifier_burst_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function custom_modifier_burst_buff:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_burst_buff:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_burst_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_burst_buff:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_burst_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_burst_buff:PlayEffects()
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
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end