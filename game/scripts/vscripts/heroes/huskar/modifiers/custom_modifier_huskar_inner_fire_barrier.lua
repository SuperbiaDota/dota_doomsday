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
custom_modifier_huskar_inner_fire_barrier = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_inner_fire_barrier:IsHidden()
	return false
end

function custom_modifier_huskar_inner_fire_barrier:IsDebuff()
	return false
end

function custom_modifier_huskar_inner_fire_barrier:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_inner_fire_barrier:OnCreated( kv )
	-- references
	self.barrier_health = self:GetAbility():GetSpecialValueFor( "magic_sheild" )
end

function custom_modifier_huskar_inner_fire_barrier:OnRefresh( kv )
	
end

function custom_modifier_huskar_inner_fire_barrier:OnRemoved()
end

function custom_modifier_huskar_inner_fire_barrier:OnDestroy()
end


--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_huskar_inner_fire_barrier:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE ,
	}

	return funcs
end

function custom_modifier_huskar_inner_fire_barrier:OnTakeDamage( params )

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_inner_fire_barrier:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_huskar_inner_fire_barrier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_huskar_inner_fire_barrier:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_huskar_inner_fire_barrier:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_huskar_inner_fire_barrier:PlayEffects()
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