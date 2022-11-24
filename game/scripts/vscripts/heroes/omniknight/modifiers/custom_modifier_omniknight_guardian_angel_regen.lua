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
modifier_template = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_template:IsHidden()
    return false
end

function modifier_template:IsDebuff()
    return false
end

function modifier_template:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_template:OnCreated( kv )
    -- references
    self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

function modifier_template:OnRefresh( kv )
    self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

function modifier_template:OnRemoved()
end

function modifier_template:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_template:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT ,
    }

    return funcs
end


function modifier_template:GetModifierConstantHealthRegen()
    return self.hp_regen
end
