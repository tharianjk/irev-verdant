<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Report Set</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />

<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/hint-textbox.js"></script>
		<link rel="stylesheet" href="css/jquery-ui.css">
		<link rel="stylesheet" href="css/stylePush.css">
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
		<script type='text/javascript' src="js/popupmessage.js" ></script>
        <link rel="stylesheet" href="css/popupmessage.css">


<style>
INPUT.hintTextbox { color: #888; } 
INPUT.hintTextboxActive { color: #000; }
</style>

</head>
<body>
&nbsp; &nbsp;&nbsp;<button  title="Collapse" name="Collapse" class="myButtonGo" onclick="Collapse();"><img src='img/resize.png'/></button>
<div id="SelBody"> 

<table>
	<tr><td><table >
		<tr><td><label><b>---Select Reports---</b></label></td></tr>

        <tr><td><div id="l3db"><input type="checkbox" id="3db" value="3db" onchange='setVisible("3db");'><label id=lbl3db>3db BeamWidth and Beam Squint</label></div> </td>
        		<td>
		        <table id="3dbtab" style="display:none;">
		         <tr><td>       	  
			   <input type="radio" id="3bm" value="bm" name="opt3db" >Beam Max &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="30d" value="0d" name="opt3db" >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="390d" value="90d" name="opt3db" >90 &deg; &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="3all" value="0d90d" name="opt3db" checked >All &nbsp; &nbsp;&nbsp;
		          </td></tr>
			    </table></td></tr>
        <tr><td><div id="l10db"><input type="checkbox" id="10db" value="10db" onchange='setVisible("10db");' ><label id=lbl10db>10db BeamWidth and Back-lobe level</label></div> </td>
        <td><table id="10dbtab" style="display:none;">
        <tr><td>       	  
			   <input type="radio" id="bm" value="bm" name="optdb" >Beam Max &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="0d" value="0d" name="optdb" >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="90d" value="90d" name="optdb" >90 &deg; &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="all" value="0d90d" name="optdb" checked >All &nbsp; &nbsp;&nbsp;
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
	 
	 <tr><td><div id="lpp"><input type="checkbox" id="pp" value="p"  onchange='setVisible("p");' >Polar</div></td>	 
	    <td><table id ='ptab' style="display:none;">
	    <c:set var="cnt" value="1"/>
	    <tbody>
	    <tr>
          <td>
          <div id="cp">          
       <input type="checkbox" id="hdata" value="hdata" onclick="fnenable('h');">HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata" onclick="fnenable('v');" >VP Data  &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="cpdata" value="cpdata" onclick="fnenable('c');"><label id="lblcp">CP Data </label> &nbsp; &nbsp;&nbsp;       
        </div> </td>
       </tr>
	    <tr><td><c:forEach items="${model.freqlist}" var="freq">		
				
				 <input type="checkbox" name="chkid" value="${freq.frequency}" id="${freq.frequency}" class="chkfreq">${freq.frequency}
					 &nbsp;<input type="text" name="lgid"  id='lg-${freq.frequency}'  class="hintTextbox" style="width:50;" maxlength="20"  value="l-gain"/>
				
			<!-- 	<c:if test="${ cnt < 7}">
					
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequency}" id="${freq.frequency}" class="chkfreq">${freq.frequency}
					 &nbsp;<input type="text" name="lgid"  id='lg-${freq.frequency}'  class="hintTextbox" style="width:50;" maxlength="20"  value="l-gain"/>
					 <c:set var="cnt" value="${cnt + 1 }"/> 
				</c:if>
				<c:if test="${ cnt == 6 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 6 && cnt<13}">
					 &nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequency}" id="${freq.frequency}" class="chkfreq">${freq.frequency}
					 &nbsp;<input type="text" name="lgid"  id='lg-${freq.frequency}'  class="hintTextbox" style="width:50;" maxlength="20" value="l-gain"/>
					 <c:set var="cnt" value="${cnt + 1 }"/>  
				</c:if>
				<c:if test="${ cnt == 12 }">
				<br>
				</c:if>
				<c:if test="${ cnt > 12}">
					&nbsp; &nbsp;&nbsp;<input type="checkbox" name="chkid" value="${freq.frequency}" id="${freq.frequency}" class="chkfreq">${freq.frequency}
					&nbsp;<input type="text" name="lgid"  id='lg-${freq.frequency}'  class="hintTextbox" style="width:50;" maxlength="20" value="l-gain"/>
					<c:set var="cnt" value="${cnt + 1 }"/>  
				</c:if> -->
				
			</c:forEach></td></tr>
			<tr>
	       
	       <td><div id="divimg">&nbsp; &nbsp;&nbsp;<input type="checkbox" id="img" value="img" >Show Aircraft Image</div></td>
	       <td>&nbsp; &nbsp;&nbsp;<input type="button" value="Scale" id="btnscale" name="scale" style="display:none;" class="myButtonGo" onclick="scaleclick()"/>
			</tr>
			</tbody>
	    
	    </table>  </td></tr>		
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
</div>
<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>
<div id="dialog-form-scaling" title="Scaling" style="display:none;overflow:hidden;border:none">
    <iframe id="scalingdialog" width="800" height="400" style="border:none" ></iframe>
