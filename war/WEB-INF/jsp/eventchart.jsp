<!doctype html>  
<html>  
<head>  
<!--<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
		<meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script src="js/Chart.js"></script>
    <link rel="stylesheet" type="text/css" href="irev-style.css" />
</head>  
 <body> 
 <div id="selectionbar">
 &nbsp;&nbsp;<font color="#eff0f2">
	Duration
	<select id="seldur" onchange="updatechart(this.selectedIndex, this.id)";>
		<option value="last24hrs">Last 24 hours</option>
		<option value="lastweek">Last 7 days</option>
		<option value="lastmonth">Last 30 days</option>
		<option value="lastyear">Last 365 days</option>
		<!-- <option value="custom">Specify Period</option> -->
	</select>
	Chart Type
	<select id="selctype" onchange="updatechart(this.selectedIndex, this.id)">
		<option value="dist">Distribution</option>
		<option value="Trend">Trend</option>
	</select>
<!-- 	Summarize By and custom duration search.. ***** TBD later ***********
	<select id="selsumby" disabled>
		<option value="hour">Hour</option>
		<option value="day">Day</option>
		<option value="month">Month</option>
	</select>
 
	From:<input type="date" id="fromdate" disabled>
	To:<input type="date" id="todate" disabled>
-->
	<button onclick="renderchart()" class="myButtonGo" title="Click to generate chart"> Go </button>
	</font>
	</div>
	
	<div id="chartarea">
	<table width="190" border="2" align="right">
  <tr>
    <td width="8" BGCOLOR="#F7464A"><span style="background-color:#F7464A"></span></td>
    <td width="1">Defective Meters</td>
  </tr>
  <tr>
    <td width="8" BGCOLOR="#46BFBD"><span class="style2"></span></td>
   <td width="1">Power Failure</td>
  </tr>
  <tr>
   <td width="8" BGCOLOR="#FDB45C"><span class="style2"></span></td>
   <td width="1">Parameter Exception</td>
  </tr>
  <tr>
   <td width="8" BGCOLOR="#000080"><span class="style2"></span></td>
   <td width="1">Control</td>
  </tr>
  <!--<tr>
   <td width="4"><span class="style2"></span></td>
   <td>DS4</td>
  </tr>
  <tr>
    <td width="4"><span class="style2"></span></td>
   <td>DS5</td>
  </tr>-->
