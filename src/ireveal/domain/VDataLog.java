package ireveal.domain;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class VDataLog {
private int logid;
private int tagid;
private Double nreading;
private Date dtlogdate;
private String strlogdate;
private String metername;
private String attribute;
private int attributeid;
private MultipartFile filename; 
private int secid;
private int nlevel;
private String displayname;
private Double prevreading;
private Double nqty;
private String username;
public String getUsername() {
	return username;
}
public void setUsername(String username) {
	this.username = username;
}
public Double getNqty() {
	return nqty;
}
public void setNqty(Double nqty) {
	this.nqty = nqty;
}
public String getDisplayname() {
	return displayname;
}
public Double getPrevreading() {
	return prevreading;
}
public void setPrevreading(Double prevreading) {
	this.prevreading = prevreading;
}
public void setDisplayname(String displayname) {
	this.displayname = displayname;
}
public String getStrlogdate() {
	return strlogdate;
}
public void setStrlogdate(String strlogdate) {
	this.strlogdate = strlogdate;
}
private String bqty;
private int utilityid;
private String coretype;
private int meterid;
public int getLogid() {
	return logid;
}
public void setLogid(int logid) {
	this.logid = logid;
}
public int getTagid() {
	return tagid;
}
public void setTagid(int tagid) {
	this.tagid = tagid;
}
public Double getNreading() {
	return nreading;
}
public void setNreading(Double nreading) {
	this.nreading = nreading;
}
public Date getDtlogdate() {
	return dtlogdate;
}
public void setDtlogdate(Date dtlogdate) {
	this.dtlogdate = dtlogdate;
}
public String getMetername() {
	return metername;
}
public void setMetername(String metername) {
	this.metername = metername;
}
public String getAttribute() {
	return attribute;
}
public void setAttribute(String attribute) {
	this.attribute = attribute;
}
public MultipartFile getFilename() {	
	return filename;
}
public void setFilename(MultipartFile filename) {
	this.filename = filename;
}
public int getSecid() {
	return secid;
}
public void setSecid(int secid) {
	this.secid = secid;
}
public int getNlevel() {
	return nlevel;
}
public void setNlevel(int nlevel) {
	this.nlevel = nlevel;
}
public String getBqty() {
	return bqty;
}
public void setBqty(String bqty) {
	this.bqty = bqty;
}
public int getUtilityid() {
	return utilityid;
}
public void setUtilityid(int utilityid) {
	this.utilityid = utilityid;
}
public String getCoretype() {
	return coretype;
}
public void setCoretype(String coretype) {
	this.coretype = coretype;
}
public int getMeterid() {
	return meterid;
}
public void setMeterid(int meterid) {
	this.meterid = meterid;
}
public int getAttributeid() {
	return attributeid;
}
public void setAttributeid(int attributeid) {
	this.attributeid = attributeid;
}
}