</div>

</body>



<script type="text/javascript">
var val="Collapse";
function Collapse(){
	console.log("val " +val);
	if(val=="Collapse"){
	document.getElementById("SelBody").style.display="none";
	document.getElementById("SelBody").title="Expand";
	val="Expand";
	}
	else{
		document.getElementById("SelBody").style.display="block";
		//document.getElementById("SelBody").value="Collapse";
		document.getElementById("SelBody").title="Collapse";
		val="Collapse";
	}
}

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
	  document.getElementById("lbl10db").innerHTML="10dB Beamwidth ";
 	  document.getElementById("lbl3db").innerHTML="3dB Beamwidth ";
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
	 document.getElementById("lbl10db").innerHTML="10dB Beamwidth with Beam Squint";
	  document.getElementById("lbl3db").innerHTML="3dB Beamwidth with Beam Squint";
	 
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
  document.getElementById("lbl10db").innerHTML="10dB Beamwidth with Beam Squint";
  document.getElementById("lbl3db").innerHTML="3dB Beamwidth with Beam Squint";
}
$(".hintTextbox").keydown(function (e) 
		{
	
	// Only enter the minus sign (-) if the user enters it first
	 if (e.keyCode == 189 && this.value == "") {
	        return true;
	    }
	
    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
         // Allow: Ctrl+A
        (e.keyCode == 65 && e.ctrlKey === true) || 
         // Allow: home, end, left, right
        (e.keyCode >= 35 && e.keyCode <= 39)) {
             // let it happen, don't do anything
             return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
    	if(e.keyCode!=189)
        e.preventDefault();
    }
});

});

