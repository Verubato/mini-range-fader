local _, addon = ...
---@type MiniFramework
local mini = addon.Framework
local config = addon.Config
local maxParty = MAX_PARTY_MEMBERS or 4
local maxRaid = MAX_RAID_MEMBERS or 40
---@type Db
local db

---Retrieves a list of Blizzard frames.
---@return table
local function BlizzardFrames()
	local frames = {}

	-- + 1 for player/self
	for i = 1, maxParty + 1 do
		local frame = _G["CompactPartyFrameMember" .. i]

		if frame and frame:IsVisible() then
			frames[#frames + 1] = frame
		end
	end

	for i = 1, maxRaid do
		local frame = _G["CompactRaidFrame" .. i]

		if frame and frame:IsVisible() then
			frames[#frames + 1] = frame
		end
	end

	return frames
end

local function UpdateAlpha(frame)
	if frame.background then
		if db.BlackBackground then
			frame.background:SetIgnoreParentAlpha(true)
			frame.background:SetAlpha(1)
		else
			frame.background:SetIgnoreParentAlpha(false)
		end
	end

	if frame.outOfRange == nil then
		return
	end

	frame:SetAlphaFromBoolean(frame.outOfRange, db.OutOfRangeAlpha, 1)
end

local function OnCufSetAlpha(frame)
	-- ignore nameplates
	if string.find(frame.unit, "nameplate") ~= nil then
		return
	end

	UpdateAlpha(frame)
end

local function OnAddonLoaded()
	config:Init()

	db = mini:GetSavedVars()

	if CompactUnitFrame_UpdateCenterStatusIcon then
		hooksecurefunc("CompactUnitFrame_UpdateCenterStatusIcon", OnCufSetAlpha)
	end
end

function addon:Refresh()
	local frames = BlizzardFrames()

	for _, frame in ipairs(frames) do
		UpdateAlpha(frame)
	end
end

mini:WaitForAddonLoad(OnAddonLoaded)
