<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>  
    
<html>  
<head>  
  
    <script type="text/javascript" src="js/getscreen.js"></script> 
     <script src="js/jquery.min.js"></script>
	<script src="js/jquery-ui.min.js"></script>
	<link rel="stylesheet" href="css/jquery-ui.min.css">	
    <script src="js/Chart.js"></script>
   
    <style>
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
.canvas{
        width: 100% !important;
        max-width: 800px;
        height: auto !important;
    }
    
       </style>
</head>  
 <body > 
 <script>
 
 var ctag = [];
	var tmdsp;
 var maxindex =20;
 var curmin=0;
 var curmax=0;
 var curcnt=0;
 var tagarray = {"tagvals":[]};
 var chartno='${model.chartno}'; 
 var pbottom='${model.pbottom}'; 
 var pright='${model.pright}';
 var mname='${model.mname}';
 var ht=pageHeight();
 var wth=pageWidth();
 var timeid=4000;
 //parent.window.blur();
 
 
 window.onblur = function() {
	 setTimeout(function(){ getfocus()}, timeid);		 	 
	 };
 window.document.title=mname;
 if(chartno=='1')
 {
	 window.moveBy(pright,0);}
 if(chartno=='2')
 {//alert(chartno);
	 window.moveBy(0,pbottom);
	 var win =""
 }
 if(chartno=='3')
 {	//alert(chartno);
	 window.moveBy(pright,pbottom);}
 
  </script>
 
 <table style="background-color:#000000;">
 <tr style="background-color:#000000;">
	<td style="background-color:#BCBEBC;width:20;height=20">
	<button  style="background-color:#BCBEBC" id ="btnfirst" onclick='refresh(1)' title="First"><img src ="/ireveal-base/img/first.png"></button></td>
	<td style="background-color:#BCBEBC;width:20;height=20"><button  style="background-color:#BCBEBC" id ="btnprevious" onclick='refresh(2)' title="Previous"><img src ="/ireveal-base/img/previous.png"></button></td>
	<td style="background-color:#BCBEBC;width:20;height=20"><button  style="background-color:#BCBEBC" id ="btnnext" onclick='refresh(3)' title="Next"><img src ="/ireveal-base/img/next.png"></button></td>
	<td style="background-color:#BCBEBC;width:20;height=20"><button  style="background-color:#BCBEBC" id ="btnlast" onclick='refresh(4)' title="Last"><img src ="/ireveal-base/img/last.png"></button></td>
	<td style="background-color:#BCBEBC;width:20;height=20"><label><font color="#BCBEBC">............</font></label></td>
	<td><button  style="font-size:60%;" class="refreshtoggle">Stop Refresh</button> </td>	
	</tr>
</table>

	
		<input type="hidden" id="tagid" value="${model.tagid}">		
			<div id="divcanvas">
				<canvas id="idcanvas" height="400" width="800"></canvas>
			</div>	
    </body> 
    
 <script>
	// Global variables
	var chartrefresh_tmr = 0;
	var chartrefresh_time = 10000; // Default autorefresh duration 10,000 ms
	var lineChartData = {
			labels : [],
			datasets : [
				{
					label: "My First dataset",
					fillColor : "rgba(98,178,193,0.5)",
					strokeColor : "rgba(220,220,220,1)",
					pointColor : "rgba(220,220,220,1)",
					pointStrokeColor : "#fff",
					pointHighlightFill : "#fff",
					pointHighlightStroke : "rgba(120,220,220,1)",
					data : []
				}
			]
	}
		
	var mychart;
		var resetCanvas = function(){
			console.log('came to resetCanvas');
			  $('#idcanvas').remove(); // this is my <canvas> element
			  $('#divcanvas').append('<canvas id="idcanvas" class="canvas"></canvas>');
			  canvas = document.querySelector('#idcanvas');
			  ctx = canvas.getContext('2d');
			//  ctx.canvas.width = $('#graph').width(); // resize to parent width
			 // ctx.canvas.height = $('#graph').height(); // resize to parent height
			  var x = canvas.width/2;
			  var y = canvas.height/2;
			  ctx.font = '10pt Verdana';
			  ctx.textAlign = 'center';
			  ctx.fillText('This text is centered on the canvas', x, y);
			};

	//
	// Handler for auto refresh
	//
	$(function() {
    $( ".refreshtoggle" ).button({
      text: false,
      icons: {
    	 label: "Stop Refresh",
        primary: "ui-icon-pause"
      }
    })
    .click(function() {
		var options;
      if ( $( this ).text() === "Stop Refresh" ) { // **User pressed button to STOP autorefresh
    	//console.log('stop refresh pressed. ');
		clearInterval(chartrefresh_tmr);
		options = {
			          label: "Start Refresh",
			          icons: {
			            primary: "ui-icon-play"
			          }
			        };			   
      } else { 									 // ** User pressed button to START autorefresh
    	//console.log('start refresh pressed. '); 
		refresh(4);
		chartrefresh_tmr = setInterval(function(){refresh(4)}, chartrefresh_time);
    	options = {
          label: "Stop Refresh",
          icons: {
            primary: "ui-icon-pause"
          }
        };
      }
      $( this ).button( "option", options );
    });
  });	
	
	
			
