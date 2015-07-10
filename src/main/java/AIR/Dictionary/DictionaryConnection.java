/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.net.URI;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import AIR.Common.Utilities.UrlEncoderDecoderUtils;


public class DictionaryConnection {
	private static final Logger _logger = LoggerFactory.getLogger(DictionaryConnection.class);
	
    private final String _apiKey;
    private final String _apiUrl;
    

    public DictionaryConnection(String apiKey, String apiUrl)
    {
        _apiKey = apiKey;
        _apiUrl = apiUrl;
    }
    // Source = Stream
    public String lookup(String word)
    {
    	
    	try (CloseableHttpClient httpClient = HttpClientBuilder.create().build()){
//        // make word url safe
			word = UrlEncoderDecoderUtils.encode (word);

			// create url to send
			String baseUrl = _apiUrl + word;
			URI restAPIURI = new URI(baseUrl+"?key=" + _apiKey);
			// create client
			HttpGet request = new HttpGet(restAPIURI);
			request.setHeader("Accept-Charset", "UTF-8");
			 HttpResponse response = httpClient.execute(request);
						 
			 String responseXML = EntityUtils.toString(response.getEntity(),"UTF-8");
			 return responseXML;
	        
		} catch (Exception e) {
			_logger.error("Error Calling Dictionary rest API ",e);
		}
    	return null;
    }
    
}

