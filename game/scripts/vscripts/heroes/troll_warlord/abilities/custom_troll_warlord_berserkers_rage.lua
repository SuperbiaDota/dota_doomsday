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
custom_troll_warlord_berserkers_rage = class({})

LinkLuaModifier( "custom_modifier_troll_warlord_berserkers_rage", 
	"heroes/troll_warlord/modifiers/custom_modifier_troll_warlord_berserkers_rage", 
	LUA_MODIFIER_MOTION_NONE
)

function custom_troll_warlord_berserkers_rage:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------
-- Toggle
function custom_troll_warlord_berserkers_rage:OnToggle()
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"custom_modifier_troll_warlord_berserkers_rage",
			{}
		)
	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil
		end
	end
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Ability Events
function custom_troll_warlord_berserkers_rage:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
		self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
-- Ability Effects
function custom_troll_warlord_berserkers_rage:PlayEffects()

end