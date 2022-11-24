custom_modifier_bloodthorn_silence = class({})

function custom_modifier_bloodthorn_silence:IsHidden()
    return false
end

function custom_modifier_bloodthorn_silence:IsDebuff()
    return true
end

function custom_modifier_bloodthorn_silence:IsPurgable()
    return true
end

function custom_modifier_bloodthorn_silence:OnCreated()
    if IsServer() then
        self.damage_amp = self:GetAbility():GetSpecialValueFor("damage_amp_pct") / 100
        self.total = 0
    end
end

function custom_modifier_bloodthorn_silence:OnRefresh()
end

function custom_modifier_bloodthorn_silence:OnRemoved()
    if not IsServer() then return end
    if self:GetRemainingTime() <= 0 then
        local damage_table = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage_amp * self.total,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            0,
            ability = self:GetAbility()
        }
    
        ApplyDamage(damage_table)
    end
end

function custom_modifier_bloodthorn_silence:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function custom_modifier_bloodthorn_silence:OnTakeDamage( event )
    if not IsServer() then return end
    if event.unit == self:GetParent() then
        self.total = self.total + event.damage
    end
end

function custom_modifier_bloodthorn_silence:CheckState()
    return {
        [MODIFIER_STATE_SILENCED] = true
    }
end