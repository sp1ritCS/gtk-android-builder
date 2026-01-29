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
import groovy.io.FileType
import java.nio.charset.StandardCharsets
import java.security.MessageDigest

plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace '<xsl:value-of select="$package" />'
    compileSdk 35

    defaultConfig {
        applicationId "<xsl:value-of select="$package" />"
        minSdk 31
        targetSdk 35
<xsl:variable name="version" select="pw:vermax(//pw:metainfo//meta:component//meta:releases//meta:release//@version)" />
<xsl:variable name="vercalc" select="pw:metainfo/@vercalc" />
<xsl:choose>
	<xsl:when test="$vercalc = 'sem121010'">
        versionCode <xsl:value-of select="pw:semver2code($version)" />
	</xsl:when>
	<xsl:when test="$vercalc = 'identity'">
        versionCode <xsl:value-of select="$version" />
	</xsl:when>
	<xsl:otherwise>
        versionCode <xsl:value-of select="count(pw:metainfo/meta:component/meta:releases/meta:release)" />
	</xsl:otherwise>
</xsl:choose>
        versionName "<xsl:value-of select='$version'/>"

        multiDexEnabled false

        ndk {
            abiFilters <xsl:value-of select="$abis" />
        }
    }

    def fingerprintAssetDir = layout.buildDirectory.dir("generated/fingerprint")
    sourceSets.main.assets.srcDir(fingerprintAssetDir)
    tasks.register('generateFingerprint') {
        def assetsDir = layout.projectDirectory.dir("src/main/assets").asFile
        doLast {
            def assetsList = []
            assetsDir.eachFileRecurse FileType.FILES, { File file ->
                assetsList &lt;&lt; file
            }
            assetsList.sort { it.path }

            def digest = MessageDigest.getInstance("SHA-512")
            def buffer = new byte[4096]
            assetsList.forEach { File file ->
                def relPath = assetsDir.toPath().relativize(file.toPath())
                digest.update(relPath.toString().getBytes(StandardCharsets.UTF_8))
                file.withInputStream { InputStream stream ->
                    int bytesRead
                    while ((bytesRead = stream.read(buffer)) > 0) {
                        digest.update(buffer, 0, bytesRead)
                    }
                }
            }
            def digestOut = digest.digest()

            mkdir fingerprintAssetDir
            def fingerprintBuffer = new byte[128]
            // Historically, the fingerprint was 128 random bytes. As we use
            // a SHA-512 hash here, we have 64 bytes left over that are just
            // zeroed.
            System.arraycopy(digestOut, 0, fingerprintBuffer, 0, Math.min(digestOut.length, fingerprintBuffer.length))
            def fingerprintFile = fingerprintAssetDir.get().file("afpr").asFile
            fingerprintFile.createNewFile()
            fingerprintFile.bytes = fingerprintBuffer
        }
    }
    applicationVariants.configureEach { variant ->
        variant.getMergeAssetsProvider().configure { task ->
            task.dependsOn(generateFingerprint)
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
