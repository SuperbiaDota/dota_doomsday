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
custom_omniknight_heavenly_grace = class({})
LinkLuaModifier( 
    "custom_modifier_omniknight_heavenly_grace", 
    "heroes/omniknight/modifiers/custom_modifier_omniknight_heavenly_grace", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Ability Start
function custom_omniknight_heavenly_grace:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- logic
    caster:AddNewModifier(
        caster,
        self,
        "custom_modifier_omniknight_heavenly_grace",
        {duration = duration}
    )
    target:AddNewModifier(
        caster,
        self,
        "custom_modifier_omniknight_heavenly_grace",
        {duration = duration}
    )

    -- Play Effects
    self:PlayEffects()
end

function custom_omniknight_heavenly_grace:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        self:GetCaster(),
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        self:GetCaster():GetOrigin(), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end