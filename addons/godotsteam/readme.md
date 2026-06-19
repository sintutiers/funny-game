`# GodotSteam for GDExtension | Sponsors Edition
A series of projects for GodotSteam sponsors to check out before release.  You can also guide how upcoming development by submitting pull requests or discussing in our [Discord server](https://discord.gg/SJRSq6K).


Documentation
---
[Documentation is available here](https://godotsteam.com). You can also check out the Search Help section inside Godot Engine. [To start, try checking out our tutorial on initializing Steam.](https://godotsteam.com/tutorials/initializing/) There are additional tutorials, with more in the works. You can also [check out additional Godot and Steam related videos, text, additional tools, plug-ins, etc. here.](https://godotsteam.com/resources/external/)

Feel free to chat with us about GodotSteam or ask for assistance on the [Stoat server](https://stt.gg/9DxQ3Dcd) or [IRC on Libera Chat](irc://irc.libera.chat/#godotsteam).


Current Build
---
You can [download pre-compiled versions of this repo here](https://codeberg.org/godotsteam/godotsteam-sponsors/releases).

**Version 4.19.1 Changes**

- Changed: commented out possible issue with removing dock node
- Fixed: in-editor docs error, thanks to ***evanwang0***

[You can read more change-logs here](https://godotsteam.com/changelog/gdextension/).


Compatibility
---
While rare, sometimes Steamworks SDK updates will break compatilibity with older GodotSteam versions. Any compatability breaks are noted below.  Newer API files (dll, so, dylib) _should_ still work for older versions.

Steamworks SDK Version | GodotSteam Version
---|---
1.63 or newer | 4.17
1.62 | 4.14 or 4.16.2
1.61 | 4.12 to 4.13
1.60 | 4.6 to 4.11
1.59 | 4.6 to 4.8
1.58a or older | 4.5.4 or older

Versions of GodotSteam that have compatibility breaks introduced.

GodotSteam Version | Broken Compatibility
---|---
4.8 | Networking identity system removed, replaced with Steam IDs
4.9 | sendMessages returns an Array
4.11 | setLeaderboardDetailsMax removed
4.13 | getItemDefinitionProperty return a dictionary, html_needs_paint key 'bgra' changed to 'rbga'
4.14 | Removed first argument for stat request in steamInit and steamInitEx, steamInit returns intended bool value
4.16 | Variety of small break points, refer to [4.16 changelog for details](https://godotsteam.com/changelog/godot4/#version-416)
4.17 | Windows projects using Steam SDK 1.63 are meant to work with Proton 11 or Experimental on Linux / Steam Deck.
4.19 | Lots of changes to Voice functions, refer to [4.19 changelog for details](https://godotsteam.com/changelog/godot4/#version-419)


Known Issues
---
- GDExtension for 4.4 is **not** compatible with 4.3.x or lower. Please check the versions you are using.
- Overlay will not work in the editor but will work in export projects when uploaded to Steam.  This seems to a limitation with Vulkan currently.


Quick How-To
---
For complete instructions on how to build the GDExtension version of GodotSteam, [please refer to our documentation's 'How-To GDExtension' section.](https://godotsteam.com/howto/gdextension/) It will have the most up-to-date information.

Alternatively, you can just [download the pre-compiled versions in our Releases section](https://codeberg.org/godotsteam/godotsteam-sponsors/releases) or [from the Godot Asset Library](https://godotengine.org/asset-library/asset/2445) and skip compiling it yourself!


Need Help?
---
As a sponsor, you can reach out to me [directly by e-mail at gp@godotsteam.com](mailto:gp@godotsteam.com).


Thank You!
---
Thank you so much for supporting this project!

I am always looking for some additional perks to provide to sponsors to show appreciation for you all supporting the project.  If you have any ideas, please feel free to hit me up at either of the places above!


License
---
MIT license
