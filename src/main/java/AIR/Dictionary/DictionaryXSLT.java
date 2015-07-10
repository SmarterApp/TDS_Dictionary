/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;

public class DictionaryXSLT {

	private Transformer transformer;

  public DictionaryXSLT(Source xsltReader) throws TransformerConfigurationException // uses .xslt file
  // what is an analog in JAVA C# class XsltArgumentList
  // How to add Extension Object in Java?
  // add to xslt file header:  xmlns:scr="java:AIR.Dictionary.Xslt2Functions"
  {
  	TransformerFactory factory = TransformerFactory.newInstance();
  	transformer = factory.newTransformer(xsltReader);
  }

  public String transformXmlDoc(Source xmlInput) throws TransformerException // uses .xml file
  {
      String strRepeatString = "";
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			  StreamResult result = new StreamResult(new OutputStreamWriter(bos, "UTF-8"));
			  
			  transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			  
			  transformer.transform(xmlInput, result);
			  
			  byte[] outputBytes = bos.toByteArray();
			  strRepeatString = new String(outputBytes, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
      
      return strRepeatString;
  }
}
