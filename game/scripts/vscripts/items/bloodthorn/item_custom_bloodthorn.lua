item_custom_bloodthorn = class({})

LinkLuaModifier(
    "custom_modifier_bloodthorn",
    "items/bloodthorn/custom_modifier_bloodthorn"
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_bloodthorn_silence",
    "items/bloodthorn/custom_modifier_bloodthorn_silence"
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_bloodthorn_magic_weakness",
    "items/bloodthorn/custom_modifier_bloodthorn_magic_weakness"
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_bloodthorn:GetIntrinsicModifierName()
    return "custom_modifier_bloodthorn"
end

function item_custom_bloodthorn:OnSpellStart()
    if not IsServer() then return end

    local point = self:GetCursorPosition()

    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),
        point,
        nil,
        self:GetSpecialValueFor("radius"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        0,
        0,
        false
    )

    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(
            self:GetCaster(),
            self,
            "custom_modifier_bloodthorn_silence",
            {duration = self:GetSpecialValueFor("silence_duration")}
        )

        enemy:AddNewModifier(
            self:GetCaster(),
            self,
            "custom_modifier_bloodthorn_magic_weakness",
            {duration = self:GetSpecialValueFor("weakness_duration")}
        )
    end
end