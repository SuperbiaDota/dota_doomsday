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
custom_modifier_omniknight_degen_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_omniknight_degen_aura:IsHidden()
	return true
end

function custom_modifier_omniknight_degen_aura:IsDebuff()
	return false
end

function custom_modifier_omniknight_degen_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_omniknight_degen_aura:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.aura_linger = self:GetAbility():GetSpecialValueFor( "aura_linger" )

    if IsServer() then
        self:PlayEffects()
    end
end

function custom_modifier_omniknight_degen_aura:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.aura_linger = self:GetAbility():GetSpecialValueFor( "aura_linger" )
end

function custom_modifier_omniknight_degen_aura:OnRemoved()
end

function custom_modifier_omniknight_degen_aura:OnDestroy()
end

--------------------------------------------------------------------------------
-- Aura Effects
function custom_modifier_omniknight_degen_aura:IsAura()
	return true
end

function custom_modifier_omniknight_degen_aura:GetModifierAura()
	return "custom_modifier_omniknight_degen_aura_effect"
end

function custom_modifier_omniknight_degen_aura:GetAuraRadius()
	return self.radius
end

function custom_modifier_omniknight_degen_aura:GetAuraDuration()
	return self.aura_linger
end

function custom_modifier_omniknight_degen_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function custom_modifier_omniknight_degen_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_omniknight_degen_aura:PlayEffects()
    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_degen_aura.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

    -- buff particle
    self:AddParticle(
        effect_cast,
        false,
        false,
        -1,
        false,
        false
    )
end