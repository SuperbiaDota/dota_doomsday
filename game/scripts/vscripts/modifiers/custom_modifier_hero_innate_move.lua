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
custom_modifier_hero_innate_move = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_hero_innate_move:IsHidden()
    return true
end

function custom_modifier_hero_innate_move:IsDebuff()
    return false
end

function custom_modifier_hero_innate_move:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_hero_innate_move:OnCreated( kv )
    -- references
    
end

function custom_modifier_hero_innate_move:OnRefresh( kv )
    
end

function custom_modifier_hero_innate_move:OnRemoved()
end

function custom_modifier_hero_innate_move:OnDestroy()
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_hero_innate_move:AddCustomTransmitterData()
    -- on server
    local data = {
        value = self.value
    }

    return data
end

function custom_modifier_hero_innate_move:HandleCustomTransmitterData( data )
    -- on client
    self.value = data.value
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_hero_innate_move:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function custom_modifier_hero_innate_move:OnAttack( params )

end

function custom_modifier_hero_innate_move:GetModifierMoveSpeedBonus_Percentage()
    return -100
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_hero_innate_move:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_hero_innate_move:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Motion Effects
function custom_modifier_hero_innate_move:UpdateHorizontalMotion( me, dt )

end

function custom_modifier_hero_innate_move:OnHorizontalMotionInterrupted()
end
