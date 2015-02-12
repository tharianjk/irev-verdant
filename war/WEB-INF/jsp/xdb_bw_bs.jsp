<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>X-db Beam Width and Beam Squint</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>
<body>
<table>
 <tr>
		
       <td>
       	  
	   <input type="checkbox" id="bm" value="bm" checked >Beam Max &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="0d" value="0d" checked >0 &#176;  &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="90d" value="90d" checked >90 &deg; &nbsp; &nbsp;&nbsp;
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
		var nprecision=1;
		var deg ;	
		var testid=${model.testid};
		var typ='${model.typ}';
		var atype='${model.atype}';
		var rptheader='${model.rptheader}';
		var rptfooter='${model.rptfooter}';
		nprecision='${model.nprecision}';
		if(document.getElementById("bm").checked)
			{deg='bm';}
		if(document.getElementById("0d").checked)
		{if(deg=="" || deg==null){deg='0d';}
		else deg='bm0d';}
		
		if(document.getElementById("90d").checked)
		{
			if(deg=="" || deg==null) deg='90d';
		else if (deg=='bm0d') deg='a';
		else if (deg=='0d') deg='0d90d';
		else deg='bm90d';
		}
		if(!document.getElementById("0d").checked && !document.getElementById("90d").checked)
			{deg="bm";}
			//3dbWithCP_report.rptdesign
			var url="";
			if(typ=='3db' ){
				if(atype=='P' || atype=='R' ){ //Elevation (pitch or roll)
		         url="/birt-verdant/frameset?__report=3dbPitchRoll_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
				else if (atype=='NCP' || atype=="E"){
					 url="/birt-verdant/frameset?__report=3db_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
				else{
				 url="/birt-verdant/frameset?__report=3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
			}
			if(typ=='10db' ){
				if(atype=='P' || atype=='R'){ //Elevation or (pitch or roll)
		         url="/birt-verdant/frameset?__report=10dbPitchRoll_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
				else if (atype=='NCP' || atype=="E"){
					 url="/birt-verdant/frameset?__report=10db_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
				else{
				 url="/birt-verdant/frameset?__report=10dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+atype+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;}
			}
			
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>