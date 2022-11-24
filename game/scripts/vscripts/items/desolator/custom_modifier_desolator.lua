custom_modifier_desolator = class({})

custom_modifier_desolator = class({})
function custom_modifier_desolator:IsHidden() return true end
function custom_modifier_desolator:IsPurgable() return false end
function custom_modifier_desolator:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function custom_modifier_desolator:RemoveOnDeath() return false end

function custom_modifier_desolator:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    self.damage = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function custom_modifier_desolator:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
   MODIFIER_EVENT_ON_ATTACK_LANDED
}

function custom_modifier_desolator_2:GetModifierPreAttack_BonusDamage()
    return self.damage
end

function item_custom_desolator:OnAttackLanded()
    if event.attacker == self:GetParent() and not event.attacker:IsIllusion() then
        event.target:AddNewModifier(
            self:GetParent(),
            self:GetAbility(),
            "custom_modifier_desolator_debuff",
            {duration = self.duration}
        )
    end
end
    