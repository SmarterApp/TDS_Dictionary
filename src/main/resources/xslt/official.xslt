<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:scr="AIR.Dictionary.Xslt2Functions"
                >
  <xsl:output method="html" version="1.0" encoding="utf-8" indent="no" omit-xml-declaration="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  <xsl:param name="meta-file" />
  <xsl:strip-space elements="entry def aq" />

  <!-- *** Any meta data for this reference. *** -->
  <xsl:variable name="meta-data" select="document($meta-file)/data" />

  <!-- *** The meta data key. *** -->
  <xsl:key name="meta-data-keys" match="entry" use="./hw" />

  <xsl:template match="/entry_list">
    <div id="result_entry_list_div">
      <xsl:apply-templates />
    </div>
  
    <xsl:if test="suggestion">
      <div class="suggestions">
        <p>The word you've entered isn't in the dictionary. Click on a spelling suggestion below or try again using the search bar above.</p>

        <ul>
          <xsl:call-template name="suggestion_template"/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="suggestion_template">
    <xsl:for-each select="suggestion">
      <li>
        <a href="#" class="dict_link">
          <xsl:value-of select="."/>
        </a>
      </li>
    </xsl:for-each>
  </xsl:template>

  
  <!-- Match alpha tags. -->
  <!-- unused
  <xsl:template match="/alpha">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="styles/reference.css" />
        <script type="text/javascript" src="scripts/reference.js">
          <xsl:text> </xsl:text>
        </script>
      </head>
      <body onload="initApp()">
        <div id="app">
          <xsl:apply-templates select="entry" />
        </div>
      </body>
    </html>
  </xsl:template>
  -->

  <!-- Match all other entries. -->
  <xsl:template match="entry">
    <div class="mwEntryData">
      <span class="entry_label" style="display:none;">
        <xsl:value-of select="./@id" />
      </span>

      <div class="headword first">
        <xsl:apply-templates select="hw | ahw" />
        
          <xsl:if test="pr">
          <xsl:apply-templates select="pr" />
        </xsl:if>
        
          <xsl:if test="fl">
          <span class="main-fl">
            <xsl:apply-templates select="fl" />
          </span>
        </xsl:if>
        
          <xsl:if test="lb">
          <span class="lb usage">
            <xsl:apply-templates select="lb" />
          </span>
        </xsl:if>
      </div>

      <xsl:if test="vr">
        <div class="vr">
          Variant(s): <xsl:apply-templates select="vr" />
        </div>
      </xsl:if>
      
      <xsl:if test="date">
        <div>
          Date: <xsl:apply-templates select="date" />
        </div>
      </xsl:if>

      <xsl:if test="in">
        <div class="inf-forms">
          <span class="secret-label">INF Forms</span>
          <xsl:apply-templates select="in" />
        </div>
      </xsl:if>

      <div class="definitions">
        <h2 class="def-header" aria-label="Full Definition">
          <span>
            Full Definition of
            <em>
              <xsl:value-of select="./@id" />
            </em>
          </span>
        </h2>
        <ol>
          <li class="definition-block" role="definition">
            <ol class="scnt">
              <xsl:apply-templates select="cx | def | art | table | vt | cap | list" />

              <xsl:if test="dro">
                <li class="li_for_dr">
                  <div>
                    <ol class="dr">
                      <xsl:apply-templates select="dro" />
                    </ol>
                  </div>
                </li>
              </xsl:if>
            </ol>
          </li>
        </ol>

        <xsl:apply-templates select="sent" />
        <xsl:apply-templates select="et" />
        <xsl:apply-templates select="synon" />
      </div>

    </div>
  </xsl:template>

  <xsl:template match="comment() | ew | formula | hed | note | subj | table" />

  <xsl:template match="abbreviation | bible-book | entity | language | month | name | region">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="cat | cx | vr | ri">
    <xsl:apply-templates />
    <xsl:if test="name(.) = 'cat'">
      <xsl:call-template name="output_list_separator" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="et">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="set">
    <xsl:text> </xsl:text>
    <span class="set">
      [<xsl:apply-templates />]
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="svr">
    <xsl:apply-templates />
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Match sense-specific inflected forms. -->
  <xsl:template match="sin">
    <xsl:apply-templates />
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Match inflected forms. -->
  <xsl:template match="in">
    <xsl:choose>
      <xsl:when test="name(following-sibling::node()) = 'in'">
        <span class="in-more">
          <strong>
            <xsl:apply-templates />
          </strong>
        </span>
      </xsl:when>

      <xsl:otherwise>
        <span class="in">
          <strong>
            <xsl:apply-templates />
          </strong>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="in/text()[position() = last() and normalize-space() = '']"></xsl:template>

  <!-- <xsl:template match="cl | fl | il | lb | sl | slb | spl | ssl | vpl"> these are moved to preceding matches of dt-->
  <xsl:template match="fl">
    <xsl:text> </xsl:text>
    <em>
      <xsl:apply-templates />
      <xsl:if test="name(.) = 'fl' and name(following-sibling::*[1]) = 'sl'">,</xsl:if>
    </em>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="aq | dx">
    &#x2014; <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="un">
    <xsl:variable name="curr_pos" select="position()" />
    <xsl:choose>
      <xsl:when test="../node()[name() = 'un' and position() = $curr_pos - 1]">
        <xsl:text>; </xsl:text>
      </xsl:when>
      <xsl:when test="normalize-space(preceding-sibling::text()) = ''">
        <xsl:choose>
          <xsl:when test="../node()[name() = 'un' and position() = $curr_pos - 2]">
            <xsl:text>; </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&#x2014;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#x2014;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
  </xsl:template>

  <!-- Match called also's. -->
  <xsl:template match="ca">
    <xsl:text disable-output-escaping="yes">&#8212;called also </xsl:text>
    <em>
      <xsl:apply-templates select="node()[position() &gt; 1]" />
    </em>
  </xsl:template>

  <!-- Match more at's. -->
  <xsl:template match="ma">
    &#x2014; more at <xsl:call-template name="cross-reference" />
  </xsl:template>

  <!-- Match prons and sense prons. -->
  <xsl:template match="pr | sp">
    <span class="pr">
      \<xsl:apply-templates />\
    </span>
  </xsl:template>

  <xsl:template match="sd">
    <xsl:text>; </xsl:text>
    <em>
      <xsl:apply-templates />
    </em>
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="ss">
    <div>
      <strong>synonyms</strong> see <xsl:call-template name="cross-reference" />
    </div>
  </xsl:template>

  <!-- Match see in addition. -->
  <xsl:template match="sa">
    <xsl:if test="not(name(preceding-sibling::*[1]) = 'sa')">
      <strong>synonyms</strong> see in addition<xsl:text> </xsl:text>
    </xsl:if>
    <xsl:call-template name="cross-reference" />
    <xsl:if test="name(following-sibling::node()[1]) = 'sa'">
      ,<xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Match defined and undefined run-ons. -->
  <xsl:template match="dro | uro">
    <li class="dr">
      &#x2014;
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <!-- Match variant labels. -->
  <xsl:template match="vl">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Match dates. -->
  <xsl:template match="entry/date">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Match usage sections. -->
  <xsl:template match="us">
    <div>
      <strong>usage</strong> see <xsl:call-template name="cross-reference" />
    </div>
  </xsl:template>

  <!-- Match verb. -->
  <xsl:template match="vt">
    <div class="vt">
      <xsl:value-of select="." />
    </div>
  </xsl:template>

  <xsl:template match="pt">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Match dates. -->
  <xsl:template match="def/date"></xsl:template>

  <!-- Match definitions. -->
  <xsl:template match="entry/def">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="dro/def">
    <xsl:for-each select="dt">
      <div class="definitions">
        <div class="sense-block-one">
          <div class="scnt">
            <span class="ssens">
              <xsl:apply-templates />
            </span>
          </div>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- Match defining text. -->
  <xsl:template match="dt">
    <li class="ssens">
      <span class="sn">
        <xsl:value-of select="preceding-sibling::sn[1]" />
      </span>
      
      <xsl:if test="preceding-sibling::*[1][name() = 'sl' or name() = 'slb' or name() = 'spl' or name() = 'vpl' or name() = 'ssl' ]">
        <xsl:text> </xsl:text>
        <em>
          <xsl:value-of select="preceding-sibling::*[1]" />
          <xsl:if test="name(.) = 'fl' and name(following-sibling::*[1]) = 'sl'">,</xsl:if>
        </em>
        <xsl:text> </xsl:text>
      </xsl:if>

      <span class="sense-content">
        <xsl:apply-templates />
      </span>
    </li>
  </xsl:template>

  <!-- Match g tags. -->
  <xsl:template match="g">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="sensb">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="sens[sn]">
    <xsl:apply-templates select="sn[scr:Matches(., '^\s*[0-9]+')][1]" mode="sense-number" />
    <div class="sens">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  <xsl:template match="sens[not(sn)]">
    <div class="sens-one">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="sn" mode="sense-number">
    <div class="sensb">
      <xsl:value-of select="scr:Replace(., '^\s*([0-9]+).*$', '$1')" />
    </div>
  </xsl:template>

  <!-- Match sense numbers. accessed explicitly inside dt-->
  <xsl:template match="sn">

  </xsl:template>

  <!-- Match bold tags. -->
  <xsl:template match="bold">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- Match bold italic tags. -->
  <xsl:template match="bit">
    <em class="b">
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- Match italic small-cap tags. -->
  <xsl:template match="isc">
    <em class="sc">
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- Match italic tags. -->
  <xsl:template match="it">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- Match list items. -->
  <xsl:template match="item">
    <li>
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <!-- Match roman tags. -->
  <xsl:template match="rom">
    <em class="rom">
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- Match subscript tags. -->
  <xsl:template match="inf">
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>

  <!-- Match superscript tags. -->
  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates />
    </sup>
  </xsl:template>

  <!-- Match word lists. -->
  <xsl:template match="list">
    <ol>
      <xsl:apply-templates select="item" />
    </ol>
  </xsl:template>

  <!-- Match various bold items. They may contain syllabication dots and sound file link icons. -->
  <xsl:template match="va | drp | rie | bold">
    <strong>
      <xsl:call-template name="syllables">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </strong>
  </xsl:template>

  <!-- Match headwords and alternate headwords. -->
  <xsl:template match="hw | ahw">
    <xsl:if test="not(position() = 1)">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <strong>
      <xsl:call-template name="syllables">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </strong>
    <xsl:variable name="curr_pos" select="position()" />
    <xsl:apply-templates select="../node()[position() &gt; $curr_pos and name() = 'sound']/wav">
      <xsl:with-param name="word" select="." />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="hw | ahw" mode="attribute">
    <xsl:variable name="hw0">
      <xsl:call-template name="escape_apos">
        <xsl:with-param name="text">
          <xsl:apply-templates select="./text()" mode="ascii" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="hw1" select="translate($hw0, '*', '')" />
    <xsl:variable name="hw2" select="normalize-space($hw1)" />
    <xsl:variable name="hw">
      <xsl:value-of select="$hw2" />
      <xsl:if test="starts-with(., '{h,')">
        [<xsl:value-of select="substring-after(substring-before(., '}'), '{h,')" />]
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$hw" />
  </xsl:template>

  <!-- Match function labels. -->
  <xsl:template match="fl" mode="attribute">
    <xsl:call-template name="escape_apos">
      <xsl:with-param name="text">
        <xsl:apply-templates select="." mode="ascii" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Match inflected forms and ure's. -->
  <xsl:template match="if | ure">
    <strong>
      <xsl:call-template name="syllables">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </strong>
  </xsl:template>

  <!-- Match sound tags. -->
  <xsl:template match="sound">
    <xsl:variable name="word">
      <xsl:choose>
        <xsl:when
          test="preceding-sibling::node()[name() = 'if' or name() = 'ure' or name() = 'va' or name() = 'rie' or name() = 'it'][1]/text()">
          <xsl:value-of
            select="preceding-sibling::node()[name() = 'if' or name() = 'ure' or name() = 'va' or name() = 'rie' or name() = 'it'][1]/text()" />
        </xsl:when>
        <xsl:when test="preceding-sibling::node()[position() = 1 and name() = '']">
          <xsl:call-template name="getLastWord">
            <xsl:with-param name="text">
              <xsl:value-of select="preceding-sibling::node()[position() = 1 and name() = '']" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="wav">
      <xsl:with-param name="word" select="translate($word, '*', '')" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- *** The template gets the last word in a block of plaintext. *** -->
  <xsl:template name="getLastWord">
    <xsl:param name="text" />
    <xsl:variable name="ntext" select="normalize-space($text)" />
    <xsl:choose>
      <xsl:when test="$ntext = ''"></xsl:when>
      <xsl:when test="contains($ntext, ' ')">
        <xsl:call-template name="getLastWord">
          <xsl:with-param name="text" select="substring-after($ntext, ' ')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ntext" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template creates the syllabication of a word. -->
  <xsl:template name="syllables">
    <xsl:param name="text" />
    <xsl:value-of select="." />
    <!-- fixes a bug which was cuasing syllables template to ouptut the word multiple times
  BC
	<xsl:choose>
		<xsl:when test="contains($text, '*')">
      T1
      <xsl:call-template name="substitute-html">
        <xsl:with-param name="text" select="substring-before($text, '*')"/>
      </xsl:call-template>
      <xsl:text disable-output-escaping = "yes">&amp;#183;</xsl:text>
      <xsl:call-template name="syllables">
        <xsl:with-param name="text" select="substring-after($text, '*')"/>
      </xsl:call-template></xsl:when>
		<xsl:otherwise>
      T2
      <xsl:call-template name="substitute-html">
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:otherwise>
	</xsl:choose>-->
  </xsl:template>

  <!-- Match wav tags. -->
  <xsl:template match="wav">
    <xsl:param name="word" />
    <xsl:text> </xsl:text>
    <xsl:element name="a">   
      <xsl:attribute name="class">au</xsl:attribute>
      
      <xsl:attribute name="href">
        <xsl:value-of select="scr:Replace(., '\.wav$', '')" />
      </xsl:attribute>
      <xsl:attribute name="data-language">en/us/</xsl:attribute>
      Listen to the pronunciation of
      <xsl:call-template name="substitute-html">
        <xsl:with-param name="text" select="translate($word, '*', '')" />
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- Match art tags. -->
  <xsl:template match="art">
    <!-- not yet supported 
    <xsl:if test="bmp">
      <div>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('/art/dict/', substring-before(bmp, '.'), '.htm')" />
          </xsl:attribute>
          <xsl:attribute name="class">dict_link_art</xsl:attribute>
          <xsl:text>[</xsl:text>
          <xsl:value-of select="concat(../ew, ' illustration')" />
          <xsl:text>]</xsl:text>
        </xsl:element>
      </div>
    </xsl:if>
    -->
  </xsl:template>

  <!-- Match table tags. -->
  <xsl:template match="cap">
    <div>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="concat('/table/dict/', substring-after(substring-before(., ';'), 'table/'), '.htm')" />
        </xsl:attribute>
        <xsl:attribute name="class">dict_link_table</xsl:attribute>
        <xsl:text>[</xsl:text>
        <xsl:choose>
          <xsl:when test="../ew">
            <xsl:value-of select="concat(../ew, ' table')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(../../ew, ' table')" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]</xsl:text>
      </xsl:element>
    </div>
  </xsl:template>

  <!-- Match math formulas. -->
  <xsl:template match="math">
    <xsl:element name="img">
      <xsl:attribute name="class">math formula</xsl:attribute>
      <xsl:attribute name="src">
        /math/<xsl:value-of select="text()" />
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Match pl tags. -->
  <xsl:template match="pl">
    <xsl:choose>
      <xsl:when test="text() = 'syn'">
        <div>
          <strong>synonyms</strong>
          <xsl:text> </xsl:text>
          <xsl:variable name="pl_pos">
            <xsl:value-of select="position()" />
          </xsl:variable>
          <xsl:apply-templates select="(following::node()[name() = 'pt'])[position() = 1]" />
        </div>
      </xsl:when>
      <xsl:when test="text() = 'usage'">
        <div>
          <strong>usage</strong>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="(following::node()[name() = 'pt'])[position() = 1]" />
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Match dxt tags. -->
  <xsl:template match="dxt">
    <xsl:call-template name="cross-reference">
      <xsl:with-param name="qualifier" select="dxn" />
    </xsl:call-template>
    <xsl:call-template name="output_list_separator" />
  </xsl:template>

  <!-- Match ct tags. -->
  <xsl:template match="ct">
    <xsl:call-template name="cross-reference">
      <xsl:with-param name="qualifier" select="ctn" />
    </xsl:call-template>
    <xsl:call-template name="output_list_separator" />
  </xsl:template>

  <!-- Match sx tags. -->
  <xsl:template match="sx">
    <xsl:call-template name="cross-reference">
      <xsl:with-param name="qualifier">
        <xsl:for-each select="sxn">
          <xsl:value-of select="." />
          <xsl:if test="position() != last()">,</xsl:if>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="list_separator" />
  </xsl:template>

  <!-- Turn (possibly) qualified cross-references into hypertext links. A qualifier is either a sense number or 'table' or 'illustration'. -->
  <xsl:template name="cross-reference" match="pt/sc | fw">
    <xsl:param name="qualifier" />
    <xsl:variable name="word">
      <xsl:for-each select=".//text()[name(..) != 'ctn' and name(..) != 'dxn' and name(..) != 'sxn']">
        <xsl:value-of select="." />
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$qualifier">
        <xsl:choose>
          <xsl:when test="normalize-space($qualifier) = 'illustration' or normalize-space($qualifier) = 'table'">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="normalize-space($qualifier) = 'table'">
                    <xsl:text>/table/dict</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>/art/dict</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>/</xsl:text>
                <!-- NB. Table and art files are assumed to have underscores in place of spaces. -->
                <xsl:value-of select="translate(normalize-space($word), ' ', '_')" />
                <xsl:text>.htm</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="class">dict_link dcit_linkB</xsl:attribute>
              <!-- NB. Must convert to lower case otherwise font-variant: small-caps will not work -->
              <xsl:value-of
                select="translate(normalize-space(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="xref">
              <xsl:with-param name="word" select="normalize-space($word)" />
              <xsl:with-param name="qualifier" select="normalize-space($qualifier)" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xrefs">
          <xsl:with-param name="list" select="normalize-space($word)" />
        </xsl:call-template>
        <xsl:if test="name() = 'sc'">
          <xsl:call-template name="output_list_separator" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Turn a list of unqualified cross-references into a comma-separated list of hypertext links. -->
  <xsl:template name="xrefs">
    <xsl:param name="list" />
    <xsl:choose>
      <xsl:when test="contains($list, ', ')">
        <xsl:call-template name="xref">
          <xsl:with-param name="word" select="normalize-space(substring-before($list, ', '))" />
        </xsl:call-template>
        <xsl:text>, </xsl:text>
        <xsl:call-template name="xrefs">
          <xsl:with-param name="list" select="normalize-space(substring-after($list, ', '))" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="xref">
          <xsl:with-param name="word" select="normalize-space($list)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Turn a (possibly) qualified cross-references into a hypertext link. -->
  <xsl:template name="xref">
    <xsl:param name="word" />
    <xsl:param name="qualifier" />
    <xsl:element name="a">
      <xsl:attribute name="href">
        <!-- Strip homograph index, normalize space. -->
        <xsl:variable name="headword">
          <xsl:choose>
            <xsl:when test="starts-with($word, '{h,')">
              <xsl:value-of select="normalize-space(substring-after($word, '}'))" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($word)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Convert to lower case, convert spaces to pluses, substitute entities with ASCII equivalents.-->
        <xsl:call-template name="substitute_for_link">
          <xsl:with-param name="esc_apos">false</xsl:with-param>
          <xsl:with-param name="text" select="scr:Replace(scr:LowerCase(normalize-space($headword)), '[ \t]', '+')" />
        </xsl:call-template>
        <!-- Append homograph label, if any.-->
        <xsl:if test="starts-with($word, '{h,')">
          <xsl:value-of
            select="concat('[', normalize-space(substring-after(substring-before($word, '}'), '{h,')), ']')" />
        </xsl:if>
      </xsl:attribute>
      <xsl:attribute name="class">dict_link dict_linkC</xsl:attribute>
      <xsl:if test="name(.) = 'fw'">
        <xsl:attribute name="class">formulaic dict_link</xsl:attribute>
      </xsl:if>
      <!-- Substitute entities with HTML equivalents.-->
      <xsl:call-template name="substitute-html">
        <xsl:with-param name="text" select="normalize-space($word)" />
      </xsl:call-template>
    </xsl:element>
    <xsl:if test="$qualifier">
      <!-- Append roman qualifier.-->
      <xsl:text> </xsl:text>
      <xsl:value-of select="$qualifier" />
    </xsl:if>
  </xsl:template>

  <!-- Match small-caps tags. -->
  <xsl:template match="sc">
    <em class="sc">
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- Match verbal illustrations. Verbal illustrations are displayed between '&lt;' and '&gt;' and have {sdash} replaced by headword without homograph label. -->
  <xsl:template match="vi">
    <span class="vi">
      <xsl:text>&lt;</xsl:text>
      <xsl:for-each select="node()">
        <xsl:choose>
          <xsl:when test="name(.) != ''">
            <xsl:apply-templates select="." />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="substitute-html">
              <xsl:with-param name="text">
                <xsl:call-template name="replace_sdash">
                  <xsl:with-param name="value" select="." />
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <!-- This template replaces sdash characters. -->
  <xsl:template name="replace_sdash">
    <xsl:param name="value" />
    <xsl:choose>
      <xsl:when test="contains($value, '{sdash}')">
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="substring-before($value, '{sdash}')" />
        </xsl:call-template>
        <em>
          <xsl:choose>
            <xsl:when
              test="name(..) = 'vi' and name(../../preceding-sibling::*[name(.) = 'dt' or name(.) = 'slb'][1]) = 'slb' and ../../preceding-sibling::slb[1][. = 'not capitalized']">
              <xsl:variable name="word">
                <xsl:call-template name="stripped-headword" />
              </xsl:variable>
              <xsl:value-of
                select="translate(substring($word, 1, 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
              <xsl:value-of select="substring($word, 2)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="stripped-headword" />
            </xsl:otherwise>
          </xsl:choose>
        </em>
        <xsl:call-template name="replace_sdash">
          <xsl:with-param name="value" select="substring-after($value, '{sdash}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="$value" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template returns a stripped headword. -->
  <xsl:template name="stripped-headword">
    <xsl:variable name="raw-headword" select="ancestor::node()/hw" />
    <xsl:choose>
      <xsl:when test="starts-with($raw-headword, '{h,')">
        <xsl:call-template name="strip-syllabication">
          <xsl:with-param name="text" select="substring-after($raw-headword, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="strip-syllabication">
          <xsl:with-param name="text" select="$raw-headword" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template strips syllabication from a word. -->
  <xsl:template name="strip-syllabication">
    <xsl:param name="text" />
    <xsl:value-of select="translate($text, '*', '')" />
  </xsl:template>

  <!-- This template deletes headings and comments. -->
  <xsl:template match="head | comment()"></xsl:template>

  <!-- This method outputs a separator between one or more items when needed. -->
  <xsl:template name="output_list_separator">
    <xsl:variable name="curr_name" select="name()" />
    <xsl:variable name="curr_pos" select="position()" />
    <xsl:choose>
      <xsl:when test="../node()[name() = $curr_name and position() = $curr_pos + 1 and following-sibling::node()]">
        ,<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="normalize-space(following-sibling::text()) = ''">
        <xsl:if test="../node()[name() = $curr_name and position() = $curr_pos + 2]">
          ,<xsl:text> </xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This method outputs a separator between one or more items when needed. -->
  <xsl:template name="list_separator">
    <xsl:variable name="curr_name" select="name()" />
    <xsl:choose>
      <xsl:when test="name(./following-sibling::node()[1]) = $curr_name">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:when test="name(./following-sibling::node()[2]) = $curr_name">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
    <xsl:if
      test="name(./following-sibling::node()[1]) = $curr_name or (./following-sibling::node()[1]/self::text() and not(starts-with(./following-sibling::node()[1], ' ')))">
    </xsl:if>
  </xsl:template>

  <!-- This method template all text nodes. -->
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = ''">
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template handles all unmatched tags. -->
  <xsl:template match="node()" priority="-1">
    <xsl:message>
      Unhandled node <xsl:value-of select="name(.)" />
    </xsl:message>
  </xsl:template>

  <!-- This template escapes apostrophe's. -->
  <xsl:template name="escape_apos">
    <xsl:param name="text" />
    <xsl:variable name="text2" select="translate($text, '&#xA;&#x9;', '  ')" />
    <xsl:choose>
      <xsl:when test="contains($text, &quot;'&quot;)">
        <xsl:value-of select="substring-before($text, &quot;'&quot;)" />\'
        <xsl:call-template name="escape_apos">
          <xsl:with-param name="text">
            <xsl:value-of select="substring-after($text, &quot;'&quot;)" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sensb" mode="csv-xml-data">
    <xsl:apply-templates mode="csv-xml-data" />
  </xsl:template>
  <xsl:template match="sens" mode="csv-xml-data">
    <xsl:apply-templates mode="csv-xml-data" />
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Etymology -->
  <xsl:template match="entry/et">
    <div class="etymology">

      <h2>Origin</h2>
      <div class="content">
        <xsl:apply-templates />
      </div>

    </div>
  </xsl:template>

  <!-- Synonyms -->
  <xsl:template match="entry/synon">
    <div class="synonyms-reference">
      <h2>RELATED</h2>
        <xsl:apply-templates select="ant|near|rel|syn" />
        <xsl:if test="@see-more = 'yes'">
          <div class="see-more">
            <xsl:element name="a">
              <xsl:attribute name="href">
                /thesaurus/
                <xsl:call-template name="substitute_for_link">
                  <xsl:with-param name="esc_apos">true</xsl:with-param>
                  <xsl:with-param name="text" select="translate(term, '*', '')" />
                </xsl:call-template>
              </xsl:attribute>
              <xsl:attribute name="class">dict_link dict_linkD</xsl:attribute>
              See more synonyms and antonyms
            </xsl:element>
          </div>
        </xsl:if>
      </div>
  </xsl:template>

  <xsl:template match="entry/synon//*[scr:Matches(name(.), '^(ant|near|rel|syn)$')]">
    <xsl:param name="id" />
    <div class="{name(.)}-para">
      <strong>
        <xsl:choose>
          <xsl:when test="name(.) = 'ant'">Antonyms</xsl:when>
          <xsl:when test="name(.) = 'near'">Near Antonyms</xsl:when>
          <xsl:when test="name(.) = 'rel'">Related Words</xsl:when>
          <xsl:otherwise>Synonyms</xsl:otherwise>
        </xsl:choose>
      </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates>
        <xsl:with-param name="id" select="$id" />
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="entry/synon//lex">
    <a class="dict_link dict_linkA" href="/dictionary/{normalize-space(scr:Replace(., '\(.*$', ''))}">
      <xsl:call-template name="synonym-syllables">
        <xsl:with-param name="text" select="scr:Replace(., '\s*\(\s*$', '')" />
      </xsl:call-template>
    </a>
    <xsl:if test="scr:Matches(., '\s*\(\s*$')">
      <xsl:text> (</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="entry/synon//it">
    <em class="it">
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="entry/synon//text()">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="synonym-syllables">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '*')">
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="substring-before($text, '*')" />
        </xsl:call-template>
        <xsl:text disable-output-escaping="yes">&amp;#183;</xsl:text>
        <xsl:call-template name="synonym-syllables">
          <xsl:with-param name="text" select="substring-after($text, '*')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="$text" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Verbal Illustrations -->
  <xsl:template match="entry/sent">
    <div class="example-sentences">
      <h2>EXAMPLES</h2>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="entry/sent//content/i">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <xsl:template match="entry/sent//content/phrase">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="entry/sent//content">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="entry/sent//it">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="entry/sent//vi">
    <li class="vi-{@src}">
      <xsl:apply-templates select="content" />
      <xsl:if test="source | author">
        <xsl:text> </xsl:text>[<xsl:apply-templates select="author" />,<xsl:text> </xsl:text>
        <xsl:apply-templates select="source" />
        <xsl:if test="source">
          ,<xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="pub-date" />]
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="entry/sent//*[scr:Matches(name(.), '^(author|pub-date|source)$')]">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="entry/sent//text()" priority="-1">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text" select="scr:Replace(., '\n', '')" />
    </xsl:call-template>
  </xsl:template>

  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->
  <!-- Include the substitution file. -->

  <!-->
  Entity definitions (delimited by braces '{}') are extracted from the file entities.xml.
  <-->
  <xsl:key name="entity" match="table/td" use="@id" />
  <xsl:variable name="entities" select="document('')" />


  <!-- This template escapes apostrophes with a backslash for Javascript usagem, etc. -->
  <xsl:template name="esc_apos">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, &quot;'&quot;)">
        <xsl:value-of select="substring-before($text, &quot;'&quot;)" />\'
        <xsl:call-template name="esc_apos">
          <xsl:with-param name="text" select="substring-after($text, &quot;'&quot;)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- This template substitutes HREF version of entities from lookup document. -->
  <xsl:template name="substitute_for_link">
    <xsl:param name="text" />
    <xsl:param name="esc_apos">true</xsl:param>
    <xsl:choose>
      <xsl:when test="$esc_apos = 'true'">
        <xsl:call-template name="esc_apos">
          <xsl:with-param name="text">
            <xsl:call-template name="substitute-ascii">
              <xsl:with-param name="text" select="$text" />
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substitute-ascii">
          <xsl:with-param name="text" select="$text" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-->
  Template for substituting entities in text.
  <-->
  <!-- Substitute ASCII version of entities from lookup document.-->
  <xsl:template name="substitute-ascii-3-2-2010">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '{')">
        <xsl:value-of select="substring-before($text, '{')" />
        <xsl:variable name="entity-name"
                      select="concat('{', concat(substring-after(substring-before($text, '}'), '{'), '}'))" />
        <xsl:for-each select="$entities">
          <xsl:variable name="substitution" select="key('entity', $entity-name)" />
          <xsl:choose>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity-name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="substitute-ascii">
          <xsl:with-param name="text" select="substring-after($text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="node()" mode="ascii-value" priority="-1">
    <xsl:call-template name="substitute-ascii">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="substitute-ascii">
    <xsl:param name="text" />
    <!-- Causes Artigas, Jos{eacute} Gervasio to become Artigas, JoseGervasio -->
    <!-- xsl:variable name="regexp">\s*\{[^\}]*\}\s*</xsl:variable -->
    <xsl:variable name="regexp">\{[^\}]*\}</xsl:variable>

    <xsl:value-of select="." />
    <!-- xsl:analyze-string select="$text" regex="{$regexp}">
        <xsl:matching-substring>
          <xsl:variable name="entity" select="normalize-space(.)" />
          <xsl:variable name="substitution" select="key('entity', $entity, $entities)"/>
          <xsl:choose>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="." />
        </xsl:non-matching-substring>
      <xsl:analyze-string -->


  </xsl:template>


  <xsl:template match="*" mode="html-value" priority="-1">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text"
                      select="scr:Replace(scr:Replace(scr:Replace(., '\{ndash\}', '-'), '\*', ''), '^\{h,([0-9]+)\}(.+)$', '$2[$1]')" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="text()" mode="html-value" priority="-1">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text"
                      select="scr:Replace(scr:Replace(scr:Replace(., '\{ndash\}', '-'), '\*', ''), '^\{h,([0-9]+)\}(.+)$', '$2[$1]')" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="substitute-html">
    <xsl:param name="text" />
    <xsl:variable name="regexp-old">\s*\{[^\}]*\}\s*</xsl:variable>
    <xsl:variable name="regexp">\{[^\}]*\}</xsl:variable>

    <!-- BUG 122519 -->
    <xsl:choose>
      <xsl:when test="./sxn">
        <xsl:value-of select="text()"/>
      </xsl:when>
    
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
     
    <!-- xsl:analyze-string select="$text" regex="{$regexp}">
        <xsl:matching-substring>
          <xsl:variable name="entity" select="normalize-space(.)" />
          <xsl:variable name="substitution" select="key('entity', $entity, $entities)"/>
          <xsl:choose>
            <xsl:when test="$substitution/html">
              <xsl:copy-of select="$substitution/html/node()"/>
            </xsl:when>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="." />
        </xsl:non-matching-substring>
      <xsl:analyze-string -->
  </xsl:template>

  <!-- ***06/15/2008 - Substitute HTML version of entities from lookup document.-->
  <xsl:template name="substitute-html-2-2-2010">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '{')">
        <xsl:value-of select="substring-before($text, '{')" />
        <xsl:variable name="entity-name"
                      select="concat('{', concat(substring-after(substring-before($text, '}'), '{'), '}'))" />
        <xsl:for-each select="$entities">
          <xsl:variable name="substitution" select="key('entity', $entity-name)" />
          <xsl:choose>
            <xsl:when test="$substitution/html">
              <xsl:copy-of select="$substitution/html/node()" />
            </xsl:when>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity-name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="substring-after($text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Substitute pron version of entities from lookup document.-->
  <xsl:template name="substitute-pron">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '{')">
        <xsl:value-of select="substring-before($text, '{')" />
        <xsl:variable name="entity-name"
                      select="concat('{', concat(substring-after(substring-before($text, '}'), '{'), '}'))" />
        <xsl:for-each select="$entities">
          <xsl:variable name="substitution" select="key('entity', $entity-name)" />
          <xsl:choose>
            <xsl:when test="$substitution/pron">
              <xsl:copy-of select="$substitution/pron/node()" />
            </xsl:when>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity-name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="substitute-pron">
          <xsl:with-param name="text" select="substring-after($text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-->
  Replace middot characters.
  <-->
  <xsl:template name="replace_middot">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '*')">
        <xsl:value-of select="substring-before($text, '*')" />
        <xsl:text disable-output-escaping="yes">·</xsl:text>
        <xsl:call-template name="replace_middot">
          <xsl:with-param name="text" select="substring-after($text, '*')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-->
  Template for processing text nodes. Call appropriate substitution template.
  <-->
  <xsl:template match="text()" mode="ascii" priority="-1">
    <xsl:call-template name="substitute-ascii">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>
  <!-- *** 06/15/2008 - In HTML mode, do HTML substitutions. -->
  <xsl:template match="text()" mode="html" priority="-1">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>

  <!-- *** 06/15/2008 - In pron mode, do pron substitutions. -->
  <xsl:template match="text()" mode="pron" priority="-1">
    <xsl:call-template name="substitute-pron">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:template>

  <!-->
  Low priority template for processing nodes. Propagate mode to children.
  <-->
  <!-- *** 06/15/2008 - In ASCII mode, copy node. -->
  <xsl:template match="node()" priority="-2" mode="ascii">
    <xsl:copy>
      <xsl:apply-templates mode="ascii" />
    </xsl:copy>
  </xsl:template>
  <!-- *** 06/15/2008 - In HTML mode, copy node. -->
  <xsl:template match="node()" priority="-2" mode="html">
    <xsl:copy>
      <xsl:apply-templates mode="html" />
    </xsl:copy>
  </xsl:template>
  <!-- *** 06/15/2008 - In pron mode, copy node. -->
  <xsl:template match="node()" priority="-2" mode="pron">
    <xsl:copy>
      <xsl:apply-templates mode="pron" />
    </xsl:copy>
  </xsl:template>

  <!-- *** UNICODE PROCESSING *** -->

  <!-- *** 06/15/2008 - In Unicode mode, do Unicode and middot substitutions. -->
  <xsl:template match="text()" mode="unicode" priority="-1">
    <xsl:call-template name="substitute-unicode">
      <xsl:with-param name="text">
        <xsl:call-template name="replace_middot">
          <xsl:with-param name="text" select="." />
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="to-unicode">
    <xsl:param name="text" />
    <xsl:call-template name="substitute-unicode">
      <xsl:with-param name="text">
        <xsl:call-template name="replace_middot">
          <xsl:with-param name="text" select="$text" />
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- ***06/15/2008 - Substitute Unicode version of entities from lookup document.-->
  <xsl:template name="substitute-unicode">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '{')">
        <xsl:value-of select="substring-before($text, '{')" />
        <xsl:variable name="entity-name"
                      select="concat('{', concat(substring-after(substring-before($text, '}'), '{'), '}'))" />
        <xsl:for-each select="$entities">
          <xsl:variable name="substitution" select="key('entity', $entity-name)" />
          <xsl:choose>
            <xsl:when test="$substitution/unicode">
              <xsl:copy-of select="$substitution/unicode/node()" />
            </xsl:when>
            <xsl:when test="$substitution/ascii">
              <xsl:copy-of select="$substitution/ascii/node()" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$entity-name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="substitute-unicode">
          <xsl:with-param name="text" select="substring-after($text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** 06/15/2008 - In Unicode mode, copy node. -->
  <xsl:template match="node()" priority="-2" mode="unicode">
    <xsl:copy>
      <xsl:apply-templates mode="unicode" />
    </xsl:copy>
  </xsl:template>

  <!-- *** UNICODE PROCESSING *** -->

  <!-- Replace middot characters. -->
  <xsl:template name="replace-middot">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '*')">
        <xsl:value-of select="substring-before($text, '*')" />&amp;#xB7;
        <xsl:call-template name="replace-middot">
          <xsl:with-param name="text" select="substring-after($text, '*')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** 06/15/2008 - In Unicode mode, do Unicode and middot substitutions. -->
  <xsl:template match="text()" mode="csv-unicode">
    <xsl:call-template name="substitute-csv-unicode">
      <xsl:with-param name="text">
        <xsl:call-template name="replace-middot">
          <xsl:with-param name="text" select="." />
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- ***06/15/2008 - Substitute Unicode version of entities from lookup document.-->
  <xsl:template name="substitute-csv-unicode">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, '{')">
        <xsl:value-of select="substring-before($text, '{')" />
        <xsl:variable name="entity-name"
                      select="concat('{', concat(substring-after(substring-before($text, '}'), '{'), '}'))" />
        <xsl:for-each select="$entities">
          <xsl:variable name="substitution" select="key('entity', $entity-name)" />
          <xsl:choose>
            <xsl:when test="$substitution/unicode">
              <xsl:value-of select="$substitution/unicode/node()" disable-output-escaping="yes" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:comment>
                Entity <xsl:value-of select="$entity-name" /> not found.
              </xsl:comment>
              <xsl:value-of select="$entity-name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:call-template name="substitute-csv-unicode">
          <xsl:with-param name="text" select="substring-after($text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="scr:Replace($text, '&amp;amp;', '&amp;')" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>