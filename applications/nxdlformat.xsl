<?xml version="1.0" encoding="UTF-8"?>

<!--
     Stylesheet to provide a condensed view of a NeXus NXDL specification.
     (see http://trac.nexusformat.org/definitions/ticket/181)

     The nxdlformat.xsl stylesheets differ between the directories 
     because of the rule regarding either /definition/NXentry or
     /definition/NXsubentry for application and contributed definitions.
     (see http://trac.nexusformat.org/definitions/ticket/179)

     Modify <xsl:template match="nx:definition">...</xsl:template> 
     for each directory.
     
     ########### SVN repository information ###################
     # $Date$
     # $Author$
     # $Revision$
     # $HeadURL$
     # $Id$
     ########### SVN repository information ###################


line breaks are VERY TRICKY here, be careful how you edit!
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:nx="http://definition.nexusformat.org/nxdl/3.1" version="1.0">

     <xsl:output method="text"/>
     <xsl:variable name="indent_step" select="'  '"/>


     <xsl:template match="/">
          <xsl:apply-templates select="nx:definition"/>
     </xsl:template>
     

     <!--
          Modify ONLY this section for each directory:
          base_classes/nxdlformat.xsl             no rule for NXentry or NXsubentry
          applications/nxdlformat.xsl             required rule for NXentry or NXsubentry
          contributed_definitions/nxdlformat.xsl  optional rule for NXentry or NXsubentry
     -->
     <xsl:template match="nx:definition">
          <xsl:call-template name="showClassName"/>
          <xsl:choose>
             <xsl:when test="count(nx:group[@type='NXentry'])=1"><!-- 
                  assume this is a candidate for an application definition
             -->  (overlays NXentry)<xsl:text><!-- tricky line break here -->
</xsl:text><xsl:call-template name="startFieldsGroups"/></xsl:when>
             <xsl:when test="count(nx:group[@type='NXsubentry'])=1"><!-- 
                  assume this is a candidate for an application definition
             -->  (overlays NXsubentry)<xsl:text><!-- tricky line break here -->
</xsl:text><xsl:call-template name="startFieldsGroups"/></xsl:when>
               <xsl:otherwise>
                    <!-- enforce required rule for NXentry or NXsubentry  -->  
                    /definition/NXentry or /definition/NXsubentry not found!
                    Cannot be used as an application definition.
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     

     <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
     <!-- +++    From this point on, the code is the same for,       +++ -->
     <!-- +++    base_classes applications/, and contributed/        +++ -->
     <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

     <!--
          This template describes an application or contributed definition that 
          overrides the standard NXentry or NXsubentry.
     -->
     <xsl:template match="nx:group[@type='NXentry']|nx:group[@type='NXsubentry']">
          <xsl:call-template name="startFieldsGroups"/>
     </xsl:template>
     

     <xsl:template match="nx:field">
          <xsl:param name="indent"/>
          <xsl:value-of select="$indent"/><xsl:value-of select="@name"/>:<xsl:choose>
               <xsl:when test="count(@type)"><xsl:value-of select="@type"/></xsl:when>
               <xsl:otherwise>NX_CHAR</xsl:otherwise>
          </xsl:choose>
          <xsl:text><!-- tricky line break here -->
</xsl:text>
     </xsl:template>
     

     <xsl:template match="nx:group">
          <xsl:param name="indent"/>
          <xsl:value-of select="$indent"/>
          <xsl:if test="count(@name)"><xsl:value-of select="@name"/>:</xsl:if>
          <xsl:value-of select="@type"/>
          <xsl:text><!-- tricky line break here -->
</xsl:text>
          <xsl:apply-templates select="nx:field">
               <xsl:with-param name="indent">
                    <xsl:value-of select="$indent"/>
                    <xsl:value-of select="$indent_step"/>
               </xsl:with-param>
               <xsl:sort select="@name"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="nx:group">
               <xsl:with-param name="indent">
                    <xsl:value-of select="$indent"/>
                    <xsl:value-of select="$indent_step"/>
               </xsl:with-param>
               <xsl:sort select="@type"/>
          </xsl:apply-templates>
     </xsl:template>
     

     <xsl:template name="startFieldsGroups">
          <xsl:choose>
               <!-- Two ways to render.  
                    1=1: fields before groups, sorted alphabetically
                    1!=1: order of appearance in NXDL
               -->
               <xsl:when test="1=1"><!-- write fields before groups -->
                    <xsl:apply-templates select="nx:field">
                         <xsl:with-param name="indent"><xsl:value-of select="$indent_step"/></xsl:with-param>
                         <xsl:sort select="@name"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="nx:group">
                         <xsl:with-param name="indent"><xsl:value-of select="$indent_step"/></xsl:with-param>
                         <xsl:sort select="@type"/>
                    </xsl:apply-templates>
               </xsl:when>
               <xsl:otherwise><!-- write in order of appearance in NXDL -->
                    <xsl:apply-templates select="nx:field|nx:group">
                         <xsl:with-param name="indent"><xsl:value-of select="$indent_step"/></xsl:with-param>
                         <xsl:sort select="@type"/>
                    </xsl:apply-templates>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     

     <xsl:template name="showClassName">
          <xsl:value-of select="@name"/> (<xsl:choose>
               <xsl:when test="@category='base'">base class</xsl:when>
               <xsl:when test="@category='application'">application definition</xsl:when>
               <xsl:when test="@category='contributed'">contributed definition</xsl:when>
          </xsl:choose><xsl:if test="count(@version)">, version <xsl:value-of
               select="@version"/></xsl:if>)<xsl:text><!-- tricky line break here -->
</xsl:text></xsl:template>

</xsl:stylesheet>

<!--
     # NeXus - Neutron and X-ray Common Data Format
     # 
     # Copyright (C) 2008-2011 NeXus International Advisory Committee (NIAC)
     # 
     # This library is free software; you can redistribute it and/or
     # modify it under the terms of the GNU Lesser General Public
     # License as published by the Free Software Foundation; either
     # version 3 of the License, or (at your option) any later version.
     #
     # This library is distributed in the hope that it will be useful,
     # but WITHOUT ANY WARRANTY; without even the implied warranty of
     # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
     # Lesser General Public License for more details.
     #
     # You should have received a copy of the GNU Lesser General Public
     # License along with this library; if not, write to the Free Software
     # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
     #
     # For further information, see http://www.nexusformat.org
     
     ########### SVN repository information ###################
     # $Date$
     # $Author$
     # $Revision$
     # $HeadURL$
     # $Id$
     ########### SVN repository information ###################
-->
