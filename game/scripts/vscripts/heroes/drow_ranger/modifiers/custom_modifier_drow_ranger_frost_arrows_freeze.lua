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
custom_modifier_drow_ranger_frost_arrows_freeze = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_frost_arrows_freeze:IsHidden()
	return false
end

function custom_modifier_drow_ranger_frost_arrows_freeze:IsDebuff()
	return true
end

function custom_modifier_drow_ranger_frost_arrows_freeze:IsPurgable()
	return false
end

-- Optional Classifications
function custom_modifier_drow_ranger_frost_arrows_freeze:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_drow_ranger_frost_arrows_freeze:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
	}
end

function custom_modifier_drow_ranger_frost_arrows_freeze:GetModifierPhysicalArmorBase_Percentage( params )
    if self.lock then
        return 0
    end
    return 100
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_drow_ranger_frost_arrows_freeze:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
	}
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_drow_ranger_frost_arrows_freeze:GetEffectName()
    return "particles/generic_gameplay/generic_frozen.vpcf"
end