-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_generic_bash_resistance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_bash_resistance:IsHidden()
	return false
end

function modifier_generic_bash_resistance:IsDebuff()
	return false
end

function modifier_generic_bash_resistance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_bash_resistance:OnCreated( kv )
    if IsServer() then
        self:SetDuration( math.max(self:GetRemainingTime(), kv.duration), false )
        
        -- add stack modifier
        local this = tempTable:AddATValue( self )
        self:GetParent():AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_bash_resistance_stack", -- modifier name
            {
                duration = kv.duration,
                modifier = this,
            } -- kv
        )

        -- increment stack
        self:IncrementStackCount()
end

function modifier_generic_bash_resistance:OnRefresh( kv )
    if IsServer() then
        self:SetDuration( math.max(self:GetRemainingTime(), kv.duration), false )

        -- add stack
        local this = tempTable:AddATValue( self )
        self:GetParent():AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_bash_resistance_stack", -- modifier name
            {
                duration = kv.duration,
                modifier = this,
            } -- kv
        )
        
        -- increment stack
        self:IncrementStackCount()
    end
end

function modifier_generic_bash_resistance:OnRemoved()
end

function modifier_generic_bash_resistance:OnDestroy()
end

--------------------------------------------------------------------------------
-- Unique
function modifier_generic_bash_resistance:GetBashReduction()
	return 1 - 0.8 ^ self:GetStackCount() 
end
