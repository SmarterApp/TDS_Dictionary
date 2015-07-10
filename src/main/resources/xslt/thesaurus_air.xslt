<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 				
				xmlns:scr="AIR.Dictionary.Xslt2Functions"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
               >
  <xsl:output method="html" version="1.0" encoding="utf-8" indent="no" omit-xml-declaration="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

   <xsl:template match="it">
    <em>
      <xsl:value-of select="."/>
    </em>
  </xsl:template>
  
  <xsl:template match="sens">
    <li class="ssens">
      <div class="thesaurus-definition">
        <xsl:value-of select="mc"/>
      
        <span class="vi">
          <xsl:apply-templates select="vi"/>
        </span>
      </div>

      <xsl:apply-templates select="syn"/>
      <xsl:apply-templates select="rel"/>
      <xsl:apply-templates select="near"/>
      <xsl:apply-templates select="ant"/>
    </li>
  </xsl:template>

  <xsl:template match="syn">
    <div class = "thesaurus-synonyms">
      <strong>Synonyms </strong>
      
      <span class="synos-raw">
        <xsl:value-of select="."/>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="rel">
  <div class = "thesaurus-related-words">
    <strong>Related Words </strong>

    <span class="synos-raw">
      <xsl:value-of select="."/>
    </span>
  </div>
  </xsl:template>
  
  <xsl:template match="near">
    <div class = "thesaurus-near-antoynms">
      <strong>Near Antonyms </strong>

      <span class="synos-raw">
        <xsl:value-of select="."/>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="ant">
    <div class = "thesaurus-antonyms">
      <strong>Antonyms </strong>

      <span class="synos-raw">
        <xsl:value-of select="."/>
      </span>
    </div>
  </xsl:template>

  <xsl:template name="fl">
    <span class="main-fl">
      <em>
        <xsl:value-of select="fl"/>
      </em>
    </span>
  </xsl:template>

  <xsl:template match="vi">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template name="term">
      <strong>
        <xsl:value-of select="term/hw"/>
      </strong>
  </xsl:template>

  <xsl:template match="entry">
    <div class="mwEntryData">
      <span class="entry_label" style="display: none">
        <xsl:value-of select="./term/hw"/> (<xsl:value-of select="./fl"/>)
      </span>
      
      <div class="headword first">
        <xsl:call-template name="term"/>
        <xsl:call-template name="fl"/>
      </div>
      
      <div class="definitions thesaurus">
        <ol>
          <li class="definitions-block">
            <ol class="scnt">
              <xsl:apply-templates select="sens" />
            </ol>
          </li>
        </ol>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="/entry_list">
    <div id="result_entry_list_div">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="suggestion"></xsl:template>
</xsl:stylesheet>