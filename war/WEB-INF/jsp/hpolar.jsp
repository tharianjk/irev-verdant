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
          &nbsp; &nbsp;&nbsp;  <input type="checkbox" id="hdata" value="h" checked >HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata"  >VP Data  &nbsp; &nbsp;&nbsp;<td>
       
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
		var testid=${model.testid};
		
		var url="/birt-viewer/frameset?__report=HdataVerdant_report.rptdesign&freq="+freqid+"&testid="+testid+"&max="+max+"&min="+min;
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		//alert("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>