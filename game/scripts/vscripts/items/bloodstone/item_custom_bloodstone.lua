item_custom_bloodstone = class({})

LinkLuaModifier(
    "custom_modifier_bloodstone",
    "items/bloodstone/custom_modifier_bloodstone"
    LUA_MODIFIER_MOTION_NONE
)

LinkLuaModifier(
    "custom_modifier_bloodstone_active",
    "items/bloodstone/custom_modifier_bloodstone_active"
    LUA_MODIFIER_MOTION_NONE
)

function item_custom_bloodstone:CastFilterResult()
    if self:GetCurrentCharges() > 1 then
        return UF_SUCCESS
    else
        return UF_FAIL_CUSTOM
    end
end

function item_custom_bloodstone:OnSpellStart()
    self:SpendCharge()

    self:GetCaster():AddNewModifier(
        self:GetCaster(),
        self,
        "custom_modifier_bloodstone_active",
        {duration = self:GetSpecialValueFor("duration")}
    )
end

function item_custom_bloodstone:OnOwnerDied()
    self:SpendCharge()
    self:SpendCharge()
end