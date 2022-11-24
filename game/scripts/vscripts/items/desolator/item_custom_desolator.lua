item_custom_desolator = class({})

LinkLuaModifier(
    "custom_modifier_desolator",
    "items/desolator_2/custom_modifier_desolator",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_desolator_debuff",
    "items/desolator_2/custom_modifier_desolator_debuff",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_desolator_2:GetIntrinsicModifierName()
    return "custom_modifier_desolator"
end