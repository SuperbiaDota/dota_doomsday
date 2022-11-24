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
custom_meepo_divided_we_stand = class({})

LinkLuaModifier( "custom_modifier_meepo_divided_we_stand_mute", 
	"heroes/meepo/modifiers/custom_modifier_meepo_divided_we_stand_mute", 
	LUA_MODIFIER_MOTION_NONE 
)

--------------------------------------------------------------------------------
-- Initialize
function custom_meepo_divided_we_stand:Init()
    self.other_meepos = {}
end

function custom_meepo_divided_we_stand:Spawn()
    if IsServer() then
        local player = self:GetCaster():GetPlayerOwner()
        if not player.MeepoInit then
            player.MeepoInit = true
            FilterManager:AddModifyExperienceFilter(self.OnCloneXP, self)
            FilterManager:AddExecuteOrderFilter(self.OnClonePickupItem, self)
        end
    end
end

--------------------------------------------------------------------------------
-- Hero Events
function custom_meepo_divided_we_stand:OnOwnerSpawned()
    if not IsServer() then return end
    if self:GetCaster():IsClone() then return end
    for meepo, _ in pairs(self.other_meepos) do
        FindClearSpaceForUnit(meepo, self:GetCaster():GetAbsOrigin(), true)
        meepo:RespawnUnit()
    end
end

function custom_meepo_divided_we_stand:OnOwnerDied()
    if not IsServer() then return end
    print("owner died")
    local caster = self:GetCaster()
    for meepo, _ in pairs(self.other_meepos) do
        if meepo:IsAlive() then
            Kill(self, caster)
        end
    end
end

function custom_meepo_divided_we_stand:OnHeroLevelUp()
    if not IsServer() then return end
    if self:GetCaster():IsClone() then return end
    for meepo, _ in pairs(self.other_meepos) do
        meepo:HeroLevelUp(false)
    end
end

-- Keep skill build consistent accross clones
function custom_meepo_divided_we_stand:OnAbilityUpgrade( ability )
    if not IsServer() then return end
    local ability_name = ability:GetAbilityName()
    for meepo, _ in pairs(self.other_meepos) do
        local other_ability = meepo:FindAbilityByName(ability_name)
        if other_ability:GetLevel() < ability:GetLevel() then
            meepo:UpgradeAbility(other_ability)
        end
    end
end


--------------------------------------------------------------------------------
-- Ability Events
function custom_meepo_divided_we_stand:OnUpgrade()
	if not IsServer() then return end
	local caster = self:GetCaster()
    if caster:IsClone() then return end
    local spawn_location = caster:GetAbsOrigin()
    local clone = CreateUnitByName(
        caster:GetUnitName(),
        spawn_location,
        true,
        caster,
        caster:GetOwner(),
        caster:GetTeamNumber()
    )

    clone.IsClone = function()
        return true
    end

    clone:AddNewModifier(
        caster,
        self,
        "custom_modifier_meepo_divided_we_stand_mute",
        {}
    )

    clone:SetControllableByPlayer(caster:GetPlayerID(), false)

    local clone_ult = clone:FindAbilityByName("custom_meepo_divided_we_stand")

    clone_ult.lock = true
    CopySkills(caster, clone)
    clone_ult.lock = nil

    CopyInventory(caster, clone)

    -- copy meepo info to clone
    for meepo, _ in pairs(self.other_meepos) do
        -- add clone to other meepos
        local other_ult = meepo:FindAbilityByName("custom_meepo_divided_we_stand")
        other_ult.other_meepos[clone] = true

        -- add other meepos to clone
        clone_ult.other_meepos[meepo] = true
    end

    -- add clone to this meepo
    self.other_meepos[clone] = true

    -- add this meepo to clone
    clone_ult.other_meepos[caster] = true
end

--------------------------------------------------------------------------------
-- Item Events
function custom_meepo_divided_we_stand:OnInventoryContentsChanged()
    if not IsServer() then return end
	if self:GetCaster():IsClone() then return end
	-- TODO: make this not trigger on the clones
	for meepo, _ in pairs(self.other_meepos) do
		CopyInventory(self:GetCaster(), meepo)
	end
end

--------------------------------------------------------------------------------
-- Filters
function custom_meepo_divided_we_stand:OnCloneXP( event )
    DebugPrint("Gained XP-------------------")
    DebugPrintTable(event)
    for meepo, _ in pairs(self.other_meepos) do
        print ("meepo entindex: " .. meepo:GetEntityIndex())
    end
    if event.hero_entindex_const == self:GetCaster() then
        for meepo, _ in pairs(self.other_meepos) do
            meepo:AddExperience(event.experience, event.reason_const, false, false)
        end
        return false
    elseif self.other_meepos[event.hero_entindex_const] ~= nil then
        self:GetCaster():AddExperience(event.experience, event.reason_const, false, false)
        return false
    end
    return true
end

function custom_meepo_divided_we_stand:OnClonePickupItem( event )
    DebugPrint("ORDER EVENT--------------------")
    DebugPrintTable(event)
    local entindex = event.units[0]
    if entindex and self.other_meepos[EntIndexToHScript(entindex)] ~= nil then
        if event.order_type == DOTA_UNIT_ORDER_DROP_ITEM
            or event.order_type == DOTA_UNIT_ORDER_GIVE_ITEM
            or event.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM
            or event.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM
            or event.order_type == DOTA_UNIT_ORDER_SELL_ITEM 
            or event.order_type == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM 
            or event.order_type == DOTA_UNIT_ORDER_MOVE_ITEM 
            or event.order_type == DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK then
            return false
        end
    elseif event.entindex_target and self.other_meepos[EntIndexToHScript(event.entindex_target)] ~= nil then
        if event.order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
            return false
        end
    end
    return true
end

--------------------------------------------------------------------------------
-- Interface
function custom_meepo_divided_we_stand:FindNearestMeepo( point )
    local closest = self:GetCaster()
    local closest_distance = (point - closest:GetAbsOrigin()):Length2D()
    for meepo, _ in pairs(self.other_meepos) do
        local distance = (point - meepo:GetAbsOrigin()):Length2D()
        if distance < closest_distance then
            closest = meepo
            closest_distance = distance
        end
    end
    return closest
end

-- TODO: add this to some library file
function CopyInventory(source, target)
	for item_id = 0, 5 do
		local item_in_caster = source:GetItemInSlot(item_id)
		if ( item_in_caster ~= nil ) then
			-- make space for items
			item_in_clone = target:GetItemInSlot(item_id)
			if item_in_clone ~= nil then item_in_clone:Kill() end

			-- copy item
			local item_created = CreateItem( item_in_caster:GetName(), target, target)
			target:AddItem(item_created)
			item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges())
		end
	end
end

-- TODO: add this to some library file
function CopySkills(source, target)
	local caster_level = source:GetLevel()
	for i = 2, caster_level do
		target:HeroLevelUp(false)
	end

	for ability_id = 0, 15 do
		local target_ability = target:GetAbilityByIndex(ability_id)
		if ability then
            local source_ability = source:GetAbilityByIndex(ability_id)
            while source_ability:GetLevel() > target_ability:GetLevel() do
                target:UpgradeAbility(target_ability)
            end
		end
	end
end

