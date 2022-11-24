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
custom_meepo_earthbind = class({})
LinkLuaModifier( 
    "custom_modifier_meepo_earthbind",
    "heroes/meepo/modifiers/custom_modifier_meepo_earthbind",
    LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Ability Start
function custom_meepo_earthbind:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
    local particle_origin = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc"))
    local vDirection = point - particle_origin
    vDirection.z = 0
    local max_speed = #Vector(self:GetSpecialValueFor( "speed" ), 0, (point.z - particle_origin.z))

    local projectile_info = {
        Source = caster,
        vSpawnOrigin = particle_origin,
        vVelocity = vDirection:Normalized() * self:GetSpecialValueFor( "speed" ),
        fDistance = #vDirection,

        MovementType = PROJECTILES_ARC,
        fGravity = 128,
        fDestHeight = point.z,

        GroundBehavior = PROJECTILES_NOTHING,
        WallBehavior = PROJECTILES_NOTHING,
        TreeBehavior = PROJECTILES_NOTHING,
        
        OnFinish = function(projectile, location)
            projectile.ability:OnProjectileLanded(projectile.spell_info, location)
        end,
        Think = function(projectile)
            local particle_pos = projectile.pos
            particle_pos.z = max(particle_pos.z, GetGroundPosition(projectile.pos, projectile.Source).z)
            ParticleManager:SetParticleControl(projectile.id, 0, projectile.pos)
            ParticleManager:SetParticleControl(projectile.id, 1, projectile.pos)
        end,
        
        bProvidesVision = true,
        iVisionRadius = self:GetSpecialValueFor( "projectile_vision" ),

        EffectName = "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf",
        ControlPoints = {
            [2] = Vector(max_speed, 0, 0),
        },
        ControlPointEntityAttaches = {
            [5] = {
                attachPoint = "attach_attack1"
            }
        },

        ability = self,
        spell_info = {
            damage = self:GetSpecialValueFor("damage"),
            damage_type = self:GetAbilityDamageType(),
            radius = self:GetSpecialValueFor( "radius" ),
            duration = self:GetSpecialValueFor( "duration" ),
        }
    }
    -- self.net =
    Projectiles:CreateProjectile(projectile_info)
end

--------------------------------------------------------------------------------
-- Projectile
function custom_meepo_earthbind:OnProjectileLanded( info, location )
    local damage_table = {
        attacker = self:GetCaster(),
        damage = info.damage,
        damage_type = info.damage_type,
        ability = self
    }
    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),
        location,
        nil,
        info.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        0,
        0,
        false
    )
    for _, enemy in pairs(enemies) do
        damage_table.victim = enemy
        ApplyDamage(damage_table)
        enemy:AddNewModifier(
            self:GetCaster(),
            self,
            "custom_modifier_meepo_earthbind",
            {
                duration = info.duration
            }
        )
    end
end