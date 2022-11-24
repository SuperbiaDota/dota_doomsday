custom_modifier_silver_edge_backstab = class({})

function custom_modifier_silver_edge_backstab:IsHidden()
    return false
end

function custom_modifier_silver_edge_backstab:IsDebuff()
    return true
end

function custom_modifier_silver_edge_backstab:IsPurgable() 
    return false 
end

function custom_modifier_silver_edge_backstab:OnCreated( kv )
    self.crit = self:GetAbility():GetSpecialValueFor("backstab_crit")
    EmitSoundOn("sounds/items/silver_edge_target.vsnd", self:GetParent())
end

function custom_modifier_silver_edge_backstab:OnRefresh()
   EmitSoundOn("sounds/items/silver_edge_target.vsnd", self:GetParent())
end

-- State
function custom_modifier_silver_edge_backstab:CheckState()
    return {
        [MODIFIER_STATE_EVADE_DISABLED] = true
    }
end

-- Declare modifier events/properties
function custom_modifier_silver_edge_backstab:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function custom_modifier_silver_edge_backstab:OnAttackStart( keys )
    if IsServer() then
        if self:GetParent() == keys.target then
            keys.attacker:AddNewModifier(
                self:GetCaster(),
                self:GetAbility(),
                "custom_modifier_silver_edge_backstab_crit",
                {crit = self.crit}
            )
        end
    end
end

function custom_modifier_silver_edge_backstab:GetEffectName()
    return "particles/items3_fx/silver_edge.vpcf"
end