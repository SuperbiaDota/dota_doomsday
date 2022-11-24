modifier_custom_arc_warden_reincarnate = class({})

function modifier_custom_arc_warden_reincarnate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
		-- MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_custom_arc_warden_reincarnate:ReincarnateTime( params )
	if IsServer() then
		-- if self:IsDouble then return 0 end
		if self:GetAbility():GetLevel() >= 1  and self:Reincarnate() then
			return self.reincarnate_time
		end
		return 0
	end
end

function modifier_custom_arc_warden_reincarnate:Reincarnate()
	local main_hero = self:GetParent()
	local hmod = main_hero:FindModifierByName("modifier_custom_arc_warden_double_handle")
	if hmod ~= nil then
		local double = hmod.handle
		if double and double:IsAlive() then
			local double_pos = double:GetOrigin()
			double:ForceKill()
			FindClearSpaceForUnit(main_hero, double_pos, true)

			-- play effects
			--self:PlayEffects()

			return true
		end
	end
	return false
end

function modifier_custom_arc_warden_reincarnate:IsDouble()
	return self:GetParent():FindModifierByName("modifier_custom_arc_warden_tempest_double") ~= nil
end