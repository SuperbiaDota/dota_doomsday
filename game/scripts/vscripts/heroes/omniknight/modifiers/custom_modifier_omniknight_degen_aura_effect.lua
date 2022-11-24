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
custom_modifier_omniknight_degen_aura_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_omniknight_degen_aura_effect:IsHidden()
	return false
end

function custom_modifier_omniknight_degen_aura_effect:IsDebuff()
	return true
end

function custom_modifier_omniknight_degen_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_omniknight_degen_aura_effect:OnCreated( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "ms_slow" )
    self.dmg_reduction = self:GetAbility():GetSpecialValueFor( "dmg_reduction" )

    self.time_to_max = self:GetAbility():GetSpecialValueFor("time_to_max")

    self.mult = 0
    self.start = GameRules:GetGameTime()
    self:SetIntervalThink(0.2)

    self.modifier = self:GetParent():AddNewModifier(
        self:GetCaster(),
        self:GetAbility(),
        "modifier_generic_damage_modification",
        {
            callback = self.GetDamagePercent,
            priority = 0,
            damage_type = DAMAGE_TYPE_ALL
        }
    )
end

function custom_modifier_omniknight_degen_aura_effect:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "ms_slow" )
    self.dmg_reduction = self:GetAbility():GetSpecialValueFor( "dmg_reduction" )
end

function custom_modifier_omniknight_degen_aura_effect:OnRemoved()
end

function custom_modifier_omniknight_degen_aura_effect:OnDestroy()
    self.modifier:RemoveMod(self)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_omniknight_degen_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function custom_modifier_omniknight_degen_aura_effect:GetModifierMoveSpeedBonus_Percentage()
    return -(self.mult * self.ms_slow)
end

function custom_modifier_omniknight_degen_aura_effect:GetDamagePercent(excess, context)
    return excess * (1-(self.mult * self.dmg_reduction / 100))
end

--------------------------------------------------------------------------------
-- Think
function custom_modifier_omniknight_degen_aura_effect:OnIntervalThink()
    local dt = GameRules:GetGameTime() - self.start
    local mult = dt / self.time_to_max
    if mult > 1 then 
        self.mult = 1
        self:SetIntervalThink(-1)
    else
        self.mult = mult
    end
    self.dmg_percent = -(self.mult * self.dmg_reduction)
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_omniknight_degen_aura_effect:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
end

function custom_modifier_omniknight_degen_aura_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

