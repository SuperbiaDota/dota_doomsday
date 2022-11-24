
custom_drow_ranger_marksmanship_aura = class({})

LinkLuaModifier( "custom_modifier_drow_ranger_marksmanship_aura", 
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_marksmanship_aura", 
    LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "custom_modifier_drow_ranger_marksmanship_aura_effect", 
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_marksmanship_aura_effect", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_drow_ranger_marksmanship_aura:GetIntrinsicModifierName()
    return "custom_modifier_drow_ranger_marksmanship_aura"
end

--------------------------------------------------------------------------------
-- Custom KV

-- AOE Radius
function custom_drow_ranger_marksmanship_aura:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end