-- Loads the whole addon into a mocked client and drives it through login.
-- The shared body lives in build/Lua/SmokeTest.lua.

local fw = require("TestFramework")
local smoke = require("SmokeTest")
local WowMock = require("WowMock")

---The section rule is built by the framework and never handed back to the addon, so a test
---finds it the way a player sees it, by its label.
---@param text string
---@return boolean
local function HasDivider(text)
	for _, frame in ipairs(WowMock.Frames) do
		if frame.Label and frame.Label.GetText and frame.Label:GetText() == text then
			return true
		end
	end

	return false
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

---The alpha slider now sits below the renamed Background checkbox, not above it.
---@return boolean
local function SliderFollowsCheckbox()
	local checkbox = FindCheckbox("Background")

	if not checkbox then
		return false
	end

	for _, frame in ipairs(WowMock.Frames) do
		if frame:GetObjectType() == "Slider" then
			local _, relativeTo = frame:GetPoint()
			return relativeTo == checkbox
		end
	end

	return false
end

smoke.Run("MiniRangeFader", {
	extra = function(context)
		fw.eq(context.Addon.Framework.CustomStyling, true, "custom styling on")
		fw.eq(context.Addon.Framework.CustomStylingOverrides.Button, false, "stock buttons")
		fw.truthy(HasDivider("SETTINGS"), "the settings section rule under the header")
		fw.truthy(SliderFollowsCheckbox(), "the alpha slider follows the renamed Background checkbox")
	end,
})
