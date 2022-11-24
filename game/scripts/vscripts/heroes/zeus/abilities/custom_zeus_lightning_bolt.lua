custom_zeus_lightning_bolt = class({})
LinkLuaModifier("custom_modifier_zeus_vision_thinker", "abilities/zeus/custom_modifier_zeus_vision_thinker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("custom_modifier_zeus_thundergods_wrath_location_table", "abilities/zeus/custom_modifier_thundergods_wrath_aura.lua", LUA_MODIFIER_MOTION_NONE)

function custom_zeus_lightning_bolt:CastFilterResultLocation(targetPoint)
    local caster = self:GetCaster()

    if (targetPoint - caster:GetAbsOrigin()):Length2D() <= radius then
        return UF_SUCCESS
    end

    local mTable = caster:FindAllModifiersByName("custom_modifier_zeus_thundergods_wrath_location_table")
    local radius = caster:FindAbilityByName("custom_zeus_thundergods_wrath"):GetLevelSpecialValueFor("sight_radius", (ability:GetLevel()-1))

    for i=1, #mTable do
        local locTable = mTable[i].locations
        for j=1, #locTable do
            local location = locTable[j]
            local vector_distance = targetPoint - location
            local distance = (vector_distance):Length2D()
            if distance <= radius then
                return UF_SUCCESS
            end
        end
    end

    return UF_FAIL_CUSTOM
end

function custom_zeus_lightning_bolt:CastFilterResultTarget(target)
    return custom_zeus_lightning_bolt:CastFilterResultLocation(target:GetAbsOrigin())
end

function custom_zeus_lightning_bolt:OnSpellStart()

    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    if target == nil then
        local radius = self:GetSpecialValueFor("search_radius")

        local SearchInfo = {
            caster = caster,
            ability = self,
            point = point,
            radius = radius,
            prioritize_heroes 	= true
        }
        target = SearchArea(SearchInfo)[1]
    end

    if target ~= nil then
        point = target:GetAbsOrigin()
        
        local stun_duration = self:GetSpecialValueFor("stun_duration")
        if caster:HasTalent("custom_zeus_special_bonus_unique_2") then
            stun_duration = stun_duration + caster:FindTalentValue("custom_zeus_special_bonus_unique_2")
        end

        target:AddNewModifier(caster, ability, "modifier_stun", {duration = stun_duration})
		ApplyDamage(
            {
                victim = target,
                attacker = caster, 
                damage = ability:GetAbilityDamage(), 
                damage_type = ability:GetAbilityDamageType()
            }
        )
        
        point.z = point.z + target:GetBoundingMaxs().z -- place particle on unit's head
        local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
    else
        local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    end

    ParticleManager:SetParticleControl(particle, 0, point)
    ParticleManager:SetParticleControl(particle, 1, Vector(point.x,point.y,1000))
    ParticleManager:SetParticleControl(particle, 2, point)

    CreateModifierThinker(
        caster,
        self,
        "custom_modifier_zeus_vision_thinker",
        {
            radius = self:GetSpecialValueFor("sight_radius")
            duration = self:GetSpecialValueFor("sight_duration")
        },
        point,
        caster:GetTeam(),
        false
    )

    self:PlayEffects()
    
end

function custom_zeus_lighting_bolt:PlayEffects()
    -- Get Resources
    local particle_cast = "string"
    local sound_cast = "string"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
    local attach = "attach_hitloc"
    if self:GetCaster():ScriptLookupAttachment( "attach_attack3" ) then attach = "attach_attack3" end
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        iControlPoint,
        hTarget,
        PATTACH_POINT_FOLLOW,
        attach,
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
    EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
    EmitSoundOn( sound_cast, self:GetCaster() )
end