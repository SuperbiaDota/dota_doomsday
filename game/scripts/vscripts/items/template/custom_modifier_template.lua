custom_modifier_template = class({})

function custom_modifier_template:IsHidden()
    return true
end

function custom_modifier_template:IsPurgable() 
    return false 
end

function custom_modifier_template:GetAttributes() return 
    MODIFIER_ATTRIBUTE_MULTIPLE 
end

function custom_modifier_template:RemoveOnDeath() 
    return false 
end