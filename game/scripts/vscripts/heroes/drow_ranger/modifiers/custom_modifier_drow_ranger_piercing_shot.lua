
custom_modifier_drow_ranger_piercing_shot = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_piercing_shot:IsHidden()
	return true
end

function custom_modifier_drow_ranger_piercing_shot:IsDebuff()
	return false
end

function custom_modifier_drow_ranger_piercing_shot:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_drow_ranger_piercing_shot:OnCreated( kv )
	self.distance_multiplier_pct = kv.distance_multiplier_pct
    self.agi_multiplier = kv.agi_multiplier
    self.frost_arrows = self:GetCaster():FindAbilityByName("custom_drow_ranger_frost_arrows")
end

function custom_modifier_drow_ranger_piercing_shot:OnRefresh( kv )
	self.distance_multiplier_pct = kv.distance_multiplier_pct
    self.agi_multiplier = kv.agi_multiplier
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_drow_ranger_piercing_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function custom_modifier_drow_ranger_piercing_shot:GetModifierPreAttack_BonusDamage()
    if IsServer() then
        return self:GetCaster():GetAgility() * self.agi_multiplier
    end
end

function custom_modifier_drow_ranger_piercing_shot:GetModifierDamageOutgoing_Percentage( attack_event )
    if IsServer() then
	   return self.distance_multiplier_pct -100
    end
end

function custom_modifier_drow_ranger_piercing_shot:GetModifierOverrideAbilitySpecial( event )
    if event.ability == self.frost_arrows and event.ability_special_value == "AbilityManaCost" then
        return 1
    else
        return 0
    end
end

function custom_modifier_drow_ranger_piercing_shot:GetModifierOverrideAbilitySpecialValue( event )
    return 0
end