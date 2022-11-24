custom_zeus_thundergods_wrath = class({})
LinkLuaModifier("custom_modifier_zeus_vision_thinker", "abilities/zeus/custom_modifier_zeus_vision_thinker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("custom_modifier_zeus_thundergods_wrath_location_table", "abilities/zeus/custom_modifier_thundergods_wrath_aura.lua", LUA_MODIFIER_MOTION_NONE)

function custom_zeus_thundergods_wrath:GetCooldown()
    local base_cooldown = self.BaseClass.GetCooldown(self, (self:GetLevel()-1))

    if self:GetCaster():HasTalent("custom_zeus_special_bonus_unique_4") then
        return base_cooldown + self:GetCaster():FindTalentValue("custom_zeus_special_bonus_unique_4")
    else
        return base_cooldown
    end
end

function custom_zeus_thundergods_wrath:OnSpellStart()

    local caster = self:GetCaster()

    local heroTable = HeroList:GetAllHeroes()
    local casterTeam = caster:GetTeam()
    local vision_range = self:GetSpecialValueFor("sight_radius")
    local vision_duration = self:GetLevelSpecialValueFor("sight_duration", (self:GetLevel()-1))
    local damage = self:GetAbilityDamage()
    local damage_type  =self:GetAbilityDamageType()

    local locTable = {}

    for heroIndex=1, #heroTable do
        local otherHero = heroTable[heroIndex]
        if otherHero:GetTeam() ~= casterTeam then
            ApplyDamage(
                {
                    victim = otherHero, 
                    attacker = caster, 
                    damage = damage, 
                    damage_type = damage_type
                }
            )
            self:PlayEffectsVictim(otherHero)

            local point = otherHero:GetAbsOrigin()
            AddFOWViewer( casterTeam, point, vision_range, vision_duration, false )
            local mVisionThinker = CreateModifierThinker(
                caster,
                self,
                "custom_modifier_zeus_vision_thinker",
                {
                    radius = vision_range
                    duration = vision_duration
                },
                point,
                casterTeam,
                false
            )

            locTable[#locTable+1] = point
        end
    end

    caster:AddNewModifier(
        caster, -- player source
        self, -- ability source
        "custom_modifier_zeus_thundergods_wrath_location_table", -- modifier name
        {
            duration = vision_duration
            locations = locTable
        } -- kv
    )

    self:PlayEffectsCaster()
end

function custom_zeus_thundergods_wrath:PlayEffectsCaster()
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

function custom_zeus_thundergods_wrath:PlayEffectsVictim(target)
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