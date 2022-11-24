custom_modifier_silver_edge_backstab_crit = class({})

function custom_modifier_silver_edge_backstab_crit:IsHidden()
    return true
end

function custom_modifier_silver_edge_backstab_crit:IsDebuff()
    return false
end

function custom_modifier_silver_edge_backstab_crit:IsPurgable() 
    return false 
end

function custom_modifier_silver_edge_backstab_crit:OnCreated( kv )
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
        self.crit = kv.crit
    end
end

function custom_modifier_silver_edge_backstab_crit:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED 
    }
end

function custom_modifier_silver_edge_backstab_crit:GetModifierPreAttack_CriticalStrike()
    if IsServer() then
        return self.crit
    end
end

-- Remove the crit modifier when the attack is concluded
function custom_modifier_silver_edge_backstab_crit:OnAttack(keys)
    if IsServer() then
        -- If this unit is the attacker, remove its crit modifier
        if self:GetParent() == keys.attacker then
            self:Destroy()
        end
    end
end

function custom_modifier_silver_edge_backstab_crit:OnAttackCancelled(keys)
    if IsServer() then
        -- If this unit is the attacker, remove its crit modifier
        if self:GetParent() == keys.attacker then
            self:Destroy()
        end
    end
end
