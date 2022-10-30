# Abandoned branch

This is an abandoned branch.

Windows UI Automation API (aka UIA) looked very promising for the purpose of switching Chrome tabs as it allows us to:

  - Get the actual size of the tabs area, instead of relying on the hardcoded offsets
  - Check if the first and last tabs are currently selected, allowing for an option to prevent tab scrolling from wraping around
  - Avoid having to send key presses triggering next/previous tab hotkeys, which sometimes bug out, allowing to programatically select the next/previous tab
  - Maybe more that I'm forgetting about

However, as it was later realized, this came with certain drawbacks:

  - [When using UIA, Chrome would consume more memory than usual](https://bugs.chromium.org/p/chromium/issues/detail?id=1379575)
    - On average around 600 MiB per 80 of fully loaded tabs, but it really depends the contents
    - In a worst case with just 5 loaded tabs, Chrome can go from using 7.5 GiB of memory to 20.5 GiB, becoming unresponsive for 100 seconds while allocating all this memory
  - [When using UIA, Chrome would take a very long time to close](https://bugs.chromium.org/p/chromium/issues/detail?id=1379575)
    - A window with 80 fully loaded tabs could take around 30 seconds to close, while being totally unresponsive in the process
    - In some cases a window might close immediately, but leave chrome.exe processes that keep consuming many GiB of memory and 100% of a single CPU core
  - Only visible tabs are accessible via UIA, if a tab goes off the screen -- it doesn't show up in the API call results, so we can't scroll to it
    - Took me a while to realize as I was testing with less than 130 tabs in a full screen window on a 1440p monitor, so I didn't have any tabs go off the screen during the testing

These drawbacks are big deal breakers, so UIA is abandoned in favor of sending keyboard shortcuts.

Personally I'm upset that using UIA ended up not being viable and I have to discard all of my work and go back to the key-based solution.
I have spent quite a bit of time working on this, and being able to disable scroll wrapping had me excited, as it was a big improvement towards the goal of imitating Chromium's behavior on Linux.

---

# Chrome Mouse Wheel Tab Scroller

Program that allows you to scroll Google Chrome tabs using a mouse wheel.

Windows-only.

## Screenshots

In action:

![Animation showing tab switching](https://i.imgur.com/UksPxCz.gif)

Tray menu (as of v2.0.0):

![Screenshot of the tray menu](https://i.imgur.com/eGOREZ6.png)

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

This could happen in the previous versions of the program, but the newer versions (v1.0.0 and newer) have switched to using the Raw Input mouse capture method which shouldn't affect the mouse movement.

You can temporarily disable the program by left-clicking on its icon in the tray, or alternatively right-clicking and selecting "Disable".
The tray icon will show a little red x symbol in a corner, signifying that the program is disabled.

### Autofocus stops working

Because the program runs with regular user's privileges, if the currently focused window is a privileged window, e.g. the Task Manager running as Administrator, Windows prevents the program from capturing the mouse input, so it doesn't know that you are scrolling the mouse wheel and thus is unable to function.
To work around this, you can run the program as Administrator or just not have a privileged window being in focus.

### Antivirus flags the program

Antiviruses might incorrectly flag  the .exe as malicious, as AutoIt is often used by [script kiddies](https://en.wikipedia.org/wiki/Script_kiddie) and the way it creates .exe files is by combining AutoIt.exe and a script into a single .exe file, so all AutoIt .exes are very similar bit-wise and prone to false positives from antiviruses.

You don't have to trust my executable if you don't want to.
As long as you trust the source code, you can [install AutoIt](https://www.autoitscript.com/site/autoit/downloads/) and run the .au3 file directly, or build your own .exe out of it, which AutoIt makes very easy to do.

## Attribution

This script uses parts of [UI Automation UDF](https://www.autoitscript.com/forum/topic/201683-ui-automation-udfs/), which are included in the repository for the convenience.

The application icon is a combination of:

- [Google Chrome icon](https://www.iconfinder.com/icons/1298719/chrome_google_icon) by [Just UI](https://www.iconfinder.com/justui)
- [tab icon](https://www.iconfinder.com/icons/3256/tab_icon) by [Everaldo Coelho](http://www.everaldo.com/)
- [x icon](https://www.iconfinder.com/icons/1398917/circle_close_cross_delete_incorrect_invalid_x_icon) by [iconpack](https://www.iconfinder.com/iconpack)

## License

chrome-mouse-wheel-tab-scroller.au3 -- GPL-3.0-only.

The icons are licensed differently.
