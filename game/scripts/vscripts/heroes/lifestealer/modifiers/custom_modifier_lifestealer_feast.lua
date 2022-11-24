custom_modifier_lifestealer_feast = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_lifestealer_feast:IsHidden()
	return true
end

function custom_modifier_lifestealer_feast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_feast:OnCreated( kv )
	-- references
	local ability = self:GetAbility()
	self.leech_percent = ability:GetLevelSpecialValueFor( "hp_leech_percent", ability:GetLevel()-1 )/100 
end

function custom_modifier_lifestealer_feast:OnRefresh( kv )
	-- references
	local ability = self:GetAbility()
	self.leech_percent = ability:GetLevelSpecialValueFor( "hp_leech_percent", ability:GetLevel()-1 )/100 
end

function custom_modifier_lifestealer_feast:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_lifestealer_feast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function custom_modifier_lifestealer_feast:GetModifierProcAttack_BonusDamage_Physical( params )
	if not IsServer() then return end

	local nResult = UnitFilter(
		params.target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		self:GetParent():GetTeamNumber()
	)
	if nResult == UF_SUCCESS and params.target:GetUnitName() ~= "npc_dota_roshan" then
		-- leech
		local leech = params.target:GetHealth() * self.leech_percent
		if self:GetParent():IsIllusion() == true then leech = 0 end
		self:GetParent():Heal( leech, self:GetParent() )
		self:PlayEffects()
		return leech
	else 
		return 0
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function custom_modifier_lifestealer_feast:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function custom_modifier_lifestealer_feast:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

function custom_modifier_lifestealer_feast:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
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