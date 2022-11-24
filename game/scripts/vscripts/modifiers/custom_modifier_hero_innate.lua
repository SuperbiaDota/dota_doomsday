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
custom_modifier_hero_innate = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_hero_innate:IsHidden()
	return true
end

function custom_modifier_hero_innate:IsDebuff()
	return false
end

function custom_modifier_hero_innate:IsPurgable()
	return false
end

function custom_modifier_hero_innate:RemoveOnDeath()
	return false
end

function custom_modifier_hero_innate:AllowIllusionDuplicate()
    return true
end

function custom_modifier_hero_innate:OnCreated()
    self.position = self:GetCaster():GetAbsOrigin()
    self.lock = 0
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_hero_innate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		--MODIFIER_EVENT_ON_ORDER,
        --MODIFIER_PROPERTY_DISABLE_TURNING,
        --MODIFIER_EVENT_ON_UNIT_MOVED 
	}

	return funcs
end

function custom_modifier_hero_innate:GetModifierConstantHealthRegen()
	local default_regen = 0.1
	local target_regen = 0.03
	return -(self:GetParent():GetStrength() * (default_regen - target_regen))
end

function custom_modifier_hero_innate:GetModifierPreAttack_BonusDamage()
	return self:GetParent():GetStrength() / 3
end


--function custom_modifier_hero_innate:OnOrder( keys )
--	if not IsServer() or keys.unit ~= self:GetParent() then return end
--    --DebugPrint("Order Received")
--    --DebugPrintTable( keys )
--    if --keys.order_type == DOTA_UNIT_ORDER_NONE or
--        keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or
--        keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then 
--        self.lock = 1
--    else
--        self.lock = 0
--    end
--end
--
--function custom_modifier_hero_innate:OnUnitMoved( keys )
--    if not IsServer() or keys.unit ~= self:GetParent() then return end
--    if keys.new_pos ~= Vector(0,0,0) then
--        -- start turning
--        self.target_pos = keys.new_pos
--        self.turn_rate = 0.9
--        if not self.prev_time then self.prev_time = GameRules:GetGameTime() end
--        self:StartIntervalThink(TICK_RATE)
--    end
--end
--
--function custom_modifier_hero_innate:GetModifierDisableTurning()
--    return self.lock
--end

--------------------------------------------------------------------------------
-- Interval Think
--function custom_modifier_hero_innate:OnIntervalThink()
--    if IsServer() then
--        if self.target_pos == self.position then
--            self.prev_time = nil
--            self:StartIntervalThink(-1)
--            return
--        end
--
--        -- time
--        local dt = GameRules:GetGameTime() - self.prev_time
--        self.prev_time = GameRules:GetGameTime()
--
--        --print("time: " .. GameRules:GetGameTime() .. "; dt: " .. dt)
--        
--        -- vectors
--        local parent = self:GetParent()
--        local forward = parent:GetForwardVector()
--        local target_vec = (self.target_pos - self.position)
--        self.position = parent:GetAbsOrigin()
--        target_vec.z = 0
--        target_vec = target_vec:Normalized()
--        local cross = CrossVectors(forward, target_vec)
--
--        -- direction
--        local is_clockwise = cross.z < 0
--        local turn = self.turn_rate * dt / TICK_RATE
--        if is_clockwise then
--            turn = -turn
--        end
--        
--        -- rotate var forward by var turn along the z plane
--        local result = Vector(
--            forward.x * math.cos(turn) - forward.y * math.sin(turn),
--            forward.x * math.sin(turn) + forward.y * math.cos(turn),
--            0
--        )
--
--        if cross:Dot(CrossVectors(result, target_vec)) <= 0 then -- check if we overshot the target vector
--            parent:SetForwardVector(target_vec)
--            self.prev_time = nil
--            self:StartIntervalThink(-1)
--        else
--            parent:SetForwardVector(result)
--        end
--    end
--end