 <%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>

<link rel="stylesheet" href="css/jquery-ui.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui.js"></script>  
  <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">
   
    <link rel="stylesheet" type="text/css" href="irev-style.css" />
<style>
#drop{
	border:2px dashed #bbb;
	-moz-border-radius:5px;
	-webkit-border-radius:5px;
	border-radius:5px;
	padding:25px;
	text-align:center;
	font:20pt bold,"Vollkorn";color:#bbb
}
#b64data{
	width:100%;
}
 
.errorblock {
	color: #000;
	background-color: #ffEEEE;
	border: 3px solid #ff0000;
	padding: 8px;
	margin: 16px;
}
</style>
</head>
 
<body>
<script>
var fileext;

//<!-- Begin Script
var progressEnd = 10; // set to number of progress <span>'s.
var progressColor = 'blue'; // set to progress bar color
var progressInterval = 1000; // set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;
function progress_clear() {
for (var i = 1; i <= progressEnd; i++) document.getElementById('progress'+i).style.backgroundColor = 'transparent';
progressAt = 0;
}
function progress_update( typ) {
	//console.log("progress_update");
	if(typ=='M'){
	tabledata();
	if(document.getElementById("strfreq").value=="" ||document.getElementById("strfreq").value==null || document.getElementById("strfreq").value=='null'){
		alert("Frequencies not added");
		progress_stop();
		return;
	}
	}
	/*var filename=document.getElementById("filename").value;
	if(filename==null || filename=="")
		{
	alert("Please Select file to import");
		}
	*/
	document.getElementById("progressbar").style.display="block"
progressAt++;
if (progressAt > progressEnd) progress_clear();
else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
progressTimer = setTimeout('progress_update("D")',progressInterval);
}
function progress_stop() {
clearTimeout(progressTimer);
progress_clear();
}
// End --> 

//$('#myTable tr:last').after('<tr>...</tr><tr>...</tr>');

</script>
<div id="dialogtip"  style="display:none;-moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    border-radius: 10px;
    border: 1px solid;">
<table>
<tr>
<td></td>
<td align="right"><button id="closetip" onclick="closetipclick();"> <img  src ="/irev-verdant/img/closetip.png"></button></td></tr>
<tr><td></td><td style="font-size:11;font-style:italic;font-color:#FFBF00;">(1) The importing file can either be xlxs or xls,<br>(2)The first row can be the header or the frequencies,<br>(3) The angle can start from 0 degree or 0.1 degree 
</td></tr></table>
</div>


