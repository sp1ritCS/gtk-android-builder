<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:set="http://exslt.org/sets"
	xmlns:pw="https://sp1rit.arpa/pixiewood/"
	xmlns:meta="https://specifications.freedesktop.org/metainfo/1.0"
	version="1.0"
>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="/pw:app">
		<xsl:for-each select="set:distinct(//pw:metainfo//*[@xml:lang]/@xml:lang)">
			<xsl:value-of select="."/>
			<xsl:text>&#x0A;</xsl:text>
		</xsl:for-each>
       </xsl:template>
</xsl:stylesheet>
