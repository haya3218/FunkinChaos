### Update

FULLY RELEASED LMAOOOOOOOOO
CURRENTLY IN BETA
UPDATES SOON

# Friday Night Funkin' Chaos

This is the repository for Friday Night Funkin' Chaos, a fork of Friday Night Funkin', a game originally made for Ludum Dare 47 "Stuck In a Loop".
Chaos is not responsible for the burning of your eyes and mouth.
All proceeds go to no one.

Play the Ludum Dare prototype here: https://ninja-muffin24.itch.io/friday-night-funkin
Play the Newgrounds one here: https://www.newgrounds.com/portal/view/770371
Support the original project on the itch.io page: https://ninja-muffin24.itch.io/funkin

## Credits / shoutouts

### Original Game
- [ninjamuffin99 (me!)](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

### Mod Makers
- [haya (me, the one who kicked this off)](https://example.com) - Programmer
- [FriedFrick](https://example.com) - Second Programmer and the one who game me the idea
- [Keaton Hoshida](https://example.com) - Art maker for some of the characters
- [Saff](https://example.com) - Logo
- [Bishop](https://example.com) - for being cute lmao
- [LuciDin](https://example.com) - cool guy
- [Smokey](https://example.com), [Rozebud](https://example.com), [KadeDev](https://example.com) and [Cval](https://example.com) - for being cool lmao

This game was made with love to Newgrounds and it's community. Extra love to Tom Fulp.

## Build instructions

### Installing shit

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
The link to that is on the [HaxeFlixel website](https://haxeflixel.com/documentation/getting-started/)

That should give you HaxeFlixel and all of it's setup and shit. If you run into issues, ask them in the #flixel channel in the [Haxe Discord Server](https://discord.gg/5ybrNNWx9S).

Other installations you'd need is the additional libraries, a fully updated list will be in `Project.xml` in the project root, but here are the one's I'm using as of writing.

```
hscript
flixel-ui
newgrounds
```

So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install polymod. 
First, get git, which is as simple as [clicking this link, dumbo](https://gitforwindows.org/).
Then use the command prompt and type this in.

```
haxelib git polymod https://github.com/larsiusprime/polymod.git
```

### Ignored files

I gitignore the export folder for the game, since it uses a lot of obj files from VS 2019 (we'll get to that later).

### Compiling game

Once you have all those installed, it's pretty easy to compile the game. You just need to run 'lime test html5 -debug' in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))

To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. 

# Building to Linux

For Linux, you only need to open a terminal in the project directory and run 'lime test linux -debug' and then run the executible file in export/release/linux/bin. 

# Building to Windows

For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
* C++ Profiling tools
* C++ CMake tools for windows
* C++ ATL for v142 build tools (x86 & x64)
* C++ MFC for v142 build tools (x86 & x64)
* C++/CLI support for v142 build tools (14.21)
* C++ Modules for v142 build tools (x64/x86)
* Clang Compiler for Windows
* Windows 10 SDK (10.0.17134.0)
* Windows 10 SDK (10.0.16299.0)
* MSVC v141 - VS 2017 C++ x64/x86 build tools
* MSVC v140 - VS 2015 C++ build tools (v14.00)

This will install about 22GB of crap, but once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin

# Building to Mac

As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac. Its semi-same with the Linux building steps.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)
