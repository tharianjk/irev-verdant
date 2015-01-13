<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Report Set</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>
<body>


<table>
<tr><td> 
<table >
<tr><td><label><b>---Select Report---</b></label></td></tr>
	    <tr><td><input type="checkbox" id="polar" value="p" checked >Polar</td></tr>
        <tr><td><input type="checkbox" id="3db" value="3db" checked >3db Beam With With Beam Squint </td></tr>
        <tr><td><input type="checkbox" id="10db" value="10db" checked >10db Beam With With Beam Squint </td></tr>
        <tr><td><input type="checkbox" id="ar" value="ar" checked >Axial Ratio </td></tr>      
</table>
</td>
<td>&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;</td>
<td>
<table>
 <tr>
		<td > Frequency : </td>
       <td width="50">
       <select id="freqid" >          
         <option value="-1">--Select--</option>      
   		 <c:forEach items="${model.freqlist}" var="freq">
   		  <c:choose>
   		 <c:when test="${freq.frequency eq model.freq}">	
            <option value=<c:out value="${freq.frequency}" /> selected ><c:out value="${freq.frequency}"/></option>
           </c:when>
	    <c:otherwise>
	       <option value=<c:out value="${freq.frequency}" /> ><c:out value="${freq.frequency}"/></option>
	    </c:otherwise>      
		</c:choose>
    	</c:forEach>
		</select>			           
			   
          </td>
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	<!-- &nbsp; &nbsp;&nbsp;<input type="button" value="back" name="go" class="myButtonGo" onclick="back()"/> -->
		</td>
		</tr>
</table>
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
		var testid=${model.testid};
		var typ='${model.typ}';
		if(document.getElementById("p45").checked)
			{deg='p';}
		if(document.getElementById("n45").checked)
		{
			if(deg=="" || deg==null){deg='n';}
		else deg='b';}
		
				var url="/birt-viewer/frameset?__report=verdantreportset.rptdesign&freq="+freqid+"&testid="+testid;
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		//alert("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>