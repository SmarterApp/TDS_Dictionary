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
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import AIR.Common.Configuration.AppSettingsHelper;
import AIR.Common.Helpers._Ref;
import AIR.Common.Web.HttpWebHelper;
import AIR.Common.Web.MimeMapping;

public class AudioConnection {
	private String _urlRoot;
	private String _type;
	private String _fileName;
    private static final HttpWebHelper 	HttpWebHelper = new HttpWebHelper ();
    private int                        	_maxRetries = 5; // default value
    static { // TODO dictionary.sympyTimeoutMillis = ?
        HttpWebHelper.setTimeoutInMillis (AppSettingsHelper.getInt32 ("dictionary.sympyTimeoutMillis", 10000));
      }

    public int getMaxTries () {
        return _maxRetries;
      }

	private static final Logger _logger = LoggerFactory
			.getLogger(AudioConnection.class);

	public AudioConnection(String filename, String type) {
		_urlRoot = "http://media.merriam-webster.com/audio/prons/en/us/";
		_type = type;
		_fileName = getModifiedFilename(filename);
	}

    private String getFileIndex()
    { 
         //rules from here http://www.dictionaryapi.com/info/faq-audio-image.htm#collegiate

        if (_fileName.substring(0, 3).equals("bix"))
        {
            return "bix";
        }
        else if (_fileName.substring(0, 2).equals("gg"))
        {
            return "gg";
        }
        else if (matches(_fileName, "^[0-9]+.+$"))
        {
            return "number";
        }
        else
        {
            return _fileName.substring(0, 1);
        }
    }

    public String getMapping()
    {
        return MimeMapping.getMapping(_fileName);
    }

    private String getModifiedFilename(String oldFileName)
    {
        String result = oldFileName;
        int extIndex = oldFileName.length() - 3;
        if (!oldFileName.substring(extIndex, 3).equals(_type))
        {
            result = oldFileName.substring(0, extIndex) + _type;
        }
        return result;
    }

    public Source getStream() throws UnsupportedEncodingException
    {
        String index = getFileIndex();
        String soundUrl = _urlRoot + _type +"/"+ index + "/" + _fileName;
        
		_Ref<Integer> httpStatusCode = new _Ref<Integer>(HttpServletResponse.SC_OK);
		String httpResponse = "";
		try {
			Map<String, Object> formParametersToString = new HashMap<String, Object> ();
			httpResponse = HttpWebHelper.submitForm (soundUrl, formParametersToString, getMaxTries(), httpStatusCode);
		} catch (IOException e) {
			_logger.error (String.format ("Failed to invoke audiofile by url = \"%s\". HttpWebHelper returned an exception: %s ", 
					soundUrl, e.getMessage()), e);
//				throw new DictionaryException or DictionaryError;
		}
		if (httpStatusCode.get () == HttpServletResponse.SC_OK) {
		// I don't understand if I need to JsonHelper.deserialize ?
		// String response = JsonHelper.deserialize (httpResponse, String.class);
		}

 		return new StreamSource(new ByteArrayInputStream (httpResponse.getBytes ("UTF-8")));       

    }
    
    private boolean matches(String source, String pttern)
    {
    	Pattern pattern = Pattern.compile(pttern);
    	Matcher matcher = pattern.matcher(source);
    	return matcher.matches();
    }

}
