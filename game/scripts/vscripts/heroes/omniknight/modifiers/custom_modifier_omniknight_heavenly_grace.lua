custom_modifier_omniknight_heavenly_grace = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_omniknight_heavenly_grace:IsHidden()
    return false
end

function custom_modifier_omniknight_heavenly_grace:IsDebuff()
    return false
end

function custom_modifier_omniknight_heavenly_grace:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_omniknight_heavenly_grace:OnCreated( kv )
    self.regen = self:GetAbility():GetSpecialValueFor("hp_regen")
    self.resist = self:GetAbility():GetSpecialValueFor("status_resist")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus")

    if IsServer() then
        local parent = self:GetParent()
        parent:UpdateDebuffDurations(parent:GetStatusResistance(), self.resist) -- TODO: check if status resistance already takes effect

        -- Play Effects
        self.sound_cast = "Hero_Omniknight.Repel"
        EmitSoundOn( self.sound_cast, self:GetParent() )
    end
end

function custom_modifier_omniknight_heavenly_grace:OnRefresh( kv )
    self.regen = self:GetAbility():GetSpecialValueFor("hp_regen")
    self.resist = self:GetAbility():GetSpecialValueFor("status_resist")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus")

    if IsServer() then
        local parent = self:GetParent()
        parent:UpdateDebuffDurations(parent:GetStatusResistance(), self.resist) -- TODO: check if status resistance already takes effect
    end
end

function custom_modifier_omniknight_heavenly_grace:OnRemoved( kv )
    if IsServer() then
        local parent = self:GetParent()
        parent:UpdateDebuffDurations(parent:GetStatusResistance(), -self.resist)
    end
end

function custom_modifier_omniknight_heavenly_grace:OnDestroy( kv )
    if IsServer() then
        StopSoundOn( self.sound_cast, self:GetParent() )
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_omniknight_heavenly_grace:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function custom_modifier_omniknight_heavenly_grace:GetModifierStatusResistanceStacking()
    return self.resist
end

function custom_modifier_omniknight_heavenly_grace:GetModifierConstantHealthRegen()
    return self.regen
end

function custom_modifier_omniknight_heavenly_grace:GetModifierMoveSpeedBonus_Constant()
    return self.ms_bonus
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_omniknight_heavenly_grace:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf"
end

function custom_modifier_omniknight_heavenly_grace:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end