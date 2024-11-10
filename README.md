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

## WebSocket Specifications
Although the guidelines did dictate that it is mandatory that this application must be able to consume feed from a WebSocket, it did not give any specifications on the commands should be structured. Therefore, I had to come up with a general ruleset that the WebSocket commands should follow.

The commands contain multiple segments separated by spaces. Each command can be broken up into 3 parts:
- `Command`: The first segment which tells the command handler exactly what kind of action you are trying to perform. This is case insensitive.
- `Modulator`: The second segment which tells the command handler what subcommand you are trying to run under the specific command. This is case insensitive.
- `Arguments`: Any segments after the second segment. These are the additional values that would be passed to the command handler which change how the command would evaluate. This is case sensitive.

Although not all commands require it, all 3 segments are required for a command to exhibit expected behavior. Now, that we have gone through the expected expected segments, let's go through the valid command combinations.

### The `usb` command
This command is used to satisfy the requirement that entails that the application should be able to receive and handle a websocket command that enables and/or disables the use of USB drives. It must be followed by the `device` modulator.

This command expects one argument after the `device` modulator which can be either `block` or `unblock`. The `block` argument disables the use of USB drives and the `unblock` argument enables the usage of USB drives.

> An example of a complete command would be `usb device block`

### The `sync` command
This command is used to tell the receiver to synchronize all of its contents with the other end. It updates the local caches of the sync folder snapshot so that it matches up with its current state. It supports only one modulator which is `now`.

> An example of a complete command would be `sync now`

### The `push` command
This command is used by the receiver that the sender needs it to forward its own version of a given file. It could probably because the file has been updated or it needs to maintain consistency with the receiver. This command has 3 modulators which are `folder`, `file`, and `eof`.

The `folder` modulator is used to tell the receiver that it requires the sender to synchronize all of the contents of a given folder. It is currently not supported by this client. It expects only one argument which is the path of the folder that needs to be retrieved relative from the _sync folder_. 

The `file` modulator is used to tell the receiver that it requires the sender requires it to send its version of the contents of a given file. It expects only one argument which is the path of the file that needs to be retrieved relative from the _sync folder_. 

The `eof` modulator is used to tell the sender that it has reached the end of the current ***file*** that is being streamed. This implies that when all the contents of a folder are being retrieved and uploaded, it would be followed by two `push eof` commands. This command takes no arguments.

> An example of a complete command would be `push file foo/bar.txt`

### The `pull` command
This command is used by the sender to tell the receiver that it needs to retrieve its own version of a given file or folder because it is probably the most up to date. This command has 3 modulators which are `folder`, `file`, and `eof`.

The `folder` modulator is used to tell the receiver that it needs to pull the contents of an entire folder from the sender. It expects only one argument which is the path of the folder to be retrieved relative from the _sync folder_. 

The `file` modulator is used to tell the receiver that it needs to pull the contents of a single file from the sender. It expects only one argument which is the path of the file to be retrieved relative from the _sync folder_. 

The `eof` modulator is used to tell the receiver that we have reached the end of the current ***file*** that is being streamed. This implies that when all the contents of a folder are being retrieved and uploaded, it would be followed by two `push eof` commands. This command takes no arguments.

> An example of a complete command would be `pull file foo/bar`

### The `cmd-status` command
This command is used by the sender to tell the receiver about the status of the last command that was received. It is used in either one of two ways: to tell the receiver about how the last operation went, or to tell the receiver if it can proceed to do what is expected by the last command.

This command only has two possible values which are:

- `cmd-status true` which means that the last command was fine or the receiver can proceed to do what is expected by the last command.
- `cmd-status false` which means that the last command failed or the receiver should not proceed with executing the last command.