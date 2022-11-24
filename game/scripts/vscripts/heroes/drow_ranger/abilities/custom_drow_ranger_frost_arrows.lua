
custom_drow_ranger_frost_arrows = class({})

LinkLuaModifier( "modifier_generic_orb_effect_lua", 
    "generic/modifier_generic_orb_effect_lua", 
    LUA_MODIFIER_MOTION_NONE 
)

LinkLuaModifier( "custom_modifier_drow_ranger_frost_arrows_slow", 
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_frost_arrows_slow", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Passive Modifier
function custom_drow_ranger_frost_arrows:GetIntrinsicModifierName()
    return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Orb Effects
function custom_drow_ranger_frost_arrows:GetProjectileName()
    return "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end

function custom_drow_ranger_frost_arrows:OnOrbFire( params )
    local sound_cast = "Hero_DrowRanger.FrostArrows"
    EmitSoundOn( sound_cast, self:GetCaster() )
end

function custom_drow_ranger_frost_arrows:OnOrbImpact( params )
    local slow_duration = self:GetDuration()

    params.target:AddNewModifier(
        self:GetCaster(), -- player source
        self, -- ability source
        "custom_modifier_drow_ranger_frost_arrows_slow", -- modifier name
        { duration = slow_duration } -- kv
    )
end