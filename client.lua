local VORP = require("vorp")

-- Define constants
local ADPOSTER_ITEM_NAME = "adposter"
local ADPOSTER2_ITEM_NAME = "adposter2"

-- Define global variables
local advertisements = {}

-- Handle ad creation and placement
VORP.RegisterEvent("playerInventoryUse", function(itemId)
    if itemId == VORP.GetInventoryItemByName(ADPOSTER_ITEM_NAME).id then
        VORP.ShowInputBox("Enter Advertisement URL:", function(input)
            if input ~= "" then
                VORP.SendToServer("FetchImage", input, function(imageURL)
                    if imageURL ~= nil then
                        advertisements[VORP.GetPlayerIndex()] = imageURL

                        VORP.RemoveItem(ADPOSTER_ITEM_NAME, 1)
                        VORP.AddItem(ADPOSTER2_ITEM_NAME, 1)

                        VORP.ShowNotification("Advertisement created successfully!")
                    else
                        VORP.ShowNotification("Invalid advertisement URL.")
                    end
                end)
            end
        end)
    end
end)

-- Handle ad viewing and taking
VORP.RegisterEvent("playerItemUse", function(itemId, itemPos)
    if itemId == VORP.GetInventoryItemByName(ADPOSTER2_ITEM_NAME).id then
        VORP.ShowWebView(advertisements[VORP.GetPlayerIndex()])
    end
end)

-- Handle item placement and interaction
VORP.RegisterEvent("playerDroppedItem", function(itemId, itemPos)
    if itemId == VORP.GetInventoryItemByName(ADPOSTER2_ITEM_NAME).id then
        VORP.SetEntityXY(itemPos, VORP.GetPlayerPosition())
        VORP.SetEntityRotation(itemPos, 0, 0, 0)

        VORP.ShowNotification("Advertisement placed successfully!")
    end
end)

-- Handle player proximity to placed item
VORP.RegisterEvent("playerProximityToEntity", function(entity)
    if VORP.GetEntityItem(entity) ~= nil and VORP.GetEntityItem(entity).name == ADPOSTER2_ITEM_NAME then
        VORP.ShowActionMenu("Advertisement Interaction", {
            {
                name = "View Advertisement",
                action = function()
                    VORP.ShowWebView(advertisements[VORP.GetPlayerIndex()])
                end
            },
            {
                name = "Take Advertisement",
                action = function()
                    VORP.RemoveEntity(entity)
                    VORP.AddItem(ADPOSTER2_ITEM_NAME, 1)
                    VORP.ShowNotification("Advertisement taken.")
                end
            }
        })
    end
end)
