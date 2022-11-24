custom_modifier_desolator_2 = class({})

function custom_modifier_desolator_2:IsHidden()
    return true 
end

function custom_modifier_desolator_2:IsPurgable() 
    return false 
end

function custom_modifier_desolator_2:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_desolator_2:RemoveOnDeath() 
    return false 
end

function custom_modifier_desolator_2:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.base_damage = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.damage_per_kill = self:GetAbility():GetSpecialValueFor("damage_per_kill")
    self.damage_per_assist = self:GetAbility():GetSpecialValueFor("damage_per_assist")
    self.corruption_duration = self:GetAbility():GetSpecialValueFor("corruption_duration")
end

function custom_modifier_desolator_2:DeclareFunctions()
    return {
       MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
       MODIFIER_EVENT_ON_ATTACK_LANDED,
       MODIFIER_EVENT_ON_KILL,
       MODIFIER_EVENT_ON_ASSIST,
       --MODIFIER_EVENT_ON_HERO_KILLED
    }
end

function custom_modifier_desolator_2:GetModifierPreAttack_BonusDamage()
    return self.base_damage + self:GetAbility():GetCurrentCharges()
end

-- TODO: replace projectile with desolator effect
-- TODO: doesn't stack with base desolator

function custom_modifier_desolator_2:OnAttackLanded( event )
    if not IsServer() then return end
    if event.attacker == self:GetParent() and not event.attacker:IsIllusion() then
        event.target:AddNewModifier(
            self:GetParent(),
            self:GetAbility(),
            "custom_modifier_desolator_2_debuff",
            {duration = self.corruption_duration}
        )
    end
end

function custom_modifier_desolator_2:OnHeroKilled( event ) -- TODO: assists give + 1 charge
    if event.attacker == self:GetParent() then
        self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + self.damage_per_kill)
    end
end

-- TODO: test if these events actually work
function custom_modifier_desolator_2:OnKill()
    self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + self.damage_per_kill)
end

function custom_modifier_desolator_2:OnAssist()
    self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + self.damage_per_assist)
end