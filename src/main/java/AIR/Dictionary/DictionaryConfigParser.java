/*******************************************************************************
 * Educational Online Test Delivery System 
 * Copyright (c) 2015 American Institutes for Research
 *   
 * Distributed under the AIR Open Source License, Version 1.0 
 * See accompanying file AIR-License-1_0.txt or at
 * http://www.smarterapp.org/documents/American_Institutes_for_Research_Open_Source_Software_License.pdf
 ******************************************************************************/
package AIR.Dictionary;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class DictionaryConfigParser {
	
	
	
    public DictionaryConfigParser(List<DictionaryGroup> dictionaryGroups) {
		super();
		this.dictionaryGroups = dictionaryGroups;
	}
    
	private List<DictionaryGroup> dictionaryGroups = new ArrayList<>();
    
    public List<DictionaryGroup> getDictionaryGroups() {
		return dictionaryGroups;
	}

	public void setDictionaryGroups(List<DictionaryGroup> dictionaryGroups) {
		this.dictionaryGroups = dictionaryGroups;
	}

    public Map<String, Map<String, DictionaryConnection>> getAllConnections()
    {
       Map<String, Map<String, DictionaryConnection>> resultDictionary = new HashMap<String, Map<String, DictionaryConnection>>();
       
        //Loop through all groups available and create dictionary entry for each
       for (DictionaryGroup group : dictionaryGroups)
       {
           resultDictionary.put(group.getGroupName(), getConnectionsByGroup(group));
       }
       return resultDictionary;    
    }
    
    public Map<String, DictionaryConnection> getConnectionsByGroup(DictionaryGroup groupName)
    {
        Map<String, DictionaryConnection> resultDictionary = new HashMap<String, DictionaryConnection>();

        //add those names to the dictionary of results
        for(DictionaryGroup.Connection connection: groupName.getConnections())
        {
        	resultDictionary.put(connection.getCode(), 
        			new DictionaryConnection(connection.getKey(), connection.getUrl()));
        }
        return resultDictionary; 

    }
    
    public List<String> getGroups()
    {
        List<String> resultList = new ArrayList<String>();
        
        for(DictionaryGroup group : dictionaryGroups) {
        	resultList.add(group.getGroupName());
        }
        
        return resultList;
        
    }
    public String getDefaultGroup()
    {
        for(DictionaryGroup group : dictionaryGroups) {
        	if(group.isDefaultGroup()) {
        		return group.getGroupName();
        	}
        }
        return "";
    }
}
