custom_modifier_gungnir_buff = class({})

function custom_modifier_gungnir_buff:IsHidden()
    return false
end

function custom_modifier_gungnir_buff:IsDebuff()
    return false
end

function custom_modifier_gungnir_buff:IsPurgable()
    return false
end

function custom_modifier_gungnir_buff:OnCreated(kv)
    if not IsServer() then return end
    self:SetStackCount(kv.attack_count)
    self.damage_multiplier = kv.pct_damage_to_magic / 100
    self.base_mod = self:GetParent():FindModifierByName("custom_modifier_gungnir")
    self.base_mod.lock = true
end

function custom_modifier_gungnir_buff:OnRefresh(kv)
    self:OnCreated(kv)
end

function custom_modifier_gungnir_buff:OnDestroy()
    if IsServer() then
        self.base_mod.lock = nil
    end
end

function custom_modifier_gungnir_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ALWAYS_ETHEREAL_ATTACK
    }
end

function custom_modifier_gungnir_buff:GetModifierProcAttack_BonusDamage_Magical( event )
    if not IsServer() then return end
    if event.attacker == self:GetParent() and not event.target:IsBuilding() then
        self:DecrementStackCount()

        -- overhead event
        SendOverheadEventMessage(
            nil, --DOTAPlayer sendToPlayer,
            OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
            event.target,
            self.damage_multiplier * event.damage * (1 + self:GetParent():GetSpellAmplification(false)),
            self:GetParent():GetPlayerOwner() -- DOTAPlayer sourcePlayer
        )

        return self.damage_multiplier * event.damage
    end
end

function custom_modifier_gungnir_buff:GetAllowEtherealAttack()
    return true
end

function custom_modifier_gungnir_buff:CheckState()
    return {
        [MODIFIER_STATE_CANNOT_MISS] = true
    }
end

function custom_modifier_gungnir_buff:OnStackCountChanged(old_count)
    if self:GetStackCount() <= 0 then self:Destroy() end
end