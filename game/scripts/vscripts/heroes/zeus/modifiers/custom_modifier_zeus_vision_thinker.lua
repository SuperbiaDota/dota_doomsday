custom_modifier_zeus_vision_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_zeus_vision_thinker:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = kv.radius
end

function custom_modifier_zeus_vision_thinker:OnRefresh( kv )
	
end

function custom_modifier_zeus_vision_thinker:OnRemoved()
end

function custom_modifier_zeus_vision_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Aura Effects

function custom_modifier_zeus_vision_thinker:IsAura()
	return true
end

function custom_modifier_zeus_vision_thinker:GetModifierAura()
	return "modifier_truesight"
end

function custom_modifier_zeus_vision_thinker:GetAuraRadius()
	return self.radius
end

function custom_modifier_zeus_vision_thinker:GetAuraDuration()
	return 0.5
end

function custom_modifier_zeus_vision_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function custom_modifier_zeus_vision_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function custom_modifier_zeus_vision_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
