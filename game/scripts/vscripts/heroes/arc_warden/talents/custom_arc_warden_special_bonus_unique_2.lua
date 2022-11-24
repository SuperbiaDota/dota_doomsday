custom_arc_warden_special_bonus_unique_2 = class({})

function custom_arc_warden_special_bonus_unique_2:OnUpgrade()
	AddNewModifier(
		self:GetParent(), -- player source
		self, -- ability source
		"modifier_custom_arc_warden_reincarnate", -- modifier name
		{ reincarnate_time = 0 } -- kv
	)
end
