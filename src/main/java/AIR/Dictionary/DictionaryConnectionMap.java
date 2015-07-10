/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.xml.sax.SAXException;

import AIR.Common.Utilities.UrlEncoderDecoderUtils;
@Component
public class DictionaryConnectionMap {
    private static Map<String, Map<String, DictionaryConnection>> _dictMap = null;
    private static DictionaryXSLT _officialXslt = null;
    private static DictionaryXSLT _thesaurusXslt = null;
    private static DictionaryXSLT _spanishXslt = null;
    
    @Autowired
    private DictionaryConfigParser _configParser;
    
    private static String _defaultGroup;

    public DictionaryConnectionMap() throws TransformerConfigurationException, ParserConfigurationException, SAXException, IOException, SQLException
    {
        
    }
    
    @PostConstruct
    public void init() {
    	   try {
			_officialXslt 	= new DictionaryXSLT(getXSLTReader("official.xslt"));
			_thesaurusXslt 	= new DictionaryXSLT(getXSLTReader("thesaurus_air.xslt"));
			_spanishXslt 	= new DictionaryXSLT(getXSLTReader("spanish_off_air.xslt"));
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		}
        _defaultGroup 	= _configParser.getDefaultGroup();
        _dictMap 		= _configParser.getAllConnections();
    }

    public DictionaryConnectionMap(boolean is) throws TransformerConfigurationException, ParserConfigurationException, SAXException, IOException, SQLException
    {
 	   try {
			_officialXslt 	= new DictionaryXSLT(getXSLTReader("official.xslt"));
			_thesaurusXslt 	= new DictionaryXSLT(getXSLTReader("thesaurus_air.xslt"));
			_spanishXslt 	= new DictionaryXSLT(getXSLTReader("spanish_off_air.xslt"));
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		}
     _defaultGroup 	= _configParser.getDefaultGroup();
     _dictMap 		= _configParser.getAllConnections();
       
    }

    public static Source getXSLTReader(String fileName)
    {
    	String resourceName = "/xslt/" + fileName;
    	String filePath = DictionaryConnectionMap.class.getResource(resourceName).getPath();
    	filePath = UrlEncoderDecoderUtils.decode(filePath);
        Source xsltReader = new StreamSource(new File(filePath));
        return xsltReader;
    }
    
    public List<String> getConnectionLabels()
    {
    	List<String> keys = new ArrayList<String>(_dictMap.keySet());
        return keys;
    }

    private Source lookup(String dictCode, String word, String group)
    {
        if (group == null || group.isEmpty())
        {
            group = _defaultGroup;
        }
        Map<String, DictionaryConnection> map = _dictMap.get(group);
        DictionaryConnection dc = map.get(dictCode);
        String response = dc.lookup(word);
        InputStream stream = new ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8));

        return new StreamSource(stream);
    }
    
	public String getDefHTML(String dictCode, String word, String group)
			throws TransformerException {
		Source xmlReader = lookup(dictCode, word, group);
		String result_html = _officialXslt.transformXmlDoc(xmlReader);
		return result_html;

	}

	public String getThesHTML(String word, String group)
			throws TransformerException {
		Source xmlReader = lookup("thesaurus", word, group);
		String result_html = _thesaurusXslt.transformXmlDoc(xmlReader);
		return result_html;

	}

	public String getSpanishHTML(String word, String group)
			throws TransformerException {
		Source xmlReader = lookup("spanish", word, group);
		String result_html = _spanishXslt.transformXmlDoc(xmlReader);
		return result_html;

	}
}
