# double_jump_flag

Double jump plugin for players with a specific admin flag. Includes a built-in cooldown to prevent abuse.  
Published because the person who requested this plugin publicly claimed it as their own work.

## Installation

1. Compile `double_jump_flag_en.sma` (or `double_jump_flag_pl.sma`) using the AMXX compiler
2. Copy the resulting `.amxx` file to `addons/amxmodx/plugins/`
3. Add the plugin filename to `addons/amxmodx/configs/plugins.ini`

## Configuration

All settings are compile-time constants at the top of the `.sma` file:

| Constant | Default | Description |
|---|---|---|
| `DOUBLE_JUMP_FLAG` | `262144` (flag `s`) | Admin flag required to use double jump |
| `DOUBLE_JUMP_TIME` | `10.0` | Cooldown in seconds between jumps |
| `DOUBLE_JUMP_MIN_VELOCITY` | `265.0` | Minimum upward velocity applied on jump |
| `DOUBLE_JUMP_MAX_VELOCITY` | `285.0` | Maximum upward velocity applied on jump |

## TODO

- [ ] Instead of maintaining two separate plugins, introduce multi-lingual support: https://wiki.alliedmods.net/Advanced_Scripting_(AMX_Mod_X)#Multi-Lingual_Support

## Credits

- Original code by **benio101** & **speedkill** via AMXX.pl VIP Generator - https://amxx.pl/vipgenerator/
- Modified by me
