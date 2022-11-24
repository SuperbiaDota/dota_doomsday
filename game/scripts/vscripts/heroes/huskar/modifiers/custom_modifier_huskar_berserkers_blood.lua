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
custom_modifier_huskar_berserkers_blood = class({})

-- TODO: make the "break-even" health pct the same at all levels

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_berserkers_blood:IsHidden()
	return true
end

function custom_modifier_huskar_berserkers_blood:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_berserkers_blood:OnCreated( kv )
	-- references
	local ability = self:GetAbility()
	self.min_heal_amp = ability:GetSpecialValueFor( "min_heal_amp")
	self.max_heal_amp = ability:GetSpecialValueFor( "max_heal_amp")
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_huskar_berserkers_blood:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function custom_modifier_huskar_berserkers_blood:GetModifierHealAmplify_PercentageTarget()
	local range = self.max_heal_amp - self.min_heal_amp
	return self.min_heal_amp + range * self:GetEffectsPercent()
end

function custom_modifier_huskar_berserkers_blood:GetModifierHPRegenAmplify_Percentage()
	local range = self.max_heal_amp - self.min_heal_amp
	return self.min_heal_amp + range * self:GetEffectsPercent()
end

function custom_modifier_huskar_berserkers_blood:GetModifierLifestealRegenAmplify_Percentage()
	local range = self.max_heal_amp - self.min_heal_amp
	return self.min_heal_amp + range * self:GetEffectsPercent()
end

function custom_modifier_huskar_berserkers_blood:GetModifierSpellLifestealRegenAmplify_Percentage()
	local range = self.max_heal_amp - self.min_heal_amp
	return self.min_heal_amp + range * self:GetEffectsPercent()
end

--------------------------------------------------------------------------------
-- Helper
function custom_modifier_huskar_berserkers_blood:GetEffectsPercent()
	local parent = self:GetParent()
	return (1 - parent:GetHealth() / parent:GetMaxHealth())
	--return math.min( 1, 1 - (health_pct - self.min_health) / (100 - self.min_health) )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_berserkers_blood:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_huskar_berserkers_blood:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_huskar_berserkers_blood:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_huskar_berserkers_blood:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_huskar_berserkers_blood:PlayEffects()
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