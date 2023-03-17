# World of Warcraft

A note to myself:
WOW was a nice game. But there are some reasons why I should not play it anymore.

* Addons make the game playable
* Multiple servers, character transfer, factions, etc.; If you're not on the right server, you are not one of us
* Massive time wasted
  * Achievements, etc.; To find an item that will be useless in the next major patch
  * Rare bosses: Hard to find, Respawn 8h
  * Drop chance 0.5% 0.01%
  * Eternal collecting things; Like grinding a sword that is never finished
* After each new patch, you could virtually delete everything you had before
  * Every item you own is useless
  * Each quest area, does not bring you; You can't even play there for fun
  * Only unbalanced time wandering dungeons
* Score (Gear Score, ...); Prove to me that you can play before I play with you
* Stupid players; It is not a problem if you have to learn something first, only if you are learning resistant

And the most important point:
A game should be fun!
Just start and go, without any obligations or anything like that.
Immerse yourself in a breathtaking world where you can find like-minded people.
When I want to work, I do something else.

*Last extension: Dragonflight*

*Note: Possibly old and untested*

## Links

* [World of Warcraft](https://worldofwarcraft.com/)
* [CurseForge](https://download.curseforge.com/)

## Shortcuts

| Key       | Action    |
|:--------- |:--------- |
| Ctrl + R  | Show FPS  |

## Backup on Linux

```bash
tar -C ~/.var/app/com.usebottles.bottles/data/bottles/bottles/Blizzard/drive_c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/ -Jcf /mnt/storage/backup/games/$(date +%Y-%m-%d)_World-of-Warcraft.tar.xz Interface Screenshots WTF
```

## Addons

Creates a 'WOW-Adons_username.txt' file with Addon folder on Desktop:

```powershell
$pathWowAddons = "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns";
$pathDesktop = [Environment]::GetFolderPath("Desktop");
(Get-ChildItem -Path "$pathWowAddons" -Directory -Force -ErrorAction SilentlyContinue | Sort Name).Name | Set-Content -Path "$pathDesktop\WOW-Addons_$env:UserName.txt"
```

Questionable:

* Cyb Core
* Broken [MoveAnything](https://www.curseforge.com/wow/addons/move-anything)

* [AdiBags: Archaeology](https://www.curseforge.com/wow/addons/adibags-archaeology)
* [AdiBags: Artifact_Weapons](https://www.curseforge.com/wow/addons/adibags-artifacts)
* Old-Broken [AdiBags: Azerite Essence items](https://www.curseforge.com/wow/addons/adibags-azerite-essence-items)
* Old-Broken [AdiBags: Battle Pet Items](https://www.curseforge.com/wow/addons/adibags-battle-pet-items)
* Old-Broken [AdiBags: DevelopmentFilter (Bug: Tooltip reading)]()
* Old-Broken [AdiBags: Fishing_Items](https://www.curseforge.com/wow/addons/adibags-fishing-items)
* Old-Broken [AdiBags: Garrison](https://www.curseforge.com/wow/addons/adibags_garrison)
* [AdiBags: Hearthstones](https://www.curseforge.com/wow/addons/adibags-hearthstones)

* Old-Broken [AdiBags: Legion](https://www.curseforge.com/wow/addons/adibags_legion)
* Old-Broken [AdiBags: Mechagon_Tinkering](https://www.curseforge.com/wow/addons/adibags-mechagon-tinkering)
* Old-Broken [AdiBags: Openable](https://www.curseforge.com/wow/addons/adibags_openable)
* [AdiBags: Shadowlands](https://www.curseforge.com/wow/addons/adibags-shadowlands)

* [Adibags: Zereth Mortis](https://www.curseforge.com/wow/addons/adibags-zerethmortis)
* [Zereth Mortis Puzzle Helper](https://www.curseforge.com/wow/addons/zereth-mortis-puzzle-helper)

* [Mythic Plus Timer](https://www.curseforge.com/wow/addons/mythicplustimer)
* [TomCat's Tours](https://www.curseforge.com/wow/addons/tomcats)

Recommended:

* [AdiBags](https://www.curseforge.com/wow/addons/adibags)
* [Adibags: Dragonflight](https://www.curseforge.com/wow/addons/adibags-dragonflight)
* [AdiBags: Jukebox](https://www.curseforge.com/wow/addons/adibags-jukebox)
* [AdiBags: World Events](https://www.curseforge.com/wow/addons/adibags-world-events)

* [BugSack](https://www.curseforge.com/wow/addons/bugsack)
* [Deadly Boss Mods (DBM)](https://www.curseforge.com/wow/addons/deadly-boss-mods)
* [Deadly Boss Mods (DBM) - Dungeons (All Dungeon Mods)](https://www.curseforge.com/wow/addons/deadly-boss-mods-dbm-dungeons)
* [GoGoMount](https://www.curseforge.com/wow/addons/gogomount-ghudas-fork)
* [Minimap Button Bag Reborn](https://www.curseforge.com/wow/addons/minimapbuttonbag-reborn-mmb-reborn)
* [Postal - Mailbox enhancement](https://www.curseforge.com/wow/addons/postal)
* [Prat - Chat enhancement](https://www.curseforge.com/wow/addons/prat-3-0)
* [Scrap - Junk Seller](https://www.curseforge.com/wow/addons/scrap)
* [SilverDragon - Rare Scanner](https://www.curseforge.com/wow/addons/silver-dragon)
* [TomTom](https://www.curseforge.com/wow/addons/tomtom)
* [WeakAuras](https://www.curseforge.com/wow/addons/weakauras-2)
* [WIM](https://www.curseforge.com/wow/addons/wim-3)

Optional:

* [BtWQuests](https://www.curseforge.com/wow/addons/btw-quests)
* [DejaCharacterStats](https://www.curseforge.com/wow/addons/dejacharacterstats)
* [Decursive](https://www.curseforge.com/wow/addons/decursive)
* [Groupfinder Flags](https://www.curseforge.com/wow/addons/groupfinderflags)
* [HandyNotes](https://www.curseforge.com/wow/addons/handynotes)
* [HandyNotes: Data Broker and Minimap Button](https://www.curseforge.com/wow/addons/handynotes-databroker)
* [MacroToolkit](https://www.curseforge.com/wow/addons/macro-toolkit)
* [Narcissus](https://www.curseforge.com/wow/addons/narcissus)
* [OPie: Radial action-binding](https://www.curseforge.com/wow/addons/opie)
* [Pawn: Find upgrades](https://www.curseforge.com/wow/addons/pawn)
* [Quartz: Casting bar](https://www.curseforge.com/wow/addons/quartz)
* [World Quest Tracker](https://www.curseforge.com/wow/addons/world-quest-tracker)

Debugging:

* [AddonUsage](https://www.curseforge.com/wow/addons/addon-usage)
* [idTip](https://www.curseforge.com/wow/addons/idtip)

Expansion - Burning Crusade:

* [Ogri'Lazy](https://www.curseforge.com/wow/addons/ogri-lazy)
  * [An Apexis Relic](https://www.wowhead.com/quest=11058/an-apexis-relic)
  * /ogri

Expansion - Warlords of Draenor:

* [Master plan: Garrison and Naval Missions UI](https://www.townlong-yak.com/addons/master-plan)

Expansion - Battle for Azeroth:

* [War plan: War Campaign missions](https://www.townlong-yak.com/addons/war-plan)

Expansion - Shadowland:

* [Venture plan: Adventure Campaign missions](https://www.townlong-yak.com/addons/venture-plan)

Handy Notes:

* General
  * [Azeroth's Top Tunes](https://www.curseforge.com/wow/addons/handynotes_azerothstoptunes)
  * [Field Photographer](https://www.curseforge.com/wow/addons/handynotes-field-photographer)
  * [Travel Guide](https://www.curseforge.com/wow/addons/handynotes-travelguide)
* Dungeon
  * [Ahn'Qiraj Scarab Coffers (AQ20/40)](https://www.curseforge.com/wow/addons/handynotes-ahnqiraj-scarab-coffers-aq20-40)
* Events
  * [Hallow's End](https://www.curseforge.com/wow/addons/handynotes_hallowsend)
  * [Midsummer Festival](https://www.curseforge.com/wow/addons/handynotes_summerfestival)
* Classic
  * [Well Read: Books](https://www.curseforge.com/wow/addons/handynotes-well-read)
  * [Warfront Treasure](https://www.curseforge.com/wow/addons/handynotes-warfront-treasure)
* The Burning Crusade
* Wrath of the LichKing
  * [Higher Learning: Read Books in Dalaran](https://www.curseforge.com/wow/addons/handynotes-higher-learning)
* Cataclysm
* Mists of Pandaria
  * [Pandaria](https://www.curseforge.com/wow/addons/handynotes-pandaria)
  * [Timeless Isle](https://www.curseforge.com/wow/addons/handynotes-timeless-isle)
* Warlords of Draenor
  * [Draenor](https://www.curseforge.com/wow/addons/handynotes-draenor)
handynotes_treasurehunter)
* Legion
  * [Argus](https://www.curseforge.com/wow/addons/handynotes-argus)
  * [Broken Shore](https://www.curseforge.com/wow/addons/handynotes-broken-shore)
  * [Higher Dimensional Learning](https://www.curseforge.com/wow/addons/handynotes_higherdimensional)
  * [Legion (Treasures and Rares)](https://www.curseforge.com/wow/addons/handynotes_legiontreasures)
  * [Suramar and Shal'Aran Telemancy](https://www.curseforge.com/wow/addons/handynotes-suramar-and-shalaran-telemancy)
  * [Withered Army Training](https://www.curseforge.com/wow/addons/handynotes-withered-army-training)
    * Möglichst komplette verdorrte nehmen
    * Vermutlich 1x pro Tag?!
    * Last max verdorrte: 400
    * /way #680 36.49 45.83 Erste Arkanistin Thalyssra
* Battle for Azeroth
  * [Battle for Azeroth](https://www.curseforge.com/wow/addons/handynotes-battle-for-azeroth)
  * [Battle for Azeroth Treasures](https://www.curseforge.com/wow/addons/handynotes-battle-for-azeroth-treasures)
  * [Ferry Network](https://www.curseforge.com/wow/addons/handynotes-ferry-network)
* Shadowlands
  * [Shadowlands](https://www.curseforge.com/wow/addons/handynotes-shadowlands)
  * [Maze Helper (Dungeon: Mists of Tirna Scithe)](https://www.curseforge.com/wow/addons/maze-helper-mists-of-tirna-scithe)
* Dragonflight
  * [Dragonflight](https://www.curseforge.com/wow/addons/handynotes-dragonflight)
  * [Dragonflight (Dragon Isles) Treasures and Rares](https://www.curseforge.com/wow/addons/handynotes-dragonflight-treasures)
  * [Dragon Glyphs](https://www.curseforge.com/wow/addons/handynotes-dragon-glyphs)

## Konfiguration

Optionen > Tab "Spiel":

* Gameplay
  * Steuerung
    * Steuerung > Schnell-Plündern = true
  * Interface
    * Namensplaketten > Alle Namensplaketten anzeigen = true
  * Aktionsleisten
    * Aktionsleisten 2,3,4,5 = true
  * Kontakte > Chatzeitstempel = 15:27
  * Tastaturbelegung
    * Bewegungstasten: Automatisch rennen ein/aus = Maustaste 4 [Unset Numlock]
    * GoGoMount: Aufsitzen/Absitzen = Maustaste 5

## Chill points

Addon Tomtom:

```lua
-- Get current position
/way local

-- Show current location
/way list

-- Azeroth > Die Verheerten Inseln > Suramar
/way #680 50.00 65.30 Wheater: Somewhere at Suramar (Arkane Sparkles)

-- Azeroth > Die Verheerten Inseln > Val'sharah > Der Hain der Träume
/way #715 35.33 53.15 Smaragdgrüner Traumpfad
```

## Macros

```lua
-- Show addon "addon usage"
/addonusage

-- Shadowlands: Weekly rewards > Icon: Box
/run LoadAddOn("Blizzard_WeeklyRewards") WeeklyRewardsFrame:Show()

-- Raid Frame Lock/Unlock
/click CompactRaidFrameManagerDisplayFrameLockedModeToggle

-- Esc > Interface > Game > Raid Profiles > Keep Groups Together
/click CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether

-- Toggle Autoloot
/run if(GetCVar("autoLootDefault") == "1") then t="Off"; SetCVar("autoLootDefault", 0); else t="On"; SetCVar("autoLootDefault", 1); end; DEFAULT_CHAT_FRAME:AddMessage("[App] Autoloot "..t);

-- Lock/unlock action bar
/run if(LOCK_ACTIONBAR == 1) then o=false; LOCK_ACTIONBAR=0; else o=true; LOCK_ACTIONBAR=1;end;m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n) then EditMacro(i,n,o and 550 or 561,b,l,_);end;end;

-- Auto quest watch
/run SetCVar("autoQuestWatch", 1) ReloadUI()
/console autoQuestWatch 1 and /console autoQuestWatch 0 then do a /reload

-- Blue
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,533,b,l,_);end;end;

-- Green
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,550,b,l,_);end;end;

-- Red
/run m=GameTooltipTextLeft1:GetText();for i=0,36 do n,x,b,l=GetMacroInfo(i);if(m==n)then EditMacro(i,n,561,b,l,_);end;end;
```

## Useful

* @todo Untested: Use Portals between Draenor and Outland
  * Wait until [Timewalking Dungeon Event](https://www.wowhead.com/events#holidays;q=timewalking): Burning Crusade (15.02.2023 - 22.02.2023)
  * Map: Scherbenwelt > Shattrath
  * /way #111 54.6 39.6 Cupri (Timewalking Vendor)
  * Buy: [Ever-Shifting Mirror](https://www.wowhead.com/item=129929/ever-shifting-mirror)
  * See: HandyNotes - Travel Guide

* Get a free bag: [Misty Satchel](https://www.wowhead.com/item=202194/misty-satchel)
  * Map: Azeroth > Dracheninseln > Küste des Erwachens
  * /way #2022 59.25 53.20 Fly through the waterfall at the grab handle

## Mytic Skillung

Talente: 15 = Cenarischer Zauberschutz, 40 = Inkarnation - Baum des Lebens, 50 = Gedeihen

## Raid Skillung

Talente: 15 = Überfluss, 40 = Grüner Daumen, 50 = Photosynthese

## WeakAura

Instanzen / Raid:

* [Maze Assist | Mists of Tirna Scithe](https://wago.io/EgXRfuxSw/7)
* [Xy'mox Annihilation casting bar](https://wago.io/0rO0pTnjK/1)

Quest:

* [Postmaster Sorting DE](https://wago.io/prRg1e0Hr)

## Runenschnitzen

* Schreiben des Tempos (173160)
* Schreiben der Meisterschaft (173162)

## Bag

-- Safe to delete
https://de.wowhead.com/item=178149/#english-comments
They are mainly used for the bonus objective in Bastion.
These are used for the Hostile Recollection quest in Bastion, click on Depleted Clawguards for +8% completion.
https://www.youtube.com/watch?v=MKzcSqtTNTE

### Bag: Quest

https://de.wowhead.com/item=20404/#english-comments
/way #81 53.2 35.0 Bor Wildmane
these now gives 500 reputation for each turn in of 10 at Bor Wildmane > Silithus


### Bag: Keys

https://de.wowhead.com/item=29460/#english-comments
Managruft

https://de.wowhead.com/item=87779/#english-comments
/way 22.8 25.8
/way #390 21.4 16.9 Uralte Guo-Lai-Truhe
Pandaria > Tal der Ewigen Blüten > Guo-Lai hallen > Truhe im keller irgendwo 2-3 Spawn punkte erreichbar

### Bag: Other 1

https://de.wowhead.com/item=45038/#english-comments
https://de.wowhead.com/item=174927/#english-comments
https://de.wowhead.com/item=128320/#english-comments
https://de.wowhead.com/item=141011/#english-comments
https://de.wowhead.com/item=115463/#english-comments
https://de.wowhead.com/item=85580/#english-comments
https://de.wowhead.com/item=9313/#english-comments
https://de.wowhead.com/item=24538/#english-comments
https://de.wowhead.com/item=109076/#english-comments
https://de.wowhead.com/item=82392/#english-comments
https://de.wowhead.com/item=29735/#english-comments
https://de.wowhead.com/item=3599/#english-comments
https://de.wowhead.com/item=81054/#english-comments
https://de.wowhead.com/item=112499/#english-comments

### Bag: Junk

https://de.wowhead.com/item=69815/#english-comments
https://de.wowhead.com/item=71141/#english-comments
https://de.wowhead.com/item=163691/#english-comments
https://de.wowhead.com/item=94221/#english-comments

### Bag: Reagent

https://de.wowhead.com/item=138875/#english-comments
(One crystal is consumed when you use Runas' Crystal Grinder to create 20 Crackling Shards.)
If you use up the 5 crystals you get from the quest reward, you can pick more up later scattered around Leyhollow cave.

### Bag: Other 2

* 182744 Prächtige Gürtelschnalle
/way #1525 48.6 68.6 Deadfoot
5x Durchfluteter Rubin -> All-In-One Belt Repair Kit

* 94130 95350 Zauberformel von ... https://de.wowhead.com/item=95350/zauberformel-von-vu#english-comments

```lua
/run for t,q in pairs({Incantation=32611,Trove=32609,LeiShenKey=32626,RareMobLooted=32610,Chamberlain=32505}) do print(format("%s (%s): %sDone",t,q,C_QuestLog.IsQuestFlaggedCompleted(q) or "Not ")) end
```

## Show quest done

```lua
/run for t,q in pairs({Incantation=32611,Trove=32609,LeiShenKey=32626,RareMobLooted=32610,Chamberlain=32505}) do print(format("%s (%s): %sDone",t,q,C_QuestLog.IsQuestFlaggedCompleted(q) or "Not ")) end

/dump C_QuestLog.IsQuestFlaggedCompleted(40963)

/run for i,q in ipairs({32611,32609,32626,32610,32505}) do print(format("%s (%s): %sDone",C_QuestLog.GetTitleForQuestID(q) or "",q,C_QuestLog.IsQuestFlaggedCompleted(q) or "Not ")) end
```

```bash
curl -H "Authorization: Bearer {TOKEN}" "https://eu.api.blizzard.com/data/wow/item/115530?namespace=static-eu&locale=de_DE" | jq
```

-- Garrision
122473, https://de.wowhead.com/item=122473/fanal-der-legion

# Fliegen Battle Atzeroth

Erforscher von Battle for Azeroth
* Erkundet Drustvar
* Erkundet Zuldazar
* Erkundet Vol'dun

Diplomat von Azeroth -> Respektvoll
* Der Glutorden
* Die Sturmwacht
* 7. Legion
* Champions von Azeroth
* Tortollanische Sucher

Die weite Welt der Quests
* 8 / 100

Gerüstet zum Krieg
* Blutgetränkter Sand
* Jagd auf die Dunkelheit
* Goldene Gelegenheit
* Blut im Wasser

## Schrottplatz: Music Rolls

```lua
/way #1462 25.4 76.4 Steel Singer Freza
/way #1462 56.2 36.0 Ol' Big Tusk
/way #1462 51.6 50.0 Boilburn
/way #1462 58.6 68.6 Gemicide
/way #1462 63.6 24.8 Earthbreaker Gulroc
/way #1462 54.8 28.4 Boggac Skullbash
/way #1462 57.2 52.4 Mechagonian Nullifier
/way #1462 63.0 57.0 Data Anomaly

/way #1462 66.2 40.4 The Kleptoboss
/way #1462 66.4 47.8 The Kleptoboss
/way #1462 66.8 46.0 The Kleptoboss
/way #1462 66.8 48.4 The Kleptoboss
/way #1462 66.8 48.6 The Kleptoboss
/way #1462 67.0 42.8 The Kleptoboss
/way #1462 67.2 46.6 The Kleptoboss
/way #1462 67.8 46.2 The Kleptoboss
/way #1462 68.4 46.8 The Kleptoboss
/way #1462 68.4 47.6 The Kleptoboss
/way #1462 68.6 46.6 The Kleptoboss
/way #1462 68.8 46.4 The Kleptoboss
/way #1462 69.0 45.4 The Kleptoboss
/way #1462 71.4 49.2 The Kleptoboss
/way #1462 71.8 49.8 The Kleptoboss

169688, -- Vinyl: Gnomeregan Forever
/way #1462 54.8 28.4 Boggac Skullbash
/way #1462 57.2 52.4 Mechagonian Nullifier

169689, -- Vinyl: Mimiron's Brainstorm
/way #1462 25.4 76.4 Steel Singer Freza
/way #1462 56.2 36.0 Ol' Big Tusk
/way #1462 51.6 50.0 Boilburn
/way #1462 58.6 68.6 Gemicide
/way #1462 63.6 24.8 Earthbreaker Gulroc
/way #1462 66.2 40.4 The Kleptoboss

169690, -- Vinyl: Battle of Gnomeregan
/way #1462 63.0 57.0 Data Anomaly

169691, -- Vinyl: Depths of Ulduar
/way #1462 25.4 76.4 Steel Singer Freza
/way #1462 56.2 36.0 Ol' Big Tusk
/way #1462 51.6 50.0 Boilburn
/way #1462 58.6 68.6 Gemicide
/way #1462 63.6 24.8 Earthbreaker Gulroc
/way #1462 66.2 40.4 The Kleptoboss

169692, -- Vinyl: Triumph of Gnomeregan
/way #1462 25.4 76.4 Steel Singer Freza
```

## Garnision: Music Rolls

```lua
-- Stash of Dusty Music Rolls: Alliance and Horde
122219, -- Music Roll: Way of the Monk

-- Kalimdor (from North to South)
122214, -- Music Roll: Mulgore Plains

-- Outland
122196, -- Music Roll: The Burning Legion
```

Kalimdor (from North to South)
* Shalandis Isle - Looted from High Priestess' Reliquary front of Tyrande Whisperwind in the Temple of the Moon, Darnassus.
* The Shattering - Chance to loot from Deathwing's Elementium Fragment, last encounter of Dragon Soul.

Eastern Kingdom:
* Legends of Azeroth - Chance to drop from Nefarian in Blackwing Descent.
* Karazhan Opera House - Chance to drop from the Opera encounter in Karazhan.
* Zul'Gurub Voodoo - Chance to drop from Jin'do the Godbreaker in Zul'Gurub.

Northend:
* Mountains of Thunder - Chance to drop from Loken in Halls of Lightning.
* Invincible - Chance to drop from The Lich King in Icecrown Citadel.
* Wrath of the Lich King - Chance to drop from Kel'Thuzad in Naxxramas.

Pandaria:
* Song of Liu Lang - Sold by Tan Shin Tiao for 80 gold in Vale of Eternal Blossoms. Need to be Revered with the Lorewalkers faction.
* Heart of Pandaria - Chance to drop from Sha of Fear in Terrace of Endless Spring.
* War March - Sold by Ongrom Black Tooth for 500 Lion's Landing Commission at Domination Point. Guide to Dominance Offensive.

Draenor:
* A Siege of Worlds - Chance to drop from Blackhand in Blackrock Foundry.

## Garnision

Angelhütte 2
* Erfolg: Draenorangler
  - 100x Seeskorpionangler
  - 100x Angler von dicken Schläfern
  - 100x Angler von Schwarzwasserpeitschflossen
  - 100x Feuerammonitenangler
  - 100x Angler von kieferlosen Schleichern
  - 100x Angler von blinden Seestören
  - 100x Angler von Tiefenschluckaalen

Mondsturzausgrabung 2
* Erfolg: Bleibt ein Weilchen und hört zu
  - Quest: Cros Rache
  - Quest: Ein wenig missgelaunt
  - Quest: Der Seelenschnitter
  - Quest: Das gütige Strahlen
  - Quest: Familientraditionen
  - Quest: Schattenhafte Geheimnisse
  - Quest: Cenarische Belange
  - Quest: Aber ja keine Streitkolben!
  - Quest: Oralius' Abenteuer
  - Quest: Gut zu Vögeln
  - Quest: Zeitverlorene Wikinger
  - Quest: Der Messingkompass
  - Quest: Ein Heilmittel gegen den Tod
  - Quest: Avianas Anfrage
  - Quest: Damen und Drachen
  - Quest: Die Jägerinnen
  - Quest: Titanenevolution
  - Quest: Spalten der Zeit
  - Quest: Das Leerentor
  - Quest: Kalter Stahl

Handelsposten 2
* Erfolg: Wilde Freunde
  - Draenor 3 Fraktionen erfürchtig

Lagerhaus 2
* Erfolg: Ich wär' so gerne Millionär

Menagerie 2
* Erfolg: Draenischer Haustierkämpfer

/range 18

## Development

* [API Clients](https://develop.battle.net/access/clients)
* [API Documentation](https://develop.battle.net/documentation/world-of-warcraft/game-data-apis)

### API Authorization

```bash
source functions.sh
getKeysByJsonFile ~/Sync/private-notes/storage/api-keys.json
wowItemTranslate 22206 37898
```

## Garnision:

* Alchemiegeheimnisse von Draenor
* Ingenieursgeheimnisse von Draenor

## Die Welt verfinstern:

* Dunkelmond-Insel
* /way 36.54 57.96 Rona Grünzahn
* Tintenschwarzer Trank (ID: 124640)

## Die Nacht zum Tag machen:

* Azeroth > Kalimdor > Tanaris > Höhlen der Zeit
* /way 42.14 71.70 Otela
* Sonnenerwärmter Sand (ID: 170379)
* Krug mit sonnenerwärmter Sand (ID: 170380)

## Wildtierkampf (Pokemon)

Todeskombi (Für Kämpfe gegen legendäre Sologegner):
* Knochi
* Winziger Wirbelsturm
* Ikki

Pet kontert:
* Kleiner böse Wolf: Kleintiere
* Nexuswelpling: Flugtiere
* Mechanischer Axtschnabel: Wildtiere
* Detektiv Ray: Drachkin
* Schimmerschnecke: Elementare
* Verzauberter Stift: Flugtiere
* (Jeder Elementar): Mechanischer
* Gnatz: Humanoide
* Benax: Untote
* Mechanischer Pandarendrachling: Magische

Zum Fangen anderer Viecher:
* Corgi

Dolchzahnfrenzy
Diener von Demidos

## World of Warcraft

Schicker Dschungelhut
Wallendes Saphirontuch

Quests:
/way reset all
/way Tanaandschungel 58.44 60.32 Exarchin Yrel

Erweiterungen

* Wrath of the Lich King (Legion)
* Cataclysm
* Mists of Pandaria
* Warlords of Draenor
* Legion
* Battle for Azeroth
* Shadowlands

Server: Antonias

del: cybw, Items: Insigne der Allianz, Düsterbräus Fernbedienung
del: cybj, items: Hundepfeife, Überquellender violetter Braufestkrug

Talente:

* Pflege
  * Cenarischer Zauberschutz
* Erneuerung
  * Wilde Attacke
* Gleichgewichtsaffinität
* Herz der Wildnis
* Inkarnation: Baum des Lebens
  * Grüner Daumen
* Frühlingsblüten
* Photosynthese

* Mal der Wildnis
* Rasche Frühlingsreife
* Fokussierendes Wachstum

Kochen: Sungshin Eisentatz: Pandaria, Tal der Vier Winde, Halbhügel, 55,77, 51,23

sync-notes ? damit man dinge auslagern kann. eventuell als privates ordner

```lua
/cast [nostance:4] Mondkingestalt
/cast [form:4] Mondfeuer
/cast [nostance:3] Cat Form(Shapeshift);
/cast Katzengestalt

/cancelform [stance:6/4/3/2/1]
/dismount [mounted]
/cast Schnelligkeit der Natur
/stopcasting
/cast [help] Heilende Berührung; [target=player] Heilende Berührung
```
