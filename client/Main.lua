
Areas = {}

Areas.current_areas = {
    {
        draw = true,
        coords = {
            vec3(228.32,-1123.81,29.2),
            vec3(42.97,-1122.46,29.3),
            vec3(32.44,-1120.65,29.22),
            vec3(82.53,-1009.92,29.32),
            vec3(161.02,-795.36,31.07),
            vec3(308.7,-850.45,29.25),
            vec3(230.64,-1070.45,29.1)
        }
    }
}

Areas.CreateArea = function(data)
    table.insert(Areas.current_areas, data)

    return #Areas.current_areas
end

Areas.DeleteArea = function(area_id)
    Areas.current_areas[area_id] = nil
end

Areas.InsideArea = function(area_id)
    local ped = PlayerPedId()
    local ped_coords = GetEntityCoords(ped)
    local dictionary = Areas.current_areas[area_id]

    if dictionary then
        local inside = false
    
        local area_index = #dictionary.coords
        for index = 1, #dictionary.coords do    
            local intersect = ((dictionary.coords[index].y > ped_coords.y) ~= (dictionary.coords[area_index].y > ped_coords.y)) and (ped_coords.x < (dictionary.coords[area_index].x - dictionary.coords[index].x) * (ped_coords.y - dictionary.coords[index].y) / (dictionary.coords[area_index].y - dictionary.coords[index].y) + dictionary.coords[index].x)
            if intersect then
                inside = not inside
            end
            area_index = index
        end
    
        return inside    
    end

    return false
end

CreateThread(function()
    while true do
        Wait(4)
        for _,y in pairs(Areas.current_areas) do
            if y.draw then
                local ped = PlayerPedId()
                local ped_coords = GetEntityCoords(ped)
                for k,v in pairs(y.coords) do
                    local distance = #(ped_coords - v)
                    if distance <= 550.0 then
                        local next_index = y.coords[k + 1] and k + 1 or 1
                        local next_coord = y.coords[next_index]
                        local mid_point = vec3(
                            (v.x + next_coord.x) / 2,
                            (v.y + next_coord.y) / 2,
                            (v.z + next_coord.z) / 2
                        )
                        local point_direction = vec3(
                            next_coord.x - v.x,
                            next_coord.y - v.y,
                            next_coord.z - v.z
                        )
                        local points_distance = #(vec3(v.x,v.y,v.z) - next_coord)
                        local points_angle = math.deg(math.atan2(point_direction.y, point_direction.x))
        
                        DrawMarker(43,mid_point.x,mid_point.y,mid_point.z - 5,0.0,160.0,0.0,0.0,0.0,points_angle,points_distance,0.02,45.0,245,10,70,200,0,0,0,0)
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        for k,v in pairs(Areas.current_areas) do
            local inside = Areas.InsideArea(k)
            print(k, inside)
        end
        Wait(500)
    end
end)

exports("Create", Areas.CreateArea)
exports("Delete", Areas.DeleteArea)
exports("IsInside", Areas.InsideArea)