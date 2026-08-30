-- Loads the whole addon into a mocked client and drives it through login.
-- The shared body lives in build/Lua/SmokeTest.lua.

local fw = require("TestFramework")
local smoke = require("SmokeTest")
local WowMock = require("WowMock")

local VERTICAL_SPACING = 16

---The section rule is built by the framework and never handed back to the addon, so a test
---finds it the way a player sees it, by its label.
---@param text string
---@return table?
local function FindDivider(text)
	for _, frame in ipairs(WowMock.Frames) do
		if frame.Label and frame.Label.GetText and frame.Label:GetText() == text then
			return frame
		end
	end
end

---The styled toggle keeps its label on a .Text field, so a test finds it by its caption.
---@param text string
---@return table?
local function FindCheckbox(text)
	for _, frame in ipairs(WowMock.Frames) do
		if frame.Text and frame.Text.GetText and frame.Text:GetText() == text then
			return frame
		end
	end
end

---@return table?
local function FindSlider()
	for _, frame in ipairs(WowMock.Frames) do
		if frame:GetObjectType() == "Slider" then
			return frame
		end
	end
end

smoke.Run("MiniRangeFader", {
	extra = function(context)
		fw.eq(context.Addon.Framework.CustomStyling, true, "custom styling on")
		fw.eq(context.Addon.Framework.CustomStylingOverrides.Button, false, "stock buttons")

		local divider = FindDivider("SETTINGS")
		fw.not_nil(divider, "the settings section rule under the header")

		local checkbox = FindCheckbox("Background")
		fw.not_nil(checkbox, "the Background checkbox")

		local _, checkboxAnchor, _, checkboxX, checkboxY = checkbox:GetPoint()
		fw.eq(checkboxAnchor, divider, "the Background checkbox anchors to the section divider")
		fw.eq(checkboxX, 0, "the Background checkbox has no horizontal offset")
		fw.eq(checkboxY, -VERTICAL_SPACING, "one vertical spacing between the divider and the checkbox")

		local slider = FindSlider()
		fw.not_nil(slider, "the alpha slider")

		local _, sliderAnchor, _, sliderX, sliderY = slider:GetPoint()
		fw.eq(sliderAnchor, checkbox, "the alpha slider anchors to the Background checkbox")
		fw.eq(sliderX, 0, "the alpha slider has no horizontal offset")
		fw.eq(sliderY, -VERTICAL_SPACING * 2, "a slider needs a double gap since its label sits above the track")
	end,
})
