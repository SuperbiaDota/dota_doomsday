custom_modifier_creep_wave_buff = class({})

function custom_modifier_creep_wave_buff:OnCreated()
	local ability = self:GetAbility()
	local unit_name = self:GetParent():GetUnitName()

    local last_5 = string.sub(unit_name, -5, -1)

	if last_5 == "melee" then 
		self.damage = ability:GetSpecialValueFor("damage_melee")
		self.health = ability:GetSpecialValueFor("health_melee")

	elseif last_5 == "anged" then
		self.damage = ability:GetSpecialValueFor("damage_ranged")
		self.health = ability:GetSpecialValueFor("health_ranged")

	elseif last_5 == "siege" then
		self.damage = ability:GetSpecialValueFor("damage_siege")
		self.health = ability:GetSpecialValueFor("health_siege")
	end

    self:SetHasCustomTransmitterData(true)
end

function custom_modifier_creep_wave_buff:OnRefresh()
    if IsServer() then
        local parent = self:GetParent()
        if parent.wave_number then  
            self:SetStackCount(math.floor((parent.wave_number - 1) / 15))
            self.bonus_damage = self.damage * self:GetStackCount() * self:GetAbility():GetLevel()
            self.bonus_health = self.health * self:GetStackCount() * self:GetAbility():GetLevel()

            self:SendBuffRefreshToClients()
        end
    end
end

function custom_modifier_creep_wave_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE ,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS 
	}
	return funcs
end

function custom_modifier_creep_wave_buff:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function custom_modifier_creep_wave_buff:GetModifierExtraHealthBonus()
	return self.bonus_health
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_creep_wave_buff:AddCustomTransmitterData()
    -- on server
    local data = {
        bonus_damage = self.bonus_damage,
        bonus_health = self.bonus_health
    }
    return data
end

function custom_modifier_creep_wave_buff:HandleCustomTransmitterData( data )
    -- on client
    self.bonus_damage = data.bonus_damage
    self.bonus_health = data.bonus_health
end
