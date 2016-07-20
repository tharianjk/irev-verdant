package ireveal.web;

 
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.domain.AssetTree;
import ireveal.service.AssetTreeManager;
import ireveal.service.MastersService;



public class AssetTreeController extends SimpleFormController {
	private String viewName = null;
	public AssetTreeManager assetTreeManager ;
	public MastersService mastersservice ;
	public AssetTree assetTree;
	String deletemsg="Deleted Successfully ";
	String strType="Product";
	protected final Log logger = LogFactory.getLog(getClass());
	
	
		
	public void setViewName(String viewName) {
	      this.viewName = viewName;
	   }
	   public String getViewName() {
	      return viewName;
	   }
	  	   
	   public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	    	
	        logger.info("*** Inside Asset controller ");
	        int inttyp=0;
	        int intid=0;
	        boolean saveStat=true;
	        String deletestat=(String)request.getParameter("stat");
	       // logger.info("*** Inside Asset controller deletestat :" +deletestat);
	        String typ=(String)request.getParameter("typ");
	       // logger.info("*** Inside Asset controller typ :" +typ);
	        String id=(String)request.getParameter("id");
	        String assetname=(String)request.getParameter("assetname");
	        String treemode=(String)request.getSession().getAttribute("treemode");
	        logger.info("*** Inside Asset controller treemode :" +treemode);
	        request.getSession().setAttribute("treemode", treemode);
	        request.getSession().setAttribute("typ", null);
	        request.getSession().setAttribute("stat", null);
	        request.getSession().setAttribute("id", null);
	       // request.getRequestDispatcher("/WEB-INF/jsp/assettree.jsp").forward(request, response);
	       
	       
	        //delete entities
	       
	        if(deletestat!=null && deletestat !="")
	        {
	        	 // logger.info("*** Inside Asset controller inside deletestat:" );
	        if(typ!=null && typ!="")
	        {
	        	 //logger.info("*** Inside Asset controller inside typ");
	           inttyp=Integer.parseInt(typ);
	        }
	        if(id!=null && id!="")
	        {
	           intid=Integer.parseInt(id);
	        }
	                      
	        if(inttyp==2)
	        {
	        	saveStat=mastersservice.deleteproduct(intid);
	        }
	        if(inttyp==3)
	        {
	        	strType="Product Serial";
	        	saveStat=mastersservice.deleteproductser(intid);
	        }
	        if(inttyp==4)
	        {
	        	strType="Test Data";
	        	saveStat=mastersservice.deleteTestData(intid);
	        } 
	        if(inttyp==7)
	        {
	        	strType="Scaling";
	        	saveStat=mastersservice.deletescaleProduct(intid);
	        }
	        if(inttyp==8)
	        {
	        	strType="PV Test";
	        	saveStat=mastersservice.deletePVTest(intid);
	        } 
	        if(saveStat==false)
	        	deletemsg="Could not delete " ;
	     }
	        request.getSession().setAttribute("AssetListSec", assetTreeManager.getAssetList());
	        ModelAndView mv = new ModelAndView(getViewName());
	        if(deletestat!=null && deletestat !="")
	        {
	        	deletemsg=deletemsg+strType+" "+assetname;
	        	strType=strType.toLowerCase();
	        	mv=new ModelAndView(new RedirectView("assettree.htm?treemode=edit&strType="+strType+"&savestat=1&deletemsg="+deletemsg));
	        }
	        return  mv;	             
	    }
	   
	   
	   
	   
	   public  String AsName ;
	   
	   public void setAName(String assetName) {
	       this.AsName = assetName;
	   }

	   public String getAName() {
	       return assetTreeManager.sbAssetName();
	   }
	   
	   public List<AssetTree> getAList ()
	   {		   
		   return  assetTreeManager.getAssetList();
	   }
	   public void setAssetTreeManager(AssetTreeManager assetTreeManager) {
	       this.assetTreeManager = assetTreeManager;
	   }

	   public AssetTreeManager getAssetTreeManager() {
	       return assetTreeManager;
	   }
	   public void setAssetTree(AssetTree assetTree) {
	       this.assetTree = assetTree;
	   }

	   public AssetTree getAssetTree() {
	       return assetTree;
	   }
	   
	   public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }


}
