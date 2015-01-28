package ireveal.domain;

public class ProductSerial {
private int productserialid;
private int productid;
private String productname;
private String productserial;
private String rptheader;
private String rptfooter;

public String getRptheader() {
	return rptheader;
}
public void setRptheader(String rptheader) {
	this.rptheader = rptheader;
}
public String getRptfooter() {
	return rptfooter;
}
public void setRptfooter(String rptfooter) {
	this.rptfooter = rptfooter;
}
public int getProductserialid() {
	return productserialid;
}
public void setProductserialid(int productserialid) {
	this.productserialid = productserialid;
}
public int getProductid() {
	return productid;
}
public void setProductid(int productid) {
	this.productid = productid;
}
public String getProductname() {
	return productname;
}
public void setProductname(String productname) {
	this.productname = productname;
}
public String getProductserial() {
	return productserial;
}
public void setProductserial(String productserial) {
	this.productserial = productserial;
}

}
