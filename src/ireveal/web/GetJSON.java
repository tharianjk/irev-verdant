package ireveal.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import ireveal.domain.AssetTree;



import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
 



@SuppressWarnings("serial")
@WebServlet(name = "GetJSON", urlPatterns = {"/GetJSON"})
public class GetJSON extends HttpServlet {
	
	
  //  JSONObject jSONObject = new JSONObject();   
    
	public AssetTree assetTree;
	List<AssetTree> treeval=new ArrayList<AssetTree>();
	JSONArray jSONArray = new JSONArray();
	String treemode="view"; 
	protected final Log logger = LogFactory.getLog(getClass());
	
	    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        //logger.info("*** Inside GetJSON");
        treemode=(String)request.getSession().getAttribute("treemode");
      //  logger.info("*** Inside GetJSON treemode " +request.getSession().getAttribute("treemode"));
        request.getSession().setAttribute("treemode", request.getSession().getAttribute("treemode"));
        PrintWriter out = response.getWriter();
        jSONArray = new JSONArray();
        try {
        	
        	 //List<AssetTree> treeval = atreeControl.getTreeList();
        	  treeval=(List<AssetTree>)request.getSession().getAttribute("AssetListSec");
              if(treeval==null)
        	 {
        		 logger.info("*** GetJSON.getTreeList return null");
        	 }
        	/* else 
        	 {
        		 logger.info("*** GetJSON.getTreeList size :***" + Integer.toString(treeval.size()));
        	 }*/     	
        	
               
                //fillTree(treeval.get(0).getAssetId(),treeval.get(0).getTreeLevel(),jSONArray);
            /*    JSONObject jSONObject = new JSONObject();   
     		  
     	               jSONObject.put("state","open");
     	               jSONObject.put("data",treeval.get(0).getAssetName());
     	
     	               JSONObject jsonAttr = new JSONObject();                
     	               jsonAttr.put("Assetname", treeval.get(0).getAssetName());
     	               jSONObject.put("attr", jsonAttr);
     	               jsonAttr = null;
     	               
     	              JSONArray jsonEKMdarray = new JSONArray();
     	              JSONObject childEKM = new JSONObject();
     	              childEKM.put("state","open");
     	              childEKM.put("data",treeval.get(1).getAssetName());

                      JSONObject jsonChildAttr = new JSONObject();                        
                      jsonChildAttr.put("Assetname", treeval.get(1).getAssetName());
                      childEKM.put("attr", jsonChildAttr);
                      jsonChildAttr = null;
                      //jsonEKMdarray.put(childEKM);
                     
                      
                      JSONArray jsonSec1Array = new JSONArray();
                      JSONObject childSec1 = new JSONObject();
                      childSec1.put("state","open");
                      childSec1.put("data",treeval.get(2).getAssetName());

                      JSONObject jsonChildAttr1 = new JSONObject();                        
                      jsonChildAttr1.put("Assetname", treeval.get(2).getAssetName());
                      childSec1.put("attr", jsonChildAttr1);
                      jsonChildAttr1 = null;
                     // jsonSec1Array.put(childSec1);
                      //child1=null; 
                      
                      JSONArray jsonSec11Array = new JSONArray();
                      JSONObject childSec11 = new JSONObject();
                      childSec11.put("state","open");
                      childSec11.put("data",treeval.get(4).getAssetName());

                      JSONObject jsonChildAttr4 = new JSONObject();                        
                      jsonChildAttr4.put("Assetname", treeval.get(4).getAssetName());
                      childSec11.put("attr", jsonChildAttr4);
                      jsonChildAttr4 = null;
                      jsonSec11Array.put(childSec11);
                      childSec11=null;
                      
                      childSec1.put("children",jsonSec11Array);                     
                      jsonSec1Array.put(childSec1);
                      childSec1=null;   
                     
                  
                      JSONObject  childSec2 = new JSONObject();
                      childSec2.put("data",treeval.get(3).getAssetName());

                      jsonChildAttr1 = new JSONObject();                        
                      jsonChildAttr1.put("Assetname", treeval.get(3).getAssetName());
                      childSec2.put("attr", jsonChildAttr1);
                      jsonChildAttr1 = null;
                      jsonSec1Array.put(childSec2);
                      childSec2=null;
                      
                      childEKM.put("children", jsonSec1Array);
                      jsonEKMdarray.put(childEKM);
                      
                      jSONObject.put("children", jsonEKMdarray);
     	               
     	               jSONArray.put(jSONObject);
     	               jSONObject=null;
            logger.info("*** jSONArray " + jSONArray);
            System.out.println(jSONArray);
            out.print(jSONArray);
            jSONArray=null;*/
        	 
        	 JSONObject jSONObject = new JSONObject(); 
        	 jSONObject.put("state","open");
        	 jSONObject.put("data",treeval.get(0).getAssetname());
             jSONObject.put("text",treeval.get(0).getAssetname());
             jSONObject.put("id",treeval.get(0).getAssetid());
             jSONObject.put("parent",treeval.get(0).getAssetparentid());                         
             JSONObject jsonAttr = new JSONObject();   
             jsonAttr.put("id",treeval.get(0).getAssetid());
             jsonAttr.put("atype",treeval.get(0).getAtype());
             jsonAttr.put("pvtype",treeval.get(0).getPvtype());
             jsonAttr.put("Assetname", treeval.get(0).getAssetname());
             jsonAttr.put("Assetid", treeval.get(0).getAssetid());
             jsonAttr.put("parentId", treeval.get(0).getAssetparentid());
             jsonAttr.put("treeType", treeval.get(0).getTreelevel());            
             jsonAttr.put("rel",treeval.get(0).getAssettype());
             jSONObject.put("attr", jsonAttr);
             jsonAttr = null;
             
             logger.info("treeval "+treeval.get(0).getAssetid()+" "+treeval.get(0).getTreelevel()+" atype="+treeval.get(0).getAtype());
         JSONArray jsonRtnarray=fillTree(treeval.get(0).getAssetid(),treeval.get(0).getTreelevel(),treeval.get(0).getAtype());
         if(jsonRtnarray!=null)    
         jSONObject.put("children", jsonRtnarray);
              
              jSONArray.put(jSONObject);
              jSONObject=null;
              //logger.info("*** jSONArray " + jSONArray);
             // System.out.println(jSONArray);
              out.print(jSONArray);
              jSONArray=null;
             
        	 
        }
            catch(Exception e){
            System.out.println(e);
        }
        finally {
            out.close();
        }
    }
	   private JSONArray fillTree(int parentId,int nlevel,String atype) throws JSONException
	   {
		   JSONArray jsonChildarray = new JSONArray();	
		   for(int i=1; i< treeval.size();){			  
			  
			   if(parentId==treeval.get(i).getAssetparentid() && nlevel==treeval.get(i).getNlevel() )
			   {
				   
				  // logger.info("*** fillTree " + Integer.toString(parentId));
				       JSONObject child = new JSONObject();
                       child.put("data",treeval.get(i).getAssetname());
                       child.put("state","close");
                       child.put("text",treeval.get(i).getAssetname());
                       child.put("id",treeval.get(i).getAssetid());
                       child.put("parent",treeval.get(0).getAssetparentid());  
                       JSONObject jsonChildAttr = new JSONObject();
                       jsonChildAttr.put("id",treeval.get(i).getAssetid());
                       jsonChildAttr.put("atype",treeval.get(i).getAtype());
                       jsonChildAttr.put("pvtype",treeval.get(i).getPvtype());
                       jsonChildAttr.put("Assetname", treeval.get(i).getAssetname());
                       jsonChildAttr.put("Assetid", treeval.get(i).getAssetid());
                       jsonChildAttr.put("parentId", treeval.get(i).getAssetparentid());
                       jsonChildAttr.put("treeType", treeval.get(i).getTreelevel());
                       jsonChildAttr.put("nlevel", treeval.get(i).getNlevel());
                       jsonChildAttr.put("rel",treeval.get(i).getAssettype());
                       child.put("attr", jsonChildAttr);
                       jsonChildAttr = null;
                       
                      
	                  // logger.info("*** fillTree " + treeval.get(i).getAssetname());
	                   if(treeval.get(i).getTreelevel()!= 5 && !atype.equals("V")) //meters
	                   {
	                	   //logger.info("atype="+atype);
	                   JSONArray rtnArray= fillTree(treeval.get(i).getAssetid(),treeval.get(i).getTreelevel(),treeval.get(i).getAtype());
	                   
	                   //logger.info("*** fillTree i=" + Integer.toString(rtnArray.length()) + " rtnArray " + rtnArray);
	                   if(rtnArray.length()!=0)
	                	   child.put("children", rtnArray);
	                   }
	                  // logger.info("*** fillTree i=" + Integer.toString(i) + " child " + child);
	                   
	                   jsonChildarray.put(child);
	                  
	                   
	                  // logger.info("*** fillTree i=" + Integer.toString(i) + " jsonChildarray " + jsonChildarray);
			   }  	
			   
			   
			   
		   i++;
		   }
		 //  logger.info("*** fillTree jsonarray " + jsonChildarray);
		 return jsonChildarray;
		   
	   }
	
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	 request.getSession().setAttribute("treemode", treemode);
    	
        processRequest(request, response);
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	 request.getSession().setAttribute("treemode", treemode);
        processRequest(request, response);
    }
 
    @Override
    public String getServletInfo() {
        return "edit";
    }   

	   public void setAssetTree(AssetTree assetTree) {
	       this.assetTree = assetTree;
	   }

	   public AssetTree getAssetTree() {
	       return assetTree;
	   }
	   
}