<div id="appbody" style="width:1000px;">


    <div id="pageHdr" style="width:1000px;">
	<h2>Test Details</h2>
	</div>
 
	<form:form name="form1" id="form1" method="POST"  commandName="TestData" enctype="multipart/form-data">
 
		<form:errors path="*" cssClass="errorblock" element="div" />
		<table>
		<tr>
		<td>Test Configuration * :</td>  
          <td><form:input path="testname" id="testname" required="required" />  
          </td>
          <td>Test Center * :</td>  
		<td><form:input path="testcenter" required="required" /></td>
         </tr>
         <tr>
          <td>Test date *:</td>
	     <td><form:input id="dttest" path="strtestdate" type="datetime-local" required="required" /> </td>
		<td>
		Antenna Type :</td> <td><input type="text" value='${prodtype}' readonly="readonly"/></td></tr>
		</table>
 <table>
 <tr>
 <td>
		<table id="tblmain">
		
		<tr>
		<td > Product Serial No: </td>
       <td >
			           
			 <form:select id="psl" path="productserialid" required="required" disabled = "true"> 			              
			 <c:forEach items="${prodserlist}" var="prdser"> 
			  <form:option label="${prdser.productserial}"   value="${prdser.productserialid}"/>	     
			</c:forEach>
			</form:select>
			   
          </td>
          </tr>
          <tr>
          <td>Test Type * :</td> 
          
          <td>          
           <form:select id="testtype"  path="testtype"  required="required" >           		 
		</form:select>              
          </td> 
          </tr>
          <tr>
          <td>Test Description :</td>  
        <td><form:textarea id="testdesc"  path="testdesc"  rows="2" cols="50" /></td>  
        </tr> 
          <tr>
		<td>Test Procedure  :</td> 
		<td><form:textarea id="testproc"  path="testproc"  rows="2" cols="50" /></td>   
		        
		</tr>
		<tr>
		<td>Instruments Used  :</td> 
		<td><form:textarea   path="instruments"  rows="2" cols="50" /></td>
		</tr>
		<tr>
		<td>Calibration Status  :</td> 
		<td><form:textarea   path="calibration"  rows="2" cols="50" /></td> 
		</tr>
        </table> 
        </td>
  <c:if test="${cfreq!='' || vfreq !=''  || hfreq !=''  || cfreq !=''  || pfreq !=''  || rfreq !=''  || yfreq !='' }">
 <td align="center"> <b> <u>Imported Data </u></b> 
		<table id="listtab"  border="1" cellpadding="1" cellspacing="2" style="width: 500px;vertical-align:top;">
		
	<thead>
		<tr>
		<th scope="col"> Imported Type </th>
		<th scope="col"> Spot Frequencies (MHz)</th>	
		</tr>
	</thead>
	<tbody>
	<c:if test="${cfreq!='' && cfreq !=null}">
	<tr>
	<td> CP Data </td>
	<td> ${cfreq}</td>				
	</tr>
	</c:if>
	<c:if test="${hfreq!='' && hfreq !=null}">
	<tr>
	<td> HP Data </td>
	<td> ${hfreq}</td>				
	</tr>
	</c:if>
	<c:if test="${vfreq!='' && vfreq !=null}">
	<tr>
	<td> VP Data </td>
	<td> ${vfreq}</td>				
	</tr>
	</c:if>
	<c:if test="${pfreq!='' && pfreq !=null}">
	<tr>
	<td> Pitch Data </td>
	<td> ${pfreq}</td>				
	</tr>
	</c:if>
	<c:if test="${rfreq!='' && rfreq !=null}">
	<tr>
	<td> Roll Data </td>
	<td> ${rfreq}</td>				
	</tr>
	</c:if>
	<c:if test="${yfreq!='' && yfreq !=null}">
	<tr>
	<td> Yaw Data </td>
	<td> ${yfreq}</td>				
	</tr>
	</c:if>
	
	 
	</tbody>
	</table> 
	
	</td>
	</c:if>
 </tr>
 </table>
 
         <br> 
         
         
       <table id="tbimport">  
       
       <tr> 
      
		<td>File Type * :</td> 
          
          <td width="50">
           <form:select id="ftype" name="D1" path="filetype"  ></form:select>
         
		</td>
		</tr>
	
		<tr>
		<td>
		
		<div id="imp">
		
		<p><button id="helptip" title="file data" onclick="helpclick();"> <img  src ="/irev-verdant/img/helpicon.jpg"></button>
		<input type="file" name="filename" id="filename" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" title=" click here to select Data file"/></p>
		</div>
		
		</td>		
		</table>
		
		<table>
		<tr>
		<td>
          <input type="checkbox" id="chkrange"  onchange="enablerange();" />Enable Range
        </td>        
        </tr>
        <tr>
        <td>
        <div id ="rangediv" style="display:none;">
        Start Freq.
        &nbsp; &nbsp;<input type="number" id="startfreq" />
        &nbsp; &nbsp;Range
        &nbsp; &nbsp;<input type="number" id="freqrange" />
        &nbsp; &nbsp;Last Freq.
        &nbsp; &nbsp;<input type="number" id="lastfreq"  />
        &nbsp; &nbsp;<input type="button" id="btnrange" onclick="uprange();" value="Populate" class="mybuttongo" />
        </div>
        </td>
		</table>
		
		<table id="tbimport1">
		
		<tr>
		<td width="20%"> Frequency :</td>
       <td>		
           <input type="number" id="selfreq" name="D1" step="any" min="0" maxlength="20" ></input>
        </td>
        <td><form:select path="frequnit" id="frequnit">
        <form:option value="MHz" label="MHz"></form:option>
   		 <form:option value="GHz" label="GHz"></form:option>  
   		 
		</form:select> 
        <td>		
           <input type="button" id="lg" class="mybutton" value ="Add Freq" onclick="AddNew();" />
        </td>
        <td>		
          <!--  <input type="button" id="del" class="mybutton" value ="Delete Freq" onclick="Removefreqs();" /> -->
          <input type="checkbox" id="chkdel"  onchange="AddPrev();" />Quick Select Previous Frequencies
        </td>
	  </tr>
		</table>
		
		
	<table id="tblData" class="hover order-column cell-border">
	<thead>
				<tr>
					<th scope="col"> Frequency </th>					
					<th scope="col"> </th>
					
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${freqlist}" var="freqlst">
		<tr>
			<td> <c:out value="${freqlst.frequency}"/> 
			<td> </td> 
			<td> <img src='img/delete.jpg' class='btnDelete'/></td>
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
	
	
	
	    <form:hidden id="testid" path="testid"></form:hidden>
		<form:hidden id="strfreq" path="strjsonfreq"></form:hidden>
		<form:hidden id="originalfilename" path="originalfilename"></form:hidden>
		<form:hidden path="ptype" ></form:hidden>
		<table>
		<tr>
	<td>	<input type="submit" id="more" value="Import" name="fmaction" class="myButton" onclick="progress_update('M');form1.submit();"/></td>
	<td>	<input type="submit" id="done" value="Calculate" name="fmaction" class="myButton" onclick="progress_update('D');form1.submit();"/></td>
	<td>	<input type="submit" id="save" value="Save" name="fmaction" class="myButton" onclick="form1.submit();" style="visibility:hidden"/></td>
		<td>
		<table align="center" id="progressbar" style="display:none"><tr><td><b>Saving ....</b>
