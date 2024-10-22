<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:math="http://exslt.org/math"
	xmlns:set="http://exslt.org/sets"
	xmlns:str="http://exslt.org/strings"
	xmlns:pw="https://sp1rit.arpa/pixiewood/"
	xmlns:meta="https://specifications.freedesktop.org/metainfo/1.0"
	version="1.0"
>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="abis"/>

	<xsl:template match="/pw:app">
		<xsl:variable name="id" select="pw:metainfo/meta:component/meta:id[not(@xml:lang)]" />
		<xsl:variable name="package" select="translate($id, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace '<xsl:value-of select="$package" />'
    compileSdk 34

    defaultConfig {
        applicationId "<xsl:value-of select="$package" />"
        minSdk 31
        targetSdk 34
        versionCode <xsl:value-of select="count(pw:metainfo/meta:component/meta:releases/meta:release)" />
        versionName "<xsl:value-of select='(//pw:metainfo//meta:component//meta:releases//meta:release//@version)[last()]'/>"

        multiDexEnabled false

        ndk {
            abiFilters <xsl:value-of select="$abis" />
        }
    }

    buildTypes {
        debug {
            minifyEnabled false
        }
        release {
            minifyEnabled false
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    splits {
        abi {
            enable true
            reset()
            include <xsl:value-of select="$abis" />
            universalApk true
        }
    }

    lint {
        disable "NamespaceTypo"
    }
}

dependencies {
    implementation libs.androidx.annotation
}
       </xsl:template>
</xsl:stylesheet>
