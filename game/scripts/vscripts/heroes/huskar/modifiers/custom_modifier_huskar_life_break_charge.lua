
--------------------------------------------------------------------------------
custom_modifier_huskar_life_break_charge = class({})
local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_huskar_life_break_charge:IsHidden()
	return false
end

function custom_modifier_huskar_life_break_charge:IsDebuff()
	return false
end

function custom_modifier_huskar_life_break_charge:IsStunDebuff()
	return false
end

function custom_modifier_huskar_life_break_charge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_huskar_life_break_charge:OnCreated( kv )

	local ability = self:GetAbility()
	-- references
	self.speed = ability:GetSpecialValueFor( "charge_speed" )	
	self.slow_duration = ability:GetSpecialValueFor("move_slow_duration")
	self.heal_duration = ability:GetSpecialValueFor("heal_duration")
	self.heal_mult = ability:GetSpecialValueFor("heal_mult")

	self.damage_pct = ability:GetLevelSpecialValueFor( "damage_target_pct", ability:GetLevel()-1 ) / 100
	self.cost_pct = ability:GetLevelSpecialValueFor( "damage_self_pct", ability:GetLevel()-1 ) / 100

	self.close_distance = 80
	self.far_distance = 1450

	if IsServer() then
		self.target = tempTable:RetATValue( kv.target )

		-- basic purge
		self:GetParent():Purge( false, true, false, false, false )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function custom_modifier_huskar_life_break_charge:OnRefresh( kv )
	
end

function custom_modifier_huskar_life_break_charge:OnRemoved()
end

function custom_modifier_huskar_life_break_charge:OnDestroy()
	if IsServer() then
		-- IMPORTANT: this is a must, or else the game will crash!
		self:GetParent():InterruptMotionControllers( true )

		if not self.success then return end

		-- percentage enemy damage
		local damageTable = {
			victim = self.target,
			attacker = self:GetCaster(),
			damage = self.damage_pct * self.target:GetHealth(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
		local damage_dealt = ApplyDamage(damageTable)

		-- percentage self damage
		damageTable.victim = self:GetCaster()
		damageTable.damage = self.cost_pct * self:GetCaster():GetHealth()
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		ApplyDamage(damageTable)

		-- apply debuff
		self.target:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"custom_modifier_huskar_life_break_slow", -- modifier name
			{ duration = self.slow_duration } -- kv
		)

		-- play effects
		self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function custom_modifier_huskar_life_break_charge:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function custom_modifier_huskar_life_break_charge:UpdateHorizontalMotion( me, dt )
	local origin = self:GetParent():GetOrigin()

	if not self.target:IsAlive() then
		self:EndCharge( false )
	end

	-- get direction
	local direction = self.target:GetOrigin() - origin
	direction.z = 0
	local distance = direction:Length2D()
	direction = direction:Normalized()

	-- stop if close to target or too far
	if distance<self.close_distance then
		self:EndCharge( true )
	elseif distance>self.far_distance then
		self:EndCharge( false )
	end

	-- move towards direction
	local target = origin + direction * self.speed * dt
	self:GetParent():SetOrigin( target )

	-- face towards target
	self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function custom_modifier_huskar_life_break_charge:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function custom_modifier_huskar_life_break_charge:EndCharge( success )
	-- cancel debuff if linken
	if success and (not self.target:TriggerSpellAbsorb(self:GetAbility())) then
		self.success = true
	end
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function custom_modifier_huskar_life_break_charge:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_life_break.vpcf"
	local sound_target = "Hero_Huskar.Life_Break.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self.target )
end
