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
	selected_source_ndx=0;
	selected_prod_ndx=0; 
	selected_period_ndx=0;
	selected_sum_ndx=0;
	selected_prodasset_ndx=0;
	if(msg!=null && msg=='msg'){
		reportflashMessenger.setText('<b>Please make a Selection from the Asset Tree on the left side</b>  ');}
	if(typ=="Polar") {
		window.frames['AppBody'].location="hpolar.htm?oper=hpolar&testid="+AssetTree.selectedsection;
	AssetTree.monitorstat="Reports";}
	if(typ=="3db") {
		window.frames['AppBody'].location="xdb_bw_bs.htm?oper=db&typ="+typ+"&testid="+AssetTree.selectedsection;
		AssetTree.monitorstat="Reports";}
	if(typ=="10db") {
		window.frames['AppBody'].location="xdb_bw_bs.htm?oper=db&typ="+typ+"&testid="+AssetTree.selectedsection;
		AssetTree.monitorstat="Reports";}
	if(typ=="ar") {
		window.frames['AppBody'].location="xdb_bw_bs.htm?oper=db&typ="+typ+"&testid="+AssetTree.selectedsection;
		AssetTree.monitorstat="Reports";}
	
}
function fnHomeClick()
{
	window.location.href="start.htm";
}

function HelpClick()
{
	window.open("/reg/doc/");
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
		console.log('new pswd = '+newpswd.val()+',cfm pswd = '+cfmpswd.val());
		valid = valid && checkLength(newpswd, "Password", 3, 9);
		if (newpswd.val() != cfmpswd.val()){
			updateTips(" Confirmed password does not match with new password!");
			cfmpswd.addClass( "ui-state-error" );
			valid = false;
		}
		if ( valid ) {
			var urls = '/ireveal-base/MWAPI/updatepswd/'+$("#pswd2" ).val();
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
	
	<c:if test="${model.blnreports eq 'true'}">
		<li><a href="#"><b>Reports</b></a>
			<ul>
				<li><a href="#">Polar Report</a>
				<ul>
					<!-- <li><a rel="Polar Report" href="/birt-viewer/frameset?__report=HdataVerdant_report.rptdesign&freq=1540" TARGET="AppBody" class="menuarray" onclick="fnsetstat('Reports');">H Data Report</a></li>  -->
					<li><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('Polar');">H Data Report</a></li>				
				</ul>
				</li>
				<li><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('3db');">3db Beamwidth</a> </li>
				<li><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('10db');">10db Beamwidth</a> </li>
				<li><a rel="Polar Report" class="menuarray" TARGET="AppBody" onclick="fnsetstat('ar');">Axial Ratio</a> </li>
			</ul>
		</li>
		</c:if>
		<c:if test="${model.blnsettings eq 'true'}">
		<li><a href="#"><b>Settings</b></a>
				<ul>
					<li><a href="#">System</a><ul>											
					</ul></li>
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

//for user pref dynamically adding menu to list
var attrarr="";
var attrcnt="single";
var pagearrsrc=[];
var pagearr=[];
$(".menuarray").each(function(index, element) {
var path=	location.href;
    path=path.replace("#","");
    path=path.replace("Irev-Verdant/start.htm","");
    //console.log("path "+path);
	var strscr=element.href;
	//console.log("strscr "+strscr);
	var src=strscr.replace(path,"");
	var src=src.replace("Irev-Verdant/","");
	var srcnew=src.replace("birt-viewer","/birt-viewer");
	//console.log(srcnew);
	pagearrsrc.push(srcnew);
	
		pagearr.push(element.innerText);
});


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