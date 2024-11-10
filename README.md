# Overview
This is a cross-platform desktop application written in Flutter that receives and and acts on device web socket commands. It also creates a system tray entry so you would be able to quickly access commands you might otherwise want to.

# Getting started
To build and run this application on your computer:

1. You need to install the flutter framework. You can follow this guide for [Windows](https://docs.flutter.dev/get-started/install/windows/desktop), [linux](https://docs.flutter.dev/get-started/install/linux/desktop), and [MacOS](https://docs.flutter.dev/get-started/install/macos/desktop). The specific version used to build and test this application as seen is `3.24.4`.
2. After installing flutter correctly, clone this repository locally on your computer then open the folder you cloned this repository inside of.
3. Run the command `flutter pub get` to fetch all dependencies used for this project for your platform.
4. To build the app:
	- Linux: `flutter build linux`
	- Windows: `flutter build windows`
	- MacOS: `flutter build macos && open macos/Runner.xcworkspace`
5. After the build has finished the CLI utility would show you the folder where the executable was stored. You can navigate to that folder and then run the binary as you normally would.

# My assumptions
A requirement I kept in mind was that _if a real websocket address is connected, it should work fine without emulation._ To achieve this, I added a means of doing this to the settings page. After changing the websocket address, you would need to restart the app before it can connect to it and use it as needed.

Another thing I did that might have not been assumed was the way I handled the **sync folder**. What I chose to do was create a mini file explorer to make navigating the sync folder inside of the app easy for users. This does not mean that you can only trigger automatic syncs from within the application though. That is not the case. Automatic syncs can still be triggered as long as any change is made to a file/folder inside of the watched directory.