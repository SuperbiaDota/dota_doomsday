item_custom_arcane_blink = class({})

LinkLuaModifier(
    "custom_modifier_arcane_blink",
    "items/arcane_blink/custom_modifier_arcane_blink",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_arcane_blink:GetIntrinsicModifierName()
    return "custom_modifier_arcane_blink"
end

function item_custom_arcane_blink:OnSpellStart()
    local caster = self:GetCaster()
    local start = caster:GetAbsOrigin()
    local point = self:GetCursorPosition()
    start.z = 0
    point.z = 0

    local max_blink_range = self:GetSpecialValueFor("range")
    local penalty = self:GetSpecialValueFor("penalty")

    local vDirection = (point - start):Normalized()
    local distance = #(point - start)
    if distance > max_blink_range then
        distance = max_blink_range - penalty
    end

    FindClearSpaceForUnit(caster, start + (vDirection * distance), true)
end