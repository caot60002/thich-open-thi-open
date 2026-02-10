-- Simple Executor Status Tracker
-- Pings "online" immediately when executor loads, regardless of game state

local Players = game:GetService("Players")

repeat task.wait() until Players.LocalPlayer
local player = Players.LocalPlayer
local uid = tostring(player.UserId)

print("[Checkonl] ========================================")
print("[Checkonl] Executor LOADED! UID:", uid)
print("[Checkonl] Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
print("[Checkonl] ========================================")

-- API endpoint
local API_BASE = "https://cdn.baotu.site"

-- Function to ping API
local function ping_api(status)
    local url = API_BASE .. "/api/ping?uid=" .. uid .. "&source=executor&status=" .. status

    print(string.format("[Checkonl] Pinging %s...", status))

    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)

    if success then
        print(string.format("[Checkonl] ✅ Success! API: %s", response:sub(1, 50)))
    else
        warn(string.format("[Checkonl] ❌ Failed: %s", tostring(response)))
    end

    return success
end

-- Wait 5 seconds for executor to fully load
print("[Checkonl] Waiting 5s before first ping...")
task.wait(5)

-- Start pinging "online" immediately
print("[Checkonl] Starting ONLINE pings... (interval: 20s)")
ping_api("online")

-- Main loop - keep pinging online
local count = 0
while true do
    count = count + 1

    -- Check if player still exists
    if not player or not player.Parent then
        warn("[Checkonl] Player removed, stopping...")
        ping_api("offline")
        break
    end

    -- Ping online every 20 seconds
    print(string.format("[Checkonl] [%d] Pinging online...", count))
    ping_api("online")

    -- Wait 20 seconds
    task.wait(20)
end

print("[Checkonl] Script stopped")
