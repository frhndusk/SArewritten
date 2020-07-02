--create vehicle

function createVehicleForPlayer(player, command, model)
    local db = exports.db:getConnection()
    local x, y, z = getElementPosition(player)
    local rotX, rotY, rotZ = getElementRotation(player)
    y = y + 5
    x = x + 5

    dbExec(db, 'INSERT INTO vehicles (model, x, y, z, rotX, rotY, rotZ) VALUES (?, ?, ?, ?, ?, ?, ?)', model, x, y, z, rotX, rotY, rotZ)
    
    local vehicleObject = createVehicle(model, x, y, z, rotX, rotY, rotZ)

    dbQuery(function() 
        local results = dbPoll(queryHandle, 0)
        local vehicle = results[1]

        
        setElementData(vehicle, 'id', result.id)
    end, db, 'SELECT id FROM vehicles ORDER BY id DESC LIMIT 1')
-- this is a function for creating a vehicle and then storing the postion coords to a sqlite database. query is a request for data or information

end
addCommandHandler('createvehicle', createVehicleForPlayer, false, false)    
addCommandHandler('createveh', createVehicleForPlayer, false, false)
addCommandHandler('makeveh', createVehicleForPlayer, false, false)
-- last two arguments for command handler are
-- 1: permission needed?
-- 2: case sensitive?
-- both are false(no) for now haha

function loadAllVehicles(queryHandle)
    local results = dbPoll(queryHandle, 0)

    for index, vehicle in pairs(results) do
        local vehicleObject = createVehicle(vehicle.model, vehicle.x, vehicle.y, vehicle.z)
        setElementRotation(vehicleObject, vehicle.rotX, vehicle.rotY, vehicle.rotZ)
        setElementData(vehicleObject, "id", vehicle.id)
    end    
    
end    
-- "for index, vehicle in pairs (results) do" is a loop
-- dbPoll checks the progress grabs data
addEventHandler('onResourceStart', resourceRoot, function()
    local db = exports.db:getConnection()
    
    dbQuery(loadAllVehicles, db, 'SELECT * FROM vehicles')    
end)

addEventHandler('onResourceStop', resourceRoot, function()
    local db = exports.db:getConnection()
    local vehicles = getElementsByType('vehicle')

    for index, vehicle in pairs(vehicles) do
        local id = getElementData(vehicle, 'id')
        local x, y, z = getElementPosition(vehicle)
        local  rotX, rotY, rotZ = getElementRotation(vehicle)
    
        dbExec(db, 'UPDATE vehicles SET x = ?, y = ?, z = ?, rotX = ?, rotY = ?, rotZ = ? WHERE id = ?', x, y, z, rotX, rotY, rotZ, id)
        
    end    

end)