modifier_generic_removed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_removed:IsDebuff()
    return true
end

function modifier_generic_removed:IsStunDebuff()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_removed:OnCreated( kv )
    if IsServer() then
        self:GetParent():AddNoDraw()
    end
end

function modifier_generic_removed:OnRefresh( kv )
end

function modifier_generic_removed:OnRemoved()
end

function modifier_generic_removed:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveNoDraw()
    end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_removed:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end