</table>
	<!--<ul>
	
		<li align=right><span style="background-color:#F7464A">Defective meters</li></span>
		<li align=right><span style="background-color:#46BFBD">Power Failure</li></span>
		<li align=right><span style="background-color:#FDB45C">Parameter Exception</li></span>
	
	</ul>-->

		<div>
			<canvas id="canvas" height="250" width="700"></canvas>
		</div>
		
	</div>
	<script>
	
	var curctype = -1;
	var barchart;
	var piechart;
	var ctx;
	var climob = false;  // To indicate if invoked from desktop or mobile
	
	//
	// Specific duration search: To be activate later : TBD
	//
	function updatechart(ndx, elid){
		console.log(' came to updatechart. selectedIndex ='+ndx+',elid='+elid);
/**
		if (elid == 'seldur'){
			if (ndx == 4){
				document.getElementById("fromdate").disabled=false;
				document.getElementById("todate").disabled=false;
			}else{
				document.getElementById("fromdate").value='';
				document.getElementById("todate").value='';
				document.getElementById("fromdate").disabled=true;
				document.getElementById("todate").disabled=true;
			}
		}
*/		
	}
	
	
	
	function getLast24hrs(){
		var time = new Date();
		var hrarr = [];
		var hour = time.getHours();
		var sthr;
		if (hour == 23)
			sthr = 0;
		else
			sthr = hour+1;
		for (i=0; i<24; i++){
			hrarr.push(sthr);
			sthr++
			if (sthr == 24)
				sthr = 0;
		}
		return hrarr;
	}
	
	function getLast7days(){
		var d = new Date();
		var n;
		var lweekarr = new Array(7);
		var weekday = new Array(7);
		weekday[0] = "Sunday";
		weekday[1] = "Monday";
		weekday[2] = "Tuesday";
		weekday[3] = "Wednesday";
		weekday[4] = "Thursday";
		weekday[5] = "Friday";
		weekday[6] = "Saturday";
		
        d.setDate(d.getDate()-8)
		for (i=0; i<7; i++){
			d.setDate(d.getDate()+1);
			n = weekday[d.getDay()];
			lweekarr[i] = n;
		}
		return lweekarr;
	}

	function getLast30days(){
		var i;
		var d = new Date();
		var n;
		var lmonarr = new Array(30);
	
        d.setDate(d.getDate()-30)
		for (i=0; i<30; i++){
			d.setDate(d.getDate()+1);
			n = d.getDate();
			lmonarr[i] = n;
		}
		return lmonarr;
	}
	
	//
	// Last 12 months from current date
	function getLast12months(){
		var d = new Date();
		var stndx;
		var lmonarr = new Array(12);
		var month = new Array();
		    month[0] = "January";
		    month[1] = "February";
		    month[2] = "March";
		    month[3] = "April";
		    month[4] = "May";
		    month[5] = "June";
		    month[6] = "July";
		    month[7] = "August";
		    month[8] = "September";
		    month[9] = "October";
		    month[10] = "November";
		    month[11] = "December";
	
		stndx = d.getMonth()+1;
		if (stndx > 11)
			stndx = 0;
		for (i=0; i<12; i++){
			lmonarr[i] = month[stndx];
			stndx++;
			if (stndx > 11)
				stndx = 0;
		}
		return lmonarr;
	}
	
	
	function getLblArrNdx(labelarr, period){
		var j;
//		console.log(' going to search for :'+period+'.. in '+labelarr);
		for (j=0; j< labelarr.length; j++){
			if (labelarr[j] == period)
				break;
		}
		if (j< labelarr.length){
			console.log('lblArrNdx returns nxd = '+j);
			return j;
		}else{
			return -1;
		}
	}
	
	function initializeData(arr){
		var k ;
		for (k=0; k< arr.length; k++){
			arr[k] = 0;
		}
		return arr;
	}
	
	function renderchart(){
		var newctype = document.getElementById("selctype").selectedIndex;
		var durationndx = document.getElementById("seldur").selectedIndex;
		var selentity;
		var selentitytype;
		if (!climob){
			selentity=parent.AssetTree.selectedsection;
			selentitytype=parent.AssetTree.selectedtype;
		}
		if (selentity === undefined){
			selentity = 0;
			selentitytype = 0;
		}
		console.log(' came to renderchart. curctype='+curctype+',newctype='+newctype+',dur='+durationndx); 
		console.log('selected asset-tree entity='+selentity+',entity-type='+selentitytype);
//		var sumbyndx = document.getElementById("selsumby").selectedIndex;
		var sumbyndx = 0; // summarize-by TBD
		ctx = document.getElementById("canvas").getContext("2d");
		

		if (curctype == 0){
			console.log('Piechart.. Always destroy before re-rendering');
			if (piechart != undefined) 
				piechart.destroy();
		}
		if (curctype == 1){
			console.log('Barchart.. Always destroy before re-rendering');
			if (barchart != undefined)
					barchart.destroy();
		}

		curctype = newctype;
		
		$.ajax({
			url: "/ireveal-base/MWAPI/eventchart/"+curctype+"/"+durationndx+"/"+sumbyndx+"/"+selentity+"/"+selentitytype
		}).then(function(data) {
			console.log(' API returned # recs = '+data.chartdata.length);
			// first initialize values
			if (curctype == 0){  // Distribution chart
				pieData[0].value = 0;
				pieData[1].value = 0;
				pieData[2].value = 0;
				pieData[3].value = 0;
				for (i=0; i<data.chartdata.length; i++){
					console.log('API returned rec#:'+i+',altype='+data.chartdata[i].Alert_Type+',val='+data.chartdata[i].Alert_Cnt);
					if (data.chartdata[i].Alert_Type == 'Power Fail'){
						pieData[1].value = data.chartdata[i].Alert_Cnt;
						console.log('Updating Power Fail with val = '+data.chartdata[i].Alert_Cnt);
					}
					if (data.chartdata[i].Alert_Type == 'Defective meters'){
						pieData[0].value = data.chartdata[i].Alert_Cnt;
						console.log('Updating Def meters with val = '+data.chartdata[i].Alert_Cnt);
					}
					if (data.chartdata[i].Alert_Type == 'Param Exception'){
						pieData[2].value = data.chartdata[i].Alert_Cnt;
						console.log('Updating Param exception with val = '+data.chartdata[i].Alert_Cnt);
					}
					if (data.chartdata[i].Alert_Type == 'Control'){
						pieData[3].value = data.chartdata[i].Alert_Cnt;
						console.log('Updating Control with val = '+data.chartdata[i].Alert_Cnt);
					}
				}
				piechart = new Chart(ctx).Pie(pieData);
			}
			
			if (curctype == 1){  // Trend chart
				if (durationndx == 1){
					barChartData.labels = getLast7days();
					console.log('last 7 days:'+getLast7days()+', len of arr='+barChartData.labels.length);
				}else if (durationndx == 0){
					barChartData.labels = getLast24hrs();
					console.log('last 24 hrs:'+getLast24hrs());
				}else if (durationndx == 2){
					barChartData.labels = getLast30days();
					console.log('last 30 days:'+getLast30days());
				}else if (durationndx == 3){
					barChartData.labels = getLast12months();
					console.log('last 12 months:'+getLast12months());
				}

				var lblndx;
				barChartData.datasets[0].data = initializeData(new Array(barChartData.labels.length));
				barChartData.datasets[1].data = initializeData(new Array(barChartData.labels.length));
				barChartData.datasets[2].data = initializeData(new Array(barChartData.labels.length));
				barChartData.datasets[3].data = initializeData(new Array(barChartData.labels.length));
				console.log(' going to set the data-segments. Cnt of elements = '+data.chartdata.length);
				for (i=0; i< data.chartdata.length; i++){
					// get period val and gets its index from label array
					lblndx = getLblArrNdx(barChartData.labels, data.chartdata[i].Alert_Prd);	
					
					// based on alert type, populate appropriate datasegment array
					if (data.chartdata[i].Alert_Type == 'Defective meters'){
						console.log(' setting value in dataseg-0 '+data.chartdata[i].Alert_Cnt+',lblndx='+lblndx);
						barChartData.datasets[0].data[lblndx] = data.chartdata[i].Alert_Cnt;
					}
					if (data.chartdata[i].Alert_Type == 'Power Fail'){
						console.log(' setting value in dataseg-1 '+data.chartdata[i].Alert_Cnt+',lblndx='+lblndx);
						barChartData.datasets[1].data[lblndx] = data.chartdata[i].Alert_Cnt;
					}
					if (data.chartdata[i].Alert_Type == 'Param Exception'){
						console.log(' setting value in dataseg-2 '+data.chartdata[i].Alert_Cnt+',lblndx='+lblndx);
						barChartData.datasets[2].data[lblndx] = data.chartdata[i].Alert_Cnt;
					}
					if (data.chartdata[i].Alert_Type == 'Control'){
						console.log(' setting value in dataseg-3 '+data.chartdata[i].Alert_Cnt+',lblndx='+lblndx);
						barChartData.datasets[3].data[lblndx] = data.chartdata[i].Alert_Cnt;
					}

				}
				
//				console.log('seg0 = '+barChartData.datasets[0].data);
//				console.log('seg1 = '+barChartData.datasets[1].data);

				console.log('creating new bar chart');
				barchart = new Chart(ctx).Bar(barChartData, {
					responsive : true,
					barShowStroke: false,
					scaleShowLabels: true
				});
				window.myBar = barchart;
			}
			
		});
	}

	
	var barChartData = {
		labels : [],
		datasets : [
			{
				label : "First dataset",
				fillColor :"#F7464A",
				strokeColor : "rgba(220,220,220,0.8)",
				highlightFill: "rgba(220,220,220,0.75)",
				highlightStroke: "rgba(220,220,220,1)",
				data : []
			},
			{
				label : "Second dataset",
				fillColor : "#46BFBD",
				strokeColor : "rgba(151,187,205,0.8)",
				highlightFill : "rgba(151,187,205,0.75)",
				highlightStroke : "rgba(151,187,205,1)",
				data : []
			},
			{
				label : "Third dataset",
				fillColor : "#FDB45C",
				strokeColor : "rgba(101,187,205,0.8)",
				highlightFill : "rgba(101,187,205,0.75)",
				highlightStroke : "rgba(101,187,205,1)",
				data : []
			},
			{
				label : "Fourth dataset",
				fillColor : "#000080",
				strokeColor : "rgba(0,0,128,0.8)",
				highlightFill : "rgba(0,0,128,0.75)",
				highlightStroke : "rgba(0,0,128,1)",
				data : []
			}
		]

	}
	
	var pieData = [
				{
					value: 0,
					color:"#F7464A",
					highlight: "#FF5A5E",
					label: "Defective-Meters"
				},
				{
					value: 0,
					color: "#46BFBD",
					highlight: "#5AD3D1",
					
					label: "Power-Failure"
				},
				{
					value: 0,
					color: "#FDB45C",
					highlight: "#FFC870",
					label: "Param Exception"
				},
				{
					value: 0,
					color: "#000080",
					highlight: "#000080",
					label: "Control"
				}
			];
			
	window.onload = function(){
		if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
			climob = true;
			console.log('Invoked from mobile device');
		}else{
			console.log('Desktop. useragent = '+navigator.userAgent);
		}
		renderchart();

		}

	</script>

</body>
</html>  