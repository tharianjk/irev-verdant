package ireveal.domain;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class PVSerialData {
private int testid;
private String testname;
private MultipartFile filename; 
private String originalfilename;
private String strjsonfreq;
private int productserialid;
private String productserial;
private String filetype;
private String frequnit;
private String ptype;
private String testtype;
private String datatype;
private int calccnt;


public int getCalccnt() {
	return calccnt;
}

public void setCalccnt(int calccnt) {
	this.calccnt = calccnt;
}

public String getDatatype() {
	return datatype;
}

public void setDatatype(String datatype) {
	this.datatype = datatype;
}

public String getTesttype() {
	return testtype;
}

public void setTesttype(String testtype) {
	this.testtype = testtype;
}
private List<MultipartFile> uploadedfiles;

public List<MultipartFile> getFiles() {
    return uploadedfiles;
}

public void setFiles(List<MultipartFile> files) {
    this.uploadedfiles = files;
}


public String getPtype() {
	return ptype;
}
public void setPtype(String ptype) {
	this.ptype = ptype;
}
public String getFrequnit() {
	return frequnit;
}
public void setFrequnit(String frequnit) {
	this.frequnit = frequnit;
}
public String getFiletype() {
	return filetype;
}
public void setFiletype(String filetype) {
	this.filetype = filetype;
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
public String getStrjsonfreq() {
	return strjsonfreq;
}
public void setStrjsonfreq(String strjsonfreq) {
	this.strjsonfreq = strjsonfreq;
}

public int getTestid() {
	return testid;
}
public void setTestid(int testid) {
	this.testid = testid;
}

public String getTestname() {
	return testname;
}
public void setTestname(String testname) {
	this.testname = testname;
}

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

}
