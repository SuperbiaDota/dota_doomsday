item_custom_ethereal_blade = class({})

LinkLuaModifier(
    "custom_modifier_ethereal_blade",
    "items/ethereal_blade/custom_modifier_ethereal_blade",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_ethereal_blade_debuff",
    "items/ethereal_blade/custom_modifier_ethereal_blade_slow",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_ethereal_blade:Spawn()
    self.speed = self:GetSpecialValueFor("projectile_speed")
    self.enemy_duration = self:GetSpecialValueFor("duration")
    self.ally_duration = self:GetSpecialValueFor("duration_ally")

    self.base_damage = self:GetSpecialValueFor("blast_damage_base")
    self.multiplier = self:GetSpecialValueFor("blast_multiplier")

    self.ms_slow = self:GetSpecialValueFor("blast_movement_slow")
    self.magic_reduce = self:GetSpecialValueFor("ethereal_damage_bonus")
end

    

function item_custom_ethereal_blade:GetIntrinsicModifierName()
    return "custom_modifier_ethereal_blade"
end

function item_custom_ethereal_blade:OnSpellStart()
    local target = self:GetCursorTarget()

    local info = {
        vSourceLoc = self:GetCaster():GetAbsOrigin(),
        Target = target,
        iMoveSpeed = self.speed,
        bDodgeable = true,
        Ability = self,
        Source = self:GetCaster()
    }

    ProjectileManager:CreateTrackingProjectile(info)

    -- cp 1 is the ground effect position
    -- cp 3 is projectile position
    self.effect_cast = ParticleManager:CreateParticle(
        "particles/items_fx/ethereal_blade.vpcf",
        PATTACH_WORLDORIGIN,
        self:GetCaster()
    )
end

function item_custom_ethereal_blade:OnProjectileThink( location )
    ParticleManager:SetParticleControl(self.effect_cast, 3, location)
end

function item_custom_ethereal_blade:OnProjectileHit(target, location)
    local is_ally = target:GetTeamNumber() == self:GetCaster():GetTeamNumber()
    local slow_duration = self.enemy_duration
    if is_ally then slow_duration = self.ally_duration end

    target:AddNewModifier(
        self:GetCaster(),
        self,
        "custom_modifier_ethereal_blade_slow",
        {
            duration = self.slow_duration,
            ms_slow = self.ms_slow,
            magic_reduce = self.magic_reduce
        }
    )

    if not is_ally then
        local damage_table = {
            victim = target,
            attacker = self:GetCaster(),
            damage = self.base_damage + self:GetCaster():GetPrimaryStatValue() * self.multiplier,
            damage_type = DAMAGE_TYPE_MAGICAL,
            0,
            self
        }
        ApplyDamage( damage_table )
    end

    ParticleManager:SetParticleControl(self.effect_cast, 1, location)
    ParticleManager:ReleaseParticleIndex(self.effect_cast)
    ParticleManager:DestroyParticle(self.effect_cast, false)
end