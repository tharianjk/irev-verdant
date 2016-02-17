<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title >X-db Beam Width </title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>
<body>
<table>
 <tr><td>
 <table id="dbtab" style="display:none"><tr><td>
       	       <input type="radio" id="bm" value="bm" name="optdb" >Beam Max &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="0d" value="0d" name="optdb" >0 &#176;  &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="90d" value="90d" name="optdb" >90 &deg; &nbsp; &nbsp;&nbsp;
		       <input type="radio" id="all" value="0d90d" name="optdb" checked >All &nbsp; &nbsp;&nbsp;
		       </td></tr>
</table> 
        </td>
          <td > &nbsp; &nbsp;&nbsp;Precision: </td>
        <td><select id="precision" >          
         <option value="-1">--Select--</option> 
            <option value=1 > 1</option>
            <option value=2 > 2</option>
            <option value=3 > 3</option>
            <option value=4 > 4</option>
		</select></td>
		</tr>
		<tr>
		<td>
		<table id ='mtab' >	    
	    <tbody><tr>
	     <td > &nbsp; &nbsp;&nbsp;Serial Nos: </td>
	    <td>
	    <c:forEach items="${model.seriallist}" var="serial">			
				<input type="checkbox" name="chkid" value="${serial.productserialid}" id="${serial.productserialid}" class="chkfreq">${serial.productserial}
		</c:forEach></td></tr></tbody>	    
        </table>
		</td>
		</tr>
		<tr>
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
$(document).ready(function(){
	var oper='${model.oper}'; //'threedb',tendb,
	var oper='${model.typ}';
	document.getElementById("precision").value='${model.nprecision}';
	if(oper=='threedb' || oper=='tendb'){
		document.getElementById("dbtab").display="block";
	}
	if(oper=='gt'){
		document.getElementById("mtab").display="none";
		
	}
	
	
});

function back()
	{
		 window.location="/irev-verdant/start.htm";
		// self.close();
	}
	
function Redirect(){
		//alert("go clicked");
		var nprecision=1;
		var deg ;	
		var testid='${model.testid}';
		var typ='${model.typ}'; // 'A'/'E'		
		var atype='${model.atype}';
		var rptheader='${model.rptheader}';
		var rptfooter='${model.rptfooter}';
		var arrsel[];
		var arrslnos[];
		var strslno= '${model.strslno}';
		var selslno="";
		nprecision=document.getElementById('precision').value;
		
		arrslnos=strslno.split(",");
		for (var i==1;i<50;i++){
			arrsel[i]=-1;
		}
		var i=0;
		var j=0;
				for (i==0;i<freqs.length;i++){				
					if(document.getElementById(arrslnos[i]).checked){					
						if(j==0){
							selslno=arrslnos[i];
							
							}
						else{
							selslno=selslno+','+arrslnos[i];
						}
						arrsel[j]=arrslnos[i];
						j=j+1;
						}	
					}
				if(selslno=="")
				{
					alert("Serial Nos not selected");
					return;
				}
				
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
			if(oper=='threedb' )
			{				
				 url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
				 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
				 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
				 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
				 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
				 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
			 
			}
			else if(oper=='tendb' )
			{				
				url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
				 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
				 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
				 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
				 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
				 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
			 
			}
			else if(oper=='gm' )
			{				
				url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
				 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
				 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
				 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
				 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
				 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
			 
			}
			if(oper=='bsbl' )
			{				
				url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
				 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
				 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
				 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
				 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
				 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
			 
			}
			if(oper=='axial' )
			{	
				if(typ=='EP'){
				
					url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
					 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
					 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
					 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
					 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
					 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
				}
				if(typ=='EN'){
					
					url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
					 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
					 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
					 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
					 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
					 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
				}
				if(typ=='E'){
					
					url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision+
					 "&s1="+arrsel[0]+"&s2="+arrsel[1]+"&s3="+arrsel[2]+"&s4="+arrsel[3]+"&s5="+arrsel[4]+"&s6="+arrsel[5]+"&s7="+arrsel[6]+"&s8="+arrsel[7]+"&s9="+arrsel[8]+"&s10="+arrsel[9]+
					 "&s11="+arrsel[10]+"&s12="+arrsel[11]+"&s13="+arrsel[12]+"&s14="+arrsel[13]+"&s15="+arrsel[14]+"&s16="+arrsel[15]+"&s17="+arrsel[16]+"&s18="+arrsel[17]+"&s19="+arrsel[18]+"&s20="+arrsel[19]+
					 "&s21="+arrsel[20]+"&s22="+arrsel[21]+"&s23="+arrsel[22]+"&s24="+arrsel[23]+"&s25="+arrsel[24]+"&s26="+arrsel[25]+"&s27="+arrsel[26]+"&s28="+arrsel[27]+"&s29="+arrsel[28]+"&s30="+arrsel[39]+
					 "&s31="+arrsel[30]+"&s32="+arrsel[31]+"&s33="+arrsel[32]+"&s34="+arrsel[33]+"&s35="+arrsel[34]+"&s36="+arrsel[35]+"&s37="+arrsel[36]+"&s38="+arrsel[37]+"&s39="+arrsel[38]+"&s40="+arrsel[39]+
					 "&s41="+arrsel[40]+"&s42="+arrsel[41]+"&s43="+arrsel[42]+"&s44="+arrsel[43]+"&s45="+arrsel[44]+"&s46="+arrsel[45]+"&s47="+arrsel[46]+"&s48="+arrsel[47]+"&s49="+arrsel[48]+"&s50="+arrsel[49];
				}
			}
			
			
			
			else if(oper=='gt' )
			{				
				url="/birt-viewer/frameset?__report=verdant/3dbWithCP_report.rptdesign&deg="+deg+"&testid="+testid+"&type="+typ+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision;
				
			}
			
		console.log("url " + url);
		
		window.frames['AppBody'].location=url;
	}
</script>

</html>