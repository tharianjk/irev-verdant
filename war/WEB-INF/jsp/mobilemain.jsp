<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/include.jsp" %>
<html lang="en" class="no-js">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
		<title>iReveal-Mobile</title>
		<meta name="description" content="Multi-Level Push Menu: Off-screen navigation with multiple levels" />
		<meta name="keywords" content="multi-level, menu, navigation, off-canvas, off-screen, mobile, levels, nested, transform" />
		<meta name="author" content="Codrops" />
		<link rel="shortcut icon" href="../favicon.ico">
		<link rel="stylesheet" type="text/css" href="css/normalize.css" />
		<link rel="stylesheet" type="text/css" href="css/demo.css" />
		<link rel="stylesheet" type="text/css" href="css/icons.css" />
		<link rel="stylesheet" type="text/css" href="css/component.css" />
		<script src="js/modernizr.custom.js"></script>
	</head>
	<body>
	<c:url value="/j_spring_security_logout" var="logoutUrl" />
	<form action="${logoutUrl}" method="post" id="logoutForm">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
	</form>
		<div class="container">
		
			<!-- Push Wrapper -->
			<div class="mp-pusher" id="mp-pusher">
			<a href="javascript:formSubmit()" class="logout" title="Press here to logout">Logout</a>

				<!-- mp-menu -->
				<nav id="mp-menu" class="mp-menu">
				
					<div class="mp-level">
					
						<h2 class="icon icon-world">All Categories</h2>
						<ul>
							<li class="icon icon-arrow-left">
								<a class="icon icon-bulb" href="#">Alert</a>
								<div class="mp-level">
									<h2 class="icon icon-bulb">Alert</h2>
									<a class="mp-back" href="#">back</a>
									<ul>
										<li><a href="tools.htm?oper=alert">Grid</a></li>
										<li><a href="tools.htm?oper=eventanalysis">Charts</a></li>									
									</ul>
								</div>
							</li>
							<!--<li class="icon icon-arrow-left">
								<a class="icon icon-news" href="#">Reports</a>
								<div class="mp-level">
									<h2 class="icon icon-news">Reports</h2>
									<a class="mp-back" href="#">back</a>
									<ul>
										<li class="icon icon-arrow-left">
											<a class="icon icon-note" href="#">Quality</a>
											<div class="mp-level">
												<h2 class="icon icon-note">Quality</h2>
												<a class="mp-back" href="#">back</a>
												<ul>
													<li><a href="#">Attribute</a></li>
													
												</ul>
											</div>
										</li>
										<li class="icon icon-arrow-left">
											<a class="icon icon-note" href="#">Usage</a>
											<div class="mp-level">
												<h2 class="icon icon-note">Usage</h2>
												<a class="mp-back" href="#">back</a>
												<ul>
													<li><a href="#">Trend</a></li>
													
												</ul>
											</div>
										</li>
										<li class="icon icon-arrow-left">
											<a class="icon icon-note" href="#">Supply</a>
											<div class="mp-level">
												<h2 class="icon icon-note">Supply</h2>
												<a class="mp-back" href="#">back</a>
												<ul>
													<li><a href="#">Supply Trend</a></li>
													<li><a href="#">Cost Trend</a></li>
													
												</ul>
											</div>
										</li>
										
										
									</ul>
								</div>
							</li>-->
							<li class="icon icon-arrow-left">
								<a class="icon icon-settings" href="#">Tools</a>
								<div class="mp-level">
									<h2 class="icon icon-settings">Tools</h2>
									<a class="mp-back" href="#">back</a>
									<ul>
										<li class="icon icon-arrow-left">
											<a class="icon icon-news" href="#">Logs</a>
											<div class="mp-level">
												<h2 class="icon icon-news">Logs</h2>
												<a class="mp-back" href="#">back</a>
												<ul>
													<li><a href="tools.htm?oper=registry&frm=main">Data Registry</a></li>
												</ul>
											</div>
										</li>
										<li class="icon icon-arrow-left">
											<a class="icon icon-news" href="#">Manual Entry</a>
											<div class="mp-level">
												<h2 class="icon icon-news">Manual Entry</h2>
												<a class="mp-back" href="#">back</a>
												<ul>
													<li><a href="manuallog.htm">Manual Data Entry</a></li>
												</ul>
												
												<ul>
													<li><a href="manualalertlog.htm">Manual Alert Entry</a></li>
												</ul>
											</div>
											
											
										</li>
										
									</ul>
								</div>
							</li>
							
						</ul>
							
					</div>
				</nav>
				<!-- /mp-menu -->

				<div class="scroller"><!-- this is for emulating position fixed of the nav -->
					<div class="scroller-inner">
						<!-- Top Navigation -->
						
						<header class="codrops-header">
							<h1 title="iReveal">iReveal <span></span></h1>
						</header>
						<div class="content clearfix">
							<div class="block block-40 clearfix">
								<p><a href="#" id="trigger" class="menu-trigger">Open/Close Menu</a></p>
								
							</div>
							
						</div>
					</div><!-- /scroller-inner -->
					<div id="footer">
  <p style="color:#000000">Copyright 2014 <a href="http://www.ireveal.in/">iReveal Technologies</a></p></div>
				</div><!-- /scroller -->

			</div><!-- /pusher -->
			
	
		</div><!-- /container -->
		<script src="js/classie.js"></script>
		<script src="js/mlpushmenu.js"></script>
		<script>
			new mlPushMenu( document.getElementById( 'mp-menu' ), document.getElementById( 'trigger' ), {
				type : 'cover'
			} );
			function formSubmit() {
			document.getElementById("logoutForm").submit();
		}
		</script>
		</body>
</html>