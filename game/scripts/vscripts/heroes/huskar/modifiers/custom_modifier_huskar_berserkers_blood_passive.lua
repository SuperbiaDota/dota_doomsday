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
custom_modifier_huskar_berserkers_blood_passive = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_berserkers_blood_passive:IsHidden()
	return true
end

function custom_modifier_huskar_berserkers_blood_passive:IsDebuff()
	return false
end

function custom_modifier_huskar_berserkers_blood_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_berserkers_blood_passive:OnCreated( kv )
	self.max_bonus_armor = self:GetAbility():GetSpecialValueFor("max_bonus_armor")
    self.max_atk_speed = self:GetAbility():GetSpecialValueFor( "max_atk_speed" )
end

function custom_modifier_huskar_berserkers_blood_passive:OnRefresh( kv )
    self.max_bonus_armor = self:GetAbility():GetSpecialValueFor("max_bonus_armor")
    self.max_atk_speed = self:GetAbility():GetSpecialValueFor( "max_atk_speed" )
end

function custom_modifier_huskar_berserkers_blood_passive:OnRemoved()
end

function custom_modifier_huskar_berserkers_blood_passive:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_huskar_berserkers_blood_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function custom_modifier_huskar_berserkers_blood_passive:GetModifierPhysicalArmorBonus()
	return self.max_bonus_armor * (1 - parent:GetHealth() / parent:GetMaxHealth())
end

function custom_modifier_huskar_berserkers_blood_passive:GetModifierAttackSpeedBonus_Constant()
    local parent = self:GetParent()
    return self.max_atk_speed * (1 - parent:GetHealth() / parent:GetMaxHealth())
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_berserkers_blood_passive:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_huskar_berserkers_blood_passive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_huskar_berserkers_blood_passive:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_huskar_berserkers_blood_passive:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_huskar_berserkers_blood_passive:PlayEffects()
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