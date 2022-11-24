
custom_modifier_drow_ranger_frost_arrows_stack = class({})

LinkLuaModifier( "custom_modifier_drow_ranger_frost_arrows_freeze", 
    "heroes/drow_ranger/modifiers/custom_modifier_drow_ranger_frost_arrows_freeze", 
    LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_drow_ranger_frost_arrows_stack:IsHidden()
	return false
end

function custom_modifier_drow_ranger_frost_arrows_stack:IsDebuff()
	return true
end

function custom_modifier_drow_ranger_frost_arrows_stack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_drow_ranger_frost_arrows_stack:OnCreated( kv )
    if not IsServer() then return end
    self.num_to_freeze = self:GetAbility():GetSpecialValueFor("num_to_freeze")
	self:SetStackCount(1)
    self.effect_cast = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf",
        PATTACH_OVERHEAD_FOLLOW,
        self:GetParent()
    )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(0, self:GetStackCount(), 0) )
end

function custom_modifier_drow_ranger_frost_arrows_stack:OnRefresh( kv )
    if IsServer() then
        self:IncrementStackCount()
        if self.effect_cast then
            ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(0, self:GetStackCount(), 0) )
        end
    end
end

function custom_modifier_drow_ranger_frost_arrows_stack:OnDestroy()
    if self.effect_cast then
        ParticleManager:DestroyParticle(self.effect_cast, true)
    end
end

function custom_modifier_drow_ranger_frost_arrows_stack:OnStackCountChanged( old_count )
    if not IsServer() then return end
    if old_count >= self.num_to_freeze then
        self:GetParent():AddNewModifier(
            self:GetCaster(),
            self:GetAbility(),
            "custom_modifier_drow_ranger_frost_arrows_freeze",
            {duration = self:GetAbility():GetSpecialValueFor("freeze_duration")}
        )
        ParticleManager:DestroyParticle(self.effect_cast, false)
        self.effect_cast = nil
        self:Destroy()
    end
end