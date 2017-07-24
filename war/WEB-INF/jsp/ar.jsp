<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Axial Ratio</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>
<body>
<table>
 <tr>
		<td><input type="checkbox" id="showtitle" value="true" checked >Show Header & Footer &nbsp; &nbsp;&nbsp;	   </td>
       <td>
       	  <label>Select Max Diff Option : </label>
			   <input type="checkbox" id="p45" value="p45" checked >0 to +45 &#176; &nbsp; &nbsp;&nbsp;	   
		       <input type="checkbox" id="n45" value="n45" checked >0 to -45 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="p30" value="p30" checked >0 to +30 &#176; &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="n30" value="p30" checked >0 to +30 &#176; &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="p60" value="p60" checked >0 to +60 &#176; &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="n60" value="p60" checked >0 to +60 &#176; &nbsp; &nbsp;&nbsp;
          </td>
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
		var deg='x' ;	
		var nprecision=1;
		var testid=${model.testid};
		var rptheader='${model.rptheader}';
		var rptfooter='${model.rptfooter}';
		if(document.getElementById("showtitle").checked){
		 rptheader='header';
		 rptfooter='footer';
		}
		var typ='${model.typ}';
		nprecision='${model.nprecision}';
		if(document.getElementById("p45").checked)
			{deg='p';}
		if(document.getElementById("n45").checked)
		{
			if(deg=="" || deg==null){deg='n';}			
		else deg='b';
			}
		
				var url="/birt-viewer/frameset?__report=verdant/AxialRation_report.rptdesign&deg="+deg+"&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>