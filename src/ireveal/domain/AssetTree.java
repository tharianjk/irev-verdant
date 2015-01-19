package ireveal.domain;

import java.io.Serializable;

public class AssetTree implements Serializable {

    private String assetname;
    private int assetid;
    private int assetparentid;
    private int nlevel;
    private int treelevel;
    private String assettype;
    private int companyid;
    private String atype;

    public String getAtype() {
		return atype;
	}
	public void setAtype(String atype) {
		this.atype = atype;
	}
	public int getCompanyid() {
		return companyid;
	}
	public void setCompanyid(int companyid) {
		this.companyid = companyid;
	}
	public String toString() {
        StringBuffer buffer = new StringBuffer();
        buffer.append("AssetName: " + assetname+";");
        buffer.append("AssetId: " + assetid);
        buffer.append("Parentid: " + assetparentid+";");
        buffer.append("treelevel: " + treelevel);
        buffer.append("nlevel: " + nlevel);
        return buffer.toString();
    }
	public String getAssetname() {
		return assetname;
	}
	public void setAssetname(String assetname) {
		this.assetname = assetname;
	}
	public int getAssetid() {
		return assetid;
	}
	public void setAssetid(int assetid) {
		this.assetid = assetid;
	}
	public int getAssetparentid() {
		return assetparentid;
	}
	public void setAssetparentid(int assetparentid) {
		this.assetparentid = assetparentid;
	}
	public int getNlevel() {
		return nlevel;
	}
	public void setNlevel(int nlevel) {
		this.nlevel = nlevel;
	}
	public int getTreelevel() {
		return treelevel;
	}
	public void setTreelevel(int treelevel) {
		this.treelevel = treelevel;
	}
	public String getAssettype() {
		return assettype;
	}
	public void setAssettype(String assettype) {
		this.assettype = assettype;
	}

		/*public AssetTree(int assetid, int assetparentid, String assetname,int treelevel) {
        this.assetid = assetid;
        this.assetparentid = assetparentid;
        this.assetname = assetname;
        this.treelevel = treelevel;
    }*/
	
}