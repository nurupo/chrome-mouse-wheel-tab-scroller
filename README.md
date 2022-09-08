# Chrome Mouse Wheel Tab Scroller

Program that allows you to scroll Google Chrome tabs using a mouse wheel.

Windows-only.

## Screenshots

In action:

![Animation showing tab switching](https://i.imgur.com/UksPxCz.gif)

Tray menu (as of v0.2.0):

![Screenshot of the tray menu](https://i.imgur.com/TRYISyN.png)

## Motivation

I got used to Chromium on Linux allowing to scroll tabs using a mouse wheel, so that when I use Google Chrome on Windows I often times catch myself trying to scroll tabs with a mouse wheel to no success, as Google Chrome doesn't support this.
There seem to be a lot of browser extensions for scrolling tabs using a mouse wheel, majority of which don't work anymore or impose some weird requirements, like having the Alt key pressed in addition to using a mouse wheel in order to scroll the tabs.
I got annoyed by all this and just hacked together a simple AutoIt script, which you can see here.

## How it works

Every time you scroll your mouse wheel, no matter in which application you are, the program will kick in, check if the active window is Google Chrome and if the mouse is in the tab area of the browser window, if so, it will emulate pressing Ctrl+PageUp or Ctrl+PageDown keys for mouse wheel up or mouse wheel down respectively.
Ctrl+PageUp and Ctrl+PageDown are Google Chrome hotkeys for navigating to the previous and the following tabs.

## Usage

Either download the executable from [Releases](https://github.com/nurupo/chrome-mouse-wheel-tab-scroller/releases), or run the AutoIt script `chrome-mouse-wheel-tab-scroller.au3` directly if you have [AutoIt installed](https://www.autoitscript.com/site/autoit/downloads/). Throw it into Startup folder in the Start menu so that it would start on system startup and you are all set.

Note that the program might affect mouse performance, especially in video games, so if your mouse doesn't act as it should, you might want to disable the program temporarily (aka Gaming Mode) from the tray menu.

Also note that antiviruses like to mark any AutoIt application as a virus, even if such application is benign, so don't be too surprised if your antivirus complains about the executable. You don't have to trust my executable if you don't want to, all the source code is available to you, so you can build one from the sources yourself or just run the script directly without creating an executable -- either way you will have to have [AutoIt installed](https://www.autoitscript.com/site/autoit/downloads/). For the reference, I'm using AutoIt v3.3.6.1 and make the executable using AutoIt3Wrapper v2.0.1.24.

## Attribution

This script uses [MouseOnEvent UDF](https://www.autoitscript.com/forum/topic/64738-mouseonevent-udf/), which is included in the repository for the convenience.

The application icon is a combination of [Google Chrome icon](https://www.iconfinder.com/icons/1298719/chrome_google_icon) by [Just UI](https://www.iconfinder.com/justui), [tab icon](https://www.iconfinder.com/icons/3256/tab_icon) by [Everaldo Coelho](http://www.everaldo.com/) and [x icon](https://www.iconfinder.com/icons/1398917/circle_close_cross_delete_incorrect_invalid_x_icon) by [iconpack](https://www.iconfinder.com/iconpack).

## License

chrome-mouse-wheel-tab-scroller.au3 -- GPL-3.0-only.

The icons and MouseOnEvent UDF are licensed differently.
