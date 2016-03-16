<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Polar Graph</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
<link rel="stylesheet" href="css/jquery-ui.css">
		
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
</head>
<body>


<table id="stab">
 <tr>
		<td >Serial No : </td> 			           
	
       <td >
       <select id="serialid" >          
         <option value="-1">--Select--</option>      
   		 <c:forEach items="${model.seriallist}" var="serial">
   		  <c:choose>
   		 <c:when test="${serial.productserialid eq model.productserialid}">	
            <option value=<c:out value="${serial.productserialid}" /> selected ><c:out value="${serial.productserial}"/></option>
           </c:when>
	    <c:otherwise>
	       <option value=<c:out value="${serial.productserialid}" /> ><c:out value="${serial.productserial}"/></option>
	    </c:otherwise>      
		</c:choose>
    	</c:forEach>
		</select>			           
			   
           
          </td>
          </tr>
           </table>
          
          <table id ='mtab' style="display:none">
	    
	    <tbody><tr><td>
	    <c:forEach items="${model.freqlist}" var="freq">			
				<input type="checkbox" name="chkid" value="${freq.frequency}" id="${freq.frequency}" class="chkfreq" checked="checked">${freq.frequency}
				
			</c:forEach></td></tr></tbody>	    
	    </table> 
          
          <table>
          <tr>
          <td>
          <div id="cp">          
       <input type="checkbox" id="hdata" value="hdata" onclick="fnenable('h');">HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata" onclick="fnenable('v');" >VP Data  &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="cpdata" value="cpdata" onclick="fnenable('c');"><label id="lblcp">CP Data </label> &nbsp; &nbsp;&nbsp;       
        </div> </td>
       </tr>
       </table>
       
       
       <table>
       <tr>
       <td > Max.Amplitude: </td>
       <td ><input id="max" value="" class="scale" style="width:50;">
       <td > &nbsp; &nbsp;&nbsp;Min.Amplitude: </td>
       <td ><input id="min"  value="" class="scale" style="width:50;"></td>
        <td > &nbsp; &nbsp;&nbsp;Precision: </td>
        <td><select id="precision" >          
         <option value="-1">--Select--</option>      
   		
            <option value=1 > 1</option>
            <option value=2 > 2</option>
            <option value=3 > 3</option>
            <option value=4 > 4</option>
         
		</select></td>
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	<!-- &nbsp; &nbsp;&nbsp;<input type="button" value="back" name="go" class="myButtonGo" onclick="back()"/> -->
		</td>
		</tr>
</table>

<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>

<script type="text/javascript">
var datatype="${model.typ}";
var rptheader='${model.rptheader}';
var rptfooter='${model.rptfooter}';
var ptype =parent.AssetTree.selectedparenttype;
var atype=parent.AssetTree.atype;
function fnenable(ctyp){
	console.log("checked");
	
		if(ctyp=='c'){
			if(document.getElementById("cpdata").checked){
				document.getElementById("hdata").checked=false;
				document.getElementById("vdata").checked=false;
			}
		    }
			else{
			if(document.getElementById("hdata").checked){
				document.getElementById("cpdata").checked=false;
				document.getElementById("vdata").checked=false;
			}
			if(document.getElementById("vdata").checked){
				document.getElementById("cpdata").checked=false;
				document.getElementById("hdata").checked=false;
			}
			}
	
}

$(document).ready(function(){
	
	console.log("parenttype="+parent.AssetTree.selectedparenttype);
	console.log("atype="+parent.AssetTree.atype);
	
	document.getElementById("precision").value='${model.nprecision}';
	$(".scale").keydown(function (e) {
		
		// Only enter the minus sign (-) if the user enters it first
		 if (e.keyCode == 189 && this.value == "") {
		        return true;
		    }
		
	    // Allow: backspace, delete, tab, escape, enter and .
	    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
	         // Allow: Ctrl+A
	        (e.keyCode == 65 && e.ctrlKey === true) || 
	         // Allow: home, end, left, right
	        (e.keyCode >= 35 && e.keyCode <= 39)) {
	             // let it happen, don't do anything
	             return;
	    }
	    // Ensure that it is a number and stop the keypress
	    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
	    	if(e.keyCode!=189)
	        e.preventDefault();
	    }
	});
	
	
	
	});


	function back()
	{
		 window.location="/irev-verdant/start.htm";
		// self.close();
	}
	function Redirect()
	{
		var img="no";
		//alert("go clicked");
		var nprecision=1;
		var scale="yes";
		var testid="${model.testid}";
		var strfreqs=[]; 
		var freqs=[];
		var lgs=[];
		var multfreqs="";
		var i=0;
		var j=0;
		var fre= '${model.strfreqs}';
		var url="";
		nprecision=document.getElementById("precision").value;	
		var serialid=document.getElementById("serialid").value;	
		var uname='${model.uname}';
		var frequnit='${model.frequnit}';
		var selfreq=0;
		//var freqid =document.getElementById("freqid").value;
		
		
		for (i==1;i<20;i++){
			strfreqs[i]=-1;
		}
		
		var max =document.getElementById("max").value;
		var min =document.getElementById("min").value;
		if(min!=null && min !=""){
			if(max==""|| max==null ){
				alert("Max.Amplitude should be entered");
				return;
			}
			scale="no";
		}
		
		if(max!=null && max !=""){
			if(min==""|| min==null ){
				alert("Min.Amplitude should be entered");
				return;
			}
			scale="no";
		}
		if(scale=="yes")
			{max=0;
			min=0;}
		
		/*if(min<0)
			if(max<0){
			if(Math.abs(max)<Math.abs(min)){
			alert("Max.Amplitude less than Min.Amplitude");
			return;
			}		
		}*/
		
		
		if((document.getElementById("hdata").checked) && (document.getElementById("vdata").checked))
		{
		typ="B";
		}
		else if (document.getElementById("hdata").checked)
		{typ="H";}
		else if (document.getElementById("vdata").checked)
			{typ="V";}
		else if (document.getElementById("cpdata").checked)
		{typ="C";}


	freqs=fre.split(",");
	
	i=0;
	j=0;
			for (i==0;i<freqs.length;i++){	
				console.log("freqs[i]="+freqs[i]);
				if(document.getElementById(freqs[i]).checked){					
					if(j==0){
						selfreq=freqs[i];}
					else{selfreq=selfreq+','+freqs[i];}
					strfreqs[j]=freqs[i];
					
					j=j+1;
					}	
				}
			
				if(selfreq==0)
					{
					alert("Frequencies not selected");
					return;
					}
				
					 url="/birt-viewer/frameset?__report=verdant/RadiationPattern.rptdesign&type="+typ+"&testid="+testid+"&serialid="+serialid+"&vdatatype="+datatype+"&scale="+scale+"&max="+max+"&min="+min+"&rpth="+rptheader+"&rptf="+rptfooter+"&img=yes&freq1="+strfreqs[0]+
					"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&freq11="+strfreqs[10]+"&freq12="+strfreqs[11]+"&freq13="+strfreqs[12]+"&freq14="+strfreqs[13]+"&freq15="+strfreqs[14]+"&freq16="+strfreqs[15]+"&freq17="+strfreqs[16]+"&freq18="+strfreqs[17];
			
		console.log(url);
window.frames['AppBody'].location=url;
	}	
</script>
</body>
</html>