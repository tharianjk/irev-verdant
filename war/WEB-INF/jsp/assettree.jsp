
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<html>
<head>

<title>iReveal EMS</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
<script type="text/javascript" src="js/jquery.js"></script>

<script type="text/javascript" src="js/jquery.jstree.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script type="text/javascript" src="js/jquery.hotkeys.js"></script>
<link rel="stylesheet" href="css/jquery-ui.css">
<script src="js/jquery-ui.js"></script>
<script type='text/javascript' src="js/popupmessage.js"></script>
<link rel="stylesheet" href="css/popupmessage.css">

</head>
<body>

	<div id="jsTreeComponent" class="demo" style="max-width: 100%;"></div>


	<script>
 $(document).ready(function () {
	   //alert("selectedname "+selectedname);
		var parmdelete='<%=request.getParameter("deletemsg")%>';
		if(parmdelete!=null && parmdelete!="" && parmdelete!="null" )
			{
			//alert (parmdelete);
			flashMessenger.setText('${param.deletemsg}');
           var strtype='<%=request.getParameter("strType")%>';
           
           var strscr=parent.frames['AppBody'].location.href;
           var i=0;
           var pp="";
         
           //alert(strscr);
          var n = strscr.indexOf(strtype);
	      if(n >-1)
	       	  {
	    	  parent.frames['AppBody'].location='edittree.htm?treemode=edit';
	       	  }
			}
		 
});
var monitorstat;
var treemode='<%=request.getParameter("treemode")%>';

