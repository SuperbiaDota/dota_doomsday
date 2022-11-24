
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
    ParticleManager:DestroyParticle(self.effect_cast, true)
    ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

function custom_rubick_null_field:OnAbilityPhaseStart()
    self:PlayEffects()
    return true -- if success
end


--------------------------------------------------------------------------------
-- Filter Effects (unused)
function custom_rubick_null_field:ProjectileFilter( data ) -- only for auto attacks, spell projectiles are handled by the projectile manager
    -- get data
    local attacker = EntIndexToHScript( data.entindex_source_const )
    local target = EntIndexToHScript( data.entindex_target_const )
    local ability = EntIndexToHScript( data.entindex_ability_const )

    -- only block projectiles that aren't from this ability
    if self.lock then return true end

    -- only block attacks
    if not data.is_attack then return true end

    -- only block enemies
    if attacker:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return true end

    -- create projectile
    local info = {
        Target = target,
        Source = attacker,
        Ability = self, 
        
        EffectName = attacker:GetRangedProjectileName(),
        iMoveSpeed = data.move_speed,
        bDodgeable = true,                           -- Optional
    
        vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
        bIsAttack = true,                                -- Optional

        ExtraData = data,
    }

    self.lock = true
    local hproj = ProjectileManager:CreateTrackingProjectile(info)
    self.lock = false
    self.attack_projectiles[hproj] = data

    return false
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_rubick_null_field:OnSpellStart()
    local caster_position = self:GetCaster():GetAbsOrigin()

    ParticleManager:ReleaseParticleIndex( self.effect_cast )
    
    if IsServer() then

        ---- check attack projectiles
        --for hproj,_ in pairs(self.attack_projectiles) do
        --    -- get position
        --    local pos = ProjectileManager:GetTrackingProjectileLocation( hproj )

        --    -- check location
        --    local distance = (pos - caster_position):Length2D()

        --    -- check if position is within the radius
        --    if distance < self:GetAOERadius() then
        --         -- destroy
        --        self.attack_projectiles[hproj].destroyed = true
        --        ProjectileManager:DestroyTrackingProjectile( hproj )

        --        -- play effects
        --        -- self:PlayProjectileEffects( pos )
        --    end
        --end

        -- check spell projectiles
        for hproj, _ in pairs(Projectiles.projectile_table) do
            -- get position
            local pos = hproj:GetPosition()
    
            -- check location
            local distance = (pos - caster_position):Length2D()

            -- check if position is within the radius
            if distance < self:GetAOERadius() then
                 -- destroy
                hproj:Destroy()

                -- play effects
                -- self:PlayProjectileEffects( pos )
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Projectile (unused)
function custom_rubick_null_field:OnProjectileHitHandle( target, location, hproj )
    local data = self.attack_projectiles[hproj]
    self.attack_projectiles[hproj] = nil

    if data.destroyed then return end

    local attacker = EntIndexToHScript( data.entindex_source_const )
    attacker:PerformAttack( target, true, true, true, true, false, false, true )
end

--------------------------------------------------------------------------------
-- Effects
-- TODO: rubick sucks projectiles into his staff
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
