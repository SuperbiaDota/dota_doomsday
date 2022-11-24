custom_modifier_lifestealer_infest_dominate = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_lifestealer_infest_dominate:IsHidden()
	return true
end

function custom_modifier_lifestealer_infest_dominate:IsDebuff()
	return false
end

function custom_modifier_lifestealer_infest_dominate:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_infest_dominate:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local base_ms = caster:GetBaseMoveSpeed()

		-- set controllable
		parent:SetTeam( caster:GetTeamNumber() )
		parent:SetOwner( caster )
		parent:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )

		-- set base ms to match LS's modified ms
		parent:SetBaseMoveSpeed(caster:GetMoveSpeedModifier(base_ms, true))
	end
end

function custom_modifier_lifestealer_infest_dominate:OnRefresh( kv )
	
end

--[[
--------------------------------------------------------------------------------
-- Modifier Functions
function custom_modifier_lifestealer_infest_dominate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED
	}
	return funcs
end

function custom_modifier_lifestealer_infest_dominate:OnUnitMoved()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	caster:SetForwardVector(parent:GetForwardVector())
end
]]

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_lifestealer_infest_dominate:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true,
	}

	return state
end
