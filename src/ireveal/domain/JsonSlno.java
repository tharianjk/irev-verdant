package ireveal.domain;

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
"serialid",
"serialno"
})
public class JsonSlno {

@JsonProperty("serialid")
private String serialid;
@JsonProperty("serialno")
private String serialno;
@JsonIgnore
private Map<String, Object> additionalProperties = new HashMap<String, Object>();

/**
*
* @return
* The serialid
*/
@JsonProperty("serialid")
public String getSerialid() {
return serialid;
}

/**
*
* @param serialid
* The serialid
*/
@JsonProperty("serialid")
public void setSerialid(String serialid) {
this.serialid = serialid;
}

/**
*
* @return
* The serialno
*/
@JsonProperty("serialno")
public String getSerialno() {
return serialno;
}

/**
*
* @param serialno
* The serialno
*/
@JsonProperty("serialno")
public void setSerialno(String serialno) {
this.serialno = serialno;
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