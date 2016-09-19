<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->


<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139.swe" match="*|@*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Readonly elements -->
  <xsl:template mode="mode-iso19139" priority="2005" match="gmd:hierarchyLevel">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="codelist"
                  select="gn-fn-metadata:getCodeListValues($schema,
                                  'gmd:MD_ScopeCode',
                                  $codelists,
                                  .)"/>

    <xsl:variable name="value" select="gmd:MD_ScopeCode/@codeListValue" />

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="$codelist/entry[code = $value]/label"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="''"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
      <xsl:with-param name="listOfValues" select="''" />
    </xsl:call-template>

  </xsl:template>

  <!-- Readonly elements -->
  <xsl:template mode="mode-iso19139" priority="2005" match="gmd:metadataStandardName">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="gco:CharacterString"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="''"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
      <xsl:with-param name="listOfValues" select="''" />
    </xsl:call-template>

  </xsl:template>


  <!-- Language - Use restricted values defined as codelist in labels.xml -->
  <xsl:template mode="mode-iso19139" priority="2005" match="gmd:language">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
    <xsl:variable name="codelist" select="$labelConfig/codelist"/>


    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="$labelConfig/label"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="$codelist"/>
      <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>
  </xsl:template>


  <!-- Reference system -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:referenceSystemInfo[1]/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier" priority="1000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>


    <xsl:variable name="refSystemXmlSnippet">
      <![CDATA[
         <gmd:referenceSystemInfo xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gco="http://www.isotc211.org/2005/gco">
            <gmd:MD_ReferenceSystem>
               <gmd:referenceSystemIdentifier>
                  <gmd:RS_Identifier>
                     <gmd:code>
                        <gco:CharacterString>{{editRow.code}}</gco:CharacterString>
                     </gmd:code>
                     <gmd:codeSpace>
                        <gco:CharacterString>{{editRow.codespace}}</gco:CharacterString>
                     </gmd:codeSpace>

                  </gmd:RS_Identifier>
               </gmd:referenceSystemIdentifier>
            </gmd:MD_ReferenceSystem>
        </gmd:referenceSystemInfo>
    ]]>
    </xsl:variable>

    <xsl:variable name="codexpath" select="gn-fn-metadata:getXPath(gmd:RS_Identifier/gmd:code)" />

    <xsl:variable name="refSystemTableModel">
      [
      {
      name: 'code',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:code', $labels, name(gmd:RS_Identifier), '', $codexpath)/label" />',
      codelist: false,
      },
      {
      name: 'codespace',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:codeSpace', $labels, name(gmd:RS_Identifier), '', '')/label" />',
      codelist: false
      }
      ]
    </xsl:variable>


    <xsl:variable name="refSystemModel">
      [
      <xsl:for-each select="../../../gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier">
        {
        'ref': '<xsl:value-of select="../../../gn:element/@ref" />',
        'refChildren': {
          'code': '<xsl:value-of select="gmd:RS_Identifier/gmd:code/gco:CharacterString/gn:element/@ref" />',
          'codespace': '<xsl:value-of select="gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString/gn:element/@ref" />',
        },
        'code': '<xsl:value-of select="normalize-space(gmd:RS_Identifier/gmd:code/gco:CharacterString )" />',
        'codespace': '<xsl:value-of select="normalize-space(gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>

    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$refSystemModel}, {$refSystemTableModel}, '{$refSystemXmlSnippet}', {../../../gn:element/@ref}, '{local-name()}', '#refsystem-popup', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the ref. system -->
      <div data-gn-modal=""
           data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
           id="refsystem-popup" class="gn-modal-lg">

        <div data-swe-date-dialog="">
          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:code', $labels, name(gmd:RS_Identifier), '', $codexpath)/label" />
            </label>

            <xsl:variable name="helper"
                          select="gn-fn-metadata:getHelper($schema, 'gmd:code', '/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code', '')"/>

            <select class="" data-ng-model="editRow.code">
              <xsl:for-each select="$helper/option">
                <xsl:sort select="."/>
                <option value="{@value}" title="{normalize-space(.)}">
                  <xsl:value-of select="."/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:codeSpace', $labels, name(gmd:RS_Identifier), '', '')/label" />
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.codespace" />
          </div>

          <div class="">
            <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
              Save
            </button>&#160;
            <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
              Cancel
            </button>

          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:referenceSystemInfo[position() &gt; 1]/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier" priority="1000" />

  <!-- Metadata dates -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date[1]" priority="3000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>

    <xsl:variable name="dateXmlSnippet">
      <![CDATA[
      <gmd:date xmlns:gmd="http://www.isotc211.org/2005/gmd">
      <gmd:CI_Date>
      <gmd:date>
        <gco:Date xmlns:gco="http://www.isotc211.org/2005/gco">{{editRow.date}}</gco:Date>
      </gmd:date>
      <gmd:dateType>
      <gmd:CI_DateTypeCode codeListValue="{{editRow.datetype}}"
                            codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"/>
        </gmd:dateType>
      </gmd:CI_Date>
    </gmd:date>
    ]]>
    </xsl:variable>

    <xsl:variable name="dateTableModel">
      [
      {
      name: 'date',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:date', $labels, name(..), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'datetype',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:dateType', $labels, name(..), '', '')/label" />',
      codelist: true
      }
      ]
    </xsl:variable>

    <xsl:variable name="dateModel">
      [
      <xsl:for-each select="../gmd:date">
        {
        'ref': '<xsl:value-of select="gn:element/@ref" />',
        'refChildren': {
          'date': '<xsl:value-of select="gmd:CI_Date/gmd:date/*/gn:element/@ref" />',
          'datetype': '<xsl:value-of select="gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/gn:element/@ref" />',
        },
        'date': '<xsl:value-of select="normalize-space(gmd:CI_Date/gmd:date/gco:DateTime|gmd:CI_Date/gmd:date/gco:Date)" />',
        'datetype': '<xsl:value-of select="normalize-space(gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>


    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$dateModel},  {$dateTableModel}, '{$dateXmlSnippet}', {../gn:element/@ref}, '{local-name()}',  '#date-popup', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the dates -->
      <div data-gn-modal=""
         data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
         id="date-popup" class="gn-modal-lg">

      <div data-swe-date-dialog="">
        <div>
          <label class="col-sm-2 control-label">
            Date
          </label>
          <!--<input name="date" type="text" class="form-control" data-ng-model="selectedRow.date" />-->
          <div data-gn-date-picker="{{editRow.date}}"
               data-label=""
               data-tag-name=""
               data-element-ref="datevalue">>
          </div>
        </div>

        <div>
          <label class="col-sm-2 control-label">
            Date type
          </label>

          <xsl:variable name="codelist"
                        select="gn-fn-metadata:getCodeListValues($schema,
                                  'gmd:CI_DateTypeCode',
                                  $codelists,
                                  .)"/>

          <select class="" data-ng-model="editRow.datetype">
            <xsl:for-each select="$codelist/entry">
              <xsl:sort select="label"/>
              <option value="{code}" title="{normalize-space(description)}">
                <xsl:value-of select="label"/>
              </option>
            </xsl:for-each>
          </select>
          <!--<input name="datetype" type="text" class="form-control" data-ng-model="selectedRow.datetype" />-->
        </div>

        <div class="">
          <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
            Save
          </button>&#160;
          <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
            Cancel
          </button>

        </div>
      </div>

    </div>
    </div>

  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date[position() &gt; 1]" priority="3000" />

  <!-- Metadata contact,  Metadata point of contact, Distributor contact -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:contact[1]|
                                            gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[1]|
                                            gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact[1]" priority="3000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="elementName" select="name()"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>

    <xsl:variable name="contactXmlSnippet">
      <![CDATA[<]]><xsl:value-of select="$elementName" /><![CDATA[ xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco">
      <gmd:CI_ResponsibleParty>
         <gmd:individualName gco:nilReason="missing">
            <gco:CharacterString/>
         </gmd:individualName>
         <gmd:organisationName>
            <gco:CharacterString>{{editRow.organisation}}</gco:CharacterString>
         </gmd:organisationName>
         <gmd:positionName gco:nilReason="missing">
            <gco:CharacterString/>
         </gmd:positionName>
         <gmd:contactInfo>
            <gmd:CI_Contact>
               <gmd:phone>
                  <gmd:CI_Telephone>
                     <gmd:voice>
                        <gco:CharacterString>{{editRow.phone}}</gco:CharacterString>
                     </gmd:voice>
                     <gmd:facsimile gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:facsimile>
                  </gmd:CI_Telephone>
               </gmd:phone>
               <gmd:address>
                  <gmd:CI_Address>
                     <gmd:deliveryPoint gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:deliveryPoint>
                     <gmd:city gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:city>
                     <gmd:administrativeArea gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:administrativeArea>
                     <gmd:postalCode gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:postalCode>
                     <gmd:country gco:nilReason="missing">
                        <gco:CharacterString/>
                     </gmd:country>
                     <gmd:electronicMailAddress>
                        <gco:CharacterString>{{editRow.email}}</gco:CharacterString>
                     </gmd:electronicMailAddress>
                  </gmd:CI_Address>
               </gmd:address>
            </gmd:CI_Contact>
         </gmd:contactInfo>
         <gmd:role>
            <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                             codeListValue="{{editRow.role}}"/>
         </gmd:role>
      </gmd:CI_ResponsibleParty>
 </]]><xsl:value-of select="$elementName" /><![CDATA[>]]></xsl:variable>

    <xsl:variable name="contactTableModel">
      [
      {
        name: 'organisation',
        title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:organisationName', $labels, name(..), '', '')/label" />',
        codelist: false,
      },
      {
        name: 'role',
        title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:role', $labels, name(..), '', '')/label" />',
        codelist: true
      },
      {
        name: 'phone',
        title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:voice', $labels, name(..), '', '')/label" />',
        codelist: false
      },
      {
        name: 'email',
        title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:electronicMailAddress', $labels, name(..), '', '')/label" />',
        codelist: false
      }
      ]
    </xsl:variable>

    <xsl:variable name="contactModel">
      [
      <xsl:for-each select="../*[name() = $elementName]">
        {
        'ref': '<xsl:value-of select="gn:element/@ref" />',
        'refChildren': {
          'organisation': '<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/gn:element/@ref" />',
          'phone': '<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString/gn:element/@ref" />',
          'email': '<xsl:value-of     select="gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress /gco:CharacterString/gn:element/@ref" />',
          'role': '<xsl:value-of select="gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/gn:element/@ref" />'
        },
        'organisation': '<xsl:value-of select="normalize-space(gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString)" />',
        'phone': '<xsl:value-of select="normalize-space(gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString)" />',
        'email': '<xsl:value-of select="normalize-space(gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString)" />',
        'role': '<xsl:value-of select="normalize-space(gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>




    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$contactModel}, {$contactTableModel}, '{$contactXmlSnippet}', {../gn:element/@ref}, '{local-name()}', '#contact-popup-{local-name()}', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the dates -->
      <div data-gn-modal=""
           data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
           id="contact-popup-{local-name()}" class="gn-modal-lg">

        <div data-swe-date-dialog="">
          <div>
            <label class="col-sm-2 control-label">
              Organisation
            </label>
            <input type="text" class="form-control" data-ng-model="editRow.organisation" />
          </div>

          <div>
            <label class="col-sm-2 control-label">
              Phone
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.phone" />
          </div>


          <div>
            <label class="col-sm-2 control-label">
              E-mail
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.email" />
          </div>


          <div>
            <label class="col-sm-2 control-label">
              Role
            </label>

            <xsl:variable name="codelist"
                          select="gn-fn-metadata:getCodeListValues($schema,
                                  'gmd:CI_RoleCode',
                                  $codelists,
                                  .)"/>

            <select class="" data-ng-model="editRow.role">
              <xsl:for-each select="$codelist/entry">
                <xsl:sort select="label"/>
                <option value="{code}" title="{normalize-space(description)}">
                  <xsl:value-of select="label"/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div class="">
            <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
              Save
            </button>&#160;
            <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
              Cancel
            </button>

          </div>
        </div>

      </div>
    </div>

  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:contact[position() &gt; 1]|
                                            gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[position() &gt; 1]|
                                            gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact[position() &gt; 1]" priority="3000" />

  <!-- Distributor format -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat[1]" priority="1000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>


    <xsl:variable name="formatXmlSnippet">
      <![CDATA[
          <gmd:distributorFormat xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gco="http://www.isotc211.org/2005/gco">
             <gmd:MD_Format>
                <gmd:name>
                   <gco:CharacterString>{{editRow.fname}}</gco:CharacterString>
                </gmd:name>
                <gmd:version>
                   <gco:CharacterString>{{editRow.version}}</gco:CharacterString>
                </gmd:version>
             </gmd:MD_Format>
          </gmd:distributorFormat>
    ]]>
    </xsl:variable>

    <xsl:variable name="formatTableModel">
      [
      {
      name: 'fname',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:name', $labels, name(gmd:MD_Format), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'version',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:version', $labels, name(gmd:MD_Format), '', '')/label" />',
      codelist: false
      }
      ]
    </xsl:variable>


    <xsl:variable name="formatModel">
      [
      <xsl:for-each select="../gmd:distributorFormat">
        {
        'ref': '<xsl:value-of select="gn:element/@ref" />',
        'refChildren': {
        'fname': '<xsl:value-of select="gmd:MD_Format/gmd:name/gco:CharacterString/gn:element/@ref" />',
        'version': '<xsl:value-of select="gmd:MD_Format/gmd:version/gco:CharacterString/gn:element/@ref" />',
        },
        'fname': '<xsl:value-of select="normalize-space(gmd:MD_Format/gmd:name/gco:CharacterString )" />',
        'version': '<xsl:value-of select="normalize-space(gmd:MD_Format/gmd:version/gco:CharacterString)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>

    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$formatModel}, {$formatTableModel}, '{$formatXmlSnippet}', {../gn:element/@ref}, '{local-name()}', '#format-popup', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the ref. system -->
      <div data-gn-modal=""
           data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
           id="format-popup" class="gn-modal-lg">

        <div data-swe-date-dialog="">
          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:name', $labels, name(gmd:MD_Format), '', '')/label" />
            </label>

            <xsl:variable name="helper"
                          select="gn-fn-metadata:getHelper($schema, 'gmd:name', 'gmd:MD_Format', '')"/>

            <select class="" data-ng-model="editRow.fname">
              <xsl:for-each select="$helper/option">
                <xsl:sort select="."/>
                <option value="{@value}" title="{normalize-space(.)}">
                  <xsl:value-of select="."/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:version', $labels, name(gmd:MD_Format), '', '')/label" />
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.version" />
          </div>

          <div class="">
            <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
              Save
            </button>&#160;
            <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
              Cancel
            </button>

          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat[position() &gt; 1]" priority="1000" />

   <!-- Thumbnails -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:identificationInfo/*/gmd:graphicOverview[1]" priority="1000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>


    <xsl:variable name="thumbnailXmlSnippet">
      <![CDATA[
          <gmd:graphicOverview>
              <gmd:MD_BrowseGraphic>
                 <gmd:fileName>
                    <gco:CharacterString>{{editRow.fname}}</gco:CharacterString>
                 </gmd:fileName>
                 <gmd:fileDescription>
                    <gco:CharacterString>{{editRow.fdescription}}</gco:CharacterString>
                 </gmd:fileDescription>
              </gmd:MD_BrowseGraphic>
          </gmd:graphicOverview>
    ]]>
    </xsl:variable>

    <xsl:variable name="thumbnailTableModel">
      [
      {
      name: 'fname',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:fileName', $labels, name(gmd:MD_BrowseGraphic), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'fdescription',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:fileDescription', $labels, name(gmd:MD_BrowseGraphic), '', '')/label" />',
      codelist: false
      }
      ]
    </xsl:variable>


    <xsl:variable name="thumbnailModel">
      [
      <xsl:for-each select="../gmd:graphicOverview">
        {
        'ref': '<xsl:value-of select="gn:element/@ref" />',
        'refChildren': {
        'fname': '<xsl:value-of select="gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString/gn:element/@ref" />',
        'fdescription': '<xsl:value-of select="gmd:MD_BrowseGraphic/gmd:fileDescription/gco:CharacterString/gn:element/@ref" />',
        },
        'fname': '<xsl:value-of select="normalize-space(gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString )" />',
        'fdescription': '<xsl:value-of select="normalize-space(gmd:MD_BrowseGraphic/gmd:fileDescription/gco:CharacterString)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>

    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$thumbnailModel}, {$thumbnailTableModel}, '{$thumbnailXmlSnippet}', {../gn:element/@ref}, '{local-name()}', '#thumbnail-popup', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the ref. system -->
      <div data-gn-modal=""
           data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
           id="thumbnail-popup" class="gn-modal-lg">

        <div data-swe-date-dialog="">
          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:fileName', $labels, name(gmd:MD_BrowseGraphic), '', '')/label" />
            </label>
            <input type="text" class="form-control" data-ng-model="editRow.fname" />
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:fileDescription', $labels, name(gmd:MD_BrowseGraphic), '', '')/label" />
            </label>

            <textarea class="form-control" data-ng-model="editRow.fdescription"></textarea>
          </div>

          <div class="">
            <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
              Save
            </button>&#160;
            <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
              Cancel
            </button>

          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:identificationInfo/*/gmd:graphicOverview[position() &gt; 1]" priority="1000" />

  <!-- Distributor transfer options -->
  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]" priority="1000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', '')"/>


    <xsl:variable name="onlineResXmlSnippet">
      <![CDATA[
          <gmd:onLine xmlns:gmd="http://www.isotc211.org/2005/gmd"
                      xmlns:gco="http://www.isotc211.org/2005/gco">
            <gmd:CI_OnlineResource>
              <gmd:linkage>
                <gmd:URL>{{editRow.url}}</gmd:URL>
              </gmd:linkage>
              <gmd:protocol>
                <gco:CharacterString>{{editRow.protocol}}</gco:CharacterString>
              </gmd:protocol>
              <gmd:name>
                <gco:CharacterString>{{editRow.name}}</gco:CharacterString>
              </gmd:name>
              <gmd:description>
                <gco:CharacterString>{{editRow.description}}</gco:CharacterString>
              </gmd:description>
            </gmd:CI_OnlineResource>
          </gmd:onLine>
    ]]>
    </xsl:variable>

    <xsl:variable name="onlineResTableModel">
      [
      {
      name: 'url',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:linkage', $labels, name(gmd:CI_OnlineResource), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'protocol',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:protocol', $labels, name(gmd:CI_OnlineResource), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'fname',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:name', $labels, name(gmd:CI_OnlineResource), '', '')/label" />',
      codelist: false,
      },
      {
      name: 'description',
      title: '<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:description', $labels, name(gmd:CI_OnlineResource), '', '')/label" />',
      codelist: false
      }
      ]
    </xsl:variable>


    <xsl:variable name="onlineResModel">
      [
      <xsl:for-each select="../gmd:onLine">
        {
        'ref': '<xsl:value-of select="gn:element/@ref" />',
        'refChildren': {
        'url': '<xsl:value-of select="gmd:CI_OnlineResource/gmd:linkage/gmd:URL/gn:element/@ref" />',
        'protocol': '<xsl:value-of select="gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString/gn:element/@ref" />',
        'fname': '<xsl:value-of select="gmd:CI_OnlineResource/gmd:name/gco:CharacterString/gn:element/@ref" />',
        'description': '<xsl:value-of select="gmd:CI_OnlineResource/gmd:description/gco:CharacterString/gn:element/@ref" />',
        },
        'url': '<xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:linkage/gmd:URL)" />',
        'protocol': '<xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString)" />',
        'fname': '<xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:name/gco:CharacterString)" />',
        'description': '<xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:description/gco:CharacterString)" />'
        }
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
      ]
    </xsl:variable>

    <div class="form-group gn-field" data-ng-controller="SweEditorTableController"
         data-ng-init="init({$onlineResModel}, {$onlineResTableModel}, '{$onlineResXmlSnippet}', {../gn:element/@ref}, '{local-name()}', '#onlineres-popup', '{$labelConfig/label}')" >

      <div data-swe-editor-table-directive="" />

      <!-- Dialog to edit the ref. system -->
      <div data-gn-modal=""
           data-gn-popup-options="{{title:'{$labelConfig/label}'}}"
           id="onlineres-popup" class="gn-modal-lg">

        <div data-swe-date-dialog="">


          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:linkage', $labels, name(gmd:CI_OnlineResource), '', '')/label" />
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.url" />
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:protocol', $labels, name(gmd:CI_OnlineResource), '', '')/label" />
            </label>

            <xsl:variable name="helper"
                          select="gn-fn-metadata:getHelper($schema, 'gmd:protocol', '', '')"/>

            <select class="" data-ng-model="editRow.protocol">
              <xsl:for-each select="$helper/option">
                <xsl:sort select="."/>
                <option value="{@value}" title="{normalize-space(.)}">
                  <xsl:value-of select="."/>
                </option>
              </xsl:for-each>
            </select>
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:name', $labels, name(gmd:CI_OnlineResource), '', '')/label" />
            </label>
            <input type="text" class="form-control" data-ng-model="editRow.fname" />
          </div>

          <div>
            <label class="col-sm-2 control-label">
              <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'gmd:description', $labels, name(gmd:CI_OnlineResource), '', '')/label" />
            </label>

            <input type="text" class="form-control" data-ng-model="editRow.description" />
          </div>

          <div class="">
            <button type="button" class="btn navbar-btn btn-success" data-ng-click="saveRow()">
              Save
            </button>&#160;
            <button type="button" class="btn navbar-btn btn-default" data-ng-click="cancel()">
              Cancel
            </button>

          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[position() &gt; 1]" priority="1000" />


</xsl:stylesheet>
