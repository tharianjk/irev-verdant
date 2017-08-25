<%@ include file="/WEB-INF/jsp/include.jsp" %>
<html>
	<head>
		<title>Verdant-TestRepo</title>
		<link rel="stylesheet" type="text/css" href="irev-style.css" />
		<link rel="stylesheet" href="css/jquery-ui.css">
		<link rel="stylesheet" href="css/stylePush.css">
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
		<script type='text/javascript' src="js/popupmessage.js" ></script>
        <link rel="stylesheet" href="css/popupmessage.css">
	</head>  
<body>
<script>
/*HttpSession session = request.getSession("User");
if(session != null && !session.isNew()) {
   //do something here
} else {
    response.sendRedirect("/redirect_the_page.jsp");
}*/

var gurl1;
var gurl2;
var chartno=0;
var precision='${model.precision}';
/*if(document.getElementById) {
	window.alert = function(txt) {
		createCustomAlert(txt);
	}
}*/
function fnsetstat(typ,msg)
{
	AssetTree.monitorstat=typ;
	// Reset the following globals. These are used inside BIRT when rendering a report. We don
	// not one reports settings to get used in another report.
	
	var testid=AssetTree.selectedsection;
	var atype=AssetTree.atype;
	AssetTree.selectedreport=typ;
	var treetype=AssetTree.treeType;
	var url="";
	
	console.log("treetype "+treetype+" atype="+atype+" typ="+typ);
	
	if(atype!="V"){
		if(treetype!=2 && treetype!=4) 
		{		
			window.frames['AppBody'].location="blank.htm?oper=blank";
		}	
	}
	else{
		if(treetype!=3) 
		{		
			window.frames['AppBody'].location="blank.htm?oper=blank";
		}
	}
	if(treetype==4)
	{
			
		if(msg!=null && msg=='msg'){
			reportflashMessenger.setText('<b>Please make a Selection from the Asset Tree on the left side</b>  ');}
		if(typ=="Polar") {
			url="hpolar.htm?oper=hpolar&testid="+testid +"&atype="+atype;
			window.frames['AppBody'].location="hpolar.htm?oper=hpolar&testid="+testid +"&atype="+atype+"&treetype="+treetype;
		AssetTree.monitorstat="Reports";}
		if(typ=="pm") {
			url="hpolarmultiple.htm?oper=polarmultiple&testid="+testid +"&atype="+atype;
			window.frames['AppBody'].location="hpolarmultiple.htm?oper=polarmultiple&testid="+testid +"&atype="+atype+"&treetype="+treetype;
		AssetTree.monitorstat="Reports";}
		if(typ=="3db") {
			if( atype!="A"){
			window.frames['AppBody'].location="xdb_bw_bs.htm?oper=db&typ="+typ+"&testid="+testid+"&atype="+atype+"&treetype="+treetype;
			AssetTree.monitorstat="Reports";}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
		}
		if(typ=="10db") {
			if( atype!="A"){
			window.frames['AppBody'].location="xdb_bw_bs.htm?oper=db&typ="+typ+"&testid="+testid+"&atype="+atype+"&treetype="+treetype;
			AssetTree.monitorstat="Reports";}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
		}
		if(typ=="blobe") {
			window.frames['AppBody'].location="tools.htm?oper=blobe&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;
			if(atype=="NCP"){
				window.frames['AppBody'].location="tools.htm?oper=blobe&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;}
			else if(AssetTree.selectedparenttype=="C"){
				window.frames['AppBody'].location="tools.htm?oper=blobe&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;}
			else if(AssetTree.selectedparenttype=="S" && atype=="E" ){
				window.frames['AppBody'].location="tools.htm?oper=blobe&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
			AssetTree.monitorstat="Reports";}
		if(typ=="ar") {
			
			if(AssetTree.selectedparenttype=="C"){
				console.log("ar");
			window.frames['AppBody'].location="ar.htm?oper=ar&typ="+typ+"&testid="+testid+"&atype="+atype+"&treetype="+treetype;}
			else if(AssetTree.selectedparenttype=="S" && atype=="E"){
				window.frames['AppBody'].location="ar.htm?oper=ar&typ="+typ+"&testid="+testid+"&atype="+atype+"&treetype="+treetype;}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
			AssetTree.monitorstat="Reports";
		}
		if(typ=="rset") {
			window.frames['AppBody'].location="reportset.htm?oper=rset&typ="+typ+"&testid="+testid+"&atype="+atype+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;
			AssetTree.monitorstat="Reports";}
		if(typ=="cpg") {
			if(AssetTree.selectedparenttype=="C" && atype!="NCP"){
			window.frames['AppBody'].location="lineargain.htm?oper=cpg&typ="+typ+"&testid="+testid+"&atype="+atype+"&treetype="+treetype;
			AssetTree.monitorstat="Reports";}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
		}
		if(typ=="od") {
			
			if( AssetTree.atype=="A"){
				window.frames['AppBody'].location="tools.htm?oper=od&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;
			}
			else window.frames['AppBody'].location="blank.htm?oper=blank";
			AssetTree.monitorstat="Reports";}
  }
	if(typ=="apt" && treetype==2) 
	{
		console.log("apt");
		window.frames['AppBody'].location="ampphaserpt.htm?oper=ampphase&typ="+typ+"&prodid="+testid+"&atype="+atype+"&treetype="+treetype;
		AssetTree.monitorstat="Reports";
    }
	if(typ=="pd" ) 
	{
		console.log("pd");
		window.frames['AppBody'].location="tools.htm?oper=phasediff&atype="+AssetTree.atype+"&testid="+testid+"&ptype="+AssetTree.selectedparenttype+"&treetype="+treetype;
		AssetTree.monitorstat="Reports";
    }
	if(treetype==3){
		console.log(typ);
		if(typ=="pv_polar_a" ) 
		{			
			url="tools.htm?oper=pvpolar&typ=A&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="pv_polar_e" ) 
		{			
			url="tools.htm?oper=pvpolar&typ=E&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="three_a" ) 
		{			
			url="tools.htm?oper=threedb&typ=A&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="three_e" ) 
		{			
			url="tools.htm?oper=threedb&typ=E&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="ten_a" ) 
		{			
			url="tools.htm?oper=tendb&typ=A&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="ten_e" ) 
		{			
			url="tools.htm?oper=tendb&typ=E&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="gt" ) 
		{			
			url="tools.htm?oper=gt&typ=G&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="gm" ) 
		{			
			url="tools.htm?oper=gm&typ=G&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="a_bs_bl" ) 
		{			
			url="tools.htm?oper=bsbl&typ=A&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="e_bs_bl" ) 
		{			
			url="tools.htm?oper=bsbl&typ=E&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="axial_e" ) 
		{			
			url="tools.htm?oper=axial&typ=E&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="axial_ep" ) 
		{			
			url="tools.htm?oper=axial&typ=EP&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		else if(typ=="axial_en" ) 
		{			
			url="tools.htm?oper=axial&typ=EN&testid="+testid+"&atype="+AssetTree.atype+"&treetype="+treetype;
			window.frames['AppBody'].location=url;
			AssetTree.monitorstat="Reports";
	    }
		
		
	}
	
	
	console.log("url "+url);
}
function fnHomeClick()
{
	window.location.href="start.htm";
}

function HelpClick()
{
	window.open("/doc-verdant/");
}
 function userpwdclick()
{

dialog = $( "#dialog-form-pswd" ).dialog({
	      autoOpen: false,
	      height: 300,
	      width: 350,
	      modal: true,
	      buttons: {
	        "Save": modPswd,
	        Cancel: function() {
	          dialog.dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.removeClass( "ui-state-error" );
	      }
	    });  
dialog.dialog( "open" );
}
 
 var dialog, form,
	newpswd = $( "#pswd1" ),
	cfmpswd = $( "#pswd2" ),
	allFields = $( [] ).add( newpswd ).add( cfmpswd )
	tips = $( ".validateTips" );
	
	function updateTips( t ) {
      tips
        .text( t )
        .addClass( "ui-state-highlight" );
      setTimeout(function() {
        tips.removeClass( "ui-state-highlight", 1500 );
      }, 500 );
    }
	
	// check lenght of new password
	function checkLength( o, n, min, max ) {
      if ( o.val().length > max || o.val().length < min ) {
        o.addClass( "ui-state-error" );
        updateTips( "Length of " + n + " must be between " +
          min + " and " + max + "." );
        return false;
      } else {
        return true;
      }
    }
 
 function modPswd() {
        var valid = true;
        newpswd = $( "#pswd1" ),
    	cfmpswd = $( "#pswd2" ),
    	allFields = $( [] ).add( newpswd ).add( cfmpswd )
    	tips = $( ".validateTips" );
		console.log('new pswd = '+newpswd.val()+',cfm pswd = '+cfmpswd.val());
		valid = valid && checkLength(newpswd, "Password", 3, 9);
		if (newpswd.val() != cfmpswd.val()){
			updateTips(" Confirmed password does not match with new password!");
			cfmpswd.addClass( "ui-state-error" );
			valid = false;
		}
		if ( valid ) {
			var urls = '/irev-verdant/MWAPI/updatepswd/'+$("#pswd2" ).val();
			$.ajax({
				type: "GET",
				url: urls,
				error: function(XMLHttpRequest, textStatus, errorThrown)  {
							alert("An error has occurred making the request: " + errorThrown)
						},
			});
			dialog.dialog( "close" );
		}
		return valid;
	}
	function userprefclick()
	{
		$("#userprefdialog").attr('src', "userpref.htm");
			dialogup =$("#dialog-form-upref").dialog({
	            width: 500,
	            height: 350,
	            modal: true,overflow: false,
	            close: function () {
	                $("#userprefdialog").attr('src', "about:blank");
	            }
	        });
	
	}
</script>

<div id="topbar">
	<div id="companylogo">
	
	</div>
	<div id="treectrld" class="ui-widget-header ui-corner-all">
  			<button id="treectrlb"></button>
	</div>	
	<div id="customerlogo">
	</div>
	
<div id="menubar">
 <nav>
	<ul>
	<c:if test="${model.blntools eq 'true'}">
	<li><a rel="reportset" id="rset" class="menuarray" TARGET="AppBody" onclick="fnsetstat('rset');"><b>Report Set</b></a></li>
	</c:if>
	<c:if test="${model.blnreports eq 'true'}">
		<li id="reports"><a href="#"><b>Reports</b></a>
		
			<ul>
			    <li id="od" style="display:none;"><a rel="Omini Devation" class="menuarray" TARGET="AppBody" onclick="fnsetstat('od');">Omni Devation</a> </li>
				<li id="pp" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('Polar');">Polar Plot</a></li>				
				<li id="3db" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('3db');">3db Beamwidth</a> </li>
				<li id="10db" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('10db');">10db Beamwidth</a> </li>
				<li id="blobe" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('blobe');">Back-lobe</a> </li>
				<li id="ar" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('ar');">Axial Ratio</a> </li>
				<li id="cpg" style="display:none;"><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('cpg');">CP Gain</a> </li>
				<li id="apt" ><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('apt');">Amplitude & Phase Tracking</a> </li>
				<li id="pd" ><a rel="Phase Diff Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('pd');">Phase Difference</a> </li>
			</ul>
			</li>
		<li id="vreports" title="VT-JK S10 L ATP-2 REV 00" style="display:none"><a href="#"><b> Reports</b></a>
		
			   
			<ul>
			 <li><a rel="Gain Measurement" id="pv_rgm" class="menuarray" TARGET="AppBody" onclick="fnsetstat('gm');">Gain Measurement</a> </li>			
			 <li><a rel="Gain Tracking" id="pv_rgt" class="menuarray" TARGET="AppBody" onclick="fnsetstat('gt');">Gain Tracking</a> </li>			
			<li><a rel="three_e" id="pv_r3db" class="menuarray" TARGET="AppBody" onclick="fnsetstat('three_e');">3dB beamwidth</a> </li>
			<!-- <li><a rel="three_a" class="menuarray" TARGET="AppBody" onclick="fnsetstat('three_a');">3dB beamwidth Elevation</a> </li>
			<li><a rel="ten_a"  class="menuarray" TARGET="AppBody" onclick="fnsetstat('ten_a');">10dB beamwidth Azimuth</a> </li> -->
			<li><a rel="ten_e" id="pv_r10db" class="menuarray" TARGET="AppBody" onclick="fnsetstat('ten_e');">10 dB beamwidth</a> </li>
			<li><a rel="a_bs_bl" id="pv_rbsbla" class="menuarray" TARGET="AppBody" onclick="fnsetstat('a_bs_bl');"> Azimuth Beam Squint and Backlobe level</a> </li>
			<li><a rel="e_bs_bl" id="pv_rbsble" class="menuarray" TARGET="AppBody" onclick="fnsetstat('e_bs_bl');">Elevation Beam Squint and Backlobe level</a> </li> 
			<li><a rel="axial_e" id="pv_ra" class="menuarray" TARGET="AppBody" onclick="fnsetstat('axial_e');">Axial Ratio Measurement </a> </li>
			<!-- <li><a rel="axial_ep" class="menuarray" TARGET="AppBody" onclick="fnsetstat('axial_ep');">Axial Ratio Measurement +45 DEG</a> </li>
			<li><a rel="axial_en" class="menuarray" TARGET="AppBody" onclick="fnsetstat('axial_en');">Axial Ratio Measurement -45 DEG</a> </li> -->
			<li><a rel="polar_a" id="pv_rpa" class="menuarray" TARGET="AppBody" onclick="fnsetstat('pv_polar_a');">Azimuth Radiation Pattern </a> </li>
			<li><a rel="polar_e" id="pv_rpe"class="menuarray" TARGET="AppBody" onclick="fnsetstat('pv_polar_e');">Elevation Radiation Pattern</a> </li>
			<!-- <li><a rel="Gain Measurement" class="menuarray" TARGET="AppBody" onclick="fnsetstat('gt');">Gain Tracking</a> </li>
			<li><a rel="Gain Measurement" class="menuarray" TARGET="AppBody" onclick="fnsetstat('gm');">Gain Measurement</a> </li>
		    -->
			</ul>
		
		</li>
		
		</c:if>
		<c:if test="${model.blnsettings eq 'true'}">
		<li><a href="#"><b>Settings</b></a>
				<ul>
					
					<li><a href="edittree.htm?treemode=edit" onclick="fnsetstat('Settings');" TARGET="AppBody">Asset-Tree</a></li>		
					<li><a href="setup.htm?oper=user" onclick="fnsetstat('Settings');" TARGET="AppBody">Manage Users</a></li>
					<li><a href="setup.htm?oper=role" onclick="fnsetstat('Settings');" TARGET="AppBody">Manage Roles</a></li>						
				</ul>
		</li>
		</c:if>
		
	</ul>
</nav>
</div>


	
<nav class="menu slide-menu-right">
    <ul>
       <li><button class="close-menu" title="Close">X</button></li>
         <li><a href="#" title="User Preference" onclick="userprefclick()"  >User Preference</a></li>
        <li><a href="#" title="Change Password" onclick="userpwdclick()" >Change Password</a></li>
    </ul>
</nav><!-- /slide menu right -->


<div id="settingsbar">
<table>
  <tr id='prefmenu'>
<td>
 <a href="JavaScript:HelpClick()"><img src="img/help.png"  title ="Help" width="30" height="30"></a>
</td>

  <td>
	<div id="wrapper">
<div id="main">
        <div class="container">
			 <a href="#">	 <img src="img/Settings.png" title="Settings" class="nav-toggler toggle-slide-right" alt="Settings" height="30px" width="30px"></a>
        </div>
</div><!-- #main -->

</div>
<script src="js/classiepush.js"></script>
		<script src="js/nav.js"></script>
     
	  	

    </td>
	
  </tr>
</table>
</div>

	<c:url value="/j_spring_security_logout" var="logoutUrl" />
	<form action="${logoutUrl}" method="post" id="logoutForm">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
		
		
	</form>
	
	<c:if test="${pageContext.request.userPrincipal.name != null}">
		<div id="username">
			Welcome : ${pageContext.request.userPrincipal.name} | <a href="javascript:formSubmit()"> Logout</a>
		</div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <small><i style="color:SeaGreen">Version: V1.3, Year: 2017</i></small>
	</c:if>

</div>

<div id="dialog-form-pswd" title="Change Password" style="display:none;">
  <p class="validateTips">All form fields are required.</p>
 
  <form>
    <fieldset>
      <label for="name">New Password</label>
      <input type="password" name="password1" id="pswd1" >
      <label for="password">Confirm Password</label>
      <input type="password" name="password2" id="pswd2">
    </fieldset>
  </form>
</div>
<div id="dialog-form-upref" title="User Preference" style="display:none;overflow:hidden;border:none">
    <iframe id="userprefdialog" width="500" height="400" style="overflow:hidden;border:none" ></iframe>
</div>

				
</div>
<script>



		function formSubmit() {
			document.getElementById("logoutForm").submit();
		}
		
</script>

<div id="treecrumbs" name="treecrumbs" frameborder="0" scrolling="no" width="100%" height="10%" 
align="top" style="font-size: 14px;font-weight: bold;left:16%;display:block;padding-left: 16%;" >${model.compname}</div>
	
<iframe id="AssetTree" name="AssetTree" src="assettree.htm" frameborder="1" scrolling="yes" width="15%" height="80%" 
marginwidth="0" marginheight="0" align="left"  >
</iframe>
 
<iframe id="AppBody" name="AppBody" src="${model.favmenu}" frameborder="1" scrolling="yes" width="84%" height="85%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>
<script language="javascript" type="text/javascript">
	
	var compid=${model.compid};
	
  $(document).ready(function(){
        AssetTree.selectedname="${model.usrsecname}";
		AssetTree.selectedtype=${model.seltype};
		
    $("#prefmenu").menu( { position: { my: "left top", at: "center bottom" } } );
	

	<!-- *******Overlay support code begins ********************-->
	    
	
	$("#elpswdmodl").click(function(){
		 dialog.dialog( "open" );
	});
	<!-- over lay for user pref -->
	$("#overlayupref").click(function(){
			$("#userprefdialog").attr('src', "userpref.htm");
			dialogup =$("#dialog-form-upref").dialog({
	            width: 500,
	            height: 350,
	            modal: true,overflow: false,
	            close: function () {
	                $("#userprefdialog").attr('src', "about:blank");
	            }
	        });
			// dialog.dialog( "open" );
		});

	  <!-- *******Overlay support code ends ********************-->
	});
// to close dialog after saving user pref 
    $(document).on('dialog-close', function() {
	    $('#dialog-form-upref').dialog('close');
	});	

  $(function() {
		<!-- ******* Tree Slide code begins ********************-->
      $( "#treectrld").button({
        text: false,
  	  	label:"Close Tree",
        icons: {
          primary:  "ui-icon-folder-collapsed"
		 
        }
      })
      .click(function() {
  		var options;
  		console.log(' text in button : '+$( this ).text());
          if ( $( this ).text().indexOf("Close") != -1 ) { // **User pressed button to Close Tree
			$("#AssetTree").slideUp("slow");
  			document.getElementById("AppBody").width="100%";
  			options = {
  			    label: "Open Tree",
  			    icons: {
				primary:  "ui-icon-folder-open"
  			      
					
  			          }
  			    };			
  		} else { 									 // ** User pressed button to Open tree	
  			$("#AssetTree").slideDown("slow");
  			document.getElementById("AppBody").width="84%";
  			options = {
  			    label: "Close Tree",
  			    icons: {
  			        primary:"ui-icon-folder-collapsed"
  			          }
  		    };	
  		}
        $( this ).button( "option", options );
      });
    }); 
  
</script>
	
</body>
</html>