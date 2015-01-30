<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Report Set</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />

<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/hint-textbox.js"></script>

<style>
INPUT.hintTextbox { color: #888; } 
INPUT.hintTextboxActive { color: #000; }
</style>

</head>
<body>


<table>
<tr><td> 
<table >
<tr><td><label><b>---Select Report---</b></label></td></tr>
	    <tr><td><div id="lpp"><input type="checkbox" id="pp" value="p"  onchange='setVisible("p");' >Polar</div></td>	 
	    <td><table id ='ptab' style="display:none;">
	    <c:set var="cnt" value="1"/>
	    <tbody><tr><td><c:forEach items="${model.freqlist}" var="freq">			
				
				<c:if test="${ cnt < 7}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency}
					 &nbsp;<input type="text" name="lgid"  id='lg-${freq.frequencyid}' class="hintTextbox" style="width:50;"  value="l-gain"/> 
				</c:if>
				<c:if test="${ cnt == 6 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 6 && cnt<19}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency}
					 &nbsp;<input type="text" name="lgid"  id='lg-${freq.frequencyid}' class="hintTextbox" style="width:50;" value="l-gain"/>  
				</c:if>
				<c:if test="${ cnt == 12 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 12}">
					<c:set var="cnt" value="${cnt + 1 }"/>
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequencyid}" id="${freq.frequencyid}" class="chkfreq">${freq.frequency}
					&nbsp;<input type="text" name="lgid"  id='lg-${freq.frequencyid}' class="hintTextbox" style="width:50;" value="l-gain"/>  
				</c:if>
				
			</c:forEach></td></tr>
			<tr>
	       
	       <td><div id="divimg">&nbsp; &nbsp;&nbsp;<input type="checkbox" id="img" value="img" >Show Aircraft Image</div></td>
			</tr>
			</tbody>
	    
	    </table>  </td></tr>
        <tr><td><div id="l3db"><input type="checkbox" id="3db" value="3db" onchange='setVisible("3db");'>3db BeamWidth and Beam Squint</div> </td>
        		<td>
		        <table id="3dbtab" style="display:none;">
		         <tr><td>       	  
			   <input type="checkbox" id="3bm" value="bm" style="display:none;" > &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="30d" value="0d" checked >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="390d" value="90d" checked >90 &deg; &nbsp; &nbsp;&nbsp;
		          </td></tr>
			    </table></td></tr>
        <tr><td><div id="l10db"><input type="checkbox" id="10db" value="10db" onchange='setVisible("10db");' >10db BeamWidth and Back-lobe level</div> </td>
        <td><table id="10dbtab" style="display:none;">
        <tr><td>       	  
			   <input type="checkbox" id="bm" value="bm" style="display:none;" > &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="0d" value="0d" checked >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="checkbox" id="90d" value="90d" checked >90 &deg; &nbsp; &nbsp;&nbsp;
		          </td></tr>
	    </table></td></tr>   
        <tr><td><div id="lar"><input type="checkbox" id="ar" value="ar"  onchange='setVisible("ar");'>Axial Ratio</div> </td>
        <td><table id="artab" style="display:none;">
        <tr><td>
         <input type="checkbox" id="p45" value="p45" checked >0 to +45 &#176; &nbsp; &nbsp;&nbsp;
         <input type="checkbox" id="n45" value="n45" checked >0 to -45 &#176;  &nbsp; &nbsp;&nbsp;</td></tr>
	    </table></td></tr>    
        <tr><td><div id="lcpg"><input type="checkbox" id="cpg" value="cpg"  >CP Gain</div> </td></tr>
        <tr><td><div id="lblobe"><input type="checkbox" id="blobe" value="blobe"  >Back-Lobe Level</div> </td></tr>
        <tr><td><div id="lod"><input type="checkbox" id="od" value="od"  >Omni Deviation</div> </td></tr>
</table>
</td>
</tr>
<tr>

<td>
<table>
 <tr>
	
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	
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
var atype=parent.AssetTree.atype;
var ptype=parent.AssetTree.selectedparenttype;
$(document).ready( function () {

console.log("atype="+atype+" ptype="+ptype);
if ((atype=="A") )
	{
	  
	  document.getElementById("lod").style.display="block";
  	  
  	  document.getElementById("lar").style.display="none";
  	  
  	  document.getElementById("lpp").style.display="block";
  	  
  	  document.getElementById("l3db").style.display="none";
  	  
  	  document.getElementById("l10db").style.display="none";
  	  
  	  document.getElementById("lcpg").style.display="none";
  	  
  	  document.getElementById("lblobe").style.display="none";
	}
else if ((atype=="E") && (ptype == "L"))
{
      
      document.getElementById("lod").style.display="none";
	  
	  document.getElementById("lar").style.display="none";
	  
	  document.getElementById("lpp").style.display="block";
	  
	  document.getElementById("l3db").style.display="block";
	  
	  document.getElementById("l10db").style.display="block";
	  
	  document.getElementById("lcpg").style.display="none";
	  
	  document.getElementById("lblobe").style.display="none";
}
else if ((atype=="E") && (ptype == 'S'))
{
  
      document.getElementById("lod").style.display="none";
	  
	  document.getElementById("lar").style.display="block";
	  
	  document.getElementById("lpp").style.display="block";
	  
	  document.getElementById("l3db").style.display="block";
	  
	  document.getElementById("l10db").style.display="block";
	  
	  document.getElementById("lcpg").style.display="none";
	 
	 document.getElementById("lblobe").style.display="block";
}
else if(atype=="CP")
{
 
  
  document.getElementById("lod").style.display="none";
  
  document.getElementById("lar").style.display="block";
  
  document.getElementById("lpp").style.display="block";
  
  document.getElementById("l3db").style.display="block";
  
  document.getElementById("l10db").style.display="block";
  
  document.getElementById("lcpg").style.display="block";
  
  document.getElementById("lblobe").style.display="block";
  
}
else if(atype=="DCP")
{
 
  
  document.getElementById("lod").style.display="none";
  
  document.getElementById("lar").style.display="none";
  
  document.getElementById("lpp").style.display="block";
  
  document.getElementById("l3db").style.display="block";
  
  document.getElementById("l10db").style.display="block";
  
  document.getElementById("lcpg").style.display="block";
  
  document.getElementById("lblobe").style.display="block";
}
else if(atype=="NCP")
{			        	 
  
  document.getElementById("lod").style.display="none";
  
  document.getElementById("lar").style.display="block";
  
  document.getElementById("lpp").style.display="block";
  
  document.getElementById("l3db").style.display="block";
  
  document.getElementById("l10db").style.display="block";
  
  document.getElementById("lcpg").style.display="none";
  
  document.getElementById("lblobe").style.display="block";
}


});

	function setVisible(typ)
	{
		// console.log("atype="+atype);
		if(typ=="p"){
			if(document.getElementById("pp").checked)
				{
				document.getElementById("ptab").style.display="block";
				if(atype!="A" && atype!="CP")
					{
					var inputs = document.getElementsByName('lgid');
				//  inputs = inputs.concat(document.getElementsByTagName('textarea'));
				  // console.log("len " +inputs.length);
				  for (i=0; i<inputs.length; i++) {
				    var input = inputs[i];
				    var lgid=input.id;
				    //console.log("id " +input.id);
				    document.getElementById(lgid).style.visibility="hidden";
					}
				}
				}
			else
				document.getElementById("ptab").style.display="none";
		}
		if(typ=="ar"){
			if(document.getElementById("ar").checked)
				{
				document.getElementById("artab").style.display="block";
				}
			else
				document.getElementById("artab").style.display="none";
		}
		if(typ=="3db"){
			if(document.getElementById("3db").checked)
				{
				document.getElementById("3dbtab").style.display="block";
				}
			else
				document.getElementById("3dbtab").style.display="none";
			}
		if(typ=="10db"){
						if(document.getElementById("10db").checked)
							{
							document.getElementById("10dbtab").style.display="block";
							}
						else
							document.getElementById("10dbtab").style.display="none";
		}
	}
	function Redirect(){
		var img="no";
		//alert("go clicked");
		var scale="yes";
		
		 var axr="no";
		 var cpg="no";
		 var blobe="no";
		 var db="no";
		 var dbv="no";
		 var polar="no";
		 var od="no";
		 var AxDeg ;
		 var dbDegv ;
		 var dbDeg ;
		var testid=${model.testid};
		var typ='${model.type}';
		var strfreqs=[20]; 
		var freqs=[];
		var i=0;
		var j=0;
		var fre= '${model.strfreqs}';
		freqs=fre.split(",");
		var rptheader='${model.rptheader}';
		var rptfooter='${model.rptfooter}';
		
		//var max =document.getElementById("max").value;
		//var min =document.getElementById("min").value;
		
		
		
		if(document.getElementById('pp').checked){
			polar="yes";
			var freqsel=0;
		for (i==0;i<freqs.length;i++){
			if(document.getElementById(freqs[i]).checked){
				strfreqs[j]=freqs[i];
				freqsel=1;
				j=j+1;
				}	
			}
			console.log(strfreqs[0]);
			if(freqsel==0)
				{
				alert("Frequency not selected");
				return;
				}
			for (i==j;i<20;i++){				
					strfreqs[j]=-1;					
					j=j+1;				
				}
		}
			
		
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
		if(document.getElementById('od').checked){
			od="yes";
		}
		if(document.getElementById("img").checked)
			img="yes";
		console.log("typ ="+typ);
		
		if(axr=="no" && cpg=="no" && blobe=="no" && db=="no" && dbv=="no" && polar=="no" && od=="no")
		{
			alert("No report Selected !!")
			return;
		}
		
		if(typ=="P"){
			
				var url="/birt-verdant/frameset?__report=ReportSetPitch.rptdesign&testid="+testid+"&type=P&polar="+polar+"&scale=yes&lgain=0"+
						"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
						"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
						"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
		}
		if(typ=="R"){
			
			var url="/birt-verdant/frameset?__report=ReportSetRoll.rptdesign&testid="+testid+"&type=R&polar="+polar+"&scale=yes&lgain=0"+
					"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
					"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
	    }
		else{
			var url="/birt-verdant/frameset?__report=CPReportset.rptdesign&testid="+testid+"&type=C&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+"&scale=yes&lgain=0"+
			"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
			"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
			"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img=no&rpth="+rptheader+"&rptf="+rptfooter;
		
			
		}
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>

</html>