custom_ability_burst = class({})

LinkLuaModifier(
    "custom_modifier_burst_buff",
    "modifiers/custom_modifier_burst_buff.lua",
    LUA_MODIFIER_MOTION_NONE
)

function custom_ability_burst:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
    end
end

function custom_ability_burst:GetChannelTime()
    return self.max_channel
end

function custom_ability_burst:OnAbilityPhaseStart()
    self.start = GameRules:GetGameTime()
    return true
end

function custom_ability_burst:OnAbilityPhaseInterrupted()
    local elapsed = GameRules:GetGameTime() - self.start
    --print("elapsed: " .. elapsed)
    local cd = self.BaseClass.GetCooldown(self, 1) * (elapsed / self:GetCastPoint())
    self:StartCooldown(cd)
end


function custom_ability_burst:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local intel = caster:GetIntellect()

    self.max_channel =  self:GetSpecialValueFor( "base_duration" ) +
        intel * self:GetSpecialValueFor("int_multiplier")

    self.modifier = caster:AddNewModifier(
        caster, -- player source
        self, -- ability source
        "custom_modifier_burst_buff", -- modifier name
        { duration = self.max_channel } -- kv
    )
end

function custom_ability_burst:StopChannel()
    if self.modifier then
        self.modifier:Destroy()
        self.modifier = nil
        
        if self:IsChanneling() then
            self:GetParent():Stop()
        end

        -- stop effects
    end
end

function custom_ability_burst:OnChannelFinish( bInterrupted )
    self:StopChannel()
end

