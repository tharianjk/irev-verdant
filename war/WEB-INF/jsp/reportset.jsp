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
	    <tr><td><input type="checkbox" id="polar" value="p"  onchange='setVisible("p");' >Polar</td>	 
	    <td><table id ='ptab' style="visibility:hidden;">
	    <c:set var="cnt" value="1"/>
	    <tbody><tr><td><c:forEach items="${model.freqlist}" var="freq">			
				
				<c:if test="${ cnt < 7}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency} 
				</c:if>
				<c:if test="${ cnt == 6 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 6 && cnt<19}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency}  
				</c:if>
				<c:if test="${ cnt == 12 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 12}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency}  
				</c:if>
				
			</c:forEach></td></tr></tbody>
	    
	    </table>  
        <tr><td><input type="checkbox" id="3db" value="3db"  onchange='setVisible("3db");'>3db BeamWidth and Beam Squint </td>
        		<td>
		        <table id="3dbtab" style="visibility:hidden;">
		         <tr><td>       	  
			   <input type="checkbox" id="3bm" value="bm" style="visibility:hidden;" > &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="30d" value="0d" checked >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="390d" value="90d" checked >90 &deg; &nbsp; &nbsp;&nbsp;
		          </td></tr>
			    </table></td></tr>
        <tr><td><input type="checkbox" id="10db" value="10db" onchange='setVisible("10db");' >10db BeamWidth and Back-lobe level </td>
        <td><table id="10dbtab" style="visibility:hidden;">
        <tr><td>       	  
			   <input type="checkbox" id="bm" value="bm" style="visibility:hidden;" > &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="0d" value="0d" checked >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="90d" value="90d" checked >90 &deg; &nbsp; &nbsp;&nbsp;
		          </td></tr>
	    </table></td></tr>   
        <tr><td><input type="checkbox" id="ar" value="ar"  onchange='setVisible("ar");'>Axial Ratio </td>
        <td><table id="artab" style="visibility:hidden;">
        <tr><td>
         <input type="checkbox" id="p45" value="p45" checked >0 to +45 &#176; &nbsp; &nbsp;&nbsp;
         <input type="checkbox" id="n45" value="n45" checked >0 to -45 &#176;  &nbsp; &nbsp;&nbsp;</td></tr>
	    </table></td></tr>    
        <tr><td><input type="checkbox" id="cpg" value="cpg" checked >CP Gain </td></tr>
        <tr><td><input type="checkbox" id="blobe" value="blobe" checked >Back-Lobe Level </td></tr>
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
	function setVisible(typ)
	{
		if(typ=="p"){
			if(document.getElementById("polar").checked)
				{
				document.getElementById("ptab").style.visibility="visible";
				}
			else
				document.getElementById("ptab").style.visibility="hidden";
		}
		if(typ=="ar"){
			if(document.getElementById("ar").checked)
				{
				document.getElementById("artab").style.visibility="visible";
				}
			else
				document.getElementById("artab").style.visibility="hidden";
		}
		if(typ=="3db"){
			if(document.getElementById("3db").checked)
				{
				document.getElementById("3dbtab").style.visibility="visible";
				}
			else
				document.getElementById("3dbtab").style.visibility="hidden";
			}
		if(typ=="10db"){
						if(document.getElementById("10db").checked)
							{
							document.getElementById("10dbtab").style.visibility="visible";
							}
						else
							document.getElementById("10dbtab").style.visibility="hidden";
		}
	}
	function Redirect(){
		 var axr="no";
		 var cpg="no";
		 var blobe="no";
		 var db="no";
		 var dbv="no";
		 var polar="no";
		 var AxDeg ;
		 var dbDegv ;
		 var dbDeg ;
		var testid=${model.testid};
		var typ='${model.typ}';
		var strfreqs=[20]; 
		var freqs=[];
		var i=0;
		var j=0;
		var fre= '${model.strfreqs}';
		freqs=fre.split(",");
		if(document.getElementById('polar').checked){
			polar="yes";
		for (i==0;i<freqs.length;i++){
			if(document.getElementById(freqs[i]).checked){
			strfreqs[j]=freqs[i];
			j=j+1;}
		}}
		if(document.getElementById('3db').checked){
			db="yes";
			if(document.getElementById('30d').checked && document.getElementById('390d').checked){
				dbDeg='0d90d';
			}
			else if(document.getElementById('30d').checked)
				dbDeg='0d';
			else if(document.getElementById('390d').checked)
				dbDeg='90d';			
		}
		if(document.getElementById('10db').checked){
			dbv="yes";
			if(document.getElementById('0d').checked && document.getElementById('90d').checked){
				dbDegv='0d90d';
			}
			else if(document.getElementById('0d').checked)
				dbDegv='0d';
			else if(document.getElementById('90d').checked)
				dbDegv='90d';			
		}
		if(document.getElementById('ar').checked){
			axr="yes";
			if(document.getElementById('p45').checked && document.getElementById('n45').checked){
				AxDeg='b';
			}
			else if(document.getElementById('p45').checked)
				AxDeg='p';
			else if(document.getElementById('n45').checked)
				AxDeg='n';			
		}
		if(document.getElementById('cpg').checked){
			cpg="yes";
		}
		if(document.getElementById('blobe').checked){
			blobe="yes";
		}
				var url="/birt-verdant/frameset?__report=CPReportset.rptdesign&testid="+testid+"&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+
						"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
						"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
						"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9];
						
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>