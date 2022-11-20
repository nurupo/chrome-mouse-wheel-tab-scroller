# Chrome Mouse Wheel Tab Scroller

Program for scolling Google Chrome tabs using a mouse wheel.

Windows-only, tested only with Google Chrome.

## Screenshots

In action:

![Animation showing tab switching](https://i.imgur.com/ye1cNBc.gif)

Tray menu:

![Animation showing the tray menu](https://i.imgur.com/aED5mOf.gif)

## Motivation

I got used to being able to scroll Chromium tabs using a mouse wheel on Linux, so much so that when I use Google Chrome on Windows, I often catch myself trying to scroll tabs with a mouse wheel to no success, as Google Chrome doesn't support this on Windows.
There are lot of browser extensions for scrolling tabs using a mouse wheel, many of which don't work or impose some weird requirements, like having the Alt key being pressed in addition to using a mouse wheel in order to scroll the tabs.
I got annoyed by all of this and hacked together an AutoIt script, which you can find here.

## How it works

Every time you scroll your mouse wheel the program kicks in, checks if the window directly under the mouse cursor is Google Chrome and if the mouse cursor is within the tabs area (the top part of the window), if so, it will emulate pressing Ctrl+PageUp or Ctrl+PageDown keys, which are Google Chrome keyboard shortcuts for navigating to the previous or the following tab.

## Setup

- Download the executable from [Releases](https://github.com/nurupo/chrome-mouse-wheel-tab-scroller/releases)
- Run it
- Make the script automatically start at the system startup by right-clicking on the tray icon and selecting "Run at startup" -> "As Administrator", agreeing to the prompts

Alternatively, you can run the AutoIt script `chrome-mouse-wheel-tab-scroller.au3` directly if you have [AutoIt installed](https://www.autoitscript.com/site/autoit/downloads/). Though you might want to build an .exe, as running .au3 directly won't set the tray icon correctly.

## FAQ

### What is the purpose of autofocus?

To switch tabs, the program sends previous/following tab keyboard shortcuts to Google Chrome. Google Chrome registers the shortcuts only when it is the focused window. As such, if you are, for example, in File Explorer, and have Google Chrome visible behind it, you can't switch the tabs unless you click on Google Chrome to make it the focused window. The autofocus option allows you to avoid having to click on Google Chrome by automatically focusing it for you. Some of the autofocus options even bring you back to the previously focused window, e.g. the File Explorer in this example, making it look as if the autofocusing never happened and Chrome switched the tabs without being focused.

### What is the difference between the two "Undo the autofocus" options?

The "fast but simple" option changes the focus from Google Chrome straight to the application that was previously focused.

The "comprehensive but slow" option changes the focus from Google Chrome to all the windows above the Google Chrome, one window at a time.

The effect this has is that the "comprehensive but slow" properly restores the focus order/history of all windows above Chrome. To give an example, say you have multiple windows above Google Chrome: Window1 and Window2, with Windows2 being currently focused. If you mouse over the Google Chrome window and scroll the tabs, the program would briefly focus the Google Chrome window to send it the previous/following tab keyboard shortcuts and will undo the focus depending on the option selected as described above, making Window2 being the focused window again. Now, if you close Window2, depending on which option you used, you will get a different behavior. If the "comprehensive but slow" option was used, Window1 would become focused, as expected, since it was right under Window2. However, if the "fast but simple" option was used, then Window1 that was visible on the screen behind Window2 would unexpectedly disappear under the Google Chrome window, with Google Chrome becoming the focused window.

### What is the "Wait after focusing" option?

How long the program should wait after focusing a window, giving the window the time to properly draw itself, bring itself up and, in case of focusing Google Chrome, accept keyboard input. Lowering the value might result in better autofocus responsiveness, at the cost of window flickering. Lowering the value too much might result in Google Chrome not receiving keyboard shortcuts for tab switching properly and in the "Undo the autofocus" options not undoing the autofocus correctly.

## Troubleshooting

### Mouse moves weirdly

If you are running a version before v1.0.0 -- update! This could happen in the previous versions of the program, but the newer versions (v1.0.0 and newer) have switched to using the Raw Input mouse capture method which shouldn't affect the mouse movement.

If this affects a specific application, you can temporarily disable the program while you are using the affected application by left-clicking on the tray icon, or, alternatively, right-clicking on the tray icon and selecting "Disable".
The tray icon will show a little red x symbol in a corner, signifying that the program is disabled.

### Autofocus doesn't always work

For the autofocus to work in all cases, the program should be run as Administrator.
Right-click on the tray icon and select "Restart as Administrator".

If the program runs with regular user's privileges and the currently focused window is a privileged window, e.g. the Task Manager, Windows prevents the program from capturing the mouse input, so the program doesn't know that you are scrolling the mouse wheel and thus it doesn't autofocus Google Chrome.
To work around this, you can run the program as Administrator or not have a privileged window being in focus.

### Antivirus flags the program

Antiviruses might incorrectly flag the .exe as malicious as AutoIt is often used by [script kiddies](https://en.wikipedia.org/wiki/Script_kiddie) for writing malicious programs, and the way AutoIt creates an .exe file is by combining the AutoIt.exe and a script into a single .exe file, so all .exes produced by AutoIt are very similar bit-wise and prone to false positives from antiviruses.

You don't have to trust my executable if you don't want to.
As long as you trust the source code, you can [install AutoIt](https://www.autoitscript.com/site/autoit/downloads/) and run the .au3 file directly, or build your own .exe out of it, which AutoIt makes very easy to do.

## Attribution

The application icon is a combination of:

- [Google Chrome icon](https://www.iconfinder.com/icons/1298719/chrome_google_icon) by [Just UI](https://www.iconfinder.com/justui)
- [tab icon](https://www.iconfinder.com/icons/3256/tab_icon) by [Everaldo Coelho](http://www.everaldo.com/)
- [x icon](https://www.iconfinder.com/icons/1398917/circle_close_cross_delete_incorrect_invalid_x_icon) by [iconpack](https://www.iconfinder.com/iconpack)

## License

chrome-mouse-wheel-tab-scroller.au3 -- GPL-3.0-only.

The icons are licensed differently.
