local advertisements = {}

VORP.RegisterEvent("playerInventoryUse", function(itemId)
    if itemId == VORP.GetInventoryItemByName(ADPOSTER_ITEM_NAME).id then
        VORP.ShowInputBox("Enter Advertisement URL:", function(input)
            if input ~= "" then
                local imageURL = VORP.FetchImage(input)

                if imageURL ~= nil then
                    advertisements[VORP.GetPlayerIndex()] = imageURL

                    VORP.RemoveItem(ADPOSTER_ITEM_NAME, 1)
                    VORP.AddItem(ADPOSTER2_ITEM_NAME, 1)

                    VORP.ShowNotification("Advertisement created successfully!")
                else
                    VORP.ShowNotification("Invalid advertisement URL.")
                end
            end
        end)
    end
end)

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
