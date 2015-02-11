<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Polar Graph</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
<link rel="stylesheet" href="css/jquery-ui.css">
		
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
</head>
<body>
<table >
 <tr>
		<td >Frequency : <table id ='ptab' style="display:none;">
	    <c:set var="cnt" value="1"/>
	    <tbody><tr><td>
	    
	    
	    <c:forEach items="${model.freqlist}" var="freq">			
				
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
	
       <td >
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
          </tr>
          <tr>
          <td>
          <div id=divlg>
          Linear Gain   :<input type="text" id="lg" class="scale" style="width:50;"></div>
          </td>
          </tr>
          <tr>
          <td>
          <div id="cp">          
       <input type="checkbox" id="hdata" value="hdata" onclick="fnenable('h');">HP Data &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="vdata" value="vdata" onclick="fnenable('v');" >VP Data  &nbsp; &nbsp;&nbsp;
       <input type="checkbox" id="cpdata" value="cpdata" onclick="fnenable('c');"><label id="lblcp">CP Data </label> &nbsp; &nbsp;&nbsp;       
        </div> </td>
       </tr>
       </table>
       <table>
       <tr>
       <td > Max.Amplitude: </td>
       <td ><input id="max" value="" class="scale" style="width:50;">
       <td > &nbsp; &nbsp;&nbsp;Min.Amplitude: </td>
       <td ><input id="min"  value="" class="scale" style="width:50;"></td>
        <td><div id="divimg">&nbsp; &nbsp;&nbsp;<input type="checkbox" id="img" value="img" >Show Aircraft Image</div></td>
		<td>&nbsp; &nbsp;&nbsp;<input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
	<!-- &nbsp; &nbsp;&nbsp;<input type="button" value="back" name="go" class="myButtonGo" onclick="back()"/> -->
		</td>
		</tr>
</table>

<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>

<script type="text/javascript">
var typ="${model.atype}";
var rptheader='${model.rptheader}';
var rptfooter='${model.rptfooter}';
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
	}
	if(document.getElementById("vdata").checked){
		document.getElementById("cpdata").checked=false;
	}
	}
}

$(document).ready(function(){
	
	console.log("parenttype="+parent.AssetTree.selectedparenttype);
	console.log("atype="+parent.AssetTree.atype);
	if(parent.AssetTree.selectedparenttype=="L")
		document.getElementById("divimg").style.display="block";
	else if(parent.AssetTree.selectedparenttype=="S" && parent.AssetTree.atype=="A")
		document.getElementById("divimg").style.display="block";
	else
		document.getElementById("divimg").style.display="none";
	
	var lgtype=parent.AssetTree.atype;
	if(lgtype=="CP" || lgtype=="A")
		    document.getElementById("divlg").style.display="block";	
		else
			document.getElementById("divlg").style.display="none";
	
	
	if(lgtype=="DCP" || parent.AssetTree.selectedparenttype=="L")
		{document.getElementById("cp").style.display="none";}
	else{
		document.getElementById("cp").style.display="block";
		document.getElementById("hdata").checked=true;
		if(parent.AssetTree.selectedparenttype=="S") {
	    	document.getElementById("cpdata").style.display="none";
	    	document.getElementById("lblcp").style.display="none";
	    	}	
	}
	$(".scale").keydown(function (e) {
		
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

	function back()
	{
		 window.location="/irev-verdant/start.htm";
		// self.close();
	}
	function Redirect(){
		var img="no";
		//alert("go clicked");
		var nprecision=1;
		var scale="yes";
		var testid="${model.testid}";
		var strfreqs=[]; 
		var freqs=[];
		var i=0;
		var j=0;
		var fre= '${model.strfreqs}';
		nprecision='${model.nprecision}';
		
		freqs=fre.split(",");
		var freqsel=0;
		//var freqid =document.getElementById("freqid").value;
		var freqid =document.getElementById("freqid").value;
		console.log(" freqids "+freqid);
		/*for (i==0;i<freqs.length;i++){
			if(document.getElementById(freqs[i]).checked){
			strfreqs[j]=freqs[i];
			freqsel=1;
			}
			else 
				{strfreqs[j]=-1;}
				j=j+1;
		}*/
		for (i==1;i<20;i++){
			strfreqs[i]=-1;
		}
		console.log(strfreqs[0]);
		if(document.getElementById("freqid").value==-1)
			{
			alert("Frequency not selected");
			return;
			}
		strfreqs[0]=freqid;
		var max =document.getElementById("max").value;
		var min =document.getElementById("min").value;
		if(min!=null && min !=""){
		if(max==""|| max==null ){
			alert("Max.Amplitude should be entered");
			return;
		}
		scale="no";
		}
		
		if(max!=null && max !=""){
			if(min==""|| min==null ){
				alert("Min.Amplitude should be entered");
				return;
			}
			scale="no";
			}
		if(scale=="yes")
			{max=0;
			min=0;}
		
		/*if(min<0)
			if(max<0){
			if(Math.abs(max)<Math.abs(min)){
			alert("Max.Amplitude less than Min.Amplitude");
			return;
			}		
		}*/
			
		var lg=document.getElementById("lg").value;
		if(lg=="" || lg==null || lg=="null")
			{lg=0.0001;}
		
		if((document.getElementById("hdata").checked) && (document.getElementById("vdata").checked))
		{
		typ="B";
		}
		else if (document.getElementById("hdata").checked)
		{typ="H";}
		else if (document.getElementById("vdata").checked)
			{typ="V";}
		else if (document.getElementById("cpdata").checked)
		{typ="C";}
if(document.getElementById("img").checked)
	img="yes";
		
		var url="/birt-viewer/frameset?__report=PolarGeneric.rptdesign&type="+typ+"&testid="+testid+"&scale="+scale+"&max="+max+"&min="+min+"&lgain="+lg+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter+"&freq1="+strfreqs[0]+
		"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
		"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9];
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		if(typ=="B")
			var url="/birt-viewer/frameset?__report=PolarHPVP.rptdesign&type="+typ+"&testid="+testid+"&scale="+scale+"&max="+max+"&min="+min+"&lgain="+lg+"&img="+img+"&rpth="+rptheader+"&rptf="+rptfooter+"&freq1="+strfreqs[0]+
			"&freq2="+strfreqs[1]+"&freq3="+strfreqs[2]+"&freq4="+strfreqs[3]+"&freq4="+strfreqs[3]+"&freq5="+strfreqs[4]+"&pc="+nprecision+
			"&freq6="+strfreqs[5]+"&freq7="+strfreqs[6]+"&freq8="+strfreqs[7]+"&freq9="+strfreqs[8]+"&freq10="+strfreqs[9];
			console.log("url " + url);
		//window.location =url; 
		window.frames['AppBody'].location=url;
		 }
</script>
</body>
</html>