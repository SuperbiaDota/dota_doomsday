
custom_modifier_tinker_mega_death_ray_burn = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_tinker_mega_death_ray_burn:IsHidden()
	return false
end

function custom_modifier_tinker_mega_death_ray_burn:IsDebuff()
	return false
end

function custom_modifier_tinker_mega_death_ray_burn:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_tinker_mega_death_ray_burn:OnCreated( kv )
    if not IsServer() then return end

	self.radius = kv.radius
    self.team_number = self:GetCaster():GetTeamNumber()
    self.pos = self:GetParent():GetAbsOrigin()

    self.damage_table = {
        attacker = self:GetCaster(),
        damage = kv.burn_damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility()
    }

	-- Start interval
	self:StartIntervalThink( kv.interval )
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_tinker_mega_death_ray_burn:OnIntervalThink()
    local enemies = FindUnitsInRadius(
        self.team_number,
        self.pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        0,
        0,
        false
    )
    for _, enemy in pairs(enemies) do
        self.damage_table.victim = enemy
        ApplyDamage(self.damage_table)
    end
end