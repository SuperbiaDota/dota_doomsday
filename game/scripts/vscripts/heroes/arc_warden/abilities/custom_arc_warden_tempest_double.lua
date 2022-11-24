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
custom_arc_warden_tempest_double = class({})
LinkLuaModifier( "modifier_custom_arc_warden_tempest_double", "heroes/arc_warden/modifiers/modifier_custom_arc_warden_tempest_double.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Init Abilities
function custom_arc_warden_tempest_double:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_template.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_template/template.vpcf", context )
end


-- just make a modifier that has a handle to the active tempest double

-- tp to tempest double if talent
--------------------------------------------------------------------------------
-- Ability Start
function custom_arc_warden_tempest_double:OnSpellStart()

	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()

	-- destroy old tempest doubles on resummon
	local mod_double = caster:FindModifierByName(self:GetIntrinsicModifierName())
	if mod_double.handle:IsAlive() then mod_double.handle:ForceKill() end

	local double = CreateUnitByName(
		caster:GetUnitName(),
		spawn_location,
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)

	mod_double.handle = double
	double:SetControllableByPlayer(caster:GetPlayerID(), true)

	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		double:HeroLevelUp(false)
	end

	for ability_id = 0, 15 do
		local ability = double:GetAbilityByIndex(ability_id)
		if ability then
			
			ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
			if ability:GetName() == "arc_warden_tempest_double" then
				ability:SetActivated(false)
			end
		end
	end


	for item_id = 0, 5 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if ( item_in_caster ~= nil and not ( item_in_caster:IsConsumable() or item_in_caster:DropsOnDeath() ) ) then
			local item_created = CreateItem( item_in_caster:GetName(), double, double)
			double:AddItem(item_created)
			item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges())
		end
	end

	double:SetHealth(caster:GetHealth())
	double:SetMana(caster:GetMana())

	--[[
	double:SetMaximumGoldBounty(0)
	double:SetMinimumGoldBounty(0)
	double:SetDeathXP(0)
	--]]

	double:SetAbilityPoints(0) 

	double:SetHasInventory(false)
	double:SetCanSellItems(false)

	double:AddNewModifier(caster, self, "arc_warden_tempest_double_modifier", nil)
end

function custom_arc_warden_tempest_double:GetIntrinsicModifierName()
	return "modifier_custom_arc_warden_double_handle"
end

-- assumes there's only one double
function custom_arc_warden_tempest_double:FindDouble() 
	local caster = self:GetCaster()
	controlled_units = caster:GetChildren()
	for i=0, #controlled_units do
		if caster:GetUnitName() == controlled_units[i]:GetUnitName() then
			return controlled_units[i]
		end
	end

	return nil
end

--------------------------------------------------------------------------------
-- Effects
function custom_arc_warden_tempest_double:PlayEffects()
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