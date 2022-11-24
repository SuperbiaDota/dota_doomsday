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
custom_modifier_burst_recoil = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_burst_recoil:IsHidden()
	return false
end

function custom_modifier_burst_recoil:IsDebuff()
	return true
end

function custom_modifier_burst_recoil:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_burst_recoil:OnCreated( kv )
	-- references
	self.self_slow = self:GetAbility():GetSpecialValueFor( "self_slow_pct" )

end

function custom_modifier_burst_recoil:OnRefresh( kv )
	
end

function custom_modifier_burst_recoil:OnRemoved()
end

function custom_modifier_burst_recoil:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_burst_recoil:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function custom_modifier_burst_recoil:GetModifierMoveSpeedReductionPercentage()
	return -self.self_slow
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_burst_recoil:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_burst_recoil:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_burst_recoil:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_burst_recoil:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_burst_recoil:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_burst_recoil:PlayEffects()
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