<div align="center">

![GTK Android Builder](https://raw.githubusercontent.com/sp1ritCS/gtk-android-builder/refs/heads/art_assets/pixiewood-banner.png)

<h1></h1>
</div>

GTK Android Builder (codename pixiewood), is a tool designed to facilitate the process of building GTK applications for Android phones. To goal of pixiewood is to effortlessly build preexisting GTK applications into packages compatible with Android, allowing users to install them with little effort on their devices.

## Usage

To build a GTK application for Android, it must meet the following preconditions:

- Have an exposed `main(int, char**, char**)` entrypoint (reduced parameters are allowed) that ends up calling `g_application_run` before it returns
- Have meson build script that uses `gnome.executable` from the [GNOME module](https://mesonbuild.com/Gnome-module.html) to define the application target. As of now, this requires a [forked meson](https://github.com/sp1ritCS/meson/tree/android2) (`git clone --depth 1 https://github.com/sp1ritCS/meson.git --branch android2`).

To then build the application, follow these steps:

1. `pixiewood prepare <manifest>`, with manifest being in format specified in [Pixiewood Format](#pixiewood-format). You might end up needing to specify paths of specific tools, among them `--meson <forked/meson/meson.py>`, for others check `pixiewood --help` to see what is available. Be aware that running `prepare` may overwrite preexisting wrap files in `subprojects/`.
2. `pixiewood generate`
3. `pixiewood build`

### Pixiewood Format
```xml
<?xml version="1.0" encoding="UTF-8"?>
<app xmlns="https://sp1rit.arpa/pixiewood/" xmlns:xi="http://www.w3.org/2001/XInclude">
	<metainfo vercalc="count">
	<!--
		vercalc determines which mechanism is used for converting the application version into an integer.
		The available modes are: 'count' (default), which just counts the number of releases listed,
		'sem121010' which calculates (major << 20) + (minor << 10) + (patch) but requires the versions to follow
		semantic versioning and 'identity' which only works if you use integer versions.
	-->

		<!--
			Ensure that the appstream manifest has xmlns="https://specifications.freedesktop.org/metainfo/1.0"
			and that {arch} is listed in /pw:app/pw:build/pw:architectures.
		-->
		<xi:include href="build://{arch}/{path/to/(localized)/appstream/manifest.xml}" parse="xml"/>
	</metainfo>
	<style>
		<!-- Currently available themes are "gtk" & "adw" -->
		<theme name="gtk"/>
		<icon type="generate">
			<drawable target="foreground" scale=".5" type="svg" path="src://{path/to/app/icon.svg}"/>
			<!-- You can also use drawable instead of color for target="background" -->
			<color target="background">#FFFFFF</color>
			<!-- The target="monochrome" is optional -->
			<drawable target="monochrome" scale=".5" type="svg" path="src://{path/to/app/icon-symbolic.svg}"/>
		</icon>
	</style>
	<dependencies>
		<glib revison="2.80.0">
			<patch>hack</patch>
		</glib>
		<harfbuzz/>
		<fontconfig/>
		<rsvg revision="librsvg-2.40">
			<patch>meson-for-gdkpixbuf</patch>
		</rsvg>
		<gdk-pixbuf>
			<patch>rsvg</patch>
		</gdk-pixbuf>
		<gtk/>
	</dependencies>
	<build target="{the meson target name}">
		<architectures>
			<arch>aarch64</arch>
			<arch>x86_64</arch>
		</architectures>
	</build>
</app>
```

## Installation
### Dependencies
Be aware that pixiewood ships and uses `Svg2Avd`, which requires `java` in PATH being `>= 17`. If you already have this or a newer Java installed, feel free to not install the `java-17` package.

#### openSUSE
```sh
# zypper in 'perl(Glib)' 'perl(Glib::Object::Introspection)' 'perl(IPC::Run)' 'perl(JSON)' 'perl(Set::Scalar)' 'perl(XML::LibXML)' 'perl(XML::LibXSLT)' 'typelib(AppStream)' 'java-17-openjdk'
# zypper in gcc gcc-c++ glib2-devel glib2-tools libxml2-tools meson ninja sassc shaderc
```

#### Fedora
```sh
# dnf install 'perl(Archive::Tar)' 'perl(Glib)' 'perl(Glib::Object::Introspection)' 'perl(IPC::Run)' 'perl(JSON)' 'perl(Set::Scalar)' 'perl(XML::LibXML)' 'perl(XML::LibXSLT)' appstream 'java-17-openjdk'
# dnf install gcc gcc-c++ glib2 glib2-devel glslc libxml2 meson ninja sassc
```

#### Debian
```sh
# apt-get install libglib-perl libglib-object-introspection-perl libipc-run-perl libjson-perl libset-scalar-perl libxml-libxml-perl libxml-libxslt-perl gir1.2-appstream openjdk-17-jre
# apt-get install build-essential glslc gobject-introspection libglib2.0-dev-bin libxml2-utils meson ninja-build sassc
```

### Install procedure

There are four ways to "install" gtk-android-builder

- Run `sudo make install` to install pixiewood system wide
- Run `make prefix=$HOME/.local/ install` for just your user
- Create a symlink to the `pixiewood` script in this directory and put it into a directory in your PATH
- Just run specify the path to the `pixiewood` script in this directory every invocation

## Special thanks

I want to thank the GTK developers ([Matthias Clasen](mailto:mclasen@redhat.com) et al.) that have helped me [porting GTK to Android](https://gitlab.gnome.org/GNOME/gtk/-/merge_requests/7555)
and [@theCapypara](https://github.com/theCapypara) for donating to me.
