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
custom_modifier_troll_warlord_berserkers_rage = class({})

LinkLuaModifier(
	"custom_modifier_bash_grace",
	"scripts/vscripts/modifiers/custom_modifier_bash_grace.lua",
	LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_troll_warlord_berserkers_rage:IsHidden()
	return true
end

function custom_modifier_troll_warlord_berserkers_rage:IsDebuff()
	return false
end

function custom_modifier_troll_warlord_berserkers_rage:IsPurgable()
	return false
end

function custom_modifier_troll_warlord_berserkers_rage:RemoveOnDeath()
	return false
end

function custom_modifier_troll_warlord_berserkers_rage:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_troll_warlord_berserkers_rage:OnCreated( kv )
	-- references
	self.bat_override = self:GetAbility():GetSpecialValueFor( "bat" ) -- special value
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "movespeed_bonus" ) -- special value
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "armor_bonus" ) -- special value
	self.melee_range = 150

	self.bash_chance = self:GetAbility():GetSpecialValueFor( "bash_chance" ) -- special value
	self.bash_damage = self:GetAbility():GetSpecialValueFor( "bash_damage" ) -- special value
	self.bash_duration = self:GetAbility():GetSpecialValueFor( "bash_duration" ) -- special value

	-- Save previous states
	self.pre_attack_capability = self:GetParent():GetAttackCapability()
	self.delta_attack_range = self.melee_range - self:GetParent():GetAttackRange()
	self.delta_bat = self.bat_override - self:GetBaseAttackTime()

	-- set attack compatibility
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
end

function custom_modifier_troll_warlord_berserkers_rage:OnRefresh( kv )
	-- references
	self.bat_override = self:GetAbility():GetSpecialValueFor( "base_attack_time" ) -- special value
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" ) -- special value
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" ) -- special value
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) -- special value

	self.bash_chance = self:GetAbility():GetSpecialValueFor( "bash_chance" ) -- special value
	self.bash_damage = self:GetAbility():GetSpecialValueFor( "bash_damage" ) -- special value
	self.bash_duration = self:GetAbility():GetSpecialValueFor( "bash_duration" ) -- special value
end

function custom_modifier_troll_warlord_berserkers_rage:OnDestroy()
	self:GetParent():SetAttackCapability( self.pre_attack_capability )
end


--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_troll_warlord_berserkers_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}

	return funcs
end

function custom_modifier_troll_warlord_berserkers_rage:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() then
		if RollPseudoRandomPercentage(self.bash_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_generic_stunned_lua"
				{
					duration = self.bash_duration
				}
			)
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"custom_modifier_bash_grace"
				{
					duration = self.bash_duration -- TODO: change how this works
				}
			)
			return self.bash_damage
		end
	end
end

function custom_modifier_troll_warlord_berserkers_rage:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_move_speed
end

function custom_modifier_troll_warlord_berserkers_rage:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function custom_modifier_troll_warlord_berserkers_rage:GetModifierBaseAttackTimeConstant()
	return -self.delta_bat
end

function custom_modifier_troll_warlord_berserkers_rage:GetModifierAttackRangeBonus() -- TODO: test with broom handle
	return self.self.delta_attack_range
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_troll_warlord_berserkers_rage:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_troll_warlord_berserkers_rage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_troll_warlord_berserkers_rage:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_troll_warlord_berserkers_rage:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_troll_warlord_berserkers_rage:PlayEffects()
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