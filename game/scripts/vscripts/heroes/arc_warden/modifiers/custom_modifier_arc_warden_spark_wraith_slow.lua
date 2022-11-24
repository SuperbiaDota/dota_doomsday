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
modifier_custom_arc_warden_spark_wraith_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_arc_warden_spark_wraith_slow:IsHidden()
	return false
end

function modifier_custom_arc_warden_spark_wraith_slow:IsDebuff()
	return true
end

function modifier_custom_arc_warden_spark_wraith_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_arc_warden_spark_wraith_slow:OnCreated( kv )
    self.ms_slow = kv.ms_slow
end

function modifier_custom_arc_warden_spark_wraith_slow:OnRefresh( kv )
    if self.ms_slow < kv.ms_slow then
        self.ms_slow = kv.ms_slow
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_custom_arc_warden_spark_wraith_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_custom_arc_warden_spark_wraith_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_arc_warden_spark_wraith_slow:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function modifier_custom_arc_warden_spark_wraith_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_custom_arc_warden_spark_wraith_slow:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function modifier_custom_arc_warden_spark_wraith_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end