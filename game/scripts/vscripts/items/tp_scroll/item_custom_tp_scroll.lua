item_custom_tp_scroll = class({})

LinkLuaModifier(
    "custom_modifier_tp_scroll",
    "items/tp_scroll/custom_modifier_tp_scroll",
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_tp_scroll:Spawn()
    self.interval = 0.03
end

function item_custom_tp_scroll:GetIntrinsicModifierName()
    return "custom_modifier_tp_scroll"
end

function item_custom_tp_scroll:CastFilterResultLocation(point)
    if IsClient() then
        local now = GameRules:GetGameTime()
        if (not self.prev_tick) or (now - self.prev_tick) >= self.interval then
            self.prev_tick = now
            self.custom_indicator:CreateCustomIndicator( point )
        end
    end

    return UF_SUCCESS
end

function item_custom_tp_scroll:OnSpellStart()
    if not IsServer() then return end

    local vision_radius = self:GetSpecialValueFor("vision_radius")

    local tp_info = self.custom_indicator:GetTPInfo(self:GetCursorPosition())
    self.location = tp_info.location
    self.viewer = AddFOWViewer(self:GetCaster():GetTeamNumber(), self.location, vision_radius, self:GetChannelTime(), false)
    self:GetCaster():SetMaterialGroup("teleport_image_glow")
    -- TODO calculate channel time

    self.custom_indicator:DestroyCustomIndicator()
    self.target_building = nil
end

function item_custom_tp_scroll:OnChannelFinish( bInterrupted )
    if not IsServer() then return end
    RemoveFOWViewer(self:GetCaster():GetTeamNumber(), self.viewer)

    if not bInterrupted then
        FindClearSpaceForUnit(self:GetCaster(), self.location, false)
    end
end
