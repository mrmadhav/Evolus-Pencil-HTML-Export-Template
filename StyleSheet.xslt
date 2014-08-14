<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:p="http://www.evolus.vn/Namespace/Pencil" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml"
    media-type="text/html"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="DTD/xhtml1-strict.dtd"
    cdata-section-elements="script style"
    indent="yes"
    encoding="ISO-8859-1"/>
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <title>
                    <xsl:value-of select="/p:Document/p:Properties/p:Property[@name='fileName']/text()"/>
                </title>
                <link rel="stylesheet" type="text/css" href="Resources/Style.css"><xsl:text> </xsl:text></link>
                <script type="text/javascript" src="Resources/jquery.js"><xsl:text> </xsl:text></script>
                <script type="text/javascript" src="Resources/jquery.layout.js"><xsl:text> </xsl:text></script>
                <script type="text/javascript" src="Resources/jquery.ui.all.js"><xsl:text> </xsl:text></script>
                <script type="text/javascript" src="Resources/cookie.min.js"><xsl:text> </xsl:text></script>
                <script type="text/javascript" src="Resources/path.min.js"><xsl:text> </xsl:text></script>
                <script type="text/javascript" src="Resources/main.js"><xsl:text> </xsl:text></script>
            </head>
            <body>
                <h1 id="documentTitle">
                    <xsl:value-of select="/p:Document/p:Properties/p:Property[@name='fileName']/text()"/>
                </h1>
                <div id="leftpanel" class="ui-layout-west">
                        <xsl:for-each select="/p:Document/p:Pages/p:Page">
                            <div class="ThumbContainer">
                                <a href="#/page/{p:Properties/p:Property[@name='fid']/text()}" >
                                    <img src="{@rasterized}" style="min-width:100px"/>
                                    <hr/>
                                    <span class="number">
                                        <xsl:number value="position()" format="1"/>/<xsl:number value="last()" format="1"/>
                                    </span> -
                                    <xsl:value-of select="p:Properties/p:Property[@name='name']/text()"/>
                                </a>
                            </div>
                        </xsl:for-each>
                </div>
                <div id="main" class="ui-layout-center">
                        <xsl:apply-templates select="/p:Document/p:Pages/p:Page" />
                </div>
				<div id="pageNotes" class="ui-layout-south"></div>
                <p id="documentMetadata">Exported at: <xsl:value-of select="/p:Document/p:Properties/p:Property[@name='exportTime']/text()"/>
                </p>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="p:Page">
        <div class="page" id="{p:Properties/p:Property[@name='fid']/text()}">
            <div class="pageTitle">
                <xsl:value-of select="p:Properties/p:Property[@name='name']/text()"/>
                <div class="MainNumber">
                    Page <xsl:number value="position()" format="1"/>/<xsl:number value="last()" format="1"/>
                </div>
            </div>
            <div class="ImageContainer">
                <img class="raster" style="max-width:{p:Properties/p:Property[@name='width']/text()}px" src="{@rasterized}" usemap="#map_{p:Properties/p:Property[@name='fid']/text()}"/>
            </div>
            <xsl:if test="p:Note">
                <div class="notes">
                    <xsl:apply-templates select="p:Note/node()" mode="processing-notes"/>
				</div>
            </xsl:if>
            <map name="map_{p:Properties/p:Property[@name='fid']/text()}">
                <xsl:apply-templates select="p:Links/p:Link" />
            </map>
        </div>
    </xsl:template>
    <xsl:template match="p:Link">
        <area shape="rect" coords="{@x},{@y},{@x+@w},{@y+@h}" href="#/page/{@targetFid}" title="Go to page '{@targetName}'"/>
    </xsl:template>

    <xsl:template match="html:*" mode="processing-notes">
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() != '_moz_dirty']"/>
            <xsl:apply-templates mode="processing-notes"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="html:a[@page-fid]" mode="processing-notes">
        <a href="#/page/{@page-fid}" title="Go to page '{@page-name}'">
            <xsl:copy-of select="@class|@style"/>
            <xsl:apply-templates mode="processing-notes"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
