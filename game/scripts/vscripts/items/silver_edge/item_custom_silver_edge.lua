item_custom_silver_edge = class({})

LinkLuaModifier(
    "custom_modifier_silver_edge",
    "items/silver_edge/custom_modifier_silver_edge",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_silver_edge_windwalk",
    "items/silver_edge/custom_modifier_silver_edge_windwalk",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_silver_edge_backstab",
    "items/silver_edge/custom_modifier_silver_edge_backstab",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_silver_edge_backstab_crit",
    "items/silver_edge/custom_modifier_silver_edge_backstab_crit",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_silver_edge:Spawn()
    self.backstab_duration = self:GetSpecialValueFor("backstab_duration")
    self.backstab_crit = self:GetSpecialValueFor("backstab_crit")
    self.projectiles = {}
end

function item_custom_silver_edge:GetIntrinsicModifierName()
    return "custom_modifier_silver_edge"
end

function item_custom_silver_edge:OnSpellStart()
    self:GetCaster():AddNewModifier(
        self:GetCaster(),
        self,
        "custom_modifier_silver_edge_windwalk",
        {duration = self:GetSpecialValueFor("windwalk_duration")}
    )

    ParticleManager:ReleaseParticleIndex( 
        ParticleManager:CreateParticle( 
            "particles/generic_hero_status/status_invisibility_start.vpcf",
            PATTACH_ABSORIGIN_FOLLOW, 
            self:GetCaster() 
        ) 
    )
end

function item_custom_silver_edge:OnProjectileHit( target, location )
    if UnitFilter(
        target,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        self:GetCaster():GetTeamNumber()
    ) == UF_SUCCESS then
        target:AddNewModifier(
            self:GetCaster(),
            self,
            "custom_modifier_silver_edge_backstab",
            {
                duration = self.backstab_duration,
                crit = self.backstab_crit
            }
        )
    end
end