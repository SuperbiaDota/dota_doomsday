
custom_tinker_rearm = class({})

--------------------------------------------------------------------------------
-- Ability Start
function custom_tinker_rearm:OnSpellStart()
	-- self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Effects
function custom_tinker_rearm:PlayEffects()
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

--------------------------------------------------------------------------------
-- Ability Channeling

function custom_tinker_rearm:OnChannelFinish( bInterrupted )
    if not bInterrupted then
        for i=0, 15, 1 do
            local current_ability = self:GetCaster():GetAbilityByIndex(i)
            if current_ability ~= nil and current_ability:IsRefreshable() then 
                current_ability:EndCooldown()
            end
        end
        for i=0, 5, 1 do
            local current_item = self:GetCaster ():GetItemInSlot (i)
            if current_item ~= nil and current_item:IsRefreshable() then
                current_item:EndCooldown()
            end
        end
    end
end