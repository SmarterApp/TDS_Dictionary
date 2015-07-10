/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Xslt2Functions {
    public static String Replace(String StringToModify, String pattern, String replacement)
    {
        return StringToModify.replace(pattern, replacement);
    }

    public static String LowerCase(String param)
    {
        return param.toLowerCase();
    }

    public static String UpperCase(String param)
    {
        return param.toUpperCase();
    }
    
    public static boolean Matches(String source, String pttern)
    {
    	Pattern pattern = Pattern.compile(pttern);

    	Matcher matcher = pattern.matcher(source);
    	return matcher.matches();
    }
}
