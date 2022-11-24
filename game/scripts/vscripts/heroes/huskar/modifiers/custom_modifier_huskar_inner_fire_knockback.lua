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
custom_modifier_huskar_inner_fire_knockback = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_inner_fire_knockback:IsHidden()
	return false
end

function custom_modifier_huskar_inner_fire_knockback:IsDebuff()
	return true
end

function custom_modifier_huskar_inner_fire_knockback:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_inner_fire_knockback:OnCreated( kv )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )

	if not IsServer() then return end

	self.center = self:GetCaster():GetOrigin()
	self.origin = self:GetParent():GetOrigin()
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function custom_modifier_huskar_inner_fire_knockback:OnRefresh( kv )
	
end

function custom_modifier_huskar_inner_fire_knockback:OnRemoved()
end

function custom_modifier_huskar_inner_fire_knockback:OnDestroy()
end

--------------------------------------------------------------------------------
-- Motion Effects
function custom_modifier_huskar_inner_fire_knockback:UpdateHorizontalMotion( me, dt )
	local new_origin = self:GetParent():GetOrigin()

	-- get direction

	local direction = self.origin - self.center
    direction.z = 0
    local distance = direction:Length2D()
	direction = direction:Normalized()
	local target_point = self.center + self.knockback_distance * direction
	local target_distance = self.knockback_distance - distance

	-- move towards direction
	local target = new_origin + direction * target_distance * dt
	self:GetParent():SetOrigin( target )
end

function custom_modifier_huskar_inner_fire_knockback:OnHorizontalMotionInterrupted()
	self:Destroy()
end
