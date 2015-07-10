package AIR.Dictionary;

import java.util.List;

public class DictionaryGroup {
	
	private String groupName;
	
	private List<Connection> connections;
	
	private boolean defaultGroup;
	
	
	
	public boolean isDefaultGroup() {
		return defaultGroup;
	}

	public void setDefaultGroup(boolean defaultGroup) {
		this.defaultGroup = defaultGroup;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public List<Connection> getConnections() {
		return connections;
	}

	public void setConnections(List<Connection> connections) {
		this.connections = connections;
	}



public static class Connection {
	 
	private String code;
	private String key;
	private String url;
	
	public Connection() {
		super();
	}
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}

	@Override
	public String toString() {
		return "Connection [code=" + code + ", key=" + key + ", url=" + url
				+ "]";
	}
	
 }
}

