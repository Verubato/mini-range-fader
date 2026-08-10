# MiniRangeFader - bot reference

Version 1.3.2. Interface versions: 120100, 120007 (retail Midnight only).
Saved variables: MiniRangeFaderDB (account-wide).

## What it does

Lets you choose how transparent Blizzard's compact party/raid frames become
when a unit is out of range. Since Midnight the default out-of-range alpha
dropped from 0.55 to 0.3, which many players find too aggressive; this addon
restores 0.55 by default, or any value you pick.

## How it works

- Hooks CompactUnitFrame_UpdateCenterStatusIcon and re-applies your chosen
  alpha whenever a frame's out-of-range state updates.
- Applies to Blizzard compact party frames (CompactPartyFrameMember1-5) and
  compact raid frames (CompactRaidFrame1-40). Nameplates are explicitly
  ignored, and custom raid frame addons are not touched.
- In-range frames stay at full alpha; only out-of-range frames get faded.

## Settings

Open with a slash command or Options -> AddOns -> MiniRangeFader.

| Setting | Type | Default | Range | Effect |
|---|---|---|---|---|
| Alpha | slider | 0.55 | 0.1 - 1.0, step 0.05 | Opacity used for out-of-range units. 1.0 means no fading at all. |
| Black Background | checkbox | on | - | Keeps a solid black background behind each raid frame; the background ignores the fade so faded frames stay readable. |

## Slash commands

/minirangefader, /minirf, /mrf - all open the settings panel.

## Troubleshooting

- "It does nothing on my raid frames": only default Blizzard compact
  party/raid frames are supported, not ElvUI/Grid2/Cell or similar.
- "Frames still fully fade": the slider only takes effect when the frame's
  out-of-range state updates; moving the slider triggers a refresh of
  currently visible frames.
- "Why can't I install it on Classic": the addon targets retail (Midnight)
  clients only.
