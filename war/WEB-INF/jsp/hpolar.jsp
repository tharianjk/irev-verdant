<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Polar Graph</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>
<body>
<table>
 <tr>
		<td > Frequency : </td>
       <td width="50">
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
          &nbsp; &nbsp;&nbsp;  <input type="checkbox" id="hdata" value="h" >HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata"  >VP Data  &nbsp; &nbsp;&nbsp;<td>
       <td>Linear Gain:<input type="test" id="lg" > </td>
       </div>
       </td>
       </tr>
       <tr>
       <td >&nbsp; &nbsp;&nbsp; Max. Amplitude : </td>
       <td ><input id="max" value="-40">
       <td >&nbsp; &nbsp;&nbsp; Min. Amplitude : </td>
       <td ><input id="min"  value="-70">
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	<!-- &nbsp; &nbsp;&nbsp;<input type="button" value="back" name="go" class="myButtonGo" onclick="back()"/> -->
		</td>
		</tr>
</table>

<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>

</body>



<script type="text/javascript">
var typ="${model.atype}";

$(document).ready(function(){
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
		//alert("go clicked");
		var freqid =document.getElementById("freqid").value;	
		var max =document.getElementById("max").value;
		var min =document.getElementById("min").value;
		var lg=document.getElementById("lg").value;
		if(lg=="" || lg==null || lg=="null")
			lg=0;
		var testid='${model.testid}';
		if((document.getElementById("hdata").checked) && (document.getElementById("vdata").checked))
		{
		typ="B";
		}
		else if (document.getElementById("hdata").checked)
		{typ="H";}
		else if (document.getElementById("vdata").checked)
			{typ="V";}

		var url="/birt-verdant/frameset?__report=PolarGeneric.rptdesign&type="+typ+"&freq="+freqid+"&testid="+testid+"&max="+max+"&min="+min+"&lg="+lg;
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		if(typ=="B")
			var url="/birt-verdant/frameset?__report=PolarHPVP.rptdesign&type="+typ+"&freq="+freqid+"&testid="+testid+"&max="+max+"&min="+min+"&lg="+lg;
			console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>