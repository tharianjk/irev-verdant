package ireveal.domain;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class ImportData {

private MultipartFile filename; 
private String originalfilename;
private int productserialid;
private String productserial;
private String filetype;
private String frequnit;
private String ptype;
public MultipartFile getFilename() {
	return filename;
}
public void setFilename(MultipartFile filename) {
	this.filename = filename;
}
public String getOriginalfilename() {
	return originalfilename;
}
public void setOriginalfilename(String originalfilename) {
	this.originalfilename = originalfilename;
}
public int getProductserialid() {
	return productserialid;
}
public void setProductserialid(int productserialid) {
	this.productserialid = productserialid;
}
public String getProductserial() {
	return productserial;
}
public void setProductserial(String productserial) {
	this.productserial = productserial;
}
public String getFiletype() {
	return filetype;
}
public void setFiletype(String filetype) {
	this.filetype = filetype;
}
public String getFrequnit() {
	return frequnit;
}
public void setFrequnit(String frequnit) {
	this.frequnit = frequnit;
}
public String getPtype() {
	return ptype;
}
public void setPtype(String ptype) {
	this.ptype = ptype;
}
}
