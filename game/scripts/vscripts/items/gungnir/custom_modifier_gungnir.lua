custom_modifier_gungnir = class({})

function custom_modifier_gungnir:IsHidden()
    return true
end

function custom_modifier_gungnir:IsPurgable()
    return false
end

function custom_modifier_gungnir:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_gungnir:RemoveOnDeath() 
    return false 
end

function custom_modifier_gungnir:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage_bonus")
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.proc_chance = self:GetAbility():GetSpecialValueFor("proc_chance")
    self.proc_damage = self:GetAbility():GetSpecialValueFor("proc_damage")

    self.records = {}
end

function custom_modifier_gungnir:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,

        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_RECORD,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY
    }
end

function custom_modifier_gungnir:GetModifierPreAttack_BonusDamage()
    return self.damage
end

function custom_modifier_gungnir:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

function custom_modifier_gungnir:GetModifierProcAttack_BonusDamage_Magical( event )
    if not IsServer() or self.lock then return end

    if self.records[event.record] then
        self.records[event.record] = nil

        -- overhead event
        SendOverheadEventMessage(
            nil, --DOTAPlayer sendToPlayer,
            OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
            event.target,
            self.proc_damage * (1 + self:GetParent():GetSpellAmplification(false)),
            self:GetParent():GetPlayerOwner() -- DOTAPlayer sourcePlayer
        )

        return self.proc_damage
    end
end

function custom_modifier_gungnir:OnAttackStart( event )
    self.true_strike = RollPseudoRandomPercentage(self.proc_chance, self:GetAbility():entindex(), self:GetCaster()) 
        and not event.target:IsBuilding()
end

function custom_modifier_gungnir:OnAttackRecord( event )
    if event.attacker == self:GetParent() and self.true_strike and not self:GetParent():IsIllusion() then
        self.records[event.record] = true
    end
end

function custom_modifier_gungnir:OnAttackRecordDestroy( event )
    self.records[event.record] = nil
end

function custom_modifier_gungnir:CheckState()
    if self.true_strike then
        return {
            [MODIFIER_STATE_CANNOT_MISS] = true
        }
    end
end