function fnenable(ctyp){
	console.log("checked");
	if(ctyp=='c'){
	if(document.getElementById("cpdata").checked){
		document.getElementById("hdata").checked=false;
		document.getElementById("vdata").checked=false;
	}
}
	else{
	if(document.getElementById("hdata").checked){
		document.getElementById("cpdata").checked=false;
		//document.getElementById("vdata").checked=false;
	}
	if(document.getElementById("vdata").checked){
		document.getElementById("cpdata").checked=false;
		//document.getElementById("hdata").checked=false;
	}
	}
}


	function setVisible(typ)
	{
		// console.log("atype="+atype);
		if(typ=="p"){
			if(document.getElementById("pp").checked)
				{
				document.getElementById("ptab").style.display="block";
				if(parent.AssetTree.selectedparenttype=="L")
					document.getElementById("divimg").style.display="block";
				else if(parent.AssetTree.selectedparenttype=="S" && parent.AssetTree.atype=="A")
					document.getElementById("divimg").style.display="block";
				else
					document.getElementById("divimg").style.display="none";
				if(ptype=="S" || ptype=="C")
					{
					document.getElementById("cp").style.display="block";
					if(ptype=="S" || atype=="NCP"){
						document.getElementById("cpdata").style.visibility="hidden";
						document.getElementById("lblcp").style.visibility="hidden";
					}						
					}
				else
					{
					document.getElementById("cp").style.display="none";
					}
				
				if(atype!="A" && atype!="CP")
					{
					var inputs = document.getElementsByName('lgid');
				//  inputs = inputs.concat(document.getElementsByTagName('textarea'));
				  // console.log("len " +inputs.length);
				  for (i=0; i<inputs.length; i++) {
				    var input = inputs[i];
				    var lgid=input.id;
				    //console.log("id " +input.id);
				    document.getElementById(lgid).style.display="none";
					}
				}
				document.getElementById("btnscale").style.display="block";
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
		var nprecision=parent.precision;
		 var axr="no";
		 var cpg="no";
		 var blobe="no";
		 var db="no";
		 var dbv="no";
		 var polar="no";
		 var od="no";
		 var AxDeg="x" ;
		 var dbDegv="0d90d" ;
		 var dbDeg="0d90d";
		var testid=${model.testid};
		var typ='${model.type}';
		var strfreqs=[20]; 
		var freqs=[];
		var lg=[];
		var i=0;
		var j=0;
		var fre= '${model.strfreqs}';
		freqs=fre.split(",");
		var rptheader='${model.rptheader}';
		var rptfooter='${model.rptfooter}';
		nprecision='${model.nprecision}';
		var dtype="B";
		//var max =document.getElementById("max").value;
		//var min =document.getElementById("min").value;
		
		var freqsel=0;
		
		if(document.getElementById('pp').checked){
			polar="yes";
			
		for (i==0;i<freqs.length;i++){
			if(document.getElementById(freqs[i]).checked){
				strfreqs[j]=freqs[i];
				lg[j]="0.0001";
				if(atype=="A" || atype=="CP")
				{
				if(document.getElementById('lg-'+freqs[i]).value!="l-gain" && document.getElementById('lg-'+freqs[i]).value!=null && document.getElementById('lg-'+freqs[i]).value!="")
					{
					lg[j]=document.getElementById('lg-'+freqs[i]).value;
					}				
				}
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
			var p=0;
			for (p==j;p<20;p++){
				// console.log("j"+j);
					strfreqs[j]=-1;	
					lg[j]="0.0001";
					j=j+1;				
				}
			
			var chk="N"
			if(document.getElementById("cpdata").checked){
				dtype="C";
				chk="Y";}
			if(document.getElementById("hdata").checked){
				dtype="H";
				chk="Y";}
			if(document.getElementById("vdata").checked){
				dtype="V";
				chk="Y";}
			if(document.getElementById("vdata").checked && document.getElementById("hdata").checked){
				dtype="B";
				chk="Y";
	        }
			if(atype=="DCP")
				{
				chk="Y";
				}
			if(chk=="N" && ptype!="L")
			{
				alert ("Polarization type not selected ");
				return;
			}
		}
		if(freqsel==0)	{
			for (i==0;i<20;i++){				
				strfreqs[i]=-1;	
				lg[i]="0.0001";							
			}
		}
		
		
		if(document.getElementById('3db').checked){
			db="yes";
			dbDeg="";
			/*if(document.getElementById('30d').checked && document.getElementById('390d').checked){
				dbDeg='0d90d';
			}*/
			if(document.getElementById('3all').checked){
				dbDeg='0d90d';
			}
			else if(document.getElementById('30d').checked)
				dbDeg='0d';
			else if(document.getElementById('390d').checked)
				dbDeg='90d';	
			else if(document.getElementById('3bm').checked)
				{
					 dbDeg='bm';
				}
			
			
		}
		if(document.getElementById('10db').checked){
			dbv="yes";
			dbDegv="";
			if(document.getElementById('all').checked){
				dbDegv='0d90d';
			}
			else if(document.getElementById('0d').checked)
				dbDegv='0d';
			else if(document.getElementById('90d').checked)
				dbDegv='90d';	
			else if(document.getElementById('bm').checked)
				{
					 dbDegv='bm';
				}
			
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
			if (img=="yes"){  // we have a different rptdesign file with aircraft bkgnd imag to be used when image is selected 
				var url="/birt-viewer/frameset?__report=verdant/ReportSetPitch_Img.rptdesign&testid="+testid+"&type=P&polar="+polar+"&scale=yes&lgain=0.0001"+
						"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
						"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
						"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}else{
				var url="/birt-viewer/frameset?__report=verdant/ReportSetPitch.rptdesign&testid="+testid+"&type=P&polar="+polar+"&scale=yes&lgain=0.0001"+
						"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
						"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
						"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}			
		}
		if(typ=="R"){
			if (img=="yes"){
				var url="/birt-viewer/frameset?__report=verdant/ReportSetRoll_Img.rptdesign&testid="+testid+"&type=R&polar="+polar+"&scale=yes&lgain=0.0001"+
					"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
					"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}else{
				var url="/birt-viewer/frameset?__report=verdant/ReportSetRoll.rptdesign&testid="+testid+"&type=R&polar="+polar+"&scale=yes&lgain=0.0001"+
					"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&freq1="+strfreqs[0]+
					"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}
		}
        if(typ=="Y"){
			if (img=="yes"){
				var url="/birt-viewer/frameset?__report=verdant/ReportSetYaw_Img.rptdesign&testid="+testid+"&type=Y&polar="+polar+"&scale=yes&omni="+od+"&lg1="+lg[0]+
					"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}else{
				var url="/birt-viewer/frameset?__report=verdant/ReportSetYaw.rptdesign&testid="+testid+"&type=Y&polar="+polar+"&scale=yes&omni="+od+"&lg1="+lg[0]+
					"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}
		}
       if(atype=="A" && ptype=="S"){
    	   if(dtype=='B'){
    		   if(img=="no"){
			var url="/birt-viewer/frameset?__report=verdant/RSetSlantAzimuthHpnVP.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&scale=yes&omni="+od+
					"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
	    }
    		   else{
    			   var url="/birt-viewer/frameset?__report=verdant/RSetSlantAzimuthHpnVP_img.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&scale=yes&omni="+od+
					"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
	     			
    		   }
    			   
    	   }
    	    else{
    		   if(img=="yes"){
    			   var url="/birt-viewer/frameset?__report=verdant/ReportSetSlantAzimuth_img.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&scale=yes&omni="+od+
					"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
	     			   
    		   }
    		   else{   
    		   var url="/birt-viewer/frameset?__report=verdant/ReportSetSlantAzimuth.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&scale=yes&omni="+od+
				"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+
				"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
				"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
    		   }
    	   }
    	   }
       if(atype=="E" && ptype=="S"){
    	   
			if(dtype=='B'){
			var url="/birt-viewer/frameset?__report=verdant/SlantElevationRSHnV.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&blob="+blobe+"&AxR="+axr+"&AxDeg="+AxDeg+"&scale=yes&lg1=0.0001"+
					"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}
			else
				{
				var url="/birt-viewer/frameset?__report=verdant/SlantElevationRSetHporVp.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&blob="+blobe+"&AxR="+axr+"&AxDeg="+AxDeg+"&scale=yes&lg1=0.0001"+
				"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+
				"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
				"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
		
				}
	    }
       if(atype=="NCP" && ptype=="C"){
    	   
			if(dtype=='B'){
			var url="/birt-viewer/frameset?__report=verdant/CircularWithOutCPRset.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&blob="+blobe+"&AxR="+axr+"&AxDeg="+AxDeg+"&scale=yes&lg1=0.0001"+
					"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+
					"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
					"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
			}
			else
				{
				var url="/birt-viewer/frameset?__report=verdant/CircularWithoutCPRsetHporVp.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&blob="+blobe+"&AxR="+axr+"&AxDeg="+AxDeg+"&scale=yes&lg1=0.0001"+
				"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+
				"&freq1="+strfreqs[0]+"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
				"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter;
		
				}
	    }
       if(atype=="DCP" && ptype=="C"){
    	   
    	   if(dtype!="B"){
   			var url="/birt-viewer/frameset?__report=verdant/CPReportset.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+"&scale=yes"+
   			"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+"&pc="+nprecision+
   			"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
   			"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
   			"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img=no&rpth="+rptheader+"&rptf="+rptfooter;
   			}
   			else{
   				var url="/birt-viewer/frameset?__report=verdant/CPwithHPnVPRset.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+"&scale=yes"+
   				"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+"&pc="+nprecision+
   				"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
   				"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
   				"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img=no&rpth="+rptheader+"&rptf="+rptfooter;
   				
   			}
	    }
        
		else if (atype=="CP" && ptype=="C"){
			if(dtype!="B"){
			var url="/birt-viewer/frameset?__report=verdant/CPReportset.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+"&scale=yes"+
			"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+"&pc="+nprecision+
			"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
			"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
			"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img=no&rpth="+rptheader+"&rptf="+rptfooter;
			}
			else{
				var url="/birt-viewer/frameset?__report=verdant/CPwithHPnVPRset.rptdesign&testid="+testid+"&type="+dtype+"&polar="+polar+"&axr="+axr+"&AxDeg="+AxDeg+"&scale=yes"+
				"&lg1="+lg[0]+"&lg2="+lg[1]+"&lg3="+lg[2]+"&lg4="+lg[3]+"&lg5="+lg[4]+"&lg6="+lg[5]+"&lg7="+lg[6]+"&lg8="+lg[7]+"&lg9="+lg[8]+"&lg10="+lg[9]+"&pc="+nprecision+
				"&3db="+db+"&3dbDeg="+dbDeg+"&10db="+dbv+"&10dbDeg="+dbDegv+"&cpg="+cpg+"&blobe="+blobe+"&freq1="+strfreqs[0]+
				"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+
				"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9]+"&img=no&rpth="+rptheader+"&rptf="+rptfooter;
				
			}
		}	
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
	
	
	
	function scaleclick()
	{
		$("#scalingdialog").attr('src', "scaling.htm?testid=${model.testid}");
			$("#dialog-form-scaling").dialog({
	            width: 500,
	            height: 350,
	            modal: true,overflow: true,
	            close: function () {
	                $("#scalingdialog").attr('src', "about:blank");
	            }
	        });
	
	}
	
</script>

</html>