<div style="font-size:8pt;padding:2px;border:solid black 1px">
<span id="progress0">&nbsp; &nbsp;</span>
<span id="progress1">&nbsp; &nbsp;</span>
<span id="progress2">&nbsp; &nbsp;</span>
<span id="progress3">&nbsp; &nbsp;</span>
<span id="progress4">&nbsp; &nbsp;</span>
<span id="progress5">&nbsp; &nbsp;</span>
<span id="progress6">&nbsp; &nbsp;</span>
<span id="progress7">&nbsp; &nbsp;</span>
<span id="progress8">&nbsp; &nbsp;</span>
<span id="progress9">&nbsp; &nbsp;</span>
<span id="progress10">&nbsp; &nbsp;</span>
</div>
</td></tr></table>
		
		</td>
		</tr>
		</table>
		
		<span><form:errors path="filename" cssClass="error" />
		</span>
 
	</form:form>
	
	
 </div>



<script>
var mode='<%=request.getParameter("mode")%>';

$(document).ready( function () {
	
	var savestat='<%=request.getParameter("savestat")%>';
	var msg='<%=request.getParameter("msg")%>';
		//alert (parmdelete);
		console.log("savestat "+savestat);
		if(savestat!=null && savestat!="" && savestat!=-1 && savestat!="null")
			{
			if(savestat==1)
				{
		flashMessenger.setText(msg);
		var url = '<%=request.getContextPath()%>/assettree.htm?treemode=view';     
        parent.frames['AssetTree'].location = url; 
        parent.document.getElementById("od").style.display="none";
  	    parent.document.getElementById("ar").style.display="none";
  	    parent.document.getElementById("pp").style.display="none";
  	    parent.document.getElementById("3db").style.display="none";
  	    parent.document.getElementById("10db").style.display="none";
  	    parent.document.getElementById("cpg").style.display="none";
  	    parent.document.getElementById("blobe").style.display="none";
  	    parent.document.getElementById("apt").style.display="none";
				}
			else{
				errorflashMessenger.setText(msg);
			}
			}
	
	
	var testtype = document.getElementById('testtype');
	var ptype=document.getElementById("ptype").value;
	var i;
	testtype.innerHTML="";
	document.getElementById('psl').disabled = true;
	if( ptype=="L" || ptype=="S" ) {	
		var el = document.createElement("option");
		el.textContent = "--Select--";
		el.value = "-1";
		testtype.appendChild(el);
	    el = document.createElement("option");
	    el.textContent = 'Azimuth';
	    el.value ='A';
	    testtype.appendChild(el);
	    el = document.createElement("option");
	    el.textContent = 'Elevation';
	    el.value ='E';
	    testtype.appendChild(el);  }
	else 	
	{	 
		var el = document.createElement("option");
		el.textContent = "--Select--";
		el.value = "-1";
		testtype.appendChild(el);
	    el = document.createElement("option");
	    el.textContent = 'With CP Conversion';
	    el.value ='CP';
	    testtype.appendChild(el);
	    el = document.createElement("option");
	    el.textContent = 'Without CP Conversion';
	    el.value ='NCP';
	    testtype.appendChild(el); 
	    el = document.createElement("option");
	    el.textContent = 'Direct CP';
	    el.value ='DCP';
	    testtype.appendChild(el); }
	
	//document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100, "lg":1},{"freq":1000, "lg":2},{"freq":2000, "lg":2}]}';
	/*if(document.getElementById("ptype").value=="C")
		{
		document.getElementById("A").style.visibility="hidden";
		document.getElementById("E").style.visibility="hidden";
		}
	else
		{
		document.getElementById("NCP").style.visibility="hidden";
		document.getElementById("DCP").style.visibility="hidden";
		document.getElementById("CP").style.visibility="hidden";
		}*/
	
	var testid=document.getElementById("testid").value;
	 console.log("testid "+testid);
	 if(testid!="" && testid!=null && testid !='null' && testid!=0)
		{
		 document.getElementById("frequnit").disabled = true;
		 document.getElementById("testtype").value='${testtype}';
		 
		 //$("#testtype").trigger( "onchange" );
		 $("#testtype").val('${testtype}').change();
		 if(mode=='edit')
			 {
			 document.getElementById("tbimport").style.visibility="hidden";
			 document.getElementById("tbimport1").style.visibility="hidden";
			 document.getElementById("tblData").style.visibility="hidden";
			 document.getElementById("more").style.visibility="hidden";
			 document.getElementById("done").style.visibility="hidden";
			 document.getElementById("save").style.visibility="visible";
			// document.getElementById("cancel").style.visibility="visible";
			 document.getElementById("testtype").disabled = true;
			 }		 
		}
	 else{
		 document.getElementById("chkdel").disabled = true;
		 document.getElementById("more").style.visibility="visible";
		 document.getElementById("done").style.visibility="visible";
		 document.getElementById("save").style.visibility="hidden";
		// document.getElementById("cancel").style.visibility="hidden";
		 document.getElementById("more").disabled = true;
		 document.getElementById("done").disabled = true;
		 
	 }
	 
	 if( testid!="" && testid!=null && testid !='null' && testid!=0 && mode!='edit'){
	 $('#tblmain').find('input, textarea, button, select,checkbox').attr('disabled',true);
	 document.getElementById("more").style.visibility="visible";
	 document.getElementById("done").style.visibility="visible";
	 document.getElementById("save").style.visibility="hidden";
	
	// document.getElementById("cancel").style.visibility="hidden";
	 document.getElementById("more").disabled = true;
	 document.getElementById("done").disabled = false;
	 if(ptype=="L" || testtype=="DCP")
	 document.getElementById("checkdel").disabled = true;
	 }
	 
	 
	 $("#selfreq").keydown(function (e) {
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
	            e.preventDefault();
	        }
	    });
	
} );
$('#testtype').on('change', function() {
	  var sel= this.value ; // or $(this).val()
	  var ftype = document.getElementById('ftype');
	  var ptype=document.getElementById("ptype").value;
	  ftype.innerHTML="";
		
		if(sel=="A" && ptype=="L") {	   
		    var el = document.createElement("option");
		    el.textContent = 'Yaw Data';
		    el.value ='yaw';		    
		    ftype.appendChild(el);}
		if(sel=="A" && ptype=="S") {
			 var el = document.createElement("option");
			el.textContent = "--Select--";
			el.value = "-1";
			ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'VP Data';
		    el.value ='Vdata';
		    ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'HP Data';
		    el.value ='Hdata';
		    ftype.appendChild(el);    
		}
		if(sel=="E" && ptype=="S") {
			 var el = document.createElement("option");
				el.textContent = "--Select--";
				el.value = "-1";
				ftype.appendChild(el);
			    el = document.createElement("option");
			    el.textContent = 'VP Data';
			    el.value ='Vdata';
			    ftype.appendChild(el);
			    el = document.createElement("option");
			    el.textContent = 'HP Data';
			    el.value ='Hdata';
			    ftype.appendChild(el);    
			}
		
		if(sel=="E" && ptype=="L") {
			 var el = document.createElement("option");
			el.textContent = "--Select--";
			el.value = "-1";
			ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'Pitch Data';
		    el.value ='pitch';
		    ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'Roll Data';
		    el.value ='roll';
		    ftype.appendChild(el);    
		}
		if(sel=="CP" && ptype=="C") {
			 var el = document.createElement("option");
			el.textContent = "--Select--";
			el.value = "-1";
			ftype.appendChild(el);	  
		    el = document.createElement("option");
		    el.textContent = 'VP Data';
		    el.value ='Vdata';
		    ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'HP Data';
		    el.value ='Hdata';
		    ftype.appendChild(el);
		        
		}
		if(sel=="NCP" && ptype=="C") {
			 var el = document.createElement("option");
			el.textContent = "--Select--";
			el.value = "-1";
			ftype.appendChild(el);	  
		     el = document.createElement("option");
		    el.textContent = 'VP Data';
		    el.value ='Vdata';
		    ftype.appendChild(el);
		    el = document.createElement("option");
		    el.textContent = 'HP Data';
		    el.value ='Hdata';
		    ftype.appendChild(el);
		    ftype.appendChild(el);    
		}
		if(sel=="DCP" && ptype=="C") {
			   
		    var el = document.createElement("option");
		    el.textContent = 'CP Data';
		    el.value ='CPdata';
		    ftype.appendChild(el);}
		
		
		
	});

