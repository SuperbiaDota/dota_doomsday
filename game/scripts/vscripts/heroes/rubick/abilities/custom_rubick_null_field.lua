
custom_rubick_null_field = class({})
--custom_rubick_null_field.attack_projectiles = {}

LinkLuaModifier( "custom_modifier_rubick_null_field", 
    "heroes/rubick/modifiers/custom_modifier_rubick_null_field", 
    LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "custom_modifier_rubick_null_field_effect", 
    "heroes/rubick/modifiers/custom_modifier_rubick_null_field_effect", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_rubick_null_field:GetIntrinsicModifierName()
	return "custom_modifier_rubick_null_field"
end

--------------------------------------------------------------------------------
-- Custom KV

-- AOE Radius
function custom_rubick_null_field:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start

function custom_rubick_null_field:OnAbilityPhaseInterrupted()
end

function custom_rubick_null_field:OnAbilityPhaseStart()
    self:PlayEffects()
    return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_rubick_null_field:OnSpellStart()
    local caster = self:GetCaster()

    ParticleManager:ReleaseParticleIndex( self.effect_cast )
    
    if IsServer() then
        local allied_heroes = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            self:GetAOERadius(),
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO,
            0,
            0,
            false
        )

        for _, hero in pairs(allied_heroes) do
            ProjectileManager:ProjectileDodge(hero)
        end
    end
end

--------------------------------------------------------------------------------
-- Effects
function custom_rubick_null_field:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/heroes/rubick/rubick_null_field_distortion_bubble.vpcf"

	-- Get Data

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	--ParticleManager:SetParticleControl( effect_cast, 9, vControlVector )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		9,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	
end
