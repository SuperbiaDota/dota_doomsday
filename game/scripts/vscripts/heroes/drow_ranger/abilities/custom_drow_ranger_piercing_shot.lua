
custom_drow_ranger_piercing_shot = class({})

LinkLuaModifier(
    "custom_modifier_drow_ranger_frost_arrows_slow",
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_frost_arrows_slow",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_drow_ranger_piercing_shot",
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_piercing_shot",
    LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Custom KV

function custom_drow_ranger_piercing_shot:GetCastRange(point, target)
    return self:GetCaster():Script_GetAttackRange() * self:GetSpecialValueFor("range_multiplier")
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_drow_ranger_piercing_shot:OnSpellStart()
    if not IsServer() then return end
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

    local particle_origin = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
    local vDirection = (point - particle_origin):Normalized()
    vDirection.z = 0
    local speed = self:GetSpecialValueFor("speed")

    local sound_cast = "Hero_DrowRanger.Multishot.Attack"

    --[[
    local projectile = {
        Source  = caster,
        vSpawnOrigin = particle_origin,
        vVelocity = vDirection * speed,
        fDistance = caster:Script_GetAttackRange() * self:GetSpecialValueFor("range_multiplier"),

        MovementType = PROJECTILES_LINEAR,
        bGroundLock = true,
        fGroundOffset = particle_origin.z - GetGroundHeight(particle_origin, nil),

        fStartRadius = self:GetSpecialValueFor("radius"),
        fEndRadius = self:GetSpecialValueFor("radius"),

        UnitBehavior = PROJECTILES_NOTHING,
        TreeBehavior = PROJECTILES_NOTHING,
        WallBehavior = PROJECTILES_NOTHING,
        GroundBehavior = PROJECTILES_NOTHING,

        UnitTest = function(projectile, unit)
            return UF_SUCCESS == UnitFilter(
                unit,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                projectile.Source:GetTeamNumber()
            )
        end,
        OnUnitHit = function(projectile, unit)
            local hmod = projectile.Source:AddNewModifier(
                projectile.Source,
                nil,
                "custom_modifier_drow_ranger_piercing_shot",
                {
                    agi_multiplier = projectile.spell_info.agi_multiplier,
                    distance_multiplier_pct = math.min(projectile.spell_info.distance_pct_max, ( projectile.spell_info.distance_pct_min + projectile:GetDistanceTraveled() * projectile.spell_info.distance_multiplier_pct ))
                }
            )

            -- reduce base armor to zero if frozen
            local freeze_mod = unit:FindModifierByName("custom_modifier_drow_ranger_frost_arrows_freeze")
            if freeze_mod then
                freeze_mod.lock = true
            end

            -- apply frost arrows if not already toggled on
            if projectile.frost_arrows:GetLevel() > 0 and not projectile.frost_arrows:GetAutoCastState() then
                unit:AddNewModifier(
                    projectile.Source,
                    projectile.frost_arrows,
                    "custom_modifier_drow_ranger_frost_arrows_slow",
                    {
                        duration = projectile.frost_arrows:GetSpecialValueFor("slow_duration")
                    }
                )
            end
            projectile.Source:PerformAttack(
                unit,
                true,
                true,
                true,
                true,
                false,
                false,
                true
            )
            StopSoundEvent("Hero_DrowRanger.Attack", projectile.Source)

            if freeze_mod then
                freeze_mod.lock = nil
            end
            hmod:Destroy()

            AddFOWViewer(
                projectile.Source:GetTeamNumber(), 
                unit:GetAbsOrigin(), 
                projectile.spell_info.vision_radius, 
                projectile.spell_info.vision_duration,
                true
            )

            if unit:IsRealHero() then 
                EmitSoundOn( "Hero_DrowRanger.Marksmanship.Target", unit )

                local endcap = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_flash.vpcf"
                local endcap_particle = ParticleManager:CreateParticle(endcap, PATTACH_WORLDORIGIN, unit)
                --local impact = unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc"))
                local impact = unit:GetAbsOrigin()
                impact.z = projectile.fGroundOffset + GetGroundHeight(impact, nil)
                ParticleManager:SetParticleControl(endcap_particle, 3, impact)
                local endcap_angles = VectorToAngles(projectile.vVelocity:Normalized())
                ParticleManager:SetParticleControlOrientationFLU(endcap_particle, 3, endcap_angles:Forward(), endcap_angles:Left(), endcap_angles:Up())
                ParticleManager:ReleaseParticleIndex(endcap_particle)

                projectile:Destroy() 
            end
        end,

        Think = function(projectile)
            ParticleManager:SetParticleControl(projectile.id, 1, projectile.pos)
        end,

        --EffectName = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf",
        EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_arrow.vpcf",
        ControlPoints = {
            [2] = Vector(speed, 0, 0),
        },

        -- extra info
        spell_info = {
            agi_multiplier = self:GetSpecialValueFor("dmg_per_agi"),
            distance_multiplier_pct = (self:GetSpecialValueFor("max_damage_pct") - self:GetSpecialValueFor("min_damage_pct")) / self:GetSpecialValueFor("distance_to_max"),
            distance_pct_min = self:GetSpecialValueFor("min_damage_pct"),
            distance_pct_max = self:GetSpecialValueFor("max_damage_pct"),
            vision_radius = self:GetSpecialValueFor("vision_radius"),
            vision_duration = self:GetSpecialValueFor("vision_duration")
        },

        frost_arrows = caster:FindAbilityByName("custom_drow_ranger_frost_arrows")
    }
    ]]

    local projectile_data = {
        vSpawnOrigin = particle_origin,
        vVelocity = vDirection * speed,
        fDistance = caster:Script_GetAttackRange() * self:GetSpecialValueFor("range_multiplier"),
        fStartRadius = self:GetSpecialValueFor("radius"),
        fEndRadius = self:GetSpecialValueFor("radius"),

        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC

        EffectName = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_arrow.vpcf",
        Ability = self,
        Source  = caster,
        bProvidesVision = false,
        ExtraData = {
            origin = particle_origin,
            agi_multiplier = self:GetSpecialValueFor("dmg_per_agi"),
            distance_multiplier_pct = (self:GetSpecialValueFor("max_damage_pct") - self:GetSpecialValueFor("min_damage_pct")) / self:GetSpecialValueFor("distance_to_max"),
            distance_pct_min = self:GetSpecialValueFor("min_damage_pct"),
            distance_pct_max = self:GetSpecialValueFor("max_damage_pct"),
            vision_radius = self:GetSpecialValueFor("vision_radius"),
            vision_duration = self:GetSpecialValueFor("vision_duration"),
            frost_arrows = caster:FindAbilityByName("custom_drow_ranger_frost_arrows"),
            frost_arrows_level = caster:FindAbilityByName("custom_drow_ranger_frost_arrows"):GetLevel(),
        }
    }

	-- logic
    self.projectile = ProjectileManager:CreateLinearProjectile(projectile_data)
    ProjectileManager:SetParticleControl(self.projectile, 0, particle_origin)
    ProjectileManager:SetParticleControl(self.projectile, 1, vDirection)
    ProjectileManager:SetParticleControl(self.projectile, 2, Vector(speed, 0, 0))
    --Projectiles:CreateProjectile(projectile)
    EmitSoundOn( sound_cast, self:GetCaster() )

end

function custom_drow_ranger_piercing_shot:OnProjectileHit_ExtraData( target, location, data )
    local hmod = projectile.Source:AddNewModifier(
        projectile.Source,
        nil,
        "custom_modifier_drow_ranger_piercing_shot",
        {
            agi_multiplier = data.agi_multiplier,
            distance_multiplier_pct = math.min(data.distance_pct_max, ( data.distance_pct_min + (location - data.origin):Length2D() * data.distance_multiplier_pct ))
        }
    )

    -- reduce base armor to zero if frozen
    local freeze_mod = unit:FindModifierByName("custom_modifier_drow_ranger_frost_arrows_freeze")
    if freeze_mod then
        freeze_mod.lock = true
    end

    -- apply frost arrows if not already toggled on
    -- TODO: projectile save frost arrow level
    if data.frost_arrows_level > 0 and not projectile.frost_arrows:GetAutoCastState() then
        unit:AddNewModifier(
            projectile.Source,
            projectile.frost_arrows,
            "custom_modifier_drow_ranger_frost_arrows_slow",
            {
                duration = data.frost_arrows:GetSpecialValueFor("slow_duration")
                slow_level = data.frost_arrows_level
            }
        )
    end
    projectile.Source:PerformAttack(
        unit,
        true,
        true,
        true,
        true,
        false,
        false,
        true
    )
    StopSoundEvent("Hero_DrowRanger.Attack", projectile.Source)

    if freeze_mod then
        freeze_mod.lock = nil
    end
    hmod:Destroy()

    AddFOWViewer(
        projectile.Source:GetTeamNumber(), 
        unit:GetAbsOrigin(), 
        data.vision_radius, 
        data.vision_duration,
        true
    )
    
    EmitSoundOn( "Hero_DrowRanger.Marksmanship.Target", unit )

    -- endcap
    local endcap = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_flash.vpcf"
    local endcap_particle = ParticleManager:CreateParticle(endcap, PATTACH_WORLDORIGIN, unit)
    --local impact = unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc"))
    local impact = unit:GetAbsOrigin()
    impact.z = projectile.fGroundOffset + GetGroundHeight(impact, nil)
    ParticleManager:SetParticleControl(endcap_particle, 3, impact)
    local endcap_angles = VectorToAngles(projectile.vVelocity:Normalized())
    ParticleManager:SetParticleControlOrientationFLU(endcap_particle, 3, endcap_angles:Forward(), endcap_angles:Left(), endcap_angles:Up())
    ParticleManager:ReleaseParticleIndex(endcap_particle)

    return true
end

function custom_drow_ranger_piercing_shot:OnProjectileThink( location )
    ParticleManager:SetParticleControl(self.projectile, 1, location)
end