custom_modifier_tp_scroll = class({})

function custom_modifier_tp_scroll:IsHidden()
    return true
end

function custom_modifier_tp_scroll:IsPurgable() 
    return false 
end

function custom_modifier_tp_scroll:RemoveOnDeath() 
    return false 
end

function custom_modifier_tp_scroll:OnCreated()
    self.min_distance = self:GetAbility():GetSpecialValueFor("minimum_distance")
    self.max_distance = self:GetAbility():GetSpecialValueFor("maximum_distance")
    self:GetAbility().custom_indicator = self

    if IsServer() then
        self.allied_buildings = {}
        self:SetHasCustomTransmitterData(true)
        self:OnBuildingKilled({})
    end
end

--------------------------------------------------------------------------------
-- Transmitter data
function custom_modifier_tp_scroll:AddCustomTransmitterData()
    -- on server
    local data = {
        allied_buildings = {}
    }

    for k, v in pairs(self.allied_buildings) do
        data.allied_buildings[k] = v:entindex()
    end

    return data
end

function custom_modifier_tp_scroll:HandleCustomTransmitterData( data )
    -- on client
    self.allied_buildings = {}
    for k,v in pairs(data.allied_buildings) do
        self.allied_buildings[k] = EntIndexToHScript(v)
    end
end

function custom_modifier_tp_scroll:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_BUILDING_KILLED
    }
end

function custom_modifier_tp_scroll:OnBuildingKilled( event )
    if not IsServer() then return end
    if not event.unit or event.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
        local allied_buildings = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            Vector(0,0,0),
            nil,
            FIND_UNITS_EVERYWHERE,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_BUILDING,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            FIND_ANY_ORDER,
            false
        )

        for k,v in pairs(allied_buildings) do
            self.allied_buildings[k] = v
        end

        self:SendBuffRefreshToClients()
    end
end

function custom_modifier_tp_scroll:GetTPInfo( point ) -- client only

    local building_distances = {}
    local ordered_buildings = {}

    for _, building in pairs(self.allied_buildings) do
        ordered_buildings[#ordered_buildings+1] = building
        building_distances[building] = (point - building:GetAbsOrigin()):Length2D()
    end

    table.sort(ordered_buildings, function(a, b) return building_distances[a] < building_distances[b] end)

    local target_building = ordered_buildings[1]

    local distance = building_distances[target_building]
    if distance < self.min_distance then
        distance = self.min_distance
    elseif distance > self.max_distance then
        distance = self.max_distance
    end

    local vDirection = point - target_building:GetAbsOrigin()
    vDirection.z = 0
    vDirection = vDirection:Normalized()

    location = target_building:GetAbsOrigin() + vDirection * distance
    --location.z = GetGroundHeight(location, nil)

    return {
        building = target_building,
        location = location
    }
end

function custom_modifier_tp_scroll:OnIntervalThink()
    self:StartIntervalThink(-1)
    self:DestroyCustomIndicator()
end

function custom_modifier_tp_scroll:CreateCustomIndicator( point )
    local tp_info = self:GetTPInfo( point )

    if tp_info.building ~= self.target_building then
        self.target_building = tp_info.building
        if self.casting_particle then
            self:DestroyCustomIndicator()
        end
        -- send event to panorama so it can highlight the correct building in the minimap
    end

    -- TODO: look at Dawnbreaker particle effect see how they make it stick to the ground

    --cp2 = ring position
    --cp3 = ring radius
    --cp4 = ring color
    --cp6 = glow alpha
    --cp7 = design position
    if not self.casting_particle then
        self.casting_particle = ParticleManager:CreateParticle(
            "particles/ui_mouseactions/tp_custom_indicator.vpcf", 
            PATTACH_WORLDORIGIN, 
            self:GetCaster()
        )

        ParticleManager:SetParticleControl(self.casting_particle, 3, Vector(140, 0, 0))
        ParticleManager:SetParticleControl(self.casting_particle, 6, Vector(1, 0, 0))
    end

    ParticleManager:SetParticleControl(self.casting_particle, 2, tp_info.location)
    ParticleManager:SetParticleControl(self.casting_particle, 7, tp_info.location)

    ParticleManager:SetParticleControl(self.casting_particle, 4, Vector(255, 255, 255)) -- TODO: adjust based on tp delay

    self:StartIntervalThink(0.1)
end

function custom_modifier_tp_scroll:DestroyCustomIndicator()
    if IsServer() then return end
    ParticleManager:DestroyParticle(self.casting_particle, true)
    ParticleManager:ReleaseParticleIndex(self.casting_particle)
    self.casting_particle = nil
end