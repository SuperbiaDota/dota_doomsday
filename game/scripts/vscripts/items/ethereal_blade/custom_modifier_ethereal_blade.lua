custom_modifier_ethereal_blade = class({})

function custom_modifier_ethereal_blade:IsHidden()
    return true 
end

function custom_modifier_ethereal_blade:IsPurgable() 
    return false 
end

function custom_modifier_ethereal_blade:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_ethereal_blade:RemoveOnDeath() 
    return false 
end

function custom_modifier_ethereal_blade:OnCreated()
    if not IsServer() then return end

    local item = self:GetAbility()
    if not item then self:Destroy() end

    
    self.agi = item:GetSpecialValueFor("bonus_agility")
    self.str = item:GetSpecialValueFor("bonus_strength")
    self.intel = item:GetSpecialValueFor("bonus_intellect")

    local attribute_lut = {
        [DOTA_ATTRIBUTE_STRENGTH] = "str",
        [DOTA_ATTRIBUTE_AGILITY] = "agi",
        [DOTA_ATTRIBUTE_INTELLECT] = "intel"
    }

    local primary_attribute = attribute_lut[self:GetParent():GetPrimaryAttribute()]
    self[primary_attribute] = self[primary_attribute] + item:GetSpecialValueFor("bonus_primary_attribute")

    self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_ethereal_blade:AddCustomTransmitterData()
    -- on server
    return {
        agi = self.agi,
        str = self.str,
        intel = self.intel
    }
end

function custom_modifier_ethereal_blade:HandleCustomTransmitterData( data )
    -- on client
    self.agi = data.agi
    self.str = data.str
    self.intel = data.intel
end

--------------------------------------------------------------------------------
-- Properties
function custom_modifier_ethereal_blade:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS 
    }
end

function custom_modifier_ethereal_blade:GetModifierBonusStats_Agility()
    return self.agi
end

function custom_modifier_ethereal_blade:GetModifierBonusStats_Strength()
    return self.str
end

function custom_modifier_ethereal_blade:GetModifierBonusStats_Intellect()
    return self.intel
end