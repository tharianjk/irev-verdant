<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Login Page</title>
<style>

.error {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #a94442;
	background-color: #f2dede;
	border-color: #ebccd1;
}

.msg {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px;
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1;
}

#login-box {
	width: 300px;
	padding: 20px;
	margin: 100px auto;
	background: #fff;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	border: 1px solid #000;
}


.myButton {
	-moz-box-shadow: 0px 0px 31px -4px #3dc21b;
	-webkit-box-shadow: 0px 0px 31px -4px #3dc21b;
	box-shadow: 0px 0px 31px -4px #3dc21b;
	background-color:#44c767;
	-moz-border-radius:28px;
	-webkit-border-radius:28px;
	border-radius:28px;
	border:1px solid #18ab29;
	display:inline-block;
	cursor:pointer;
	color:#ffffff;
	font-family:arial;
	font-size:17px;
	padding:4px 31px;
	text-decoration:none;
	text-shadow:0px 1px 0px #2f6627;
}
.myButton:hover {
	background-color:#5cbf2a;
}
.myButton:active {
	position:relative;
	top:1px;
}

/*   for response */
html, body, div, span,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend {
	background: transparent;
	border: 0;
	margin: 0;
	padding: 0;
	vertical-align: baseline;
}
.login { background:rgba(205, 227, 247,.9); }  
h1 { font-size: 24px; }
.loginbox { background: #444; padding: 10px; width: 400px; margin: 4% auto 0 auto; position: relative; }
.loginboxinner { 
	background: #fff; padding: 20px; position: relative; border: 1px solid #333;
	-moz-box-shadow: inset 0 1px 0 #444; -webkit-box-shadow: inset 0 1px 0 #444; box-shadow: inset 0 1px 0 #444;
}
.loginheader { height: 40px; }
.loginform { margin-top: 20px; }

.loginbox h1 { font-size: 30px; letter-spacing: 1px; color: #555; font-weight: normal; padding-top: 10px; }
.loginbox .logo {position: absolute; top: 10px; right: 20px; }
.logo img { height:70px; width:150px; }
.loginbox p { margin: 10px 0 15px 0; }
.loginbox label { display: block; color: #666; letter-spacing: 1px; font-size: 18px; }
.loginbox input { 
	padding: 12px 10px; background: #282828; color: #ccc; 
	font-family: Arial, Helvetica, sans-serif; margin-top: 8px; font-size: 15px; border: 0; width: 340px; 
	-moz-box-shadow: 0 1px 0 #444; -webkit-box-shadow: 0 1px 0 #444; box-shadow: 0 1px 0 #444; outline: none; 
}
.loginbox button { 
	background: #999; padding: 10px 20px; font-size: 18px; border: 0; letter-spacing: 1px; color: #333; width: 100px;
	-moz-box-shadow: 1px 1px 3px #222; -webkit-box-shadow: 1px 1px 3px #222; box-shadow: 1px 1px 3px #222; cursor: pointer;
}
.loginbox button.default { background: #999; color: #333; }
.loginbox button.hover { background: #ccc; color: #000; }
.loginbox button:active { background: #111; color: #fff; }
.loginerror { color: #990000; background: #fbe3e3; padding: 0 10px; overflow: hidden; display: none; }
.loginerror { -moz-border-radius: 2px; -webkit-border-radius: 2px; border-radius: 2px; }
.loginerror p { margin: 10px 0; }

.radius { -moz-border-radius: 3px; -webkit-border-radius: 3px; border-radius: 3px; }
.title { font-family: 'BebasNeueRegular', Arial, Helvetica, sans-serif; }


@media screen and (max-width: 430px) {
	
	body { font-size: 11px; }
	button, input, select, textarea { font-size: 11px; }
	
	.loginbox { width: auto; margin: 10px; }
	.loginbox input { width: 95%; }
	.loginbox button { width: 50%; }
}	

</style>
</head>
<!--<body onload='document.loginForm.username.focus();'>-->

<body class="login">
<script>
var purl=window.parent.location.href;
var n=purl.indexOf('start.htm');
if(n>0 )
	{
window.parent.location.href = 'start.htm';   }
//console.log("lgin" +window.parent.location.href);
</script>
<c:if test="${param.login_error == 2}">
	<br>
	<h2 class="red">Your session has timed out.</h2>
</c:if>

<div id="ad" style="width:100%">

</div>
<div class="loginbox radius">
<!--<h2 style="color:#FFF; text-align:center">Ireveal Technologies</h2>-->
	<div class="loginboxinner radius">
    	<div class="loginheader">
    		<h1 class="title">Login</h1>
        	<div class="logo"><a href="http://www.ireveal.in/"><img src="http://www.ireveal.in/wp-content/uploads/2014/09/Logo.png" title="www.ireveal.in"/></a></div>
    	</div><!--loginheader-->
        
        <div class="loginform">
	        <c:if test="${not empty error}">
				<div class="error"><fmt:message key="login.error"/></div>
			</c:if>
			<c:if test="${not empty msg}">
				<div class="msg"><fmt:message key="login.msglogout"/></div>
			</c:if>
                	
        	<form id="login" action="<c:url value='/j_spring_security_check' />" method='POST'>
            	<p>
                	<label for="username" class="bebas">User Name</label>
                    <input type="text" id="username" name="username" value="" class="radius2" />
                </p>
                <p>
                	<label for="password" class="bebas">Password</label>
                    <input type="password" id="password" name="password"  class="radius2" />
                </p>
                <p>
                	<input name="submit" type="submit" class="myButton" title="Click to login"
						value="Login" />
				</p>
            		<input type="hidden" name="${_csrf.parameterName}" 	value="${_csrf.token}" />
            </form>				
        </div><!--loginform-->
    </div><!--loginboxinner-->
</div><!--loginbox-->

<div id="ad" style="width:100%; margin-top:50px;">

</div>



<p style="font-size:12px;">
  <center>
    <!--<a href="http://www.intelcon.in/">Ireveal Technologies</a>-->
  </center>
</p>

</body>


</html>