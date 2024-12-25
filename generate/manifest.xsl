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

	<xsl:template match="/pw:app">
		<xsl:variable name="id" select="pw:metainfo/meta:component/meta:id[not(@xml:lang)]" />
		<xsl:variable name="class" select="concat(str:split($id, '.')[last()], 'App')" />
		<manifest>
			<application
				android:name=".{$class}"
				android:allowBackup="true"
				android:icon="@mipmap/ic_launcher"
				android:label="@string/app_name"
				android:roundIcon="@mipmap/ic_launcher_round"
				android:supportsRtl="true"
				android:theme="@style/Theme.Gtk"
				android-tools:targetApi="34"
			>
				<activity android:name="org.gtk.android.ToplevelActivity"
					android:configChanges="density|orientation|screenLayout|screenSize|touchscreen|uiMode"
					android:windowSoftInputMode="adjustResize"
					android:launchMode="standard"
					android:resizeableActivity="true"
					android:immersive="true"
					android:theme="@style/Theme.GtkSurface"
					android:exported="true"
				>
					<intent-filter>
						<action android:name="android.intent.action.MAIN" />
						<category android:name="android.intent.category.LAUNCHER" />
					</intent-filter>
					<xsl:for-each select="pw:metainfo/meta:component/meta:provides/meta:mediatype | pw:metainfo/meta:component/meta:mimetypes/meta:mimetype">
						<intent-filter>
							<action android:name="android.intent.action.VIEW"/>
							<!-- if mime is editable: action.EDIT -->
							<category android:name="android.intent.category.DEFAULT"/>
							<!-- if should be browsable: category.BROWSABLE + scheme http+https -->
							<data android:scheme="content"/>
							<data android:scheme="file"/>
							<data android:mimeType="{.}" />
						</intent-filter>
					</xsl:for-each>
				</activity>
			</application>
			<uses-permission android:name="android.permission.REORDER_TASKS"/>
		</manifest>
	</xsl:template>
</xsl:stylesheet>
