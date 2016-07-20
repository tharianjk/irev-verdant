package ireveal.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;  
import java.util.List;  
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
 

import org.springframework.web.servlet.ModelAndView;  
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;

import ireveal.domain.PVTest;
import ireveal.domain.Product;
import ireveal.service.MastersService;
  
  
public class PVTestController  extends SimpleFormController{  
  
	private String viewName = null;
	public MastersService mastersservice ;	
	public Product product;	
	public void setViewName(String viewName) {
	      this.viewName = viewName;
	   }
	   public String getViewName() {
	      return viewName;
	   }
	   public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
	   
	   private HttpSession cursess;
       int primarykey=2;
       
	    public ModelAndView onSubmit(Object command)
	            throws ServletException {
	    	logger.info("*** in onsubmit** ");
	    	
	    	int stat=0;
	    	String refresh="false";
	    	String testid = (String)cursess.getAttribute("testid");
	    	logger.info("*** in onsubmit** ");
	    	PVTest pvtest = (PVTest)command;
	        logger.info("*** PVTest onsubmit** testid =" +testid);
	        try{
	        Date dtfrom = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH).parse(pvtest.getStrtestdate().replace("T", " "));
	    	pvtest.setDttestdate(dtfrom);
	        }
	        catch(Exception e){}
	    	 if (testid == null){
	        	logger.info("*** in onsubmit .. going to create new PVTest** ");
	        	primarykey=	mastersservice.InsertPVtest(pvtest);
	        	if(primarykey!=0)
		         {
	        		testid=Integer.toString(primarykey);
		        	 stat=1;
		        	 refresh="true";
		         }
	        }else{
	        	logger.info("*** in onsubmit .. going to update pvtest** ");
	        	Boolean blnstat=true;
	        	blnstat=mastersservice.UpdatePVTest(pvtest);
	        	 if(blnstat==true)
	 	        {
	 	        	 stat=1;
	 	        	 refresh="true";
	 	        }
	        }

	        //logger.info("returning view to " + getSuccessView());
	        return new ModelAndView(new RedirectView("pvtest.htm?testid="+testid+"&refresh="+refresh+"&savestat="+stat));
	       
	    }

	    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	    	Calendar cal = Calendar.getInstance();
         	Date curTime = cal.getTime();
	    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         	SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	        String id = request.getParameter("testid");
	        
	        request.getSession().setAttribute("savestat", null);
	        logger.info("inside PVTestController"); 
	        if (id == null || id == "" || id.equals("null")){
	        	String PId=request.getParameter("PId");
	   	        logger.info("inside pvtestcontroller id:" +id);
	   	       
	        	logger.info(" going to create new PV test");
	        	request.getSession().setAttribute("testid", null);
	        	cursess.setAttribute("testid",null);
	        	PVTest pvtest=new PVTest();
	        	pvtest.setProductid(Integer.parseInt(PId));	        
	        	pvtest.setStrtestdate(sdf.format(curTime)+"T"+sdftime.format(curTime));
	        	pvtest.setTestcenter("VERDANT, COCHIN");
	        	pvtest.setFrequnit("MHz");
	        	return pvtest;
	        }else{
	        	request.getSession().setAttribute("testid", id);
	            logger.info(" going to retrieve details of PVtest="+id);
	            PVTest pvtest=new PVTest();
	            pvtest= mastersservice.getPVTest(Integer.parseInt(id));
	        	String strdate=sdf.format(pvtest.getDttestdate())+"T"+sdftime.format(pvtest.getDttestdate());	           
	        	pvtest.setStrtestdate(strdate);
	        	return pvtest;
	        }       
	    }

	    protected Map<String, Object> referenceData(HttpServletRequest request) throws Exception {
			HashMap<String, Object> referenceData = new HashMap<String, Object>();
	        List<Product> prodlist = mastersservice.getProductList();
	        referenceData.put("prodlist", prodlist);	
	        referenceData.put("prodtype","VT-JK S10 L ATP-2 REV 00");
	 		return referenceData;
		}
	  
}  

