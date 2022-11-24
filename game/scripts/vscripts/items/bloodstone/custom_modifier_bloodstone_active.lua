custom_modifier_bloodstone_active = class({})

function custom_modifier_bloodstone_active:IsHidden()
    return false
end

function custom_modifier_bloodstone_active:IsDebuff()
    return false
end

function custom_modifier_bloodstone_active:IsPurgable()
    return false
end

function custom_modifier_bloodstone_active:OnCreated()
    self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal_pct") / 100
end

function custom_modifier_bloodstone_active:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE 
    }
end

function custom_modifier_bloodstone_active:OnTakeDamage( event )
    if not IsServer() then return end
    if event.attacker == self:GetParent() and event.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
        self:GetParent():Heal(event.damage * self.spell_lifesteal, self:GetAbility())
    end
end