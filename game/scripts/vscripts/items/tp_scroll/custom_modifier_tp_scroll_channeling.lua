custom_modifier_tp_scroll_channeling = class({})

function custom_modifier_tp_scroll_channeling:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function custom_modifier_tp_scroll_channeling:GetOverrideAnimation()
    return ACT_DOTA_TELEPORT
end