package ireveal.domain;

public class Operator {

 
    private String opesymbol;
    private String opevalue;
	
 

	public Operator(String opesymbol,  String opevalue) {
        this.opesymbol = opesymbol;        
        this.opevalue = opevalue;
    }



	public String getOpesymbol() {
		return opesymbol;
	}



	public void setOpesymbol(String opesymbol) {
		this.opesymbol = opesymbol;
	}



	public String getOpevalue() {
		return opevalue;
	}



	public void setOpevalue(String opevalue) {
		this.opevalue = opevalue;
	}
    

  

}