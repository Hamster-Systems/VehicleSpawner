-- config.lua
useCommand = true
command = 'vs'  -- Set your desired command


-- Subcategory names for main categories (Required)
subCategoryNames = {
    MET = "Metropolitan Police",
    LFB = "London Fire Brigade",
    LAS = "London Ambulance Service",
}

-- Descriptions for main categories (Required)
categoryDescriptions = {
    MET = "Spawn Metropolitan Police vehicles",
    LFB = "Spawn London Fire Brigade vehicles",
    LAS = "Spawn London Ambulance Service vehicles",
}

-- Descriptions for subcategories (Required)
subcategoryDescriptions = {
    Patrol = "Local Response Vehicles",
    ARV = "Armed Response Vehicles",
    Hazmat = "Hazardous Materials Vehicles",
    Engines = "Fire Engines",
    General = "General Emergency Vehicles",
    Ambulances = "Emergency Response Ambulance",
}

-- Define vehicle categories
categories = {
    MET = {
        Patrol = {
            {
                Name = "Police Taxi", -- Title Name
                VehicleModel = "taxi", -- Spawn Code
                ---NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            },
            {
                Name = "Highway Charger", -- Title Name
                VehicleModel = "hp1", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            }
        },
        ARV = {
            {
                Name = "Police Taxi", -- Title Name
                VehicleModel = "taxi", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            },
            {
                Name = "Highway Charger", -- Title Name
                VehicleModel = "hp1", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            }
        },

    },

    LFB = {
        Hazmat = {
            {
                Name = "Police Taxi", -- Title Name
                VehicleModel = "taxi", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            },
            {
                Name = "Highway Charger", -- Title Name
                VehicleModel = "hp1", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            }
        },

    },

    LAS = {
        Ambulances = {
            {
                Name = "Police Taxi", -- Title Name
                VehicleModel = "taxi", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            },
            {
                Name = "Highway Charger", -- Title Name
                VehicleModel = "hp1", -- Spawn Code
                NumberPlate = "111", -- Set a custom plate; Comment this out to disable custom plates
                VehicleLivery= "1", -- Change vehicle livery
            }
        },

    }
}





return {
    subCategoryNames = subCategoryNames,
    categoryDescriptions = categoryDescriptions,
    subcategoryDescriptions = subcategoryDescriptions,
    categories = categories,
    useCommand = useCommand,
    command = command,
}
