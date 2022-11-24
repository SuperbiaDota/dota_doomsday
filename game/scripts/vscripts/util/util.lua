function CDOTA_Item:IsConsumable()

end

function CDOTA_Item:DropsOnDeath()

end

function DeepCopyTable( original )
    local ret = {}
    for k, v in pairs(original) do
        if type(v) == 'table' then
            ret[k] = DeepCopyTable(v)
        else
            ret[k] = v
        end
    end
    return ret
end

function spairs(t, order) -- thank you to Michal Kottman on stack overflow
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


-- Flag operations
function FlagExist(a,b)--Bitwise Exist
    local p,c,d=1,0,b
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c==d
end

function FlagAdd(a,b)--Bitwise and
    if FlagExist(a,b) then
        return a
    else
        return a+b
    end
end

function FlagMin(a,b)--Bitwise and
    if FlagExist(a,b) then
        return a-b
    else
        return a
    end
end


function CDOTA_BaseNPC:AddDebuff(
    caster,
    ability,
    modifierName,
    kv)
    if kv.duration then
        kv.duration = kv.duration * (1 - self:GetStatusResistance())
    end
    self:AddNewModifier(
        caster,
        ability,
        modifierName,
        kv
    )
end

function CDOTA_BaseNPC:UpdateDebuffDurations(old_status_resist, bonus_resist)
    local modifiers = self:FindAllModifiers()
    old_status_resist = old_status_resist / 100
    bonus_resist = bonus_resist / 100
    local new_status_resist = old_status_resist + bonus_resist - old_status_resist*bonus_resist
    for _, hmod in pairs(modifiers) do
        if hmod:IsDebuff() then
            local base_time = hmod:GetRemainingTime() * (1-old_status_resist)
            hmod:SetDuration(base_time * (1-new_status_resist), true)
        end
    end
end

