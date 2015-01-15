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
        <tr><td><input type="checkbox" id="3db" value="3db" checked >3db BeamWidth and Beam Squint </td></tr>
        <tr><td><input type="checkbox" id="10db" value="10db"  >10db BeamWidth and Backlobe level </td></tr>
        <tr><td><input type="checkbox" id="ar" value="ar" checked >Axial Ratio </td></tr>      
</table>
</td>
<td>&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;</td>
<td>
<table>
 <tr>
	
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
		//var freqid =document.getElementById("freqid").value;	
		var testid=${model.testid};
		var typ='${model.typ}';
		var strfreqs=[20]; 
		var freqs=[];
		var i=0;
		var fre= '${model.strfreqs}';
		freqs=fre.split(",");
		for (i==0;i<freqs.length;i++){
			strfreqs[i]=freqs[i];
		}
				var url="/birt-viewer/frameset?__report=verdantreportset.rptdesign&testid="+testid+"&freq1="+strfreqs[0]+
						"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
						"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9];
						
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		alert("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>