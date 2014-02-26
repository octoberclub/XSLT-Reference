<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY id-prefix "">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:output
		method="html"
		indent="yes"
		omit-xml-declaration="yes"
		doctype-system="about:legacy-compat"
	/>

	<xsl:variable name="prefix" select="'&lt;xsl:'" />
	<xsl:variable name="suffix" select="'&gt;'" />

	<xsl:key name="elements-by-name" match="element" use="@name" />
	<xsl:key name="nodes-by-name" match="element | attribute" use="@name" />

	<xsl:template match="/">
		<html>
		<head>
			<title>XSLT Quick Reference</title>
			<link rel="stylesheet" href="css/docset.css" />
			<script src="scripts/application.min.js"></script>
			<meta name="viewport" content="width=device-width, initial-scale=1" />
			<xsl:comment>
Note: This file is generated by XSLT from the elements.xml file.
So you definitely shouldn't be editing it, or you'll end up sad...
			</xsl:comment>
		</head>
		<body id="toc">
			<section id="xslt-elements">
				<h1>XSLT elements</h1>
				<xsl:apply-templates select="docset/element">
					<xsl:sort select="@name" data-type="text" order="ascending" />
				</xsl:apply-templates>
			</section>

			<section id="xpath-functions">
				<h1>XPath functions</h1>
				<xsl:apply-templates select="docset/functions/function">
					<xsl:sort select="@name" data-type="text" order="ascending" />
				</xsl:apply-templates>
			</section>
			
			<xsl:call-template name="fork-banner" />
			<xsl:call-template name="toc-link" />
		</body>
		</html>
	</xsl:template>

	<xsl:template match="element">
		<section class="element" id="&id-prefix;{@name}">
			<xsl:apply-templates select="@name" />
			<xsl:apply-templates select="description" />
			<ul class="content">
				<xsl:apply-templates select="attribute" mode="content" />
			</ul>
			<ul class="content">
				<xsl:apply-templates select="element" mode="content" />
			</ul>
		</section>
	</xsl:template>

	<xsl:template match="element[@ref]">
		<xsl:apply-templates select="key('elements-by-name', @ref)" />
	</xsl:template>

	<xsl:template match="element/@name">
		<h1>
			<a href="#&id-prefix;{.}">
				<xsl:value-of select="$prefix" />
				<xsl:value-of select="." />
				<xsl:value-of select="$suffix" />
			</a>
		</h1>
	</xsl:template>

	<xsl:template match="element" mode="content">
		<xsl:variable name="elem" select="self::element[@name] | key('nodes-by-name', @ref)" />
		<xsl:variable name="displayName" select="concat($prefix, $elem/@name, $suffix)" />
		<li class="elem-ref">
			<a href="#&id-prefix;{$elem/@name}">
				<xsl:value-of select="$displayName" />
			</a>
		</li>
	</xsl:template>

	<xsl:template match="attribute" mode="content">
		<xsl:variable name="attr" select="self::attribute[@name] | key('nodes-by-name', @ref)" />
		<xsl:variable name="name" select="$attr/@name" />
		<li class="attr-ref">
			<xsl:if test="@required = 'yes'"><xsl:attribute name="class">attr-ref required</xsl:attribute></xsl:if>
			<xsl:value-of select="$name" />
			<xsl:apply-templates select="$attr" mode="typeinfo" />
		</li>
	</xsl:template>

	<xsl:template match="attribute" mode="typeinfo">
		<xsl:text> </xsl:text>
		<span class="type">
			<span class="general"><xsl:value-of select="@content" /></span>
		</span>
	</xsl:template>

	<xsl:template match="attribute[@content = 'enum']" mode="typeinfo">
		<span class="type">
			<xsl:text> (</xsl:text>
			<span class="enum"><xsl:value-of select="@values" /></span>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="attribute[@content = 'boolean']" mode="typeinfo">
		<span class="type">
			<xsl:text> (</xsl:text>
			<span class="enum">yes|no</span>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="attribute[@content = 'nmtokens']" mode="typeinfo">
		<xsl:text> </xsl:text>
		<span class="type">
			<span class="nmtokens">list of names</span>
		</span>
	</xsl:template>

	<xsl:template match="description">
		<div class="desc">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="description//*">
		<xsl:copy>
			<xsl:apply-templates select="* | text()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="description//note">
		<p class="note">
			<xsl:apply-templates />
		</p>
	</xsl:template>

	<xsl:template match="description//ref">
		<a href="#{.}" class="elem-ref">
			<xsl:value-of select="." />
		</a>
	</xsl:template>

	<xsl:template match="description//var">
		<var class="attr-ref">
			<xsl:value-of select="." />
		</var>
	</xsl:template>

	<xsl:template name="fork-banner">
		<a href="https://github.com/greystate/XSLT-Reference#readme">
			<img
				class="forkme"
				src="http://aral.github.com/fork-me-on-github-retina-ribbons/right-orange@2x.png"
				alt="Fork me on GitHub"
			/>
		</a>
	</xsl:template>
	
	<xsl:template name="toc-link">
		<nav class="toc-link">
			<a href="#toc" title="Show a simplified table of contents">Contents</a>
			<a href="#xslt-elements">XSLT</a>
			<a href="#xpath-functions">XPath</a>
		</nav>
	</xsl:template>
	
	<xsl:include href="_functions.xslt" />

</xsl:stylesheet>