
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

	-- logic
    target:AddNewModifier(
        caster,
        self,
        "custom_modifier_tinker_laser_blind",
        {duration = self:GetSpecialValueFor("blind_duration")}
    )
    ApplyDamage(damage_table)
end