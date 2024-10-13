<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pw="https://sp1rit.arpa/pixiewood/"
	xmlns:meta="https://specifications.freedesktop.org/metainfo/1.0"
	version="1.0"
>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="lang"/>

	<xsl:template match="/pw:app">
		<resources>
			<xsl:choose>
				<xsl:when test="not($lang)">
					<xsl:apply-templates select="pw:metainfo//meta:component/*[not(@xml:lang)]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="pw:metainfo//meta:component/*[@xml:lang=$lang]" />
				</xsl:otherwise>
			</xsl:choose>
		</resources>
	</xsl:template>

	<xsl:template match="meta:name">
		<string name="app_name"><xsl:value-of select="."/></string>
	</xsl:template>

	<xsl:template match="*" priority='-1'/>
</xsl:stylesheet>
