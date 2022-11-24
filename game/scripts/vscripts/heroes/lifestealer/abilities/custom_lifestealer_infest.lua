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
custom_lifestealer_infest = class({})
LinkLuaModifier( "custom_modifier_lifestealer_infest", 
	"heroes/lifestealer/modifiers/custom_modifier_lifestealer_infest.lua", 
	LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "custom_modifier_lifestealer_infest_buff", 
	"heroes/lifestealer/modifiers/custom_modifier_lifestealer_infest_buff.lua", 
	LUA_MODIFIER_MOTION_NONE 
)
LinkLuaModifier( "custom_modifier_lifestealer_infest_dominate", 
	"heroes/lifestealer/modifiers/custom_modifier_lifestealer_infest_dominate.lua", 
	LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Init Abilities
function custom_lifestealer_infest:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_custom_lifestealer_infest.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_custom_lifestealer_infest/custom_lifestealer_infest.vpcf", context )
end

--------------------------------------------------------------------------------
-- Custom KV

function custom_lifestealer_infest:GetCooldown()
	local caster = self:GetCaster()
	local base_cooldown = self.BaseClass.GetCooldown( self, self:GetLevel()-1 )
	return base_cooldown
	--[[
	if caster:HasTalent("custom_lifestealer_special_bonus_unique_5") then
		return base_cooldown + caster:FindTalentValue( "custom_lifestealer_special_bonus_unique_5" )
	else
		return base_cooldown
	end
	--]]
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_lifestealer_infest:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- TODO(jason): is basic just creep + mechanical?
		DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function custom_lifestealer_infest:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_lifestealer_infest:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	caster:AddNoDraw()
	caster:Purge( true, true, false, false, false )

	-- disjoint projectiles
	ProjectileManager:ProjectileDodge( caster )

	-- set duration if enemy hero
	local duration = nil
	if target:GetTeamNumber() ~= caster:GetTeamNumber() and target:IsHero() then
		duration = self:GetLevelSpecialValueFor("infest_duration_enemy", self:GetLevel()-1)
	end

	-- add modifier to lifestealer
	local hmod_infest = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"custom_modifier_lifestealer_infest", -- modifier name
		{duration = duration} -- kv
	)
	hmod_infest.infested_unit = target
	
	-- dominate and select if creep
	if not target:IsHero() then
        if true then --target:CanBeDominated() then-- TODO: implement this in util
            target:AddNoDraw()
            local temp = CreateUnitByName(
                target:GetUnitName(),
                target:GetAbsOrigin(),
                false,
                caster,
                caster,
                caster:GetTeam()
            )
            target:ForceKill(false) -- TODO: turn off death effects how?
            target = temp

		    target:AddNewModifier(
		    	caster, -- player source
		    	self, -- ability source
		    	"custom_modifier_lifestealer_infest_dominate", -- modifier name
		    	{} -- kv
		    )
            target:AddAbility("custom_lifestealer_consume") -- TODO: set this to R
            PlayerResource:NewSelection(caster:GetPlayerOwnerID(), target)
        end
	end

	-- add buff to target
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"custom_modifier_lifestealer_infest_buff", -- modifier name
		{ 
			duration = duration
		} -- kv
	)

	-- replace infest with consume
	if not caster:HasAbility("custom_lifestealer_consume") then
        local consume = caster:AddAbility("custom_lifestealer_consume")
        consume:SetLevel(1)
    end
	caster:SwapAbilities( 
		"custom_lifestealer_consume",
		"custom_lifestealer_infest",
		true,
		false
	)
end

--------------------------------------------------------------------------------
-- Effects
function custom_lifestealer_infest:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end
