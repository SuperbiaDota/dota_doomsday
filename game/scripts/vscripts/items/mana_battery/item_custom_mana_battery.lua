item_custom_mana_battery = class({})

LinkLuaModifier(
    "custom_modifier_mana_battery",
    "items/mana_battery/custom_modifier_mana_battery",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_mana_battery:GetIntrinsicModifierName()
    return "custom_modifier_mana_battery"
end