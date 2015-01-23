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
<table>
 <tr>
		<td >Frequency : </td>
       <td >
       <select id="freqid" >          
         <option value="-1">--Select--</option>      
   		 <c:forEach items="${model.freqlist}" var="freq">
   		  <c:choose>
   		 <c:when test="${freq.frequency eq model.freq}">	
            <option value=<c:out value="${freq.frequencyid}" /> selected ><c:out value="${freq.frequency}"/></option>
           </c:when>
	    <c:otherwise>
	       <option value=<c:out value="${freq.frequencyid}" /> ><c:out value="${freq.frequency}"/></option>
	    </c:otherwise>      
		</c:choose>
    	</c:forEach>
		</select>			           
			   
          </td>
          <td>
          <div id="cp">
          
       <input type="checkbox" id="hdata" value="hdata" onclick="fnenable('h');">HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata" onclick="fnenable('v');" >VP Data  &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="cpdata" value="cpdata" onclick="fnenable('c');" >CP Data  &nbsp; &nbsp;&nbsp;
       Linear Gain:<input type="text" id="lg" >
        </div> </td>
      
       </tr>
       </table>
       <table>
       <tr>
       <td > Max. Amplitude : </td>
       <td width="20"><input id="max" value="-40">
       <td > &nbsp; &nbsp;&nbsp;Min. Amplitude : </td>
       <td width="20"><input id="min"  value="-70"></td>
        <td><div id="divimg">&nbsp; &nbsp;&nbsp;<input type="checkbox" id="img" value="img" >Show Aircraft Image</div></td>
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	<!-- &nbsp; &nbsp;&nbsp;<input type="button" value="back" name="go" class="myButtonGo" onclick="back()"/> -->
		</td>
		</tr>
</table>

<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>

<script type="text/javascript">
var typ="${model.atype}";
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
	}
	if(document.getElementById("vdata").checked){
		document.getElementById("cpdata").checked=false;
	}
	}
}

$(document).ready(function(){
	
	console.log("parenttype="+parent.AssetTree.selectedparenttype);
	console.log("atype="+parent.AssetTree.atype);
	if(parent.AssetTree.selectedparenttype=="L")
		document.getElementById("divimg").style.visibility="visible";
	else if(parent.AssetTree.selectedparenttype=="S" && parent.AssetTree.atype=="A")
		document.getElementById("divimg").style.visibility="visible";
	else
		document.getElementById("divimg").style.visibility="hidden";
	
	if(typ=="P" || typ=="R" || typ=="Y")
		{document.getElementById("cp").style.visibility="hidden";}
	else{
		document.getElementById("cp").style.visibility="visible";
		document.getElementById("hdata").checked=true;
	}});

	function back()
	{
		 window.location="/irev-verdant/start.htm";
		// self.close();
	}
	function Redirect(){
		var img="no";
		//alert("go clicked");
		var testid="${model.testid}";
		var freqid =document.getElementById("freqid").value;	
		var max =document.getElementById("max").value;
		var min =document.getElementById("min").value;
		var lg=document.getElementById("lg").value;
		if(lg=="" || lg==null || lg=="null")
			{lg=0;}
		
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
if(document.getElementById("img").checked)
	img="yes";
		
		var url="/birt-viewer/frameset?__report=PolarGeneric.rptdesign&type="+typ+"&freq="+freqid+"&testid="+testid+"&max="+max+"&min="+min+"&lgain="+lg+"&img="+img;
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		if(typ=="B")
			var url="/birt-viewer/frameset?__report=PolarHPVP.rptdesign&type="+typ+"&freq="+freqid+"&testid="+testid+"&max="+max+"&min="+min+"&lgain="+lg+"&img="+img;
			console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>
</body>
</html>