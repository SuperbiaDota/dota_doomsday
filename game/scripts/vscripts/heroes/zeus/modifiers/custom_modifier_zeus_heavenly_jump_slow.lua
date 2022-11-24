custom_modifier_zeus_heavenly_jump_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_template:IsHidden()
    return false
end

function modifier_template:IsDebuff()
    return true
end

function modifier_template:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_template:OnCreated( kv )
    self.as_slow = kv.aspd_slow
    self.ms_slow = kv.move_slow
end

function modifier_template:OnRefresh( kv )
    if self.as_slow < kv.aspd_slow then
        self.as_slow = kv.aspd_slow
    end
    if self.ms_slow < kv.move_slow then
        self.ms_slow = kv.move_slow
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_template:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierMoveSpeedBonus_Percentage()
    return self.ms_slow
end

function modifier_crystal_maiden_crystal_nova_lua:GetModifierAttackSpeedBonus_Constant()
    return self.as_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_template:GetEffectName()
    return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function modifier_template:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
