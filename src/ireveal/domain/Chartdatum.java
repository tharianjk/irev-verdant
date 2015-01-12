package ireveal.domain;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Generated;

import org.codehaus.jackson.annotate.JsonAnyGetter;
import org.codehaus.jackson.annotate.JsonAnySetter;
import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.annotate.JsonProperty;
import org.codehaus.jackson.annotate.JsonPropertyOrder;
import org.codehaus.jackson.map.annotate.JsonSerialize;

@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
@Generated("org.jsonschema2pojo")
@JsonPropertyOrder({
"Alert_Prd",
"Alert_Type",
"Alert_Cnt"
})
public class Chartdatum {
int alerttypeid;
Date logdt;
	
public int getAlerttypeid() {
	return alerttypeid;
}

public void setAlerttypeid(int alerttypeid) {
	this.alerttypeid = alerttypeid;
}

public Date getLogdt() {
	return logdt;
}

public void setLogdt(Date logdt) {
	this.logdt = logdt;
}

@JsonProperty("Alert_Prd")
private String alertPrd;
@JsonProperty("Alert_Type")
private String alertType;
@JsonProperty("Alert_Cnt")
private Integer alertCnt;

@JsonIgnore
private Map<String, Object> additionalProperties = new HashMap<String, Object>();

@JsonProperty("Alert_Prd")
public String getAlertPrd() {
return alertPrd;
}

@JsonProperty("Alert_Prd")
public void setAlertPrd(String alertPrd) {
this.alertPrd = alertPrd;
}

@JsonProperty("Alert_Type")
public String getAlertType() {
return alertType;
}

@JsonProperty("Alert_Type")
public void setAlertType(String alertType) {
this.alertType = alertType;
}

@JsonProperty("Alert_Cnt")
public int getAlertCnt() {
return alertCnt;
}

@JsonProperty("Alert_Cnt")
public void setAlertCnt(int alertCnt) {
this.alertCnt = alertCnt;
}

@JsonAnyGetter
public Map<String, Object> getAdditionalProperties() {
return this.additionalProperties;
}

@JsonAnySetter
public void setAdditionalProperty(String name, Object value) {
this.additionalProperties.put(name, value);
}

}