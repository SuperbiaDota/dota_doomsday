item_custom_octarine_core = class({})

LinkLuaModifier(
    "custom_modifier_octarine_core",
    "items/octarine_core/custom_modifier_octarine_core",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_octarine_core:GetIntrinsicModifierName()
    return "custom_modifier_octarine_core"
end