function fncancel(){
	//alert("redirect");
	window.location = "setup.htm?oper=test";
	 }

function AddNew(){
	
	var testname=document.getElementById("testname").value;
	if(testname==null || testname=="")
	{
	alert(" Enter Test Configuration");
	return;
	}
	var testtype=document.getElementById("testtype").value;
	if(testtype==null || testtype=="" || testtype=="-1")
	{
	alert(" Select Test Type");
	return;
	}
	var ftype=document.getElementById("ftype").value;
	if(ftype==null || ftype=="" || ftype=="-1")
	{
	alert(" Select File Type");
	return;
	}
	var filename=document.getElementById("filename").value;
	if(filename==null || filename=="")
		{
	alert("Please Select file to import");
	return;
		}

	var freq=document.getElementById("selfreq").value;	
	document.getElementById("selfreq").value="";
	if(freq==null || freq=="")
	{
	alert(" Select frequency");
	return;
	}
	if(freq.length > 20)
	{
	alert(" Enter valid frequency");
	return;
	}
	$("#tblData tbody").append(
		"<tr>"+
		"<td>"+freq+"</td>"+		
		"<td><img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	$(".btnDelete").bind("click", Delete);
	document.getElementById("more").disabled = false;
	document.getElementById("done").disabled = false;
};
function Add(){
	$("#tblData tbody").append(
		"<tr>"+
		"<td><input type='text'/></td>"+		
		"<td><img src='img/save.jpg' class='btnSave'><img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	
		$(".btnSave").bind("click", Save);		
		$(".btnDelete").bind("click", Delete);
}; 
function Save(){
	var par = $(this).parent().parent(); //tr
	var tdName = par.children("td:nth-child(1)");	
	var tdButtons = par.children("td:nth-child(4)");

	tdName.html(tdName.children("input[type=text]").val());	
	tdButtons.html("<img src='img/delete.jpg' class='btnDelete'/><img src='img/edit.jpg' class='btnEdit'/>");

	$(".btnEdit").bind("click", Edit);
	$(".btnDelete").bind("click", Delete);
};
function Edit(){
	var par = $(this).parent().parent(); //tr
	var tdName = par.children("td:nth-child(1)");	
	var tdButtons = par.children("td:nth-child(4)");

	tdName.html("<input type='text' id='txtName' value='"+tdName.html()+"'/>");	
	tdButtons.html("<img src='img/save.jpg' class='btnSave'/>");

	$(".btnSave").bind("click", Save);
	$(".btnEdit").bind("click", Edit);
	$(".btnDelete").bind("click", Delete);
};

function AddPrev(){
	if(document.getElementById("chkdel").checked){
		var ftype=document.getElementById("ftype").value;
		if(ftype==null || ftype=="" || ftype=="-1")
		{
		alert(" Select File Type");
		return;
		}
		
		Deletefreq();
	var str='${strfreqlist}';
	console.log("str "+str);
	var freq=[];
	freq=str.split(",");
	for(var i=0;i<freq.length;i++){
		
	$("#tblData tbody").append(
		"<tr>"+
		"<td>"+freq[i]+"</td>"+				
		"<td><img src='img/delete.jpg' class='btnDelete'/></td>"+
	"</tr>");
$(".btnDelete").bind("click", Delete);
document.getElementById("more").disabled = false;
document.getElementById("done").disabled = false;
	}
	}
	else{
		Deletefreq();
	}
	document.getElementById("more").disabled = false;
};

function Delete(){
	var par = $(this).parent().parent(); //tr
	par.remove();
};

function Deletefreq(){
var table =document.getElementById("tblData") ;	
var rowCount=table.rows.length;
for(var i=rowCount-1;i>0;i--)
{
table.deleteRow(i);

}
}



function tabledata()
{
	var freq;
	var lg;
	var json='{"jsonfreq":[';
	var idx=0;
	 //console.log("tabledata");
	var table = $("#tblData");
	table.find('tr').each(function (i, el) {
        var $tds = $(this).find('td'),
            freq = $tds.eq(0).text()
           
        // document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100},{"freq":1000},{"freq":2000}]}';
        if(freq!="" && freq!=null && freq !='null'){
       if(idx==0){
        json=json+'{"freq":'+freq+'}';}
       else{json=json+',{"freq":'+freq+'}';}
       
       idx=1;
        }
    });
	
	if(json.length > 15)
		{
		json=json+']}';
		document.getElementById("strfreq").value=json;
		console.log(""+json);
		}
}


function enablerange()
{
	if(document.getElementById("chkrange").checked)
	document.getElementById("rangediv").style.display="block";
	else
		document.getElementById("rangediv").style.display="none";
}

function uprange()
{
	console.log("inside uprange");
	var testname=document.getElementById("testname").value;
	if(testname==null || testname=="")
	{
	alert(" Enter Test Configuration");
	return;
	}
	var testtype=document.getElementById("testtype").value;
	if(testtype==null || testtype=="" || testtype=="-1")
	{
	alert(" Select Test Type");
	return;
	}
	var ftype=document.getElementById("ftype").value;
	if(ftype==null || ftype=="" || ftype=="-1")
	{
	alert(" Select File Type");
	return;
	}
	var filename=document.getElementById("filename").value;
	if(filename==null || filename=="")
		{
	alert("Please Select file to import");
	return;
		}
	
	if(document.getElementById("startfreq").value==null || document.getElementById("startfreq").value=="")
	{
alert("Enter Starting frequency");
return;
	}
	
	if(document.getElementById("freqrange").value==null || document.getElementById("freqrange").value=="")
		{
	alert("Enter Range");
	return;
		}
	
	if(document.getElementById("lastfreq").value==null || document.getElementById("lastfreq").value=="")
	{
alert("Enter Last frequency");
return;
	}
var rng=parseInt(document.getElementById("freqrange").value);
var rstart=parseInt(document.getElementById("startfreq").value);
var rlast=parseInt(document.getElementById("lastfreq").value);

var ai=rstart;
console.log("rlast "+rlast +" rng ="+rng);

while (ai < rlast){
	//console.log("ai "+ai);
	$("#tblData tbody").append(
			"<tr>"+
			"<td>"+ai+"</td>"+				
			"<td><img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	$(".btnDelete").bind("click", Delete);
	
	ai= ai + rng;
	//console.log("ai "+ai);
}
document.getElementById("more").disabled = false;
document.getElementById("done").disabled = false;
}


function helpclick(){
	dialogtip = $( "#dialogtip" ).dialog({
	      autoOpen: true,
	      height: 200,
	      width: 200,
	      modal: false,
	      position: { my: 'right top', at: 'right top' },
	      open: function () {
	          $(this).closest(".ui-dialog").next(".ui-widget-overlay").addClass("modalOverlayPrivate");
	          $(".ui-dialog-titlebar").hide();
	      },
	      beforeClose: function() {
	          $(this).closest(".ui-dialog").next(".ui-widget-overlay").removeClass("modalOverlayPrivate");
	      }
	    });  
	dialogtip.dialog( "open" );
}
function closetipclick()
{
	dialogtip.dialog( "close" );		
}
</script>

 
</body>
</html>

