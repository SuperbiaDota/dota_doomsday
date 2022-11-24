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
custom_modifier_omniknight_guardian_angel_block = class({})

LinkLuaModifier(
    "modifier_generic_damage_modification",
    "generic/modifier_generic_damage_modification",
    LUA_MODIFIER_MOTION_NONE
)

--------------------------------------------------------------------------------
-- Classifications
function custom_modifier_omniknight_guardian_angel_block:IsHidden()
	return false
end

function custom_modifier_omniknight_guardian_angel_block:IsDebuff()
	return false
end

function custom_modifier_omniknight_guardian_angel_block:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function custom_modifier_omniknight_guardian_angel_block:OnCreated( kv )
    --self:PlayEffects()
    if IsServer() then
        self.flying = TalentSystem:UnitHasTalent(self:GetParent(), "custom_omniknight_special_bonus_1")
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("block_instances"))
        self.modifier = self:GetParent():AddNewModifier(
            self:GetCaster(),
            self:GetAbility(),
            "modifier_generic_damage_modification",
            {
                callback = "no_damage",
                priority = 0,
                damage_type = DAMAGE_TYPE_ALL
            }
        )

        self:SetControl()
    end
end

function custom_modifier_omniknight_guardian_angel_block:OnRefresh( kv )
    self:OnCreated(kv)
end

function custom_modifier_omniknight_guardian_angel_block:OnRemoved()
end

function custom_modifier_omniknight_guardian_angel_block:OnDestroy()
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, false)
        ParticleManager:ReleaseParticleIndex(self.particle)
    end

    self.modifier:RemoveMod(self)
end

--------------------------------------------------------------------------------
-- Stack
function custom_modifier_omniknight_guardian_angel_block:OnStackCountChanged( old_count )
    if self:GetStackCount() == 0 then
        self.modifier:RemoveMod(self)
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations

function custom_modifier_omniknight_guardian_angel_block:SetControl()
    local num_block = self:GetStackCount()
    local scale = 5^0.333 / num_block^0.333
    local speed = 100 / num_block

    if self.particle then
        print("destroying particle: " .. self.particle)
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:ReleaseParticleIndex(self.particle)
    end
    
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/omniknight_p_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

    print("created particle: " .. self.particle)

    ParticleManager:SetParticleControlEnt(
        self.particle,
        1,
        self:GetParent(),
        PATTACH_ABSORIGIN_FOLLOW,
        "",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    ParticleManager:SetParticleControl(self.particle, 2, Vector(scale, scale, scale))
    ParticleManager:SetParticleControl(self.particle, 4, Vector(num_block, speed, 0))
end

function custom_modifier_omniknight_guardian_angel_block:PlayEffects()
    local sound_cast = "Hero_Omniknight.GuardianAngel"
    EmitSoundOn( sound_cast, self:GetParent() )

    local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
    if self:GetParent()==self:GetCaster() then
        particle_cast = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf"
    end

    -- create particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    -- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        5,
        self:GetParent(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        self:GetParent():GetOrigin(), -- unknown
        true -- unknown, true
    )

    self:AddParticle(
        effect_cast,
        false,
        false,
        -1,
        false,
        false
    )
end