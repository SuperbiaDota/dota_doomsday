-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
custom_omniknight_guardian_angel = class({})
LinkLuaModifier( 
    "custom_modifier_omniknight_guardian_angel_block", 
    "heroes/omniknight/modifiers/custom_modifier_omniknight_guardian_angel_block", 
    LUA_MODIFIER_MOTION_NONE 
)

LinkLuaModifier( 
    "custom_modifier_omniknight_guardian_angel_regen", 
    "heroes/omniknight/modifiers/custom_modifier_omniknight_guardian_angel_regen", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Ability Start
function custom_omniknight_guardian_angel:OnSpellStart()
	-- unit identifier
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
	local targets = FindUnitsInRadius(
        caster:GetTeam(),
        caster:GetAbsOrigin(),
        nil,
        self:GetSpecialValueFor("radius"),
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
        0, 
        false
    )
    for _, target in pairs(targets) do
        target:AddNewModifier(
            caster,
            self,
            "custom_modifier_omniknight_guardian_angel_block",
            {duration = duration}
        )
        target:AddNewModifier(
            caster,
            self,
            "custom_modifier_omniknight_guardian_angel_regen",
            {duration = duration}
        )
    end

    -- Play Effects
    local sound_cast = "Hero_Omniknight.GuardianAngel.Cast"
    EmitSoundOn( sound_cast, caster )
end