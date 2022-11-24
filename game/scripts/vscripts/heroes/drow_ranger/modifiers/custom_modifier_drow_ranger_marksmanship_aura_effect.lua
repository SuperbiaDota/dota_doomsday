
custom_modifier_drow_ranger_marksmanship_aura_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_marksmanship_aura_effect:IsHidden()
	return false
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:IsDebuff()
	return false
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_drow_ranger_marksmanship_aura_effect:OnCreated( kv )
	self.as_bonus = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("as_per_agi")
    self.range_bonus = self:GetAbility():GetSpecialValueFor("atk_range_bonus")
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:OnRefresh( kv )
	self.as_bonus = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("as_per_agi")
    self.range_bonus = self:GetAbility():GetSpecialValueFor("atk_range_bonus")
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:OnRemoved()
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_drow_ranger_marksmanship_aura_effect:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:GetModifierAttackRangeBonus()
    return self.range_bonus
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent() ~= self:GetCaster() then
	   return self.as_bonus
    end
    return 0
end

function custom_modifier_drow_ranger_marksmanship_aura_effect:GetModifierBonusStats_Agility()
    if self:GetParent() == self:GetCaster() then
        return self.as_bonus
    end
    return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_drow_ranger_marksmanship_aura_effect:GetEffectName()
    return "particles/units/heroes/hero_drow/drow_aura_buff.vpcf"
end
