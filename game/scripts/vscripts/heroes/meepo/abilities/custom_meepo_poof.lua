
custom_meepo_poof = class({})

--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_meepo_poof:CastFilterResultTarget( hTarget )
    if hTarget:GetUnitName() ~= self:GetCaster():GetUnitName() then -- TODO: change this so you cant poof to illusions
        return UF_FAIL_CUSTOM -- TODO: check to see if failure will auto change to ground targeting
    end

    --local nResult = UnitFilter(
    --  hTarget,
    --  DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    --  DOTA_UNIT_TARGET_HERO,
    --  0,
    --  self:GetCaster():GetTeamNumber()
    --)
    --if nResult ~= UF_SUCCESS then
    --  return nResult
    --end

    return UF_SUCCESS
end

function custom_meepo_poof:OnAbilityPhaseStart()
    -- play poof sound/effects
end

--------------------------------------------------------------------------------
-- Ability Start
function custom_meepo_poof:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local point = self:GetCursorPosition()

    -- load data
    local damage = self:GetSpecialValueFor( "poof_damage" )
    local radius = self:GetSpecialValueFor( "radius" )

    if not target then
        local ult_ability = self:GetCaster():FindAbilityByName("custom_meepo_divided_we_stand")
        target = ult_ability:FindNearestMeepo(point)
    end

    local damage_table = {
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }

    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        0,
        0,
        false
    )
    for _, enemy in pairs(enemies) do
        damage_table.victim = enemy
        ApplyDamage(damage_table)
    end

    -- teleport
    FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin(), true)
    
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        0,
        0,
        false
    )
    for _, enemy in pairs(enemies) do
        damage_table.victim = enemy
        ApplyDamage(damage_table)
    end
end

--------------------------------------------------------------------------------
-- Effects
function custom_meepo_poof:PlayEffects()
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
