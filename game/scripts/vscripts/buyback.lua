if not Buyback then
	Buyback = class({})
	Buyback:Init()
end

function Buyback:Init()
	FilterManager:AddModifyGoldFilter(self.UpdateBuyback, self)
	ListenToGameEvent("dota_buyback", 
		function(event)
			local hero = EntIndexToHScript(event.entindex)
			local cd_time = 120 + hero:GetRespawnTime() -- TODO: check if custom respawn time works
			hero:SetBuybackCooldownTime(cd_time)
		end,
		nil
	)
end

function Buyback:UpdateBuyback ( context, event )
	local player = PlayerResource:GetPlayer( event.player_id_const )
	local hero = player:GetAssignedHero()
	local buyback_increase = 2-(hero.max_streak * hero.max_streak/100) 
    -- 2 - 1/4 * (x/5)^2; start at 2 then exponentially approach 1 at streak = 10
    local buyback_cost = hero.BB_Multiplier * buyback_increase * hero:GetLevel() * 100
    PlayerResource:SetCustomBuybackCost(hero:GetPlayerID(), buyback_cost)
end