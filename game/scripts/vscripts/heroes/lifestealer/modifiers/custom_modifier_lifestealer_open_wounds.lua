custom_modifier_lifestealer_open_wounds = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_lifestealer_open_wounds:IsHidden()
	return false
end

function custom_modifier_lifestealer_open_wounds:IsDebuff()
	return true
end

function custom_modifier_lifestealer_open_wounds:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_open_wounds:OnCreated( kv )
	-- references
	self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" )/100 -- special value
	self.step = 1

	-- Start interval
	self:StartIntervalThink( 1 )
end

function custom_modifier_lifestealer_open_wounds:OnRefresh( kv )
	-- references
	self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" )/100 -- special value
	self.step = 1
end

function custom_modifier_lifestealer_open_wounds:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_lifestealer_open_wounds:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function custom_modifier_lifestealer_open_wounds:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then
		return self:GetAbility():GetLevelSpecialValueFor( "slow_steps", self.step )
	end
end

function custom_modifier_lifestealer_open_wounds:OnTakeDamage( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end
		if params.attacker:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then return end

		-- heal
		params.attacker:Heal( self.heal * params.damage, self:GetCaster() )

		-- play effects
		self:PlayEffects( params.attacker )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function custom_modifier_lifestealer_open_wounds:OnIntervalThink()
	self.step = self.step + 1
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_lifestealer_open_wounds:GetEffectName()
	return "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf"
end

function custom_modifier_lifestealer_open_wounds:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_lifestealer_open_wounds:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	-- ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	-- ParticleManager:SetParticleControlEnt(
	-- 	effect_cast,
	-- 	iControlPoint,
	-- 	hTarget,
	-- 	PATTACH_NAME,
	-- 	"attach_name",
	-- 	vOrigin, -- unknown
	-- 	bool -- unknown, true
	-- )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end