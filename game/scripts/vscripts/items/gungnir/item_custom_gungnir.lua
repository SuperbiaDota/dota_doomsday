item_custom_gungnir = class({})

LinkLuaModifier(
    "custom_modifier_gungnir",
    "items/gungnir/custom_modifier_gungnir",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_gungnir_buff",
    "items/gungnir/custom_modifier_gungnir_buff",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_gungnir:GetIntrinsicModifierName()
    return "custom_modifier_gungnir"
end

function item_custom_gungnir:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(
            self:GetCaster(),
            self,
            "custom_modifier_gungnir_buff",
            {
                duration = self:GetSpecialValueFor("duration"),
                attack_count = self:GetSpecialValueFor("attack_count"),
                pct_damage_to_magic = self:GetSpecialValueFor("pct_damage_to_magic")
            }
        )
    end
end