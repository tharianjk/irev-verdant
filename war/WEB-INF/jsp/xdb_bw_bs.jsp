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
       	  
	   <input type="checkbox" id="bm" value="bm" style="visibility:hidden;" >Beam Max &nbsp; &nbsp;&nbsp;
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
		var deg ;	
		var testid=${model.testid};
		var typ='${model.typ}';
		var atype='${model.atype}';
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
			//3dbWithCP_report.rptdesign
			var url="";
			if(typ=='3db' ){
				if(atyp=='E' || atyp=='E'){ //Elevation or Azumith
		         url="/birt-verdant/frameset?__report=3db_report.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
				else{
				 url="/birt-verdant/frameset?__report=3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
			}
			if(typ=='10db' ){
				if(atyp=='E' || atyp=='E'){ //Elevation or Azumith
		         url="/birt-verdant/frameset?__report=10db_report.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
				else{
				 url="/birt-verdant/frameset?__report=10dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
			}
			if(typ=='blobe' ){
				if(atyp=='NCP' ){ //with out cp
		         url="/birt-verdant/frameset?__report=BlobWithOutCP.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
				else{
				 url="/birt-verdant/frameset?__report=BlobWithCP.rptdesign&deg="+deg+"&testid="+testid+"&atype="+atype;}
			}
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>