//
// Refresh trend chart with new monitor values 
//
function refresh(cnt){
	var parwin = window.opener;
	var obj = parwin.gtobj;
	var ctagvals;
	var curtagid = document.getElementById("tagid").value;
	//console.log('came to refresh. curtagid='+curtagid);
	//mychart.clear();
	//resetCanvas();
	// Stop the auto-refresh if any button other than 'latest' is pressed
	if ((cnt == 1) || (cnt == 2) || (cnt == 3))
		stop_autorefresh();
	
	if(curmax>0){
		// mychart.destroy();
	for (i=0; i<=curcnt; i++){
		//console.log('remove i='+i);
		mychart.removeData();				
	} 
	//mychart.update();
	}
	var ctx = document.getElementById("idcanvas").getContext("2d");
	mychart = new Chart(ctx).Line(lineChartData, {
		responsive: true
	});
	window.myLine = mychart;
	if(obj !=null && obj.tagvals.length>0)
	{
	// get count of tags to update based on number of tags in json array	
	var tagindx;
	for (i=0; i<obj.tagvals.length; i++){
		//console.log('json.tagvals.len='+obj.tagvals.length);
		if (obj.tagvals[i].tagid == curtagid){
			ctagvals = obj.tagvals[i].tags;
			tagindx = i;
			break;
		}
	}
	// if no new tag values are present then return
	/*if (ctagvals.length == 0)
		return;*/
		
	// Else add new plot values to chart
	
	for (i=0; i<ctagvals.length; i++){
	//	console.log(' tag vals length = '+ctagvals.length);
		ctag[0] = ctagvals[i].val;
		tmdsp =  ctagvals[i].tm.getHours()+':'+ctagvals[i].tm.getMinutes()+':'+ctagvals[i].tm.getSeconds();
		//mychart.addData(ctag, tmdsp);
		
		tagarray.tagvals.push({"tm":tmdsp,"val":ctag[0]});
	}
	// remove elements from parent json array
	obj.tagvals[tagindx].tags.length = 0;
	}

	var intstart=0;
	var intend=0;
	if(cnt==1)
		{
		//console.log(' clicked 1');
		intstart=0;
		intend=maxindex;
		document.getElementById("btnprevious").disabled=true;
		document.getElementById("btnfirst").disabled=true;
		document.getElementById("btnnext").disabled=false;
		document.getElementById("btnlast").disabled=false;
		}
	else if(cnt==2)
		{
		//console.log(' clicked 2');
		intstart=curmin-maxindex;
		intend=curmin;
		if(intstart<0)
			{intstart=0}
		document.getElementById("btnprevious").disabled=false;
		document.getElementById("btnfirst").disabled=false;
		document.getElementById("btnnext").disabled=false;
		document.getElementById("btnlast").disabled=false;
		}
	else if(cnt==3)
	{
		//console.log(' clicked 3');
	intstart=curmax;
	intend=curmax+maxindex;
	if(intend >=tagarray.tagvals.length)
		{intend=tagarray.tagvals.length-1}
	document.getElementById("btnprevious").disabled=false;
	document.getElementById("btnfirst").disabled=false;
	document.getElementById("btnnext").disabled=false;
	document.getElementById("btnlast").disabled=false;
	}
	else if(cnt==4)
	{	
		//console.log(' clicked 4');
	intend=tagarray.tagvals.length-1;
	intstart=intend-maxindex;
	if(intstart<0)
		{intstart=0}
	document.getElementById("btnprevious").disabled=false;
	document.getElementById("btnfirst").disabled=false;
	document.getElementById("btnnext").disabled=false;
	document.getElementById("btnlast").disabled=false;
	}
	//console.log('intstart '+intstart+ ' intend'+intend);
	for (i=intstart; i<=intend; i++){
		//console.log('onload i='+i);
		 ctag[0] = tagarray.tagvals[i].val;
		 tmdsp = tagarray.tagvals[i].tm;
		 mychart.addData(ctag, tmdsp);		
		 curcnt=i;
	}
	curmin=intstart;
	 curmax=intend;
	mychart.update();
}	

//
// Stop the auto-refresh of chart. Set the icon for re-start
//
function stop_autorefresh(){
		clearInterval(chartrefresh_tmr);
		var options = {
			          label: "Start Refresh",
			          icons: {
			            primary: "ui-icon-play"
			          }
			        };	
		$( ".refreshtoggle" ).button( "option", options );
}

//
// Create an instance of chart object. Render it with monitor values
//
window.onload = function(){
	    var logdata=[];
	    var i=0;
		console.log('in windows.onload');
		console.log('model.typ ' +"${model.typ}");
		
		
		//on load data frm sampling is displayed
		if("${model.typ}"=="log"){
			console.log("log ");
			var ctag = [];
			var parwin = window.opener;
			var obj = parwin.gtobj;
			var ctagvals;
			var curtagid = document.getElementById("tagid").value;
			console.log('came to refresh. curtagid='+curtagid);
			
			// get count of tags to update based on number of tags in json array	
			var tagindx;
			for (i=0; i<obj.tagvals.length; i++){
				//console.log('json.tagvals.len='+obj.tagvals.length);
				if (obj.tagvals[i].tagid == curtagid){
					ctagvals = obj.tagvals[i].tags;
					tagindx = i;
					break;
				}
			}
			var list = ${model.meterlog};
			$.each(list, function( index, value ) {
				//alert( index + ": " + value );
				 var arr1= value.split(',');
				// console.log(arr1[0]+' '+arr1[1]);
				 ctag[0] = arr1[0];
				 tmdsp = arr1[1];
				// mychart.addData(ctag, tmdsp);
				 tagarray.tagvals.push({"tm":tmdsp,"val":ctag[0]});
			});
			
			refresh(4);
			chartrefresh_tmr = setInterval(function(){refresh(4)}, 10000);
		}		
}
		
</script>
</html>  