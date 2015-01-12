package ireveal.domain;

import java.io.Serializable;

public class Company implements Serializable {

    private String companyname;
    public int getDefalertid() {
		return defalertid;
	}
	public void setDefalertid(int defalertid) {
		this.defalertid = defalertid;
	}
	private int companyid;
    private String companyAddress;
    private String displayname;
    private int nlevel;
    private int defalertid;
    
      

    public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append("companyName: " +companyname +";");
        buffer.append("companyid: " + companyid);
        buffer.append("companyAddress: " + companyAddress+";");
        buffer.append("displayname: " + displayname+";"); 
        buffer.append("nlevel:"+ nlevel);
        return buffer.toString();
    }
	public String getCompanyname() {
		return companyname;
	}
	public void setCompanyname(String companyname) {
		this.companyname = companyname;
	}
	public int getCompanyid() {
		return companyid;
	}
	public void setCompanyid(int companyid) {
		this.companyid = companyid;
	}
	public String getCompanyAddress() {
		return companyAddress;
	}
	public void setCompanyAddress(String companyAddress) {
		this.companyAddress = companyAddress;
	}
	public String getDisplayname() {
		return displayname;
	}
	public void setDisplayname(String displayname) {
		this.displayname = displayname;
	}

	public int getNlevel() {
		return nlevel;
	}
	public void setNlevel(int nlevel) {
		this.nlevel = nlevel;
	}
	
}