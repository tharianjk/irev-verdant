package ireveal.domain;

/**
*  TagDsp: An entity bean used to represent a Tag entity. 
* 
*
* @param  
* @return 
*/
public class RoleDsp  {

	private int role_id;
	private String rolename;	
	private int companyid;
	private String company;
	private Boolean bln_reports;
	private Boolean bln_events;
	private Boolean bln_tools;
	private Boolean bln_settings;
	private int nprecision;
	public int getNprecision() {
		return nprecision;
	}
	public void setNprecision(int nprecision) {
		this.nprecision = nprecision;
	}
	private String expirydate;
	
	public String getExpirydate() {
		return expirydate;
	}
	public void setExpirydate(String expirydate) {
		this.expirydate = expirydate;
	}
	
	public Boolean getBln_reports() {
		return bln_reports;
	}
	public void setBln_reports(Boolean bln_reports) {
		this.bln_reports = bln_reports;
	}
	public Boolean getBln_events() {
		return bln_events;
	}
	public void setBln_events(Boolean bln_events) {
		this.bln_events = bln_events;
	}
	public Boolean getBln_tools() {
		return bln_tools;
	}
	public void setBln_tools(Boolean bln_tools) {
		this.bln_tools = bln_tools;
	}
	public Boolean getBln_settings() {
		return bln_settings;
	}
	public void setBln_settings(Boolean bln_settings) {
		this.bln_settings = bln_settings;
	}
	
	public int getCompanyid() {
		return companyid;
	}
	public void setCompanyid(int companyid) {
		this.companyid = companyid;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	
	public int getRole_id() {
		return role_id;
	}
	public void setRole_id(int role_id) {
		this.role_id = role_id;
	}
	public String getRolename() {
		return rolename;
	}
	public void setRolename(String rolename) {
		this.rolename = rolename;
	}
	

}