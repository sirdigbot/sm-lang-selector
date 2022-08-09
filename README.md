# Language Selector
A plugin that allows players to select the language they want SourceMod to translate text into.  

*Translations must be provided by plugins for this to have any effect on them.*  

## Features
- Configurable menu (modify `sourcemod/configs/langselect.cfg` and `cfg/sourcemod/plugin.langselect.cfg`).
- Saves player language setting across sessions (can be turned off).
- Optional prompt for new players to select a language (either ask once, or ask until they select something).
- Full and *absolutely overkill* translation support.

## How to install
See the releases tab for latest download.  
Extract the .zip/.7z into `addons/sourcemod/`.  

If upgrading, remember the auto-generated config file `cfg/sourcemod/plugin.langselect.cfg` may need to be deleted (but only if new ConVars are added).  

## Commands
| Command | Usage | Description | Access |
| --- | --- | --- | --- |
| **sm_language** | `sm_language <Country Code>` or `sm_language` (for menu) | Set your own SourceMod translation language. | Everyone |
| **sm_getlanguage** | `sm_getlanguage <Target>` | Get a player\'s SourceMod translation language. | `GENERIC` |
| **sm_setlanguage** | `sm_setlanguage <Target> <Country Code>` | Set a player\'s SourceMod translation language. | `BAN` |
| **sm_resetlanguage** | `sm_resetlanguage <Target>` | Reset a player\'s SourceMod translation language. | `BAN` |
| **sm_lang** | -- | *Shorter version of `sm_language`* | -- |
| **sm_getlang** | -- | *Shorter version of `sm_getlanguage`* | -- |
| **sm_setlang** | -- | *Shorter version of `sm_setlanguage`* | -- |
| **sm_resetlang** | -- | *Shorter version of `sm_resetlanguage`* | -- |  

## ConVars
```c
// Allow custom language codes with "sm_language <Code>".
// If 0, only codes available in the config (or the built-in list if config is disabled) are permitted.
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_allow_custom "0"

// Show a "Reset Language" option on the menu.
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_allow_reset "1"

// Location of the Language Selector config file (relative to the SourceMod directory).
// -
// Default: "configs/langselect.cfg"
langselect_config "configs/langselect.cfg"

// How should the language selection prompt show to a new player.
// 0 - On each respawn until a language is selected.
// 1 - Only once per session.
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_prompt_once "1"

// Should a player's selected language be saved.
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_save "1"

// Ask new players to select a language when they spawn.
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_show_prompt "0"

// Should the config file be used to set the available languages.
// If 0, this will use a built-in list of languages.
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
langselect_use_config "1"
```
