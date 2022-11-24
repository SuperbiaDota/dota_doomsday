custom_modifier_lifestealer_rage = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_lifestealer_rage:IsHidden()
	return false
end

function custom_modifier_lifestealer_rage:IsDebuff()
	return false
end

function custom_modifier_lifestealer_rage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_rage:OnCreated( kv )
	-- references
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "movement_speed_bonus" ) -- special value
	if IsServer() then
		self:PlayEffects()
	end
end

function custom_modifier_lifestealer_rage:OnRefresh( kv )
	-- references
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "movement_speed_bonus" ) -- special value
end

function custom_modifier_lifestealer_rage:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_lifestealer_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE ,
	}

	return funcs
end

function custom_modifier_lifestealer_rage:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_lifestealer_rage:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_lifestealer_rage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	-- assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_cast)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end