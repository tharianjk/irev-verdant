package ireveal.domain;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class TestData {
private int testid;
private Date dttestdate;
private String strtestdate;
private String testname;
private String testdesc;
private MultipartFile[] filename; 
private String originalfilename;
private String strjsonfreq;
private int productserialid;
private String productserial;
private String filetype;
private String frequnit;
private String ptype;
private String testcenter;
private String instruments;
private String calibration;
private String testproc;


public String getTestproc() {
	return testproc;
}
public void setTestproc(String testproc) {
	this.testproc = testproc;
}
public String getTestcenter() {
	return testcenter;
}
public void setTestcenter(String testcenter) {
	this.testcenter = testcenter;
}
public String getInstruments() {
	return instruments;
}
public void setInstruments(String instruments) {
	this.instruments = instruments;
}
public String getCalibration() {
	return calibration;
}
public void setCalibration(String calibration) {
	this.calibration = calibration;
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
public Date getDttestdate() {
	return dttestdate;
}
public void setDttestdate(Date dttestdate) {
	this.dttestdate = dttestdate;
}
public String getStrtestdate() {
	return strtestdate;
}
public void setStrtestdate(String strtestdate) {
	this.strtestdate = strtestdate;
}
public String getTestname() {
	return testname;
}
public void setTestname(String testname) {
	this.testname = testname;
}
public String getTestdesc() {
	return testdesc;
}
public void setTestdesc(String testdesc) {
	this.testdesc = testdesc;
}

public MultipartFile[] getFilename() {
	return filename;
}
public void setFilename(MultipartFile[] filename) {
	this.filename = filename;
}
public String getOriginalfilename() {
	return originalfilename;
}
public void setOriginalfilename(String originalfilename) {
	this.originalfilename = originalfilename;
}

}
