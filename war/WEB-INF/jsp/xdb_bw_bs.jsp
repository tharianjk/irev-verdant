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
       	   <input type="radio" id="bm" value="bm" name="optdb" >Beam Max &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="0d" value="0d" name="optdb" >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="90d" value="90d" name="optdb" >90 &deg; &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="all" value="0d90d" name="optdb" checked >All &nbsp; &nbsp;&nbsp;
	  
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
		
		if(document.getElementById('all').checked){
			deg='0d90d';
		}
		else if(document.getElementById('0d').checked)
			deg='0d';
		else if(document.getElementById('90d').checked)
			deg='90d';	
		else if(document.getElementById('bm').checked)
			{
			deg='bm';
			}
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