
custom_modifier_drow_ranger_marksmanship_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_marksmanship_aura:IsHidden()
    return true
end

function custom_modifier_drow_ranger_marksmanship_aura:IsDebuff()
    return false
end

function custom_modifier_drow_ranger_marksmanship_aura:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_drow_ranger_marksmanship_aura:OnCreated( kv )
    -- references
    self.radius = self:GetAbility():GetAOERadius()
    self.disable_radius = self:GetAbility():GetSpecialValueFor("disable_radius")
    self.enable_aura = true
    if IsServer() then
        self:SetHasCustomTransmitterData( true )
        self:StartIntervalThink(0.1)
    end
end

function custom_modifier_drow_ranger_marksmanship_aura:OnRefresh()
end

function custom_modifier_drow_ranger_marksmanship_aura:OnIntervalThink()
    local enemy_heroes = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),
        self:GetCaster():GetAbsOrigin(),
        nil,
        self.disable_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
        0,
        false 
    )
    if self.enable_aura ~= (enemy_heroes[1] == nil) then
        self.enable_aura = (enemy_heroes[1] == nil)
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_drow_ranger_marksmanship_aura:AddCustomTransmitterData()
    -- on server
    return {
        enable_aura = self.enable_aura
    }
end

function custom_modifier_drow_ranger_marksmanship_aura:HandleCustomTransmitterData( data )
    -- on client
    self.enable_aura = data.enable_aura
end

--------------------------------------------------------------------------------
-- Aura Effects
function custom_modifier_drow_ranger_marksmanship_aura:IsAura()
    return self.enable_aura
end

function custom_modifier_drow_ranger_marksmanship_aura:GetModifierAura()
    return "custom_modifier_drow_ranger_marksmanship_aura_effect"
end

function custom_modifier_drow_ranger_marksmanship_aura:GetAuraRadius()
    return self.radius
end

function custom_modifier_drow_ranger_marksmanship_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function custom_modifier_drow_ranger_marksmanship_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function custom_modifier_drow_ranger_marksmanship_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY 
end