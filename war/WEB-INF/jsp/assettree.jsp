
    <%@ include file="/WEB-INF/jsp/include.jsp" %> 
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
	 <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">
    
    </head>
    <body>
	
     <div id="jsTreeComponent" class="demo" style="max-width:100%;"></div>   
     
        
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
    var atype;
    var parents = [];
    var selectedsection;
    var selectedtype;
    var selectedname;
    var selectedparent;
    var parentname;
    var array_id=[];
    var array_data=[];
    array_data.push(" INTELCON ");
    array_id.push(1);
      
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
                	var node = $.jstree._focused().get_selected();
                	var treeType=node.attr('treeType')
                	if(treeType!=1){
                		parent_node = $.jstree._reference('#jsTreeComponent')._get_parent(node);
                		selectedparent=parent_node.attr('Assetname');
                	}                	
               	    var url ='';	
    					selectedname=node.attr('Assetname');
    					selectedtype=node.attr('treeType');
    					atype=node.attr('atype');
    			        selectedsection=node.attr('assetId');
    			        if(selectedtype==4){
    			        if(atype=="A")
    			        	{
    			        	  parent.document.getElementById("od").style.display="block";
	  			        	  parent.document.getElementById("ar").style.display="none";
	  			        	  parent.document.getElementById("pp").style.display="block";
	  			        	  parent.document.getElementById("3db").style.display="block";
	  			        	  parent.document.getElementById("10db").style.display="block";
	  			        	  parent.document.getElementById("cpg").style.display="none";
	  			        	  parent.document.getElementById("blobe").style.display="none";
    			        	}
    			        else if(atype=="E")
			        	{
			        	  parent.document.getElementById("od").style.display="block";
  			        	  parent.document.getElementById("ar").style.display="none";
  			        	  parent.document.getElementById("pp").style.display="block";
  			        	  parent.document.getElementById("3db").style.display="block";
  			        	  parent.document.getElementById("10db").style.display="block";
  			        	  parent.document.getElementById("cpg").style.display="none";
  			        	 parent.document.getElementById("blobe").style.display="none";
			        	}
    			        else if(atype=="CP")
			        	{
			        	 
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="block";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="block";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	  
			        	}
    			        else if(atype=="DCP")
			        	{
			        	 
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="block";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="block";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	}
    			        else if(atype=="NCP")
			        	{
			        	 
			        	  parent.document.getElementById("od").style.display="none";
			        	  parent.document.getElementById("ar").style.display="block";
			        	  parent.document.getElementById("pp").style.display="block";
			        	  parent.document.getElementById("3db").style.display="block";
			        	  parent.document.getElementById("10db").style.display="block";
			        	  parent.document.getElementById("cpg").style.display="none";
			        	  parent.document.getElementById("blobe").style.display="block";
			        	}
    			        }
    			        else
    			        	{
    			        	parent.document.getElementById("od").style.display="none";
  			        	  parent.document.getElementById("ar").style.display="none";
  			        	  parent.document.getElementById("pp").style.display="none";
  			        	  parent.document.getElementById("3db").style.display="none";
  			        	  parent.document.getElementById("10db").style.display="none";
  			        	  parent.document.getElementById("cpg").style.display="none";
    			        	}
                	 if(monitorstat=="monitor"){
                		// alert("treeType " +monitorstat);
                		if(treeType==2){
                			 url = '<%=request.getContextPath()%>/monitor.htm?secid='+ node.attr('assetId')+'&treetype='+selectedtype;
                      	   parent.frames['AppBody'].location =url;
                		}
                		else if(treeType==3)
                 		 {
                        	   url = '<%=request.getContextPath()%>/monitor.htm?secid='+ node.attr('assetId')+'&treetype='+selectedtype;
                        	   parent.frames['AppBody'].location =url;
                         }
                     	 else if(treeType==4)
                 		 {
                        	   url = '<%=request.getContextPath()%>/monitor.htm?secid='+ node.attr('assetId')+'&treetype='+selectedtype;
                        	   parent.frames['AppBody'].location =url;
                         }
                	 }
                	//alert(" monitorstat "+monitorstat);
                	 if(monitorstat=="monitor" || monitorstat=="Reports" || monitorstat=="Events"){
                	 breadcrumbs(data);}
                	 var attrarr="";
                	 var cnt=0;
                	 $.jstree._reference('#jsTreeComponent')._get_node(null, true).each(function() {
                         id = $(this).attr("assetId");
                         
                         
                         var treeType=$(this).attr('treeType')
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
                	var treeType=node.attr('treeType');
                	var url ='';
            if(treemode=="edit" && treeType!=5){             	  
             	 
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
                	   url = '<%=request.getContextPath()%>/productserial.htm?prodserid='+ node.attr('assetId')+'&Nlevel='+ node.attr('nlevel');
                 }
             	 
             	 parent.frames['AppBody'].location =url;
             
             	 
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
         var items;
         
       if(treemode=="edit"){
       
       // alert(" alert " +node.attr('treeType'));
        var treeType=node.attr('treeType')
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
            }
        };
        }
              
         else if (treeType==3){
        	 
        	 
        	 items = {   
        			 createItem: { // The "rename" menu item
                    label: "Add Test",
                    action: function(response) {
                        var url = '<%=request.getContextPath()%>/testimport.htm?PId='+ node.attr('assetId')+'&atype='+ node.attr('atype') ;
                       // alert("url "+url);
                        parent.frames['AppBody'].location = url;
                              }
                },
                   
       			 editItem: { // The "rename" menu item
                   label: "Edit Serial No.",
                   action: function(response) {
                	   var url = '<%=request.getContextPath()%>/testimport.htm?id='+ node.attr('assetId') ;
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
         else if(treeType==4){
             items = {
            		 editItem: { // The "rename" menu item
                         label: "Add Files/Frequency.",
                         action: function(response) {
                      	   var url = '<%=request.getContextPath()%>/testimport.htm?id='+ node.attr('assetId') ;
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