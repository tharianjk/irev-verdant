package ireveal.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
"JsonSlnos"
})
public class JsonSerials {

@JsonProperty("JsonSlnos")
private List<JsonSlno> JsonSlnos = new ArrayList<JsonSlno>();
@JsonIgnore
private Map<String, Object> additionalProperties = new HashMap<String, Object>();

/**
*
* @return
* The JsonSlnos
*/
@JsonProperty("JsonSlnos")
public List<JsonSlno> getJsonSlnos() {
return JsonSlnos;
}

/**
*
* @param JsonSlnos
* The JsonSlnos
*/
@JsonProperty("JsonSlnos")
public void setJsonSlnos(List<JsonSlno> JsonSlnos) {
this.JsonSlnos = JsonSlnos;
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