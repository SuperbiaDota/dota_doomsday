
custom_tinker_heat_seeking_missile = class({})

--------------------------------------------------------------------------------
-- Ability Start
function custom_tinker_heat_seeking_missile:OnSpellStart()

    local caster = self:GetCaster()

    self.damage_table = {
        attacker = caster,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }
	
    local enemy_heroes = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self:GetSpecialValueFor("search_radius"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
        FIND_CLOSEST,
        false
    )

	-- load data
    local particle_source = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack3"))
    local speed = self:GetSpecialValueFor("speed")

    local projectile_info = {
        vSourceLoc = caster:GetAbsOrigin(),
        iMoveSpeed = speed,
        bDodgeable = true,
        bIsAttack = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3,
        EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
        Ability = self,
        Source = caster,
        ExtraData = {
            damage = self:GetSpecialValueFor("damage")
        }
    }

    -- logic
    for enemy_index=1,self:GetSpecialValueFor("target_count") do
        if enemy_heroes[enemy_index] then
            projectile_info.Target = enemy_heroes[enemy_index]
            ProjectileManager:CreateTrackingProjectile(projectile_info)
        end
    end
end

--------------------------------------------------------------------------------
-- Projectile
function custom_tinker_heat_seeking_missile:OnProjectileHit_ExtraData( target, location, ExtraData )
    self.damage_table.victim = target
    self.damage_table.damage = ExtraData.damage

    ApplyDamage(self.damage_table)
end

--------------------------------------------------------------------------------
-- Effects
function custom_tinker_heat_seeking_missile:PlayEffects()
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