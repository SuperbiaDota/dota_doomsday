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
custom_meepo_dig = class({})
LinkLuaModifier( 
    "custom_modifier_meepo_dig", 
    "heroes/meepo/modifiers/custom_modifier_meepo_dig",
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_meepo_dig:CastFilterResultTarget( hTarget )
	if hTarget:GetUnitName() ~= self:GetCaster():GetUnitName() then -- TODO: change this so you cant poof to illusions
		return UF_FAIL_CUSTOM
	end
    return UF_SUCCESS

	--local nResult = UnitFilter(
	--	hTarget,
	--	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	--	DOTA_UNIT_TARGET_HERO,
	--	0,
	--	self:GetCaster():GetTeamNumber()
	--)
	--if nResult ~= UF_SUCCESS then
	--	return nResult
	--end

	--return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_meepo_dig:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- load data
	local dig_duration = self:GetSpecialValueFor( "duration" )
    local heal_pct = self:GetSpecialValueFor( "heal_pct" ) / 100

	-- logic
    caster:AddNewModifier(
        caster,
        self,
        "custom_modifier_meepo_dig",
        {
            duration = dig_duration,
            heal_pct = heal_pct,
            target = target,
            point_x = point.x,
            point_y = point.y,
            point_z = point.z
        }
    )
end

--------------------------------------------------------------------------------
-- Effects
function custom_meepo_dig:PlayEffects()
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
