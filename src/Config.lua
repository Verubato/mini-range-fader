local addonName, addon = ...
---@type MiniFramework
local mini = addon.Framework

---@type Db
local db

---@class Db
local dbDefaults = {
	OutOfRangeAlpha = 0.55,
	BlackBackground = true,
}

local M = {
	DbDefaults = dbDefaults,
}

addon.Config = M

function M:Init()
	db = mini:GetSavedVars(dbDefaults)

	local panel = CreateFrame("Frame")
	panel.name = addonName

	local category = mini:AddCategory(panel)

	if not category then
		return
	end

	local verticalSpacing = mini.VerticalSpacing
	local header = mini:PanelHeader({
		Parent = panel,
		Description = "Customise the raid frame transparency for units out of range.",
		Y = -verticalSpacing,
		Gap = 6,
	})

	mini:RegisterSlashCommand(category, panel, {
		"/minirangefader",
		"/minirf",
		"/mrf",
	})

	local slider = mini:Slider({
		Parent = panel,
		LabelText = "Alpha",
		Min = 0.1,
		Max = 1.0,
		Step = 0.05,
		GetValue = function()
			return db.OutOfRangeAlpha
		end,
		SetValue = function(value)
			db.OutOfRangeAlpha = mini:ClampFloat(value, 0.1, 1.0, dbDefaults.OutOfRangeAlpha)
			addon:Refresh()
		end,
	})

	slider.Slider:SetPoint("TOPLEFT", header.Anchor, "BOTTOMLEFT", 0, -verticalSpacing * 3)

	local checkbox = mini:Checkbox({
		Parent = panel,
		LabelText = "Black Background",
		Tooltip = "Show a black background behind each raid frame.",
		GetValue = function()
			return db.BlackBackground
		end,
		SetValue = function(value)
			db.BlackBackground = value
			addon:Refresh()
		end,
	})

	checkbox:SetPoint("TOPLEFT", slider.Slider, "BOTTOMLEFT", 0, -verticalSpacing)
end
