
custom_tinker_mega_death_ray = class({})

LinkLuaModifier(
    "custom_modifier_tinker_mega_death_ray", 
    "heroes/tinker/modifiers/custom_modifier_tinker_mega_death_ray", 
    LUA_MODIFIER_MOTION_NONE 
)

LinkLuaModifier(
    "custom_modifier_tinker_mega_death_ray_burn", 
    "heroes/tinker/modifiers/custom_modifier_tinker_mega_death_ray_burn", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Ability Start
function custom_tinker_mega_death_ray:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:AddNewModifier(
        caster,
        self,
        "custom_modifier_tinker_mega_death_ray",
        {duration = self:GetSpecialValueFor("delay")}
    )
end

--------------------------------------------------------------------------------
-- Effects
function custom_tinker_mega_death_ray:PlayEffects()
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
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end