if not AttackProjectiles then
    AttackProjectiles = {}
    AttackProjectiles.projectiles = {}
    FilterManager:AddTrackingProjectileFilter(AttackProjectiles.AttackProjectileFilter, AttackProjectiles)
end

function AttackProjectiles:AttackProjectileFilter( data )
    local attacker = EntIndexToHScript( data.entindex_source_const )
    local target = EntIndexToHScript( data.entindex_target_const )
    local ability = EntIndexToHScript( data.entindex_ability_const )

    -- only track projectiles that weren't created by the attack projectile manager
    if self.lock then return true end

    -- only track attack projectiles
    if not data.is_attack then return end

    -- create projectile
    local info = {
        Target = target,
        Source = attacker,
        --Ability = self.ability, 
        
        EffectName = attacker:GetRangedProjectileName(),
        iMoveSpeed = data.move_speed,
        bDodgeable = true,                           -- Optional
    
        --vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
        bIsAttack = true,                                -- Optional
    
        ExtraData = data,
    }
    self.lock = true
    local id = ProjectileManager:CreateTrackingProjectile(info)
    self.lock = false
    self.projectiles[id] = data

    return false
end