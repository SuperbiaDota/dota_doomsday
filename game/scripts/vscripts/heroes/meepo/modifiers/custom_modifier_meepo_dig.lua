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
custom_modifier_meepo_dig = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_meepo_dig:IsHidden()
	return false
end

function custom_modifier_meepo_dig:IsDebuff()
	return false
end

function custom_modifier_meepo_dig:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_meepo_dig:OnCreated( kv )
	-- references
	self.heal_pct = kv.heal_pct
    self.target = kv.target
    self.point = Vector(kv.point_x, kv.point_y, kv.point_z)
    if IsServer() then
        self:GetParent():AddNoDraw()
        self:GetParent().dig_lock = true
    end
end

function custom_modifier_meepo_dig:OnRefresh( kv )
	self:OnCreated(kv)
end

function custom_modifier_meepo_dig:OnRemoved()
end

function custom_modifier_meepo_dig:OnDestroy()
	if IsServer() then
        self:GetParent():RemoveNoDraw()
        self:GetParent().dig_lock = nil
        local ult_ability = self:GetParent():FindAbilityByName("custom_meepo_divided_we_stand")
        local nearest_clone = self.target
        if not nearest_clone then
            nearest_clone = ult_ability:FindNearestMeepo(self.point)
        end
        FindClearSpaceForUnit(self:GetParent(), nearest_clone:GetAbsOrigin(), true)
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_meepo_dig:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true
	}
end

function custom_modifier_meepo_dig:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_HEAL_RECEIVED,
    }
end

function custom_modifier_meepo_dig:OnHealReceived( params )
    if IsServer() then
        local parent = self:GetParent()
        local ult = parent:FindAbilityByName("custom_meepo_divided_we_stand")
        if ult.other_meepos[params.unit] ~= nil and not params.unit.dig_lock then
            parent:Heal(params.gain * self.heal_pct, self:GetAbility())
        end
    end
end
