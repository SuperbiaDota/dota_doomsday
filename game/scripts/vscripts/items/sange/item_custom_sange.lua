item_custom_sange = class({})

LinkLuaModifier(
    "custom_modifier_sange",
    "items/sange/custom_modifier_sange",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_sange:GetIntrinsicModifierName()
    return "custom_modifier_sange"
end