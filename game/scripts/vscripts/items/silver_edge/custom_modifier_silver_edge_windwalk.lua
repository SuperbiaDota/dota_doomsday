custom_modifier_silver_edge_windwalk = class({})

function custom_modifier_silver_edge_windwalk:IsHidden()
    return false
end

function custom_modifier_silver_edge_windwalk:IsDebuff()
    return false
end

function custom_modifier_silver_edge_windwalk:IsPurgable() 
    return false 
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_silver_edge_windwalk:OnCreated()
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("windwalk_movement_speed")
    self.crit = self:GetAbility():GetSpecialValueFor("crit_multiplier")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
    self.item = self:GetAbility()

    if IsServer() then
        self.filter = FilterManager:AddTrackingProjectileFilter(self.AttackProjectileFilter, self)
    end

    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("windwalk_fade_time"))
end

function custom_modifier_silver_edge_windwalk:OnRefresh()
    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("windwalk_fade_time"))
end

function custom_modifier_silver_edge_windwalk:OnDestroy()
    if not IsServer() then return end
    FilterManager:RemoveTrackingProjectileFilter( self.filter )
end


--------------------------------------------------------------------------------
-- Declare Functions
function custom_modifier_silver_edge_windwalk:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,

        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end

function custom_modifier_silver_edge_windwalk:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_bonus
end

function custom_modifier_silver_edge_windwalk:GetModifierPreAttack_CriticalStrike()
    return self.crit
end

function custom_modifier_silver_edge_windwalk:GetModifierInvisibilityLevel()
    return 1
end

function custom_modifier_silver_edge_windwalk:GetModifierPreAttack_BonusDamagePostCrit(params)
    if IsClient() or (params.target:IsBaseNPC() and (not params.target:IsOther() and not params.target:IsBuilding())) then -- TODO: do i have custom ward type? is it caught by IsOther()?
        return self.bonus_damage
    end
end

function custom_modifier_silver_edge_windwalk:OnAbilityExecuted( params )
    if IsServer() then
        if params.unit~=self:GetParent() then return end
        if not self.fade then return end
        self:Destroy()
    end
end

function custom_modifier_silver_edge_windwalk:OnAttack( params )
    if IsServer() then
        if params.attacker ~= self:GetParent() then return end
        if params.attacker:GetAttackCapability() ~= DOTA_UNIT_CAP_RANGED_ATTACK then -- Why doesn't params.ranged_attack work?
            self:GetAbility():OnProjectileHit(params.target, nil)
            self:Destroy()
        end
    end
end

--function custom_modifier_silver_edge_windwalk:OnAttackLanded( event )
--    if not IsServer() then return end
--    if event.attacker == self:GetParent() then
--        self:Destroy()
--    end
--end

--------------------------------------------------------------------------------
-- Filter Effects
function custom_modifier_silver_edge_windwalk:AttackProjectileFilter( data )
    -- get data
    local attacker = EntIndexToHScript( data.entindex_source_const )
    local target = EntIndexToHScript( data.entindex_target_const )
    local ability = EntIndexToHScript( data.entindex_ability_const )

    -- only track projectiles from parent
    if attacker ~= self:GetParent() then return end

    -- only track projectiles not from this ability
    if self.lock then return true end

    -- only track attacks
    if not data.is_attack then return true end

    -- create projectile
    local info = {
        Target = target,
        Source = attacker,
        Ability = self.item, 
        
        --EffectName = attacker:GetRangedProjectileName(),
        iMoveSpeed = data.move_speed,
        bDodgeable = true,                           -- Optional
    
        vSourceLoc = attacker:GetAbsOrigin(),                -- Optional (HOW)
        bIsAttack = true,                                -- Optional

        ExtraData = data,
    }
    self.lock = true
    ProjectileManager:CreateTrackingProjectile(info)
    self.lock = false

    self:Destroy()

    return true
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_silver_edge_windwalk:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = self.fade,
        [MODIFIER_STATE_CANNOT_MISS] = true
    }
end

--------------------------------------------------------------------------------
-- Think
function custom_modifier_silver_edge_windwalk:OnIntervalThink()
    self.fade = true
    self:StartIntervalThink(-1)
end