--[[
TODO:
creep upgrades
]]

if not LaneCreepLogic then
	LaneCreepLogic = class({})
end

LinkLuaModifier("modifier_generic_removed",
    "generic/modifier_generic_removed",
    LUA_MODIFIER_MOTION_NONE
)

function LaneCreepLogic:Init()

	-- get spawn locations
	self.spawn_table = {
		[0] = {},
		[1] = {}
	}
	local info_targets = Entities:FindAllByClassname("info_target")
	for _, target in pairs(info_targets) do

		local name = target:GetName()

		if string.sub(name,1,17) == "npc_dota_spawner_" then

			local side_char = string.sub(name, 18, 18)
			local side
			if side_char == 'g' then
				side = 0
			elseif side_char == 'b' then
				side = 1
			end

			local lane_lut = {
				["top"] = 0,
				["mid"] = 1,
				["bot"] = 2
			}
			local lane = lane_lut[string.sub(name, -11, -9)]
			self.spawn_table[side][lane] = target:GetOrigin()		
		end
	end

	self.wave_comp = { -- composition of each wave, upgraded periodically
		["melee"] = 3,
		["ranged"] = 1,
		["siege"] = 1
	}

    self.wave = {} -- composition of next wave

	self.spawn_handle = {}

	self.wave_number = 1 -- current wave count, increases every time PreSpawnWaves() is called

	self.upgrade = { -- upgrade level of the creep buff ability, increases when rax are destroyed
		[0] = {
			[0] = 1,
			[1] = 1,
			[2] = 1
		},
		[1] = {
			[0] = 1,
			[1] = 1,
			[2] = 1
		}
	}

	self.pending_units = {} -- table of units that have been created but not spawned

    LaneCreepLogic:SetWaveComposition(1)
    LaneCreepLogic:PreSpawnWaves()
end

function LaneCreepLogic:SpawnWaves() -- called 2 seconds before creeps spawn
	DebugPrint("Creating Creep Waves")
	local wave_number = self:PreSpawnWaves()
	self:SetWaveComposition( wave_number + 1 )

	Timers:CreateTimer(2,
        function()
            DebugPrint("Sending Creep Waves")
            self:SendWaves( wave_number )
        end
    )
end

function LaneCreepLogic:PreSpawnWaves()

	local wave_number = self.wave_number
	
	local side_lut = {
		[0] = "goodguys",
		[1] = "badguys"
	}
	for side = 0, 1 do
		for lane = 0, 2 do
			for unit_type, count in pairs(self.wave) do
				local unit_name = "custom_npc_dota_creep_" .. side_lut[side] .. "_" .. unit_type
				for i=1, count do
					local SpawnHandle = CreateUnitByNameAsync(
						unit_name, -- unitName
						Vector(9000, 9000, 0), -- location
						false, -- findClearSpace
						nil, -- npcOwner
						nil, -- entityOwner
						side+2, -- team
						_ModifyCreep
					)
					self.spawn_handle[SpawnHandle] = {
						lane = lane,
						wave_number = wave_number
					}
				end
			end
		end
	end

	self.wave_number = wave_number + 1
	return wave_number
end

function LaneCreepLogic:SendWaves( wave_number )
	for handle, info in pairs(self.spawn_handle) do
		if info.wave == wave_number then
			ManuallyTriggerSpawnGroupCompletion(handle)
            self.spawn_handle[handle] = nil
		end
	end

	for side = 0,1 do
		for lane = 0,2 do
            local location = self.spawn_table[side][lane]
			for _, unit in pairs(self.pending_units[wave_number][side][lane]) do
				unit:RemoveNoDraw()
                unit:SetOrigin(location)
                unit:FindModifierByName("modifier_generic_removed"):Destroy()
			end
		end
	end

	self.pending_units[wave_number] = nil
end

function LaneCreepLogic:SetWaveComposition(wave_number)
	-- upgrade wave at key wave numbers
	if wave_number == 31 or wave_number == 61 or wave_number == 91 then
		self.wave_comp["melee"] = self.wave_comp["melee"] + 1
	elseif wave_number == 71 then
		self.wave_comp["siege"] = self.wave_comp["siege"] + 1
	elseif wave_number == 81 then
		self.wave_comp["ranged"] = self.wave_comp["ranged"] + 1
	end

	-- set wave
	self.wave["melee"] = self.wave_comp["melee"]
	self.wave["ranged"] = self.wave_comp["ranged"]
	if (wave_number-1) % 10 == 0 and wave_number ~= 1 then
		self.wave["siege"] = self.wave_comp["siege"]
	else
		self.wave["siege"] = nil
	end
end

function LaneCreepLogic:GetModelName( unit_name, upgrade_level )
	local model_lut = {
		[2] = {
			["custom_npc_dota_creep_goodguys_melee"] = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl",
			["custom_npc_dota_creep_goodguys_ranged"] = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged.vmdl",
			["custom_npc_dota_creep_goodguys_siege"] = "models/creeps/lane_creeps/creep_good_siege/creep_good_siege.vmdl",

			["custom_npc_dota_creep_badguys_melee"] = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl",
			["custom_npc_dota_creep_badguys_ranged"] = "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged.vmdl",
			["custom_npc_dota_creep_badguys_siege"] = "models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl"
		},
		[3] = {
			["custom_npc_dota_creep_goodguys_melee"] = "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega.vmdl",
			["custom_npc_dota_creep_goodguys_ranged"] = "models/creeps/lane_creeps/creep_radiant_ranged/radiant_ranged_mega.vmdl",
			["custom_npc_dota_creep_goodguys_siege"] = "models/creeps/lane_creeps/creep_good_siege/creep_good_siege.vmdl",

			["custom_npc_dota_creep_badguys_melee"] = "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl",
			["custom_npc_dota_creep_badguys_ranged"] = "models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl",
			["custom_npc_dota_creep_badguys_siege"] = "models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl"
		}
	}
	return model_lut[upgrade_level][unit_name]
end

function LaneCreepLogic:GetModelSize( unit_name, upgrade_level )
	local size_lut = {
		[2] = {
			["custom_npc_dota_creep_goodguys_melee"] = 1.12,
			["custom_npc_dota_creep_goodguys_ranged"] = 1.12,
			["custom_npc_dota_creep_goodguys_siege"] = 0.65,

			["custom_npc_dota_creep_badguys_melee"] = 1.12,
			["custom_npc_dota_creep_badguys_ranged"] = 1.12,
			["custom_npc_dota_creep_badguys_siege"] = 0.80
		},
		[3] = {
			["custom_npc_dota_creep_goodguys_melee"] = 1.12,
			["custom_npc_dota_creep_goodguys_ranged"] = 1.12,
			["custom_npc_dota_creep_goodguys_siege"] = 0.65,

			["custom_npc_dota_creep_badguys_melee"] = 1.12,
			["custom_npc_dota_creep_badguys_ranged"] = 1.12,
			["custom_npc_dota_creep_badguys_siege"] = 0.80
		}
	}
	return size_lut[upgrade_level][unit_name]
end

function LaneCreepLogic:UpgradeCreeps( side, lane )
	self.upgrade[side][lane] = self.upgrad[side][lane] + 1
end


function _ModifyCreep ( unit )
	-- hide unit
	--unit:AddNoDraw()

    -- stun unit
    unit:AddNewModifier(
        unit,
        nil,
        "modifier_generic_removed",
        {}
    )

	local side = unit:GetTeamNumber()-2
	local wave_number = LaneCreepLogic.spawn_handle[unit:GetSpawnGroupHandle()]["wave_number"]
	local lane = LaneCreepLogic.spawn_handle[unit:GetSpawnGroupHandle()]["lane"]

	-- change model and model scale
	local upgrade = LaneCreepLogic.upgrade[side][lane]
	if upgrade > 1 then
        print("upgrade: " .. upgrade)
        print("model name: " .. LaneCreepLogic:GetModelName(unit:GetUnitName(), upgrade))
		unit:SetModel(LaneCreepLogic:GetModelName(unit:GetUnitName(), upgrade))
        print("unit model: " .. unit:GetModelName())
		unit:SetModelScale(LaneCreepLogic:GetModelSize(unit:GetUnitName(), upgrade))
	end

    -- save wave number for upgrade passive
    unit.wave_number = wave_number

    -- set level ( also refreshes passive )
	local ability = unit:FindAbilityByName("custom_ability_creep_wave_buff")
    ability:SetLevel(upgrade)

	-- add unit to table
	if not LaneCreepLogic.pending_units[wave_number] then
		LaneCreepLogic.pending_units[wave_number] = {
			[0] = {
				[0] = {},
				[1] = {},
				[2] = {},
			},
			[1] = {
				[0] = {},
				[1] = {},
				[2] = {},
			}
		}
	end
	table.insert(LaneCreepLogic.pending_units[wave_number][side][lane], unit)

    -- set initial goal entity
    local side_lut = {
        [0] = "goodguys",
        [1] = "badguys"
    }
    local lane_lut = {
        [0] = "top",
        [1] = "mid",
        [2] = "bot"
    }
    local target_str = "lane_" .. lane_lut[lane] .. "_pathcorner_" .. side_lut[side] .. "_1"
    local first_waypoint = nil
    local pathcorners = Entities:FindAllByClassname("path_corner")
    for _, corner in pairs(pathcorners) do
        if corner:GetName() == target_str then
            first_waypoint = corner
            break
        end
    end
    unit:SetInitialGoalEntity(first_waypoint)
end