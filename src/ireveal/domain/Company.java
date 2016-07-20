package ireveal.domain;



public class Company {

    private String companyname;
   
	private int companyid;
    private String companyAddress;
    private String displayname;
    
    private int nprecision;
    private int ndebugFlag;
    
    private boolean bdebugflag;
    private boolean bpurge;

    public boolean getBdebugflag() {
		return bdebugflag;
	}
	public void setBdebugflag(boolean bdebugflag) {
		this.bdebugflag = bdebugflag;
	}
	public boolean getBpurge() {
		return bpurge;
	}
	public void setBpurge(boolean bpurge) {
		this.bpurge = bpurge;
	}
	public int getNdebugFlag() {
		return ndebugFlag;
	}
	public void setNdebugFlag(int ndebugFlag) {
		this.ndebugFlag = ndebugFlag;
	}
	
	public int getNprecision() {
		return nprecision;
	}
	public void setNprecision(int nprecision) {
		this.nprecision = nprecision;
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

	
}