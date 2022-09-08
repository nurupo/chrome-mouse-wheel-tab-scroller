# Chrome Mouse Wheel Tab Scroller

Program that allows you to scroll Google Chrome tabs using a mouse wheel.

Windows-only.

## Screenshots

In action:

![Animation showing tab switching](https://i.imgur.com/UksPxCz.gif)

Tray menu (as of v1.0.0):

![Screenshot of the tray menu](https://i.imgur.com/TSDYKeH.png)

## Motivation

I got used to being able to scroll Chromium tabs using a mouse wheel on Linux, so much so that when I use Google Chrome on Windows I often catch myself trying to scroll tabs with a mouse wheel, obviously to no success, as Google Chrome doesn't support this on Windows.
There are lot of browser extensions for scrolling tabs using a mouse wheel, many of which don't work or impose some weird requirements, like having the Alt key pressed in addition to using a mouse wheel in order to scroll the tabs.
I got annoyed by all of this and just hacked together a simple AutoIt script, which you can see here.

## How it works

Every time you scroll your mouse wheel the program kicks in, checks if the window directly under the mouse cursor is Google Chrome and if the mouse cursor is within the tabs area (the top part of the window), if so, it will emulate pressing Ctrl+PageUp or Ctrl+PageDown keys for mouse wheel up or mouse wheel down respectively.
Ctrl+PageUp and Ctrl+PageDown are Google Chrome hotkeys/shortcuts for navigating to the previous and the following tabs.

## Usage

- Download the executable from [Releases](https://github.com/nurupo/chrome-mouse-wheel-tab-scroller/releases)
- Store it somewhere on your PC, e.g. Desktop or `%LocalAppData%` folders
- Throw a shortcut to it into the Startup folder. You can type `shell:startup` into Win+R to open the Startup folder

Alternatively, you can run the AutoIt script `chrome-mouse-wheel-tab-scroller.au3` directly if you have [AutoIt installed](https://www.autoitscript.com/site/autoit/downloads/). You could even build the .exe yourself, as running .au3 directly won't set the tray icon. Throw it into Startup folder the same way and it should work.

## Troubleshooting

### Mouse is moving weirdly

The program might affect mouse performance, especially in video games.

If this happens to you, you can try changing the mouse capture method in the tray menu -- some might work better than other. If that doesn't help, you can try restarting the program.

You can also temporarily disable the program by left-clicking on it in the tray, or alternatively right-clicking and selecting "Disable (Gaming Mode)". The tray icon will change to one with a little red x symbol, signifying that it's disabled.

From my limited testing in Team Fortress 2, the Hook mouse capture method causes the mouse to behave weirdly in-game, while the Raw Input mouse capture method doesn't seem to affect the mouse performance (which is why it is the default).

### Antivirus flags the program

Antiviruses might incorrectly flag  the .exe as malicious, as AutoIt is often used by [script kiddies](https://en.wikipedia.org/wiki/Script_kiddie) and the way it creates .exe files is by combining AutoIt.exe and a script into a single .exe file, so all AutoIt .exes are very similar bit-wise and prone to false positives from antiviruses.

You don't have to trust my executable if you don't want to. As long as you trust the source code, you can [install AutoIt](https://www.autoitscript.com/site/autoit/downloads/) and run the .au3 file directly, or build your own .exe out of it, which AutoIt makes very easy to do.

## Attribution

This script uses [MouseOnEvent UDF](https://www.autoitscript.com/forum/topic/64738-mouseonevent-udf/), which is included in the repository for the convenience.

The application icon is a combination of:

- [Google Chrome icon](https://www.iconfinder.com/icons/1298719/chrome_google_icon) by [Just UI](https://www.iconfinder.com/justui)
- [tab icon](https://www.iconfinder.com/icons/3256/tab_icon) by [Everaldo Coelho](http://www.everaldo.com/)
- [x icon](https://www.iconfinder.com/icons/1398917/circle_close_cross_delete_incorrect_invalid_x_icon) by [iconpack](https://www.iconfinder.com/iconpack)

## License

chrome-mouse-wheel-tab-scroller.au3 -- GPL-3.0-only.

The icons and MouseOnEvent UDF are licensed differently.
