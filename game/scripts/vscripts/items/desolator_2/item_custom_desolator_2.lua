item_custom_desolator_2 = class({})

LinkLuaModifier(
    "custom_modifier_desolator_2",
    "items/desolator_2/custom_modifier_desolator_2",
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_desolator_2_debuff",
    "items/desolator_2/custom_modifier_desolator_2_debuff",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_desolator_2:GetIntrinsicModifierName()
    return "custom_modifier_desolator_2"
end
