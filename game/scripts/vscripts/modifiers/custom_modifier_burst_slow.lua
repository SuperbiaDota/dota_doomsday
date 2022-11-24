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
custom_modifier_burst_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_burst_slow:IsHidden()
	return false
end

function custom_modifier_burst_slow:IsDebuff()
	return true
end

function custom_modifier_burst_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_burst_slow:OnCreated( kv )
	-- references
	self.duration = kv.duration
	self.decay_duration = self:GetAbility():GetSpecialValueFor( "decay_duration" )
	self.slow_pct = self:GetAbility():GetSpecialValueFor( "base_slow_pct" )	
end

function custom_modifier_burst_slow:OnRefresh( kv )
	
end

function custom_modifier_burst_slow:OnRemoved()
end

function custom_modifier_burst_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_burst_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function custom_modifier_burst_slow:GetModifierPercentageCasttime()
	return -self.slow_pct;
end

function custom_modifier_burst_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow_pct
end

function custom_modifier_burst_slow:GetModifierAttackSpeedPercentage()
	return -self.slow_pct
end

function custom_modifier_burst_slow:GetModifierTurnRate_Percentage()
	return -self.slow_pct
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_burst_slow:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_burst_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_burst_slow:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_burst_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_burst_slow:PlayEffects()
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