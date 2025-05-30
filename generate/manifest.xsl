<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:pw="https://sp1rit.arpa/pixiewood/"
	xmlns:meta="https://specifications.freedesktop.org/metainfo/1.0"
	xmlns:android="http://schemas.android.com/apk/res/android"
	xmlns:android-tools="http://schemas.android.com/tools"
	version="1.0"
>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="libname"/>

	<xsl:template match="/pw:app">
		<xsl:variable name="id" select="pw:metainfo/meta:component/meta:id[not(@xml:lang)]" />
		<manifest>
			<application
				android:name="org.gtk.android.RuntimeApplication"
				android:allowBackup="true"
				android:icon="@mipmap/ic_launcher"
				android:label="@string/app_name"
				android:roundIcon="@mipmap/ic_launcher_round"
				android:supportsRtl="true"
				android:theme="@style/Theme.Gtk"
				android-tools:targetApi="35"
			>
				<meta-data android:name="gtk.android.lib_name" android:value="{$libname}" />
				<activity android:name="org.gtk.android.ToplevelActivity"
					android:configChanges="density|orientation|screenLayout|screenSize|touchscreen|uiMode"
					android:windowSoftInputMode="adjustResize"
					android:launchMode="standard"
					android:resizeableActivity="true"
					android:theme="@style/Theme.GtkSurface"
					android:exported="true"
				>
					<intent-filter>
						<action android:name="android.intent.action.MAIN" />
						<category android:name="android.intent.category.LAUNCHER" />
					</intent-filter>
					<xsl:for-each select="pw:metainfo/meta:component/meta:provides/meta:mediatype | pw:metainfo/meta:component/meta:mimetypes/meta:mimetype">
						<xsl:variable name="actions" select="str:split(@actions, '|')" />
						<intent-filter>
							<action android:name="android.intent.action.VIEW"/>
							<xsl:if test="boolean($actions[. = 'edit'])">
								<action android:name="android.intent.action.EDIT"/>
							</xsl:if>
							<category android:name="android.intent.category.DEFAULT"/>
							<!-- TODO: how to do browsable intents?: category.BROWSABLE + scheme http+https -->
							<data android:scheme="content"/>
							<data android:scheme="file"/>
							<data android:mimeType="{.}" />
						</intent-filter>
					</xsl:for-each>
				</activity>
			</application>
			<uses-permission android:name="android.permission.REORDER_TASKS"/>
			<xsl:if test="pw:metainfo/meta:component/meta:requires[meta:internet='always' or meta:internet='first-run']
			            | pw:metainfo/meta:component/meta:recommends[meta:internet='always' or meta:internet='first-run']
			            | pw:metainfo/meta:component/meta:suggests[meta:internet='always' or meta:internet='first-run' or meta:internet='offline-only']">
				<uses-permission android:name="android.permission.INTERNET"/>
				<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
			</xsl:if>
		</manifest>
	</xsl:template>
</xsl:stylesheet>
