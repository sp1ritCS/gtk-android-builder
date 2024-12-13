# GTK Android builder

Help build the app package with GLib/GTK stack for Android.

## License

gtk-android-builder is licensed under the GPLv3.

## Install
GTK Android builder is a perl script tool, no need compile.

```sh
make install
```

## Usage
The process of build Android app package is as following:

```sh
# Generate an Android application skeleton
pixiewood generate 

# Boundle the Android package
pixiewood build pixiewood.apk
```

## Documentation

```
Usage: pixiewood [options] <action>

Global Options:
  -C, --change-dir <DIR>          The project source root of the project to build
  -v, --verbose                   Enable verbose output
  --help                          Display this help message
  -V, --version                   Display version and debug information

Actions:
  prepare [options] <manifest>    Prepare the project for building with GTK Android. This includes
                                  patching the subprojects and configuring the build directories.
    --release                       Create a release instead of debug build
    -a, --android-studio-dir <DIR>  Location where Android Studio is installed
    -s, --sdk <DIR>                 Install location of the Android SDK
    -t, --toolchain <DIR>           Install location of the Android NDK (typically within the SDK)
    --meson <EXECUTABLE>            Specify the executable for the meson buildsystem

  generate                        Generate an Android application skeleton based on the manifest.

  build [--skip-gradle]           Build the project and wrap it into and Android package.
```

## Getting in Touch

Matrix room: [#gtk-android-builder:gnome.org](https://matrix.to/#/#gtk-android-builder:gnome.org)