// alert('<%=request.getParameter("treemode")%>');
 //alert("parm " + ${param.treemode});
 </script>

	<script>
    var selectedreport;
    var atype;
    var parents = [];
    var selectedsection;
    var selectedtype;
    var selectedname;
    var selectedparent;
    var selectedparenttype;  // Can have values of 'S', 'L' or 'C'
    var parentname;
    var array_id=[];
    var array_data=[];
    array_data.push(" INTELCON ");
    array_id.push(1);
    var treeType="";
    $(function () {
    	
    	 $("#jsTreeComponent").jstree("refresh");
        $("#jsTreeComponent").jstree({
            "json_data" : {
                            "ajax" : {
                                "url" : '<%=request.getContextPath()%>/GetJSON',
                                "data" : function (n) {
                                	//array_data.push(n.attr('Assetname'));
                                    return { 
                                        "operation" : "get_children", 
                                        "id" : n.attr ? n.attr("id").replace("node_","") : 1 
                                        		
                                    };
                                }
                            }
            },
            cache: false,
                        "themes" : {
                            "theme" : "apple",                            
                            "icons" : true
                            , "url": "<%=request.getContextPath()%>/js/themes/apple/style.css"
                        },
            "plugins" : [ "themes", "json_data", "ui","contextmenu", "types"], 
            "types" : {
                "valid_children" : [ "default" ],
                "use_data" : true,
                "types" : {
                    "default" : {
                        "valid_children" : ["none"]
                    } ,
                    "Company" : {
                        "icon" : {
                            "image" : "<%=request.getContextPath()%>/js/themes/TreeIcons/company.png"
                        }
                    } ,
                    "Product" : {
                        //"valid_children" : ["none"],
                        "icon" : {
                            "image" : "<%=request.getContextPath()%>/js/themes/TreeIcons/location.png",
                            "check_node" : false,
                            "uncheck_node" : false
                        }
                    } ,
                    "ProductSer" : {
                        "icon" : {
                            "image" : "<%=request.getContextPath()%>/js/themes/TreeIcons/section.png",
                            "check_node" : false,
                            "uncheck_node" : false
                        }
                    },
                    "TestData" : {
                        "icon" : {
                            "image" : "<%=request.getContextPath()%>/js/themes/TreeIcons/asset.png",
                            "check_node" : false,
                            "uncheck_node" : false
                        }
                    },
                    "TestFiles" : {
                        "icon" : {
                            "image" : "<%=request.getContextPath()%>/js/themes/TreeIcons/tag.png",
                            "check_node" : false,
                            "uncheck_node" : false
                        }
                    }
                }
            },            
            "contextmenu": {
                "items": customMenu}                      
        });    
       
       
                $("#jsTreeComponent").bind("select_node.jstree", function (e, data) {
                	console.log("click");
                	var node = $.jstree._focused().get_selected();
                	 treeType=node.attr('treeType')
                	if(treeType!=1){
                		parent_node = $.jstree._reference('#jsTreeComponent')._get_parent(node);
                		selectedparent=parent_node.attr('Assetname');
                	}                	
               	    var url ='';	
    					selectedname=node.attr('Assetname');
    					selectedtype=node.attr('treeType');
    					atype=node.attr('atype');
    					var pvtype=node.attr('pvtype');
    					console.log("pvtype="+pvtype);
    					console.log("selectedtype="+selectedtype);
    			        selectedsection=node.attr('assetId');
    			        if(selectedtype!=1)
    			        selectedparenttype=parent_node.attr('atype');
    			        //console.log(" selectedparenttype ="+selectedparenttype)
    			        if(selectedtype==4)
    			        {
    			        	//parent.document.getElementById("pm").style.display="block";
    			        if ((atype=="A") )
    			        	{
    			        	  parent.document.getElementById("rset").style.display="block";
    			        	  parent.document.getElementById("vreports").style.display="none";
    			        	  parent.document.getElementById("reports").style.display="inline-block";
    			        	  parent.document.getElementById("od").style.display="block";
	  			        	  parent.document.getElementById("ar").style.display="none";
	  			        	  parent.document.getElementById("pp").style.display="block";
	  			        	  parent.document.getElementById("3db").style.display="none";
	  			        	  parent.document.getElementById("10db").style.display="none";
	  			        	  parent.document.getElementById("cpg").style.display="none";
	  			        	  parent.document.getElementById("blobe").style.display="none";
	  			        	  parent.document.getElementById("apt").style.display="none";
	  			        	  parent.document.getElementById("pd").style.display="none";
    			        	}
    			        else if ((atype=="E") && (selectedparenttype == 'L'))
			        	{
    			          parent.document.getElementById("rset").style.display="block";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="inline-block";
			        	  parent.document.getElementById("od").style.display="none";
  			        	  parent.document.getElementById("ar").style.display="none";
  			        	  parent.document.getElementById("pp").style.display="block";
  			        	  parent.document.getElementById("3db").style.display="block";
  			        	  parent.document.getElementById("10db").style.display="block";
  			        	 // parent.document.getElementById("10db").innerHTML="10dB Beamwidth ";
  			        	 // parent.document.getElementById("3db").innerHTML="3dB Beamwidth ";
  			        	  parent.document.getElementById("cpg").style.display="none";
  			        	 parent.document.getElementById("blobe").style.display="none";
  			        	parent.document.getElementById("apt").style.display="none";
  			        	parent.document.getElementById("pd").style.display="none";
			        	}
						else if ((atype=="E") && (selectedparenttype == 'S'))
			        	{
						  parent.document.getElementById("rset").style.display="block";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="inline-block";
			        	  parent.document.getElementById("od").style.display="none";
  			        	  parent.document.getElementById("ar").style.display="block";
  			        	  parent.document.getElementById("pp").style.display="block";
  			        	  parent.document.getElementById("3db").style.display="block";
  			        	  parent.document.getElementById("10db").style.display="block";
  			        	  parent.document.getElementById("cpg").style.display="none";
  			        	 parent.document.getElementById("blobe").style.display="block";
  			        	parent.document.getElementById("apt").style.display="none";
  			        	parent.document.getElementById("pd").style.display="none";
			        	}
    			        else if(atype=="CP")
			        	{
    			          parent.document.getElementById("rset").style.display="block";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="block";
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="block";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="block";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	  parent.document.getElementById("apt").style.display="none";
			        	}
    			        else if(atype=="DCP")
			        	{
    			          parent.document.getElementById("rset").style.display="block";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="block";
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="none";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="block";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	  parent.document.getElementById("apt").style.display="none";
			        	}
    			        else if(atype=="NCP")
			        	{	
    			        	//alert("NCP");
    			          parent.document.getElementById("rset").style.display="block";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="block";
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="block";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="none";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	  parent.document.getElementById("apt").style.display="none";
			        	  parent.document.getElementById("pd").style.display="none";
			        	}
    			        else if(atype=="PD")
			        	{	
    			        	//alert("NCP");
    			          parent.document.getElementById("rset").style.display="none";
  			        	  parent.document.getElementById("vreports").style.display="none";
  			        	  parent.document.getElementById("reports").style.display="none";
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="none";
			        	  parent.document.getElementById("pp").style.display="none";
			        	  parent.document.getElementById("3db").style.display="none";
			        	  parent.document.getElementById("10db").style.display="none";
			        	  parent.document.getElementById("cpg").style.display="none";
			        	  parent.document.getElementById("blobe").style.display="none";
			        	  parent.document.getElementById("apt").style.display="none";
			        	  parent.document.getElementById("pd").style.display="block";
			        	}
    			        
    			        }
    			        
    			        else
    			        	{
    			        	console.log("atype ="+atype);
    			        	if(atype!='V'){
	    			        	parent.document.getElementById("od").style.display="none";
	  			        	    parent.document.getElementById("ar").style.display="none";
	  			        	    parent.document.getElementById("pp").style.display="none";
	  			        	    parent.document.getElementById("3db").style.display="none";
	  			        	    parent.document.getElementById("10db").style.display="none";
	  			        	    parent.document.getElementById("cpg").style.display="none";
	  			        	    parent.document.getElementById("blobe").style.display="none";
	  			        	    parent.document.getElementById("apt").style.display="none";
	  			        	    parent.document.getElementById("rset").style.display="block";
				        	    parent.document.getElementById("vreports").style.display="none";
				        	    parent.document.getElementById("reports").style.display="block";
    			        	}
    			        	else{
    			        		if(pvtype=="GM"){
    			        			parent.document.getElementById("rset").style.display="none";
    			        			parent.document.getElementById("vreports").style.display="block";
		  			        	    //parent.document.getElementById("vreports").style.display="inline";
		  			        	    parent.document.getElementById("reports").style.display="none";
		  			        	   // parent.document.getElementById("gmreports").style.display="block";
		  			        	    parent.document.getElementById("pv_rgm").style.display="block";
		  			        	    parent.document.getElementById("pv_rgt").style.display="none";
		  			        	    parent.document.getElementById("pv_r3db").style.display="none";	
		  			        	    parent.document.getElementById("pv_r10db").style.display="none";
		  			        	    parent.document.getElementById("pv_rbsbla").style.display="none";
		  			        	    parent.document.getElementById("pv_rbsble").style.display="none";	
		  			        	    parent.document.getElementById("pv_ra").style.display="none";
		  			        	    parent.document.getElementById("pv_rpa").style.display="none";
		  			        	    parent.document.getElementById("pv_rpe").style.display="none";	
    			        		}
    			        		else if(pvtype=="GT"){
    			        			
    			        			parent.document.getElementById("rset").style.display="none";
    			        			parent.document.getElementById("vreports").style.display="block";
		  			        	   // parent.document.getElementById("vreports").style.display="inline";
		  			        	    parent.document.getElementById("reports").style.display="none";
		  			        	    parent.document.getElementById("pv_rgm").style.display="none";
		  			        	    parent.document.getElementById("pv_rgt").style.display="block";
		  			        	    parent.document.getElementById("pv_r3db").style.display="none";	
		  			        	    parent.document.getElementById("pv_r10db").style.display="none";
		  			        	    parent.document.getElementById("pv_rbsbla").style.display="none";
		  			        	    parent.document.getElementById("pv_rbsble").style.display="none";	
		  			        	    parent.document.getElementById("pv_ra").style.display="none";
		  			        	    parent.document.getElementById("pv_rpa").style.display="none";
		  			        	    parent.document.getElementById("pv_rpe").style.display="none";
    			        		}
    			        		else if(pvtype=="CO"){
    			        			console.log("CO");
    			        			parent.document.getElementById("rset").style.display="none";
		  			        	    parent.document.getElementById("vreports").style.display="inline";
		  			        	    parent.document.getElementById("reports").style.display="none";
		  			        	    parent.document.getElementById("pv_rgm").style.display="none";
		  			        	    parent.document.getElementById("pv_rgt").style.display="none";
		  			        	    parent.document.getElementById("pv_r3db").style.display="block";	
		  			        	    parent.document.getElementById("pv_r10db").style.display="block";
		  			        	    parent.document.getElementById("pv_rbsbla").style.display="block";
		  			        	    parent.document.getElementById("pv_rbsble").style.display="block";	
		  			        	    parent.document.getElementById("pv_ra").style.display="block";
		  			        	    parent.document.getElementById("pv_rpa").style.display="block";
		  			        	    parent.document.getElementById("pv_rpe").style.display="block";
    			        		}
    			        		else{
		    			        	parent.document.getElementById("rset").style.display="none";
		  			        	    parent.document.getElementById("vreports").style.display="block";
		  			        	    parent.document.getElementById("reports").style.display="none";
    			        		}
    			        	}
    			        	}
    			        if(treeType==2)
    			        	{
    			        	parent.document.getElementById("apt").style.display="block";
    			        	}
    			        else{
    			        	parent.document.getElementById("apt").style.display="none";
    			        }
                	
                	//alert(" monitorstat "+monitorstat);
                	 if(monitorstat=="monitor" || monitorstat=="Reports" || monitorstat=="Events"){
                	 breadcrumbs(data);
                	 //alert(selectedreport);
                	 if(treeType==4){
                	 parent.fnsetstat(selectedreport,"");}
                	 else if(treeType==2)
                	 {
                		 if(selectedreport=="apt")
                		 parent.fnsetstat(selectedreport,"");
                		 else{
                			 parent.frames['AppBody'].location='<%=request.getContextPath()%>/blank.htm?oper=blank&text=Select Tree Node With Data'; 
                		 }
                		 
                	 }
                	 else
                		 parent.frames['AppBody'].location='<%=request.getContextPath()%>/blank.htm?oper=blank&text=Select Tree Node With Data';
                	 //var currenturl=parent.frames['AppBody'].location;
                	 //parent.frames['AppBody'].location=currenturl;
                	 }
                	 var attrarr="";
                	 var cnt=0;
                	 $.jstree._reference('#jsTreeComponent')._get_node(null, true).each(function() {
                         id = $(this).attr("assetId");
                         
                         
                          treeType=$(this).attr('treeType')
                               if(treeType==5)
                            	   {
                            	   if(cnt==0)
                            	   {attrarr=id;}
                            	   else {attrarr=attrarr+','+id;}
                            	    cnt=cnt+1;
                            	   }
                         
                       });
                	 if(cnt>1)
                		 {parent.attrcnt="multi";}
                	 else{parent.attrcnt="single";}
                	 parent.attrarr=attrarr;
                	 console.log("attrcnt: " +parent.attrcnt+" attrarr: "+parent.attrarr);
                });                
                   
                
                
                $("#jsTreeComponent").bind("dblclick.jstree", function (event) {
                	var node = $(event.target).closest("li");
                	var data = node.data("jsTreeComponent");
                	 treeType=node.attr('treeType');
                	 atype=node.attr('AType');
                	var url ='';
            if(treemode=="edit" ){            //&& treeType!=4 	  
             	 
             	 if(treeType==1)
             	 {
             	   url = '<%=request.getContextPath()%>/company.htm?ComId='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
             	 }
             	 else if(treeType==2)
         		 {
             		 
                	   url = '<%=request.getContextPath()%>/product.htm?prodid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
                 }
             	 else if(treeType==3)
         		 {
             		if(atype=="V")
             			url = '<%=request.getContextPath()%>/pvtest.htm?testid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
             		 else
                	   url = '<%=request.getContextPath()%>/productserial.htm?prodserid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
                 }
             	else if(treeType==4)
        		 {
               	   url = '<%=request.getContextPath()%>/testimport.htm?id='+ node.attr('assetId')+'&mode=edit';
                }
             	 
             	 parent.frames['AppBody'].location =url;
            }
            else{
            	if(treeType==4)
   		        {
            	   url = '<%=request.getContextPath()%>/testimport.htm?id='+ node.attr('assetId')+'&mode=edit';
            	   parent.frames['AppBody'].location =url;
                }          	 
          	 }
                	});
               // $("#jsTreeComponent").bind("open_node.jstree",function(event,data){opennode(data)});
                
    });
    
    </script>
	<script>
    
    function opennode(data)
    {
    	var mydiv =parent.document.getElementById("treecrumbs");
    	
    	var spanTag = document.createElement('span');
    	spanTag.innerHTML=' >> ';
    	mydiv.appendChild(spanTag);
    	
    	var node = data.rslt.obj;
    	array_data.push(node.attr('Assetname'));
    	array_id.push(node.attr('assetId'));
    	
		recreate();
    }
    function recreate()
    {
    	var mydiv =parent.document.getElementById("treecrumbs");
    	 $(mydiv).text('');		
    	var len1=array_data.length;
    	for (var i=0;i <len1;i++) 
    		{   	
    	
    		if(i>0)
    			{
    	var spanTag = document.createElement('span');
    	spanTag.innerHTML=' >> ';
    	mydiv.appendChild(spanTag);
    			}   	
    	
    	var aname=array_data[i];
    	var aid=array_id[i];
    	var aTag = document.createElement('a');
    	aTag.setAttribute('class',	'breadCrumb');
    	aTag.setAttribute('id',	aid);
    	
		aTag.setAttribute('href',"#");
		aTag.innerHTML = aname;
		mydiv.appendChild(aTag);
    		}
    }
    
    </script>
	<script>
    function closeNodes(aid)
    {
    	var mydiv =parent.document.getElementById("treecrumbs");
    	$(mydiv).text('');
    	var bln=0;
    	var id;
    	var len=parents.length;
    	for (var i=0;i <len;i++) 
    		{
    		id=parents[i].id;
    		if(aid == array_id[i] )
    		{
    			bln=1;
    			//alert(array_id[i]);
    		}
    		else{
    			if(bln==0){
    				
    					// if ($("li[id=" + id + "]").hasClass("jstree-open"))
    					// $("#jsTreeComponent").jstree("close_node", "#" + id);
    					 //else
    					// $("#treeViewContainer").jstree("open_node", "#" + id);
    					 
    		  //$('#jsTreeComponent').jstree('close_node',array_id[i]);
    		  parents.splice(i, 1);
    		  
    			}
    		}
    		}  
    	recreatewithparents();
    	
     }
    function closeNodesOld(aid)
    {
    	var mydiv =parent.document.getElementById("treecrumbs");
    	$(mydiv).text('');
    	var bln=0;
    	var id;
    	var len=array_data.length;
    	for (var i=len;i >=0;i--) 
    		{
    		id=array_id[i];
    		if(aid == array_id[i] )
    		{
    			bln=1;
    			//alert(array_id[i]);
    		}
    		else{
    			if(bln==0){
    				
    					 if ($("li[id=" + id + "]").hasClass("jstree-open"))
    					 $("#jsTreeComponent").jstree("close_node", "#" + id);
    					 //else
    					// $("#treeViewContainer").jstree("open_node", "#" + id);
    					 
    		  //$('#jsTreeComponent').jstree('close_node',array_id[i]);
    		  array_data.splice(i, 1);
    		  array_id.splice(i, 1); 
    			}
    		}
    		}  
    	recreate();
    	
     }
