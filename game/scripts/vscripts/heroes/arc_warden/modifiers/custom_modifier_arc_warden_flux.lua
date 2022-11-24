arc_warden_flux_modifier = class ({})

function arc_warden_flux_modifier:OnCreated( event )
	local ability = self:GetAbility()
	self.tick_interval = ability:GetSpecialValueFor("think_interval")
	self.damage_per_second = ability:GetSpecialValueFor("damage_per_second") * self.tick_interval
	self.mute_radius = ability:GetSpecialValueFor("search_radius")
	self.slow = ability:GetSpecialValueFor("move_speed_slow_pc")
	self.enabled = true
	if IsServer() then
		self.damage_type = ability:GetAbilityDamageType()
	end
	self:StartIntervalThink(self.tick_interval) 
end

function arc_warden_flux_modifier:OnIntervalThink()
	if IsServer() and self.enabled == true then
		local target = self:GetParent()
		ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = self.damage_per_tick, damage_type = self.damage_type, ability = self:GetAbility()})
		local partcile = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field_b.vpcf", PATTACH_ROOTBONE_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(partcile)
	end
end

function arc_warden_flux_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_disruptor_kinetic_fieldslow.vpcf"
end

function arc_warden_flux_modifier:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
 
	return funcs
end

function arc_warden_flux_modifier:GetModifierMoveSpeedBonus_Percentage( event )
	if IsServer() then
		local target =  self:GetParent()
		if target:IsMagicImmune() then
			self:Destroy()
		else
			local group = FindUnitsInRadius(target:GetTeamNumber(), target:GetOrigin(), target, self.mute_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if group[2] ~= nil then
				self.enabled = false
			else
				self.enabled = true
			end
		end
		
	end
	if self.enabled == true then
		return -50
	else
		return 0
	end
end

function arc_warden_flux_modifier:IsHidden()
	return false
end

function arc_warden_flux_modifier:IsDebuff()
	return true
end

function arc_warden_flux_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end