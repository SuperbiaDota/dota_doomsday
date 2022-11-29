
custom_tinker_laser = class({})

LinkLuaModifier( 
    "custom_modifier_tinker_laser_blind", 
    "heroes/tinker/modifiers/custom_modifier_tinker_laser_blind", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Ability Start
function custom_tinker_laser:OnSpellStart()
    if not IsServer() then return end

	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local damage_table = {
        victim = target,
        attacker = caster,
        damage = self:GetSpecialValueFor( "damage" ),
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        self:GetSpecialValueFor("radius"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
        0,
        false
    )

	-- logic
    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(
            caster,
            self,
            "custom_modifier_tinker_laser_blind",
            {duration = self:GetSpecialValueFor("blind_duration")}
        )
    end
    ApplyDamage(damage_table)
end