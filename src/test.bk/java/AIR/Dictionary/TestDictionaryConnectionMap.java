/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.io.File;

import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.opentestsystem.shared.test.LifecycleManagingTestRunner;
import org.springframework.test.context.ContextConfiguration;

@RunWith(LifecycleManagingTestRunner.class)
@ContextConfiguration(locations = "/test-context.xml")
public class TestDictionaryConnectionMap {

	@Test
	public final void test_getXSLTReader() throws Exception { 

		DictionaryXSLT officialXslt 	= new DictionaryXSLT(DictionaryConnectionMap.getXSLTReader("official.xslt"));
		
	}
	@Test
	public final void test_getDefHTML() throws Exception {
		String dictCode = 	"TDS_Dict_Collegiate";
		String word = 		"word";
		String group = 		"AIR";
		
		boolean is = true;
		DictionaryConnectionMap dcm = new DictionaryConnectionMap(is);
		
		String result = dcm.getDefHTML(dictCode, word, group);
		
		System.out.println("Result: "+  result);
		
	}
	@Test
	public final void test_getThesHTML() throws Exception {
		String word = 		"word";
		String group = 		"AIR";

		boolean is = true;
		DictionaryConnectionMap dcm = new DictionaryConnectionMap(is);
		
		String result = dcm.getThesHTML(word, group);
		
		System.out.println("Result: "+  result);
		
	}

	@Test
	public final void test_getSpanishHTML() throws Exception { 
		String word = 		"palabra";
		String group = 		"AIR";

		boolean is = true;
		DictionaryConnectionMap dcm = new DictionaryConnectionMap(is);
		
		String result = dcm.getSpanishHTML(word, group);
		
		System.out.println("Result: "+  result);
		
	}
	@Test
	public final void test_T() throws Exception {

		DictionaryXSLT _officialXslt = new DictionaryXSLT(DictionaryConnectionMap.getXSLTReader("official.xslt"));

		Source xmlInput =  new StreamSource(new File("C:\\temp\\Dictionary\\input.xml"));
		String result =_officialXslt.transformXmlDoc(xmlInput);
		
		System.out.println("Result: "+  result);
		
	}

	/*
	<group name="AIR" default="true">
	<connections>
		<connection code="TDS_Dict_Collegiate" key="2cdcdd90-9e02-426d-ae02-ef2cbbef0b02" 
					url="http://air.dictionaryapi.com/api/v1/references/collegiate/xml/" />
		<connection code="TDS_Dict_Learners" key="air-lrn6-9f6c-46b5-a3e6-29ebc32458b7"
					url="http://air.dictionaryapi.com/api/v1/references/learners/xml/" />
		<connection code="TDS_Dict_SD2" key="7af32894-aae0-4608-8060-aa75fbb71ba5"
					url="http://air.dictionaryapi.com/api/v1/references/sd2/xml/" />
		<connection code="TDS_Dict_SD3" key="air-sd36-9f6c-46b5-a3e6-29ebc32458b7"
					url="http://air.dictionaryapi.com/api/v1/references/sd3/xml/" />
		<connection code="TDS_Dict_SD4" key="air-sd46-9f6c-46b5-a3e6-29ebc32458b7"
					url="http://air.dictionaryapi.com/api/v1/references/sd4/xml/" />
		<connection code="thesaurus" key="air-ithes9f6c-46b5-a3e6-29ebc32458b7"
					url="http://air.dictionaryapi.com/api/v1/references/ithesaurus/xml/" />
		<connection code="spanish" key="air-sed6-9f6c-46b5-a3e6-29ebc32458b7"
					url="http://air.dictionaryapi.com/api/v1/references/spanish/xml/" />
	</connections>
</group>
*/


}
