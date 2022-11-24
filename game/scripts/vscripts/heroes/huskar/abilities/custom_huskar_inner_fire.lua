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
custom_huskar_inner_fire = class({})
LinkLuaModifier( "modifier_generic_knockback_lua", 
	"generic/modifier_generic_knockback_lua", 
	LUA_MODIFIER_MOTION_HORIZONTAL 
)
LinkLuaModifier( "modifier_generic_barrier_shared",
	"generic/modifier_generic_barrier_shared",
	LUA_MODIFIER_MOTION_NONE
)
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Ability Start
function custom_huskar_inner_fire:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- grant magic shield
	local ability_index = tempTable:AddATValue( self )
	caster:AddNewModifier(
		caster,
		self,
		"modifier_generic_barrier_shared",
		{ 
			duration = self:GetSpecialValueFor("shield_duration"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			block = self:GetSpecialValueFor("magic_shield"),
			ability_index = ability_index
		}
	)

    local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

	-- search for targets
    local targets = FindUnitsInRadius(
        	caster:GetTeamNumber(), -- int, your team number
        	caster:GetOrigin(), -- point, center point
        	nil, -- handle, cacheUnit. (not known)
        	self:GetSpecialValueFor("radius"), -- float, radius. or use FIND_UNITS_EVERYWHERE
        	DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
        	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        	0, -- int, flag filter
        	1, -- int, order filter
        	false -- bool, can grow cache
        )

    for _, enemy in pairs(targets) do
    	local direction = enemy:GetOrigin() - caster:GetOrigin()
    	local distance = self:GetSpecialValueFor("knockback_distance") - direction:Length2D() -- doesn't need to be normalized
    	enemy:AddNewModifier(	
    		caster,
    		self,
    		"modifier_generic_knockback_lua",
    		{	
    			distance = distance,
    			duration = self:GetSpecialValueFor("knockback_duration"),
    			direction_x = direction.x,
    			direction_y = direction.y,
    			IsStun = true,
    			DestroyTreesContinuous = true
    		}
    	)
    	damageTable.victim = enemy
    	ApplyDamage(damageTable)
    end
end

--------------------------------------------------------------------------------
-- Effects
function custom_huskar_inner_fire:PlayEffects()
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