function breadcrumbs(data)
{
	parents=[];
	
	//var node = data.rslt.obj;
	//array_data.push(node.attr('Assetname'));
	//array_id.push(node.attr('assetId'));
	
	 //parents.push({ id: selectedsection, description: selectedname});
	
	data.rslt.obj.parents("li").each(function () {
	    parents.push({ id: $(this).attr("id"), description: $(this).children("a").text() });
	});
	
	//console.log("parents" +parents.length);
	recreatewithparents();

	/*	var children = [];
		data.rslt.obj.find("li").each(function () {
		    children.push({ id: $(this).attr("id"), description: $(this).children("a").text() });
		});*/
	}
function recreatewithparents()
{
	
	var mydiv =parent.document.getElementById("treecrumbs");
	 $(mydiv).text('');		
	var len=parents.length-1;
	console.log("len="+len);
	for (var i=len;i >=0;i--) 
		{  	
		
		if(i<len)
			{
			console.log("i="+i+"len="+len);
	var spanTag = document.createElement('span');
	spanTag.innerHTML=' >> ';
	mydiv.appendChild(spanTag);
			} 	
	
	var aname=parents[i].description;
	var aid=parents[i].id;
	var aTag = document.createElement('a');
	aTag.setAttribute('class',	'breadCrumb');
	aTag.setAttribute('id',	aid);
	
	//aTag.setAttribute('href',"#");
	aTag.innerHTML = aname;
	mydiv.appendChild(aTag);
		}
	
	//last level
	if(len!=-1){
	var spanTag = document.createElement('span');
	spanTag.innerHTML=' >> ';
	mydiv.appendChild(spanTag);
	}	  	
	
	var aname=selectedname;
	var aid=selectedsection;
	var aTag = document.createElement('a');
	aTag.setAttribute('class',	'breadCrumb');
	aTag.setAttribute('id',	aid);
	
	//aTag.setAttribute('href',"#");
	aTag.innerHTML = aname;
	mydiv.appendChild(aTag);
}
    function checklist(e,data)
    {    	
    	 
    	 var node = data.inst.get_checked();
    	
    	//var tagName =data.inst.get_checked().;
    	//alert(node.attr('assetId'));
    	//selectedsection=node.attr('assetId');
    	//selectedtype=node.attr('treeType');
       
       
    }
    function submitMe(){ 
        var checked_ids = []; 
        $("#jsTreeComponent").jstree("get_checked",null,true).each 
            (function () { 
                checked_ids.push(this.id); 
            }); 
           doStuff(checked_ids); 
    }    
    </script>
	<script>
    function customMenu(node) {
        // The default set of all items
        treeType=$(node).attr('treeType')
        selectedtype=node.attr('treeType');
		selectedname=node.attr('Assetname');    	
    	atype=node.attr('atype');
    	selectedsection=node.attr('assetId');
    	
        if(treeType!=1){
        parent_node = $.jstree._reference('#jsTreeComponent')._get_parent(node);
        selectedparenttype=parent_node.attr('atype');
        }
    	
        if(treemode==null || treemode=='null' ||treemode=='undefined')
        	treemode="";
        console.log("treeType="+treeType+" treemode="+treemode);
         var items;
         if ( treemode!="edit"){
        	 if(treeType==4){
                 items = {
                		 editItem: { // The "rename" menu item
                             label: "Add Files/Frequency.",
                             action: function(response) {
                          	   var url = '<%=request.getContextPath()%>/testimport.htm?mode=add&id='+ node.attr('assetId') ;
                                 parent.frames['AppBody'].location = url;
                                       }
                         }
                 }
        	 }
        	 if(treeType==3)
        	 {
        	 console.log("inside edit");
        	 if(atype!="V"){
          	 items = {   
          			 createItem: { // The "rename" menu item
                      label: "Import Test-Set",
                      action: function(response) {
                          var url = '<%=request.getContextPath()%>/testimport.htm?mode=new&PId='+ node.attr('assetId')+'&atype='+ node.attr('atype') ;
                         // alert("url "+url);
                          parent.frames['AppBody'].location = url;
                                }
                  },
                  newItem: { // The "rename" menu item
                      label: "Import Tracking",
                      action: function(response) {
                          var url = '<%=request.getContextPath()%>/ampphaseimp.htm?PId='+ node.attr('assetId')+'&atype='+ node.attr('atype') ;
                         // alert("url "+url);
                          parent.frames['AppBody'].location = url;
                                }
                  }};
        	 }
        	 else{
          		items = {
                		 /* createItem: { // The "rename" menu item
                              label: "New Serial",                      
                              action: function(response) {
                                  var url = '<%=request.getContextPath()%>/pvserialimport.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                  //alert("url "+ url);
                                  parent.frames['AppBody'].location = url;
                                        }
                          },*/
                          editItem: { // The "rename" menu item
                              label: " Serials",                      
                              action: function(response) {
                                  var url = '<%=request.getContextPath()%>/setup.htm?oper=pvserial&testid='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                  //alert("url "+ url);
                                  parent.frames['AppBody'].location = url;
                                        }
                          },
                          edittItem: { // The "rename" menu item
                              label: "Edit Test",                      
                              action: function(response) {
                                  var url = '<%=request.getContextPath()%>/pvtest.htm?testid='+ node.attr('assetId') ;
                                  //alert("url "+ url);
                                  parent.frames['AppBody'].location = url;
                                        }
                          },
                          deleteItem: { // The "rename" menu item
                              label: "Delete Test",                      
                              action: function(response) {
                            	  var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ=8&assetname='+node.attr('assetName');                    
                                  
                                 // var url = '<%=request.getContextPath()%>/setup.htm?oper=pvdeltest&testid='+ node.attr('assetId') ;
                                  //alert("url "+ url);
                            	  window.location.href = url; 
                              }
                          },
                          edittgain: { // The "rename" menu item
                              label: "Gain of STD Horn",                      
                              action: function(response) {
                                  var url = '<%=request.getContextPath()%>/gainstdhorn.htm?oper=gainstd&testid='+ node.attr('assetId') ;
                                  //alert("url "+ url);
                                  parent.frames['AppBody'].location = url;
                                        }
                          }
                          
          	}
          	}
          	 return items;
          	 
        	 
        	 }
         }
       if(treemode=="edit"){
       
       // alert(" alert " +node.attr('treeType'));
         treeType=node.attr('treeType')
        if(treeType==1)
        	{
        	items = {
          		  createItem: { // The "rename" menu item
                        label: "Create Product",                        
                        action: function(response) 
                        {
                            var url = '<%=request.getContextPath()%>/product.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                            parent.frames['AppBody'].location = url;
                        }
                    },
              renameItem: { // The "rename" menu item
                  label: "Edit Company",
                  action: function(response) {
                      var url = '<%=request.getContextPath()%>/company.htm?ComId='+node.attr('assetId');
                      parent.frames['AppBody'].location = url;
                            }                 
                          }              
          };
        	}
        else if(treeType==2){
        	if(atype=="V"){
        		items = {
              		  createItem: { // The "rename" menu item
                            label: "Create Test",                      
                            action: function(response) {
                                var url = '<%=request.getContextPath()%>/pvtest.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                //alert("url "+ url);
                                parent.frames['AppBody'].location = url;
                                      }
                        },
                        editItem: { // The "rename" menu item
                            label: "Edit Product",                      
                            action: function(response) {
                            	var url = '<%=request.getContextPath()%>/product.htm?prodid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
                                parent.frames['AppBody'].location = url;
                                      }
                        }
        	}
        	}
        	else{	
         items = {
        		  createItem: { // The "rename" menu item
                      label: "Create Product Serial",                      
                      action: function(response) {
                          var url = '<%=request.getContextPath()%>/productserial.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                          //alert("url "+ url);
                          parent.frames['AppBody'].location = url;
                                }
                  },
            renameItem: { // The "rename" menu item
                label: "Edit Product",
                action: function(response) {
                    var url = '<%=request.getContextPath()%>/product.htm?prodid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
                    parent.frames['AppBody'].location = url;
                          }
            },
            deleteItem: { // The "delete" menu item
                label: "Delete Product",
                action: function (obj) {
                	var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ='+ treeType+'&assetname='+node.attr('assetName');                    
                    window.location.href = url;                    
               	 }
            },
            deleteScale: { // The "delete" menu item
                label: "Delete Scaling",
                action: function (obj) {
                	var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ=7&assetname='+node.attr('assetName');                    
                    window.location.href = url;                    
               	 }
            }
        };
        }
        }    
         else if (treeType==3){        	 
        	 if(atype=="V"){
         		items = {
               		  /*createItem: { // The "rename" menu item
                             label: "New Serial",                      
                             action: function(response) {
                                 var url = '<%=request.getContextPath()%>/pvserialimport.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                 //alert("url "+ url);
                                 parent.frames['AppBody'].location = url;
                                       }
                         },*/
                         editItem: { // The "rename" menu item
                             label: "Serials",                      
                             action: function(response) {
                                 var url = '<%=request.getContextPath()%>/setup.htm?oper=pvserial&testid='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                 //alert("url "+ url);
                                 parent.frames['AppBody'].location = url;
                                       }
                         },
                         edittItem: { // The "rename" menu item
                             label: "Edit Test",                      
                             action: function(response) {
                                 var url = '<%=request.getContextPath()%>/pvtest.htm?testid='+ node.attr('assetId') ;
                                 //alert("url "+ url);
                                 parent.frames['AppBody'].location = url;
                                       }
                         },
                         deleteItem: { // The "rename" menu item
                             label: "Delete Test",                      
                             action: function(response) {
                           	  var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ=8&assetname='+node.attr('assetName');                    
                                 
                                // var url = '<%=request.getContextPath()%>/setup.htm?oper=pvdeltest&testid='+ node.attr('assetId') ;
                                 //alert("url "+ url);
                           	  window.location.href = url; 
                             }
                         },
                         edittgain: { // The "rename" menu item
                             label: "Gain of STD HORN",                      
                             action: function(response) {
                                 var url = '<%=request.getContextPath()%>/gainstdhorn.htm?oper=gainstd&testid='+ node.attr('assetId') ;
                                 //alert("url "+ url);
                                 parent.frames['AppBody'].location = url;
                                       }
                         }
                         
         	}
         	}
         	else{
         		if(atype=="V"){
              		items = {
                    		  createItem: { // The "rename" menu item
                                  label: "New Serial",                      
                                  action: function(response) {
                                      var url = '<%=request.getContextPath()%>/pvserialimport.htm?PId='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                      //alert("url "+ url);
                                      parent.frames['AppBody'].location = url;
                                            }
                              },
                              editItem: { // The "rename" menu item
                                  label: "Edit Serial",                      
                                  action: function(response) {
                                      var url = '<%=request.getContextPath()%>/setup.htm?oper=pvserial&testid='+ node.attr('assetId') +'&PName='+node.attr('assetName')+'&Nlevel='+ node.attr('nlevel');
                                      //alert("url "+ url);
                                      parent.frames['AppBody'].location = url;
                                            }
                              },
                              edittItem: { // The "rename" menu item
                                  label: "Edit Test",                      
                                  action: function(response) {
                                      var url = '<%=request.getContextPath()%>/pvtest.htm?testid='+ node.attr('assetId') ;
                                      //alert("url "+ url);
                                      parent.frames['AppBody'].location = url;
                                            }
                              }
                              ,
                              edittgain: { // The "rename" menu item
                                  label: "Gain of STD Horn",                      
                                  action: function(response) {
                                      var url = '<%=request.getContextPath()%>/gainstdhorn.htm?oper=gainstd&testid='+ node.attr('assetId') ;
                                      console.log("url "+ url);
                                      parent.frames['AppBody'].location = url;
                                            }
                              }
                              
              	}
                 }else{
         		
         		
        	 items = {   
        			 createItem: { // The "rename" menu item
                    label: "Import Test-Set",
                    action: function(response) {
                        var url = '<%=request.getContextPath()%>/testimport.htm?mode=new&PId='+ node.attr('assetId')+'&atype='+ node.attr('atype') ;
                       // alert("url "+url);
                        parent.frames['AppBody'].location = url;
                              }
                },
                newItem: { // The "rename" menu item
                    label: "Import Tracking",
                    action: function(response) {
                        var url = '<%=request.getContextPath()%>/ampphaseimp.htm?PId='+ node.attr('assetId')+'&atype='+ node.attr('atype') ;
                       // alert("url "+url);
                        parent.frames['AppBody'].location = url;
                              }
                },
       			 editItem: { // The "rename" menu item
                   label: "Edit Serial No.",
                   action: function(response) {
                	   var url = '<%=request.getContextPath()%>/productserial.htm?prodserid='+ node.attr('assetId') ;
                       parent.frames['AppBody'].location = url;
                             }
               },
                deleteItem: { // The "delete" menu item
                    label: "Delete Serial No.",
                    action: function (obj) {
                    	//this.remove(obj);                   	
                    	var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ='+ treeType+'&assetname='+node.attr('assetName');
                       	window.location.href = url;                        
                    }
                }
            };
         } 
         	}
       }
         else if(treeType==4){
             items = {
            		 editItem: { // The "rename" menu item
                         label: "Add Files/Frequency.",
                         action: function(response) {
                      	   var url = '<%=request.getContextPath()%>/testimport.htm?mode=add&id='+ node.attr('assetId') ;
                             parent.frames['AppBody'].location = url;
                                   }
                     },
                deleteItem: { // The "delete" menu item
                    label: "Delete Test",
                    action: function (obj) {
                    	var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit&stat=delete&id='+ node.attr('assetId')+'&typ='+ treeType+'&assetname='+node.attr('assetName');                    
                        window.location.href = url;                    
                   	 }
                }
            };
            } 
         
     };
        return items;
    }
   
    
  
    </script>

</body>
</html>