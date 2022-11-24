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
custom_modifier_drow_ranger_frost_arrows_slow = class({})

LinkLuaModifier( "custom_modifier_drow_ranger_frost_arrows_stack", 
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_frost_arrows_stack", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_frost_arrows_slow:IsHidden()
	return false
end

function custom_modifier_drow_ranger_frost_arrows_slow:IsDebuff()
	return true
end

function custom_modifier_drow_ranger_frost_arrows_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_drow_ranger_frost_arrows_slow:OnCreated( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("ms_slow")
    if IsServer() then
        if self:GetParent():FindModifierByName("custom_modifier_drow_ranger_frost_arrows_freeze") ~= nil then
            self:Destroy()
            return
        end
        if self:GetParent():GetUnitName() ~= "npc_dota_roshan" then 
            self:GetParent():AddNewModifier(
                self:GetCaster(),
                self:GetAbility(),
                "custom_modifier_drow_ranger_frost_arrows_stack",
                {duration = self:GetAbility():GetSpecialValueFor("stack_duration")}
            )
        end
    end
end

function custom_modifier_drow_ranger_frost_arrows_slow:OnRefresh( kv )
    if IsServer() then
        if self:GetParent():FindModifierByName("custom_modifier_drow_ranger_frost_arrows_freeze") ~= nil then
            self:Destroy()
            return
        end
        if self:GetParent():GetUnitName() ~= "npc_dota_roshan" then 
            self:GetParent():AddNewModifier(
                self:GetCaster(),
                self:GetAbility(),
                "custom_modifier_drow_ranger_frost_arrows_stack",
                {duration = self:GetAbility():GetSpecialValueFor("stack_duration")}
            )
        end
    end
end

function custom_modifier_drow_ranger_frost_arrows_slow:OnRemoved()
end

function custom_modifier_drow_ranger_frost_arrows_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_drow_ranger_frost_arrows_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function custom_modifier_drow_ranger_frost_arrows_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_drow_ranger_frost_arrows_slow:GetEffectName()
    return "particles/units/heroes/hero_drow/drow_frost_arrow_debuff.vpcf"
end