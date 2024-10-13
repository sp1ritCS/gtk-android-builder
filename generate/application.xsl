<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:pw="https://sp1rit.arpa/pixiewood/"
	xmlns:meta="https://specifications.freedesktop.org/metainfo/1.0"
	version="1.0"
>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="libname"/>

	<xsl:template match="/pw:app">
		<xsl:variable name="id" select="pw:metainfo/meta:component/meta:id[not(@xml:lang)]" />
		<xsl:variable name="package" select="translate($id, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:variable name="class" select="concat(str:split($id, '.')[last()], 'App')" />
package <xsl:value-of select="$package" />;

import android.app.Application;

import org.gtk.android.GlueLibraryContext;

public class <xsl:value-of select="$class" /> extends Application {
	static {
		GlueLibraryContext.setGlueLibraryProvider(() -&gt; "<xsl:value-of select='$libname'/>");
	}
}
	</xsl:template>
</xsl:stylesheet>
