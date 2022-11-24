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
custom_modifier_lifestealer_infest_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_lifestealer_infest_buff:IsHidden()
	return false
end

function custom_modifier_lifestealer_infest_buff:IsDebuff()
	return false
end

function custom_modifier_lifestealer_infest_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_lifestealer_infest_buff:OnCreated( kv )
	if not IsServer() then return end
	if kv.duration ~= nil then
		self.ms_pct = 0
		self.bonus_health = 0
	else
		self.ms_pct = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
		self.bonus_health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	end

    self:SetHasCustomTransmitterData(true)
end

function custom_modifier_lifestealer_infest_buff:OnRefresh( kv )
	
end

function custom_modifier_lifestealer_infest_buff:OnRemoved()
end

function custom_modifier_lifestealer_infest_buff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function custom_modifier_lifestealer_infest_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS ,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end


function custom_modifier_lifestealer_infest_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_pct
end

function custom_modifier_lifestealer_infest_buff:GetModifierExtraHealthBonus()
	return self.bonus_health
end

function custom_modifier_lifestealer_infest_buff:OnDeath( event )
	if event.unit == self:GetParent() then
		local hmod = self:GetCaster():FindModifierByName("custom_modifier_lifestealer_infest")
		if hmod ~= nil then hmod:Destroy() end
	end
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_lifestealer_infest_buff:AddCustomTransmitterData()
    -- on server
    local data = {
        bonus_health = self.bonus_health,
        ms_pct = self.ms_pct
    }
    return data
end

function custom_modifier_lifestealer_infest_buff:HandleCustomTransmitterData( data )
    -- on client
    self.bonus_health = data.bonus_health
    self.ms_pct = data.ms_pct
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_lifestealer_infest_buff:GetEffectName()
	return "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
end

function custom_modifier_lifestealer_infest_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function custom_modifier_lifestealer_infest_buff:GetStatusEffectName()
	return "status/effect/here.vpcf"
end

function custom_modifier_lifestealer_infest_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function custom_modifier_lifestealer_infest_buff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end