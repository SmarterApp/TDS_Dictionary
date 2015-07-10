<?xml version="1.0" encoding="utf-8"?>

<!-->

	*** NOTE: get-cache-key commented out for the Spanish translate site.

  Convert dictionary entry from XML to HTML.
  See the document COLLEGE.KEY for explanations of formatting.
  TODO: Insert separators if called for by the COMMA or SEMICOLON RULEs.
<-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 				
				xmlns:scr="AIR.Dictionary.Xslt2Functions"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
               >
  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="no" omit-xml-declaration="yes" />
  <xsl:param name="grouped">no</xsl:param>

  <xsl:key name="hgroups" match="entry" use="@hgroup" />

  <!-- *** Match alpha sections. *** -->
  <!--
<xsl:template match="/alpha">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link href="http://mwdev.m-w.com/css/css/global.css" rel="stylesheet" type="text/css" />
		<link href="http://mwdev.m-w.com/css/css/inner-2.css" rel="stylesheet" type="text/css" />
		<link href="http://mwdev.m-w.com/css/css/search.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="mwref.css" />
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	</head>
	<body class="page search thesaurus" >
		<div id="page_wrapper">
			<div id="content">
				<xsl:apply-templates select="entry" />
			</div>
			<div id="footer"></div>
		</div>
	</body>
</html>
</xsl:template>
-->

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
  
  <xsl:template match="jum|cryp|release"></xsl:template>

  <!-- *** Match headwords and alternate headwords. *** -->
  <xsl:template match="hw">
    <xsl:variable name="value" select="text()" />
    <xsl:variable name="hm_index">
      <xsl:call-template name="get_hindex">
        <xsl:with-param name="term" select="$value" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="term">
      <xsl:call-template name="strip_hindex">
        <xsl:with-param name="term" select="$value" />
      </xsl:call-template>
    </xsl:variable>
    <strong>
      <xsl:if test="$hm_index != ''">
        <sup>
          <xsl:value-of select="normalize-space($hm_index)" />
        </sup>
      </xsl:if>
      <xsl:call-template name="substitute-html">
        <xsl:with-param name="text" select="$term" />
      </xsl:call-template>
      <xsl:if test="../ahw">
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="../ahw" />
      </xsl:if>
    </strong>
    <xsl:apply-templates select="../sound" />
  </xsl:template>

  <xsl:template match="hw" mode="get-key">
    <xsl:variable name="lang" select="scr:Replace(scr:Replace(../@lang, 'english', 'English'), 'spanish', 'Spanish')" />
    <xsl:variable name="key" select="scr:Replace(scr:Replace(., '\{ndash\}', '-'), '\*', '')" />
    <xsl:variable name="key2" select="scr:Replace($key, '^\{h,([0-9]+)\}(.*)$', '$2[$1]')" />
    <xsl:variable name="key3" select="scr:Replace($key, '([^\]])$', concat('$1[', $lang, ']'))" />
    <xsl:variable name="key4" select="scr:Replace($key, '\[([0-9]+)\]$', concat('[$1,', $lang, ']'))" />
    <xsl:value-of select="$key" />
  </xsl:template>

  <!-- *** Match headwords and alternate headwords. *** -->
  <xsl:template match="ahw">
    <xsl:variable name="value" select="text()" />
    <xsl:variable name="hm_index">
      <xsl:call-template name="get_hindex">
        <xsl:with-param name="term" select="$value" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="term">
      <xsl:call-template name="strip_hindex">
        <xsl:with-param name="term" select="$value" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$hm_index != ''">
      <sup>
        <xsl:value-of select="normalize-space($hm_index)" />
      </sup>
    </xsl:if>
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text" select="$term" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sound">
    <xsl:variable name="text">
      <xsl:call-template name="to-unicode">
        <xsl:with-param name="text" select="scr:Replace(../hw, '\{h,[0-9]*\}|\*', '')" />
      </xsl:call-template>
    </xsl:variable>
    <!-- ** Convert to Camel Case ** -->
    <xsl:variable name="text2">
      <!--
      <xsl:analyze-string select="$text2" regex="\s">
        <xsl:matching-substring>
          <xsl:copy-of select="." />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="scr:UpperCase(substring(., 1, 1))" />
          <xsl:value-of select="substring(., 2)" />
        </xsl:non-matching-substring>
      </xsl:analyze-string>
      -->
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="scr:Replace(., '\.wav$', '')"/>
      </xsl:attribute>
      <xsl:attribute name="data-language">es/me/</xsl:attribute>
      <xsl:attribute name="class">au</xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="$text" /> Pronunciation
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="$text" /> Pronunciation
      </xsl:attribute>
      <span>
        <xsl:text> </xsl:text>
      </span>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sound" mode="backup_10_23_2013">
    <xsl:variable name="text">
      <xsl:call-template name="to-unicode">
        <xsl:with-param name="text" select="scr:Replace(../hw, '\{h,[0-9]*\}|\*', '')" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        /audio?file=<xsl:value-of select="scr:Replace(., '\.wav$', '')"/>&amp;word=<xsl:value-of select="$text" />&amp;format=mp3&amp;text=
      </xsl:attribute>
      <xsl:attribute name="onclick">
        au('<xsl:value-of select="scr:Replace(., '\.wav$', '')"/>', '<xsl:value-of select="$text" />'); return false;
      </xsl:attribute>
      <xsl:attribute name="class">au</xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="scr:UpperCase($text)" /> pronunciation
      </xsl:attribute>
      <xsl:attribute name="title">
        Listen to the pronunciation of <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="scr:Replace(../hw, '\{h,[0-9]*\}|\*', '')"/>
        </xsl:call-template>
      </xsl:attribute>
      <span>
        <xsl:text> </xsl:text>
      </span>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sound" mode="backup_10_07_2013">
    <xsl:variable name="text">
      <xsl:call-template name="to-unicode">
        <xsl:with-param name="text" select="scr:Replace(../hw, '\{h,[0-9]*\}|\*', '')" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="input">
      <xsl:attribute name="type">button</xsl:attribute>
      <xsl:attribute name="onclick">
        return au('<xsl:value-of select="scr:Replace(., '\.wav$', '')"/>', '<xsl:value-of select="$text" />');
      </xsl:attribute>
      <xsl:attribute name="class">au</xsl:attribute>
      <xsl:attribute name="title">
        Listen to the pronunciation of <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="scr:Replace(../hw, '\{h,[0-9]*\}|\*', '')"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- *** Match bold. *** -->
  <xsl:template match="bold">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Match bold notes. *** -->
  <xsl:template match="bnote">
    <strong class="bnote">
      <xsl:apply-templates />
    </strong>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- *** Match conjugation references. *** -->
  <xsl:template match="dx">
    <!-- <xsl:variable name="suffix"><xsl:if test="../def//rv">-rv</xsl:if></xsl:variable><div class="conj{$suffix}"><xsl:element name="a"><xsl:attribute name="href">/resources/sed/conjugations/irr_conj_<xsl:value-of select="./dxt" />.html</xsl:attribute><xsl:attribute name="onclick">popConjWin('/resources/sed/conjugations/irr_conj_<xsl:value-of select="./dxt" />.html'); return false;</xsl:attribute>Model Irregular Verb Conjugation</xsl:element></div> -->
  </xsl:template>

  <!-- *** Match defsets. *** -->
  <xsl:template match="def">
    <xsl:choose>
      <!-- see: dividirse @ dividir -->
      <xsl:when test="rv and not(sense)">
        <div class="drv-no-def">
          <xsl:apply-templates />
        </div>
      </xsl:when>
      <!-- see: tomarse @ tomar -->
      <xsl:when test="rv">
        <div class="drv">
          <xsl:apply-templates />
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="d">
          <xsl:if test=". = ../def[1] and ../fl[scr:Matches(., '\sverb')]">
            <div class="vtr">
              <span class="vt">
                <xsl:apply-templates select="../fl/node()" />
              </span>
            </div>
          </xsl:if>
          <xsl:apply-templates />
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** Match defsets. *** -->
  <xsl:template match="dro">
    <xsl:choose>
      <!-- see: dividirse @ dividir -->
      <xsl:when test="dre and not(def/sense)">
        <div class="drv-no-def">
          <xsl:apply-templates select="dre|vt|def/node()" />
        </div>
      </xsl:when>
      <!-- see: tomarse @ tomar -->
      <xsl:when test="dre">
        <div class="drv">
          <xsl:apply-templates select="dre|vt|def/node()" />
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="d">
          <xsl:if test=". = ../../def[1] and ../../fl[scr:Matches(., '\sverb')]">
            <div class="vtr">
              <span class="vt">
                <xsl:apply-templates select="../../fl/node()" />
              </span>
            </div>
          </xsl:if>
          <xsl:apply-templates select="dre|vt|def/sense" />
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- *** Match defining text. *** -->
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

  <!-- *** Match reference links. *** -->
  
  <xsl:template match="ref-link[@ref = 'spanish']">
  <!--
    <xsl:element name="a">
      <xsl:attribute name="class">ref-link</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:call-template name="to-unicode">
          <xsl:with-param name="text" select="@href" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
    -->
  </xsl:template>
  




  <xsl:template match="entry">
    <xsl:variable name="lang">
      <xsl:choose>
        <xsl:when test="@lang='spanish'">english</xsl:when>
        <xsl:otherwise>spanish</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="clang">
      <xsl:choose>
        <xsl:when test="@lang='spanish'">English</xsl:when>
        <xsl:otherwise>Spanish</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="hgroup" select="concat($lang, concat(':', substring-after(@hgroup, ':')))" />
    <xsl:variable name="term" select="substring-after($hgroup, ':')" />
    
    <xsl:if test="key('hgroups', $hgroup)">
      <a href="{$term}[{$clang}]">
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="scr:Replace(scr:Replace(scr:Replace(key('hgroups', $hgroup)[1]/hw, '\{ndash\}', '-'), '\*', ''), '^\{h,([0-9]+)\}(.+)$', '$2')" />
        </xsl:call-template>
      </a>
    </xsl:if>

    <div class="mwEntryData">
      <span class="entry_label" style="display:none;">
        <xsl:value-of select="./@id" />
      </span>

      <div class="headword first">
        <xsl:apply-templates select="hw | ahw | pr | fl | in" />
      </div>
        
      <div class="definitions">
        <h2 class="def-header" aria-label="Full Definition">
          <span>
            Spanish translation of
            <em>
              <xsl:value-of select="./@id" />
            </em>
          </span>
        </h2>
        <ol>
          <li class="definition-block" role="definition">
            <ol class="scnt">
              <xsl:apply-templates select="def" />
              <xsl:if test="dro">
                <li class="li_for_dr">
                  <div>
                    <ol class="dr">

                    </ol>
                  </div>
                </li>
              </xsl:if>
            </ol>
          </li>
        </ol>
      </div>
    </div>
  </xsl:template>
  

  <xsl:template name="output-examples">
    <xsl:if test=".//example">
      <div class="example-sentences">
        <div class="default">
          <ol>
            <xsl:for-each select=".//example[position() &lt; 11]">
              <span class="vi">
                <span class="txt">
                  <xsl:apply-templates select="sent/node()" />
                </span>
                <xsl:text> </xsl:text>
                <span class="txt">
                  <xsl:apply-templates select="trans/node()" />
                </span>
              </span>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </ol>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="example//em|vi//em">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <xsl:template match="collisions">
    <xsl:apply-templates select="collision" />
  </xsl:template>
  <xsl:template match="collision">
    <xsl:if test="count(./preceding-sibling::collision) != 0">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <a href="{.}">
      <xsl:value-of select="@lex" />
    </a>
    <xsl:if test=". != @lex">
      <xsl:text> (</xsl:text><xsl:apply-templates />)
    </xsl:if>
  </xsl:template>

  <xsl:template name="synant_ant">
    <xsl:if test=".//synant[.//antonym//anto]">
      <div class="synant_ant">
        <xsl:for-each select=".//synant//antonym">
          <xsl:apply-templates select=".//*[scr:Matches(name(.), '^(anto|br)$')]" />
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="synant_syn">
    <xsl:if test=".//synant[.//synonym//syno]">
      <div class="synant_syn">
        <xsl:for-each select=".//synant//synonym">
          <xsl:apply-templates select=".//*[scr:Matches(name(.), '^(syno|br)$')]" />
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="synant//br">
    <xsl:if test="scr:Matches(name(./preceding-sibling::*[1]), '^(anto|syno)$') and ./following-sibling::*[scr:Matches(name(.), '^(anto|syno)$')]">
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="synant//synonym//syno|synant//antonym//anto">
    <xsl:variable name="name" select="name(.)" />
    <xsl:variable name="value" select="scr:Replace(., '\.$', '')" />
    <xsl:if test="name(./preceding-sibling::*[1]) = $name">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@link-to and @link-to='yes'">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:call-template name="substitute-unicode">
              <xsl:with-param name="text" select="scr:Replace(., '\.\s*$', '')" />
            </xsl:call-template>
          </xsl:attribute>
          <!-- xsl:apply-templates /-->
          <xsl:call-template name="substitute-html">
            <xsl:with-param name="text" select="scr:Replace(., '\.\s*$', '')" />
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substitute-html">
          <xsl:with-param name="text" select="scr:Replace(., '\.\s*$', '')" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** Match etymologies. *** -->
  <xsl:template match="et">
    <xsl:apply-templates />
  </xsl:template>

  <!-- *** Match function labels. *** -->
  <xsl:template match="fl">
    <span class="main-fl"><em>
      <xsl:choose>
        <xsl:when test=". = 'adj'">adjective</xsl:when>
        <xsl:when test=". = 'adv'">adverb</xsl:when>
        <xsl:when test=". = 'art'">article</xsl:when>
        <xsl:when test=". = 'conj'">conjunction</xsl:when>
        <xsl:when test=". = 'interj'">interjection</xsl:when>
        <xsl:when test=". = 'mf'">masculine or feminine</xsl:when>
        <xsl:when test=". = 'n'">noun</xsl:when>
        <xsl:when test=". = 'nf'">feminine noun</xsl:when>
        <xsl:when test=". = 'nfpl'">feminine plural noun</xsl:when>
        <xsl:when test=". = 'nfs &amp; pl'">invariable singular or plural feminine noun</xsl:when>
        <xsl:when test=". = 'npl'">plural noun</xsl:when>
        <xsl:when test=". = 'nm'">masculine noun</xsl:when>
        <xsl:when test=". = 'nmf'">masculine or feminine noun</xsl:when>
        <xsl:when test=". = 'nmpl'">masculine plural noun</xsl:when>
        <xsl:when test=". = 'nms &amp; pl'">invariable singular or plural masculine noun</xsl:when>
        <xsl:when test=". = 'ns &amp; pl'">noun invariable for plural</xsl:when>
        <xsl:when test=". = 'prep'">preposition</xsl:when>
        <xsl:when test=". = 'pron'">pronoun</xsl:when>
        <xsl:when test=". = 'v'">verb</xsl:when>
        <xsl:when test=". = 'vb'">verb</xsl:when>
        <xsl:when test=". = 'vi'">intransitive verb</xsl:when>
        <xsl:when test=". = 'vr'">reflexive verb</xsl:when>
        <xsl:when test=". = 'vt'">intransitive verb</xsl:when>
        <xsl:when test=". = 'v impers'">impersonal verb</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em></span>
  </xsl:template>

  <!-- *** Match grammar labels. *** -->
  <xsl:template match="gl">
    <xsl:text> </xsl:text>
    <em>
      <xsl:choose>
        <xsl:when test=". = 'Arg, Chile, Peru'">Argentina, Chile, Peru</xsl:when>
        <xsl:when test=". = 'Arg, Mex, Peru'">Argentina, Mexico</xsl:when>
        <xsl:when test=". = 'Arg, Uru'">Argentina, Uruguay</xsl:when>
        <xsl:when test=". = 'CA'">Central America</xsl:when>
        <xsl:when test=". = 'Chile'">Chile</xsl:when>
        <xsl:when test=". = 'f Chile, Col, Mex'">feminine Chile, Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'Col'">Columbia</xsl:when>
        <xsl:when test=". = 'Col fam'">Columbia familiar</xsl:when>
        <xsl:when test=". = 'Col, Mex'">Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'Col, Mex fam'">Columbia, Mexico familiar</xsl:when>
        <xsl:when test=". = 'Col, Ven'">Columbia, Venezuela</xsl:when>
        <xsl:when test=". = 'f'">feminine</xsl:when>
        <xsl:when test=". = 'f,'">feminine,</xsl:when>
        <xsl:when test=". = 'f Arg, Bol, Chile'">feminine Argentina, Bolivia, Chile</xsl:when>
        <xsl:when test=". = 'f Arg, Chile, Peru'">feminine Argentina, Chile, Peru</xsl:when>
        <xsl:when test=". = 'f Arg, Chile, Col, Peru'">feminine Argentina, Chile, Columbia, Peru</xsl:when>
        <xsl:when test=". = 'f Arg, Mex, Uru'">feminine Argentina, Mexico, Uruguay</xsl:when>
        <xsl:when test=". = 'f, Arg, Uru'">feminine Argentina, Uruguay</xsl:when>
        <xsl:when test=". = 'f Bol, Mex, Peru'">feminine Bolivia, Mexico, Peru</xsl:when>
        <xsl:when test=". = 'f CA'">feminine Central America</xsl:when>
        <xsl:when test=". = 'f CA, Mex'">feminine Central America, Mexico</xsl:when>
        <xsl:when test=". = 'f Chile, Mex'">feminine Chile, Mexico</xsl:when>
        <xsl:when test=". = 'f Col, Ven'">feminine Colombia, Venezuela</xsl:when>
        <xsl:when test=". = 'f Col, Mex'">feminine Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'f Col, Mex, Pan'">feminine Colombia, Mexico, Panama</xsl:when>
        <xsl:when test=". = 'CoRi, Mex'">Costa Rica, Mexico</xsl:when>
        <xsl:when test=". = 'f Cuba, Mex, PRi'">feminine Cuba, Mexico, Puerto Rico</xsl:when>
        <xsl:when test=". = 'f fam'">feminine familiar</xsl:when>
        <xsl:when test=". = 'f Mex'">feminine Mexico</xsl:when>
        <xsl:when test=". = 'f Mex fam'">feminine Mexico familiar</xsl:when>
        <xsl:when test=". = 'f PRi'">feminine Puerto Rico</xsl:when>
        <xsl:when test=". = 'f Spain'">feminine Spain</xsl:when>
        <xsl:when test=". = 'f Ven fam'">feminine Venezuela familiar</xsl:when>
        <xsl:when test=". = 'fam'">familiar</xsl:when>
        <xsl:when test=". = 'fpl'">feminine plural</xsl:when>
        <xsl:when test=". = 'fpl fam'">feminine plural familiar</xsl:when>
        <xsl:when test=". = 'fpl Mex'">feminine plural Mexico</xsl:when>
        <xsl:when test=". = 'm'">masculine</xsl:when>
        <xsl:when test=". = 'm,'">masculine,</xsl:when>
        <xsl:when test=". = 'm Arg, Bol, Peru'">masculine Argentina, Bolivia, Peru</xsl:when>
        <xsl:when test=". = 'm Arg, Chile, Col, Peru'">masculine Argentina, Chile, Columbia, Peru</xsl:when>
        <xsl:when test=". = 'm Arg, Chile, Peru, Uru'">masculine Argentina, Chile, Peru, Uruguay</xsl:when>
        <xsl:when test=". = 'm Arg, Chile, Uru'">masculine Argentina, Chile, Uruguay</xsl:when>
        <xsl:when test=". = 'm Arg, Uru'">masculine Argentina, Uruguay</xsl:when>
        <xsl:when test=". = 'm Ca'">masculine Central America</xsl:when>
        <xsl:when test=". = 'm CA, Col'">masculine Central America, Columbia</xsl:when>
        <xsl:when test=". = 'm CA, Col, Ven'">masculine Central America, Columbia, Venezuela</xsl:when>
        <xsl:when test=". = 'm CA, Mex'">masculine Central America, Mexico</xsl:when>
        <xsl:when test=". = 'm CA, Mex, Ven'">masculine Central America, Mexico, Venezuela</xsl:when>
        <xsl:when test=". = 'm Car'">masculine Caribbean</xsl:when>
        <xsl:when test=". = 'm Chile, Col, Mex'">masculine Chile, Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'm Chile, Peru'">masculine Chile, Peru</xsl:when>
        <xsl:when test=". = 'm Col, Mex'">masculine Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'm Col, Mex, Ven'">masculine Columbia, Mexico</xsl:when>
        <xsl:when test=". = 'm fam'">masculine familiar</xsl:when>
        <xsl:when test=". = 'm Mex'">masculine Mexico</xsl:when>
        <xsl:when test=". = 'm Mex fam'">masculine Mexico familiar</xsl:when>
        <xsl:when test=". = 'm PRi'">masculine Puerto Rico</xsl:when>
        <xsl:when test=". = 'm Spain'">masculine Spain</xsl:when>
        <xsl:when test=". = 'm Ven'">masculine Venezuela</xsl:when>
        <xsl:when test=". = 'Mex'">Mexico</xsl:when>
        <xsl:when test=". = 'Mex fam'">Mexico familiar</xsl:when>
        <xsl:when test=". = 'mf'">masculine or feminine</xsl:when>
        <xsl:when test=". = 'mf CA, Mex'">masculine or feminine Central America</xsl:when>
        <xsl:when test=". = 'mf fam'">masculine or feminine familiar</xsl:when>
        <xsl:when test=". = 'mf Mex'">masculine or feminine Mexico</xsl:when>
        <xsl:when test=". = 'mf Spain'">masculine or plural Spain</xsl:when>
        <xsl:when test=". = 'mfpl'">masculine or feminine plural</xsl:when>
        <xsl:when test=". = 'mpl'">masculine plural</xsl:when>
        <xsl:when test=". = 'mpl fam'">masculine plural familiar</xsl:when>
        <xsl:when test=". = 'mpl Mex'">masculine plural Mexico</xsl:when>
        <xsl:when test=". = 'mpl Spain'">plural masculine Spain</xsl:when>
        <xsl:when test=". = 'nfpl'">feminine plural noun</xsl:when>
        <xsl:when test=". = 'nm'">masculine noun</xsl:when>
        <xsl:when test=". = 'nmpl'">masculine plural noun</xsl:when>
        <xsl:when test=". = 'pl'">plural</xsl:when>
        <xsl:when test=". = 'pl Spain'">plural Spain</xsl:when>
        <xsl:when test=". = 'PRi'">Puerto Rico</xsl:when>
        <xsl:when test=". = 'Spain'">Spain</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em>
  </xsl:template>

  <!-- *** Match if's. *** -->
  <xsl:template match="if">
    <strong>
      <xsl:apply-templates />
    </strong>
    <xsl:if test="../if[position() = last()] = . and name(../following-sibling::*[1]) = 'in'">
      <xsl:choose>
        <xsl:when test="name(../following-sibling::node()[1]) = '' and normalize-space(../following-sibling::node()[1]) = ';'">
          <xsl:text>; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- *** Match ihw's. *** -->
  <xsl:template match="ihw"></xsl:template>

  <!-- *** Match il's. *** -->
  <xsl:template match="il">
    <em>
      <xsl:choose>
        <xsl:when test=". = 'pl'">plural</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em>
  </xsl:template>

  <!-- *** Match in's. *** -->
  <xsl:template match="in"></xsl:template>
  <!-- xsl:template match="in" mode="show"><xsl:apply-templates /></xsl:template -->
  <xsl:template match="in" mode="show">
    <xsl:variable name="class">
      in<xsl:if test="name(following-sibling::node()) = 'in'">-more</xsl:if>
    </xsl:variable>
    <span class="{$class}">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <!-- *** Match italic tags. *** -->
  <xsl:template match="it">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- *** Match pr's *** -->
  <xsl:template match="pr | ip"></xsl:template>

  <!-- *** Match rv's *** -->
  <xsl:template match="rv"></xsl:template>
  <xsl:template match="rv" mode="show">
    <xsl:text> </xsl:text>
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Match dre's *** -->
  <xsl:template match="dre"></xsl:template>
  <xsl:template match="dre" mode="show">
    <xsl:text> </xsl:text>
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>


  <!-- *** Match sa's. *** -->
  <xsl:template match="sa">
    <span class="sa">
      <strong>&#x2192;</strong>
      <xsl:text> </xsl:text>
      <xsl:element name="a">
        <xsl:attribute name="class">cref syn</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:apply-templates mode="link" />
        </xsl:attribute>
        <xsl:apply-templates />
      </xsl:element>
    </span>
  </xsl:template>

  <!-- *** Match senses. *** -->
  <xsl:template match="sense">
    <xsl:variable name="css">
      <xsl:choose>
        <xsl:when test="sn">sblk</xsl:when>
        <xsl:otherwise>sense-block-one</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{$css}">
      <xsl:apply-templates select="sn" />
      <div class="scnt">
        <span class="ssens">
          <xsl:apply-templates select="node()[name(.) != 'sn']" />
        </span>
      </div>
    </div>
  </xsl:template>

  <!-- *** Match sif's. *** -->
  <xsl:template match="sif">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Match sin's. *** -->
  <xsl:template match="sin">
    <xsl:apply-templates />
  </xsl:template>

  <!-- *** Match sense numbers. *** -->
  <xsl:template match="sn">

  </xsl:template>

  <!-- *** Match sp's. *** -->
  <xsl:template match="sp"></xsl:template>

  <!-- *** Match spl's. *** -->
  <xsl:template match="spl">
    <em>
      <xsl:choose>
        <xsl:when test=". = 'pl'">plural</xsl:when>
        <xsl:when test=". = 'npl'">plural noun</xsl:when>
        <xsl:when test=". = 'nfpl'">feminine plural noun</xsl:when>
        <xsl:when test=". = 'nmpl'">masculine plural noun</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em>
  </xsl:template>

  <!-- *** Match ssl's. *** -->
  <xsl:template match="ssl">
    <em>
      <xsl:choose>
        <xsl:when test=". = 'fam'">familiar</xsl:when>
        <xsl:when test=". = 'Mex fam'">Mexico, familiar</xsl:when>
        <xsl:when test=". = 'Mex'">Mexico</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em>
  </xsl:template>

  <!-- *** Match svr's. *** -->
  <xsl:template match="svr">
    <xsl:apply-templates />
  </xsl:template>

  <!-- *** Match synonymous cross-references. *** -->
  <xsl:template match="sx">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:apply-templates mode="link" />
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
    <xsl:call-template name="output_list_separator" />
  </xsl:template>

  <xsl:template name="output_list_separator">
    <xsl:variable name="curr_name" select="name()" />
    <xsl:variable name="curr_pos" select="1 + count(./preceding-sibling::node())" />
    <xsl:variable name="next_node" select="../node[position() = ($curr_pos + 1)][1]" />
    <xsl:choose>
      <xsl:when test="name($next_node) = '' and normalize-space($next_node) != ''"></xsl:when>
      <xsl:when test="name(./following-sibling::node()[name(.) != ''][1]) = $curr_name and normalize-space(./following-sibling::node()[1]) != ','">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** Match ufl's. *** -->
  <xsl:template match="ufl">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- *** Match un's. *** -->
  <xsl:template match="un">
    <xsl:apply-templates />
  </xsl:template>

  <!-- *** Match ure's. *** -->
  <xsl:template match="ure">
    <strong>
      &#x2014;<xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Match uro's. *** -->
  <xsl:template match="uro">
    <div class="r">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <!-- *** Match uva's. *** -->
  <xsl:template match="uva">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Match uvl's. *** -->
  <xsl:template match="uvl">
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- *** Match va's. *** -->
  <xsl:template match="va">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <!-- *** Output a verbal illustration. -->
  <xsl:template match="vi[not(sent) or not(trans)]">
    <xsl:variable name="reg">\s*\{bc\}\s*</xsl:variable>
    <xsl:text> </xsl:text>
    <span class="vi">
      <!--
      <xsl:analyze-string select="." regex="{$reg}">
        <xsl:non-matching-substring>
          <span class="txt">
            <xsl:call-template name="substitute-html">
              <xsl:with-param name="text" select="."/>
            </xsl:call-template>
          </span>
          <xsl:text> </xsl:text>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
      -->
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="vi[sent and trans]">
    <span class="vi">
      <span class="txt">
        <xsl:apply-templates select="sent/node()" />
      </span>
      <xsl:text> </xsl:text>
      <span class="txt">
        <xsl:apply-templates select="trans/node()" />
      </span>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- xsl:template match="vi"><xsl:variable name="reg">\s*\{bc\}\s*</xsl:variable><xsl:text> </xsl:text><span class="vi"><xsl:analyze-string select="." regex="{$reg}"><xsl:non-matching-substring><span class="txt"><xsl:call-template name="substitute-html"><xsl:with-param name="text" select="."/></xsl:call-template></span></xsl:non-matching-substring></xsl:analyze-string></span><xsl:text> </xsl:text></xsl:template -->

  <!-- *** Match vl's. *** -->
  <xsl:template match="vl">
    <xsl:text> </xsl:text>
    <em>
      <xsl:apply-templates />
    </em>
  </xsl:template>

  <!-- *** Match vpl's. *** -->
  <xsl:template match="vpl">
    <em>
      <xsl:choose>
        <xsl:when test=". = 'nfpl'">feminine plural noun</xsl:when>
        <xsl:when test=". = 'nm'">masculine noun</xsl:when>
        <xsl:when test=". = 'nmpl'">masculine plural noun</xsl:when>
        <xsl:when test=". = 'ns &amp; pl'">noun invariable for plural</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </em>
  </xsl:template>

  <!-- *** Match vt's *** -->
  <xsl:template match="vt">
    <div class="vtr">
      <xsl:if test=". = 'vr'">
        <xsl:apply-templates select="./preceding-sibling::*[name(.) = 'rv' or name(.) = 'dre'][1]" mode="show" />
        <xsl:text> </xsl:text>
      </xsl:if>
      <span class="vt">
        <xsl:choose>
          <xsl:when test=". = 'vb'">verb</xsl:when>
          <xsl:when test=". = 'vi'">intransitive verb</xsl:when>
          <xsl:when test=". = 'vt'">transitive verb</xsl:when>
          <xsl:when test=". = 'v impers'">impersonal verb</xsl:when>
          <xsl:when test=". = 'v impers'">auxiliary verb</xsl:when>
          <xsl:when test=". = 'v aux'">auxiliary verb</xsl:when>
          <xsl:when test=". = 'vr'">reflexive verb</xsl:when>
        </xsl:choose>
      </span>
    </div>
  </xsl:template>

  <!-- *** Match x's. *** -->
  <xsl:template match="x">
    <xsl:choose>
      <xsl:when test="not(contains(scr:Replace(., '\{h,[0-9]+\}', ''), ','))">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:apply-templates mode="link" />
          </xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
        <xsl:call-template name="output_list_separator" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:call-template name="substitute-ascii">
              <xsl:with-param name="text" select="normalize-space(substring-before(., ','))" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:call-template name="substitute-html">
            <xsl:with-param name="text" select="normalize-space(substring-before(., ','))" />
          </xsl:call-template>
        </xsl:element>
        <xsl:text>, </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:call-template name="substitute-ascii">
              <xsl:with-param name="text" select="normalize-space(substring-after(., ','))" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:call-template name="substitute-html">
            <xsl:with-param name="text" select="normalize-space(substring-after(., ','))" />
          </xsl:call-template>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- *** Match xr's. *** -->
  <xsl:template match="xr[name(..) != 'entry']">
    <strong>&#x2192;</strong>
    <xsl:text> </xsl:text>
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="xr[name(..) = 'entry']">
    <div class="d">
      <div class="sense-block-one">
        <div class="scnt">
          <strong>&#x2192;</strong>
          <xsl:text> </xsl:text>
          <xsl:apply-templates />
        </div>
      </div>
    </div>
  </xsl:template>


  <!-- *** Match any tag which doesn't have a template.. *** -->
  <xsl:template match="*">
    <xsl:element name="span">
      <xsl:attribute name="class">
        <xsl:value-of select="name(.)"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!-- *** General Purpose Templates *** -->

  <!-- *** This template returns the language id of an entry. *** -->
  <xsl:template name="get_entry_lang">
    <xsl:param name="node" />
    <xsl:choose>
      <xsl:when test="name($node) = 'entry'">
        <xsl:value-of select="normalize-space(scr:LowerCase($node/sl))" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="get_entry_lang">
          <xsl:with-param name="node" select="$node/.." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- This template returns a term's homograph index. -->
  <xsl:template name="get_hindex">
    <xsl:param name="term" />
    <xsl:if test="starts-with($term, '{h,')">
      <xsl:value-of select="substring-after(substring-before($term, '}'), '{h,')" />
    </xsl:if>
  </xsl:template>

  <!-- This template strips a homograph index from a term. -->
  <xsl:template name="strip_hindex">
    <xsl:param name="term" />
    <xsl:choose>
      <xsl:when test="starts-with($term, '{h,')">
        <xsl:value-of select="substring-after($term, '}')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$term" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- The template gets the parent hw. -->
  <xsl:template name="get_hw">
    <xsl:param name="node" />
    <xsl:choose>
      <xsl:when test="$node/../hw">
        <xsl:value-of select="substring-after($node/../hw[1], '}')" />
      </xsl:when>
      <xsl:when test="$node/../rv">
        <xsl:value-of select="substring-after($node/../rv[1], '}')" />
      </xsl:when>
      <xsl:when test="name($node) != 'entry' and name($node) != 'alpha'">
        <xsl:call-template name="get_hw">
          <xsl:with-param name="node" select="$node/.." />
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-->
  All non-link text nodes are processed in HTML.
  <-->
  <xsl:template match="text()">
    <xsl:call-template name="substitute-html">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-->
  Link text nodes are processed in ASCII.
  <-->
  <xsl:template match="text()" mode="link">
    <xsl:if test="not(name(./preceding-sibling::node()[position() = last()]) = 'in') and not(name(./following-sibling::node()[1]) = 'in')">
      <xsl:call-template name="substitute-ascii">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="comment()"></xsl:template>

  <!-->
  All unmatched nodes are highlighted for debugging.
  <-->
  <xsl:template match="node()[name(.) != 'alpha']" priority="-1">
    <xsl:text>???</xsl:text>
    <xsl:copy/>
  </xsl:template>

<!-->
  <xsl:include href="substitute.xsl"/>
  <xsl:include href="index.xsl"/>
 <-->
  
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

    <xsl:value-of select="." />
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
  <!-- <xsl:variable name="entities" select="document('entities.xml')" /> -->


  <!-- This template escapes apostrophes with a backslash for Javascript usagem, etc. -->
  <xsl:template name="esc_apos2">
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
  <xsl:template name="substitute_for_link2">
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
  <xsl:template name="substitute-ascii-3-2-20102">
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

  <xsl:template name="substitute-ascii2">
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


  <xsl:template name="substitute-html2">
    <xsl:param name="text" />
    <xsl:variable name="regexp-old">\s*\{[^\}]*\}\s*</xsl:variable>
    <xsl:variable name="regexp">\{[^\}]*\}</xsl:variable>

    <xsl:value-of select="." />
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
  <xsl:template name="substitute-html-2-2-20102">
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
  <xsl:template name="substitute-pron2">
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
  <xsl:template name="replace_middot2">
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

  <xsl:template name="to-unicode2">
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
  <xsl:template name="substitute-unicode2">
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
  <xsl:template name="replace-middot2">
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
  <xsl:template name="substitute-csv-unicode2">
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