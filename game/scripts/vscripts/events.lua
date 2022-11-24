-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
	DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
	DebugPrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	DebugPrint("[BAREBONES] GameRules State Changed")
	DebugPrintTable(keys)

	local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.	This includes heroes
function GameMode:OnNPCSpawned(keys)
	--DebugPrint("[BAREBONES] NPC Spawned")
	--DebugPrintTable(keys)

	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and keys.is_respawn then
		local invuln_mod = npc:FindModifierByName("modifier_fountain_invulnerability")
        if invuln_mod then invuln_mod:Destroy() end
	end
end

-- An entity somewhere has been hurt.	This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
	--DebugPrint("[BAREBONES] Entity Hurt")
	--DebugPrintTable(keys)

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
		local entCause = EntIndexToHScript(keys.entindex_attacker)
		local entVictim = EntIndexToHScript(keys.entindex_killed)

		-- The ability/item used to damage, or nil if not damaged by an item/ability
		local damagingAbility = nil

		if keys.entindex_inflictor ~= nil then
			damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
		end
	end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	DebugPrint( '[BAREBONES] OnItemPickedUp' )
	DebugPrintTable(keys)

	local unitEntity = nil
	if keys.UnitEntitIndex then
		unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
end

-- A player has reconnected to the game.	This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	DebugPrint( '[BAREBONES] OnPlayerReconnect' )
	DebugPrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
	DebugPrint( '[BAREBONES] OnItemPurchased' )
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
	DebugPrint('[BAREBONES] AbilityUsed')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	DebugPrintTable(keys)

	local abilityname=	keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	DebugPrint('[BAREBONES] OnPlayerChangedName')
	DebugPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	DebugPrint('[BAREBONES] OnAbilityChannelFinished')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp( keys )
	DebugPrint('[BAREBONES] OnPlayerLevelUp')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local level = keys.level

	self:UpdateBuyback( keys.player_id )
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	DebugPrint('[BAREBONES] OnLastHit')
	DebugPrintTable(keys)

	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local victim = EntIndexToHScript(keys.EntKilled)

	-- TODO: turn off default gold from hero kill with modify gold filter

	if isHeroKill then
		-- reward killer
		if player and player:GetTeam() ~= victim:GetTeam() then
    	    -- kill bounty

    	    -- kill base gold: 125
    	    -- first blood: 135
    	    
    	    local bounty_gold = 125 + victim:GetLevel()*8
		
    	    if isFirstBlood then
    	        bounty_gold = bounty_gold + 135
    	    end
		
    	    killerHero = player:GetAssignedHero()
    	    killerHero:ModifyGold(bounty_gold, true, DOTA_ModifyGold_HeroKill)

    	    -- assist gold

    	    local streak = victim:GetStreak()
			if streak > 10 then 
				streak = 10
			elseif streak < 3 then
				streak = 0
			end

    	    local KillstreakBounty = streak * 60
    	    local aoe_gold = 180 + KillstreakBounty
		
    	    local assist_heroes =  FindUnitsInRadius(
    	    	victim:GetTeam(),
    	    	victim:GetOrigin(),
    	    	nil,
    	    	1500,
    	    	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    	    	DOTA_UNIT_TARGET_HERO,
    	    	0,
    	    	0,
    	    	false
    	    )

    	    local found_players = {}
    	    local found_count = 0
			
    	    for _, ally_hero in ipairs(assist_heroes) do -- TODO: test with lone druid, arc, meepo, monkey
    	        local ally_player = ally_hero:GetPlayerID()
    	        if found_players[ally_player] == nil then
    	        	found_players[ally_player] = true
    	        	found_count = found_count + 1
    	        end
    	    end
			
			local assist_count = nil
			if found_players[player] then
				assist_count = found_count
			else
				assist_count = found_count
			end

    	    aoe_gold = math.floor( aoe_gold / assist_count)
		
    	    killerHero:ModifyGold(aoe_gold, true, DOTA_ModifyGold_HeroKill)
    	    for ally_player, _ in pairs(found_players) do
    	        ally_player:GetAssignedHero():ModifyGold(aoe_gold, true, DOTA_ModifyGold_HeroKill)
    	    end

    	    -- update buyback
    	    local streak = killerHero:GetStreak()
    		if streak > 10 then
				streak = 10 
			elseif streak < 3 then
				streak = 0
			end
	
			if killerHero.max_streak < streak then
				killerHero.max_streak = streak
			end

			self.UpdateBuyback(keys.PlayerID)
	
    	end
    end

    if victim:GetTeamNumber() == DOTA_TEAM_NEUTRALS then -- TODO: roshan
        local spawner_name = nil
        if victim:GetOwnerEntity() then
            spawner_name = victim:GetOwnerEntity():GetNeutralSpawnerName()
        else
            spawner_name = victim:GetNeutralSpawnerName()
        end
        --print("neutral created, spawner name: " .. spawner_name)

        local location_to_num = { -- TODO: make pseudo random tied to camps not heroes
            ["chapel"] = 1,
            ["cemetary"] = 2,
            ["outpost"] = 3,
            ["river"] = 4,
            ["ancients"] = 5
        }

        local location = string.sub(spawner_name, 1, -3)
        local drop_table = self.material_drop_info[location]
        DeepPrintTable(drop_table)
        if drop_table ~= nil then
            for chance, item_table in spairs(drop_table, function(t,a,b) return tonumber(a) < tonumber(b) end) do -- smallest chance is rolled first
                --print("chance: " .. chance)
                if RollPseudoRandomPercentage(tonumber(chance), location_to_num[location], player:GetAssignedHero()) then
                    --print("found item: " .. )
                    local item_name = item_table[tostring(math.random(item_table["count"]))]
                    local item = CreateItem(item_name, nil, nil)
                    CreateItemOnPositionSync(victim:GetAbsOrigin(), item)
                end
            end
        end
    end

    -- get camp location
    -- get potential item drops
    -- drop item at creep kill location
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	DebugPrint('[BAREBONES] OnTreeCut')
	DebugPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
	DebugPrint('[BAREBONES] OnRuneActivated')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
	DebugPrint('[BAREBONES] OnPlayerPickHero')
	DebugPrintTable(keys)

	local heroClass = keys.hero
	local heroEntity = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
	DebugPrint('[BAREBONES] OnTeamKillCredit')
	DebugPrintTable(keys)

	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
	local numKills = keys.herokills
	local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
	DebugPrintTable( keys )
	

	-- The Unit that was Killed
	local victim = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	-- The ability/item used to kill, or nil if not killed by an item/ability
	local killerAbility = nil

	if keys.entindex_inflictor ~= nil then
		killerAbility = EntIndexToHScript( keys.entindex_inflictor )
	end

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless

	-- Put code here to handle when an entity gets killed

	if victim:IsRealHero() then
    	local victim_level = victim:GetLevel()
		
		-- set respawn
    	local respawn_timer = math.floor(11.859 + 0.141 * victim_level * victim_level)
    	GameRules:GetGameModeEntity():SetFixedRespawnTime(respawn_timer)

    	victim:ClearStreak()
    end
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
	DebugPrint('[BAREBONES] PlayerConnect')
	DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	DebugPrint('[BAREBONES] OnConnectFull')
	DebugPrintTable(keys)
	
	local entIndex = keys.index
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)
	
	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
	DebugPrint('[BAREBONES] OnIllusionsCreated')
	DebugPrintTable(keys)

	local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
	DebugPrint('[BAREBONES] OnItemCombined')
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
	DebugPrint('[BAREBONES] OnAbilityCastBegins')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
	DebugPrint('[BAREBONES] OnTowerKill')
	DebugPrintTable(keys)

	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
	DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
	--DebugPrint('[BAREBONES] OnNPCGoalReached')
	--DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text
end

function GameMode:UpdateBuyback ( player_id )
	local player = PlayerResource:GetPlayer( player_id )
	local hero = player:GetAssignedHero()
	local buyback_increase = 2-(hero.max_streak * hero.max_streak/25/4) 
    -- 1 - 1/4 * (x/5)^2; start at 1 then exponentially approach 0 at streak = 10
    local buyback_cost = hero.BB_Multiplier * buyback_increase * hero:GetLevel() * 100
    PlayerResource:SetCustomBuybackCost(hero:GetPlayerID(), buyback_cost)
end