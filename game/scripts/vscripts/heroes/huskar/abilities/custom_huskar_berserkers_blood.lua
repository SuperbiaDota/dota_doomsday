custom_huskar_berserkers_blood = class({})

LinkLuaModifier( "custom_modifier_huskar_berserkers_blood_passive", 
    "heroes/huskar/modifiers/custom_modifier_huskar_berserkers_blood_passive", 
    LUA_MODIFIER_MOTION_NONE 
)

LinkLuaModifier( "custom_modifier_huskar_berserkers_blood", 
	"heroes/huskar/modifiers/custom_modifier_huskar_berserkers_blood", 
	LUA_MODIFIER_MOTION_NONE 
)

function custom_huskar_berserkers_blood:GetIntrinsicModifierName()
    return "custom_modifier_huskar_berserkers_blood_passive"
end

function custom_huskar_berserkers_blood:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------
-- Toggle
function custom_huskar_berserkers_blood:OnToggle()
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"custom_modifier_huskar_berserkers_blood",
			{}
		)
	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Ability Events
function custom_huskar_berserkers_blood:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
	end
end