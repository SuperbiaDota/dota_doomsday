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
custom_omniknight_purification = class({})

-- AOE Radius
function custom_omniknight_purification:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_omniknight_purification:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    -- load data
    local heal = self:GetSpecialValueFor("heal_damage")
    local radius = self:GetSpecialValueFor("radius")

    -- heal
    target:Heal( heal, self )

    -- Find Units in Radius
    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),   -- int, your team number
        target:GetOrigin(), -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        0,  -- int, flag filter
        0,  -- int, order filter
        false   -- bool, can grow cache
    )

    -- Apply Damage  
    local damageTable = {
        attacker = caster,
        damage = heal,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self, --Optional.
    }
    for _,enemy in pairs(enemies) do
        damageTable.victim = enemy
        ApplyDamage(damageTable)
        self:PlayEffects2( target, enemy )
    end

    self:PlayEffects1( target, radius )
end

--------------------------------------------------------------------------------
function custom_omniknight_purification:PlayEffects1( target, radius )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
    local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
    local sound_target = "Hero_Omniknight.Purification"

    -- Create Target Effects
    local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
    ParticleManager:ReleaseParticleIndex( effect_target )
    EmitSoundOn( sound_target, target )

    -- Create Caster Effects
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        self:GetCaster():GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

function custom_omniknight_purification:PlayEffects2( origin, target )
    local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
    local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_target,
        0,
        origin,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        origin:GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
        effect_target,
        1,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        target:GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_target )
end