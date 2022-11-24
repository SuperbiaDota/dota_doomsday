custom_modifier_zeus_heavenly_jump = class({})

function custom_modifier_zeus_heavenly_jump:OnIntervalThink()

    caster = self.caster
    ability = self.ability

    -- get targets
    local SearchInfo = {
        caster = caster,
        ability = ability,
        point = self.point
        range = self.range
        prioritize_heroes = true
        all_valid_heroes = self.all_heroes
    }
    local targets = SearchArea(SearchInfo)

    distance = hop_distance,
                speed = hop_speed,
                height = hop_height,
                fix_end = false,
                isForward = true,

    -- Apply debuff and damage
    for i=1, #targets do
        local target = targets[i]

        target:AddNewModifier(
            caster, -- player source
            ability, -- ability source
            "custom_modifier_zeus_heavenly_jump_slow", -- modifier name
            { 
                duration = self.debuff_duration
                move_slow = self.move_slow
                aspd_slow = self.aspd_slow
            } -- kv
        )

        local damageTable = {
            victim = target,
            attacker = caster,
            damage = self.damage,
            damage_type = ability:GetAbilityDamageType(),
            ability = ability
        }
        ApplyDamage(damageTable)
        
    end

    self:StartIntervalThink(-1)
    self:Destroy()
end