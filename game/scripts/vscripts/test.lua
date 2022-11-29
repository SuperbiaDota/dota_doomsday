item_crit_item = class({})
LinkLuaModifier("modifier_item_crit_item", "items/item_crit_item", LUA_MODIFIER_MOTION_NONE)
function item_crit_item:GetIntrinsicModifierName() return "modifier_item_crit_item" end

--============

modifier_item_crit_item = class({})
function modifier_item_crit_item:IsHidden() return true end
function modifier_item_crit_item:IsPermanent() return true end

function modifier_item_crit_item:OnCreated() 
    if IsServer() then
        self.crits = {}
    end 
end

function modifier_item_crit_item:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_RECORD,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_item_crit_item:OnAttackRecord(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end
    self.crits[keys.record] = true
end

function modifier_item_crit_item:OnAttackRecordDestroy(keys)
    if IsServer() then
        self.crits[keys.record] = nil
    end
end

function modifier_item_crit_item:GetModifierPreAttack_CriticalStrike(keys) 
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end
    self.crits[keys.record] = nil
end

function modifier_item_crit_item:OnAttackLanded(keys)
    if not IsServer() then return end
    if keys.attacker ~= self:GetParent() then return end

    if self.crits[keys.record] then
        print("crit landed")
    end
end

