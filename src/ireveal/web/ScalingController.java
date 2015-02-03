package ireveal.web;


import ireveal.domain.AmpPhaseTrack;
import ireveal.domain.Company;
import ireveal.domain.ImportData;
import ireveal.domain.ProductSerial;
import ireveal.domain.Scaling;
import ireveal.domain.TestData;
import ireveal.domain.TestFrequency;
import ireveal.service.MastersService;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;





import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
 
public class ScalingController extends SimpleFormController{
	
	public MastersService mastersservice ;
	private HttpSession cursess;
	private int testid=0;
	private String viewName;
	 protected final Log logger = LogFactory.getLog(getClass());
 
	public ModelAndView onSubmit(Object command)
            throws ServletException, JSONException {
		 logger.info("inside Scalingcontroller inside onsubmit");
		 
		
		List<Scaling> scalelist=new ArrayList<Scaling>();
		
		Scaling scalecmd = (Scaling)command;	
	    JSONObject obj1 = new JSONObject(scalecmd.getStrjsonfreq());
	     try {
	      JSONArray result = obj1.getJSONArray("jsonfreq");
	    for(int i=0;i<result.length();i++)
	     {
	    	Scaling scale= new Scaling();
	    	logger.info(result.get(i));
	    	JSONObject obj2 = (JSONObject)result.get(i);
	    	logger.info(obj2.get("freq"));
	    	logger.info(obj2.get("minscale"));
	    	logger.info(obj2.get("minscale"));
	    	
	    		{scale.setFrequency(Double.parseDouble(obj2.get("freq").toString()));}
	    		scale.setMinscale(Double.parseDouble(obj2.get("minscale").toString()));
	    		scale.setMaxscale(Double.parseDouble(obj2.get("maxscale").toString()));
	    		scalelist.add(scale);
	     }
	    mastersservice.UpdateScaling(scalelist,scalecmd.getProductid());
	     } catch (JSONException e) {
	         e.printStackTrace();
	    }
	    
	     return new ModelAndView(new RedirectView("scaling.htm?savestat=saved"));
		}
	
	
	 protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	    	String oper = request.getParameter("oper");	    	
	    	String id = request.getParameter("testid");
	        if(id!=null && id!=""){
	        	testid=Integer.parseInt(id);
	        }
	        request.getSession().setAttribute("savestat", null);
	        logger.info("inside ScalingController"); 
	      
	        	logger.info(" going to create new Scaling");
	        	request.getSession().setAttribute("id", null);
	        	cursess.setAttribute("id",null);
	        	Scaling scale=new Scaling();
	        	scale.setProductid(mastersservice.getProductid(testid));
	        	return scale;
	    }
	
	 protected HashMap referenceData(HttpServletRequest request) throws Exception {
			HashMap referenceData = new HashMap();	
			List<Scaling> scalelist=mastersservice.getScaling(testid );
			referenceData.put("scalelist",scalelist);
	 		return referenceData;
		}
	
	
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
	  
	   public void setViewName(String viewName) {
		      this.viewName = viewName;
		   }
		   public String getViewName() {
		      return viewName;
		   }
	}
