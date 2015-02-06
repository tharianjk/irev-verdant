package ireveal.web;


import java.awt.color.CMMException;
import java.io.IOException;
import java.util.ArrayList;  
import java.util.HashMap;  
import java.util.List;  
import java.util.Map;  

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Controller;  
import org.springframework.web.bind.annotation.ModelAttribute;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RequestParam;  
import org.springframework.web.servlet.ModelAndView;  
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;

import ireveal.domain.Product;
import ireveal.service.MastersService;
  
  
public class ProductController  extends SimpleFormController{  
  
	private String viewName = null;
	public MastersService mastersservice ;	
	public Product product;	
	private int intprodid=0;
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
	    	intprodid=0;
	    	int stat=0;
	    	String refresh="false";
	    	String prodid = (String)cursess.getAttribute("prodid");
	    	logger.info("*** in onsubmit** ");
	    	Product product = (Product)command;
	        logger.info("*** Product onsubmit** prodid =" +prodid);
	       
	    	 if (prodid == null){
	        	logger.info("*** in onsubmit .. going to create new product** ");
	        	primarykey=	mastersservice.InsertProduct(product);
	        	if(primarykey!=0)
		         {
	        		prodid=Integer.toString(primarykey);
		        	 stat=1;
		        	 refresh="true";
		         }
	        }else{
	        	logger.info("*** in onsubmit .. going to update product** ");
	        	Boolean blnstat=true;
	        	blnstat=mastersservice.updateProduct(product);
	        	 if(blnstat==true)
	 	        {
	 	        	 stat=1;
	 	        	 refresh="true";
	 	        }
	        }

	        logger.info("returning view to " + getSuccessView());
	        return new ModelAndView(new RedirectView("product.htm?prodid="+prodid+"&refresh="+refresh+"&savestat="+stat));
	       
	    }

	    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	    	intprodid=0;
	        String id = request.getParameter("prodid");
	        request.getSession().setAttribute("savestat", null);
	        logger.info("inside ProductController"); 
	        if (id == null || id == "" || id.equals("null")){
	        	
	   	        logger.info("inside productController id:" +id);
	   	       
	        	logger.info(" going to create new Product");
	        	request.getSession().setAttribute("prodid", null);
	        	cursess.setAttribute("prodid",null);
	        	Product prod=new Product();
	        	
	        	return prod;
	        }else{
	        	intprodid=Integer.parseInt(id);
	        	request.getSession().setAttribute("prodid", id);
	            logger.info(" going to retrieve details of product="+id);
	        	return mastersservice.getProduct(Integer.parseInt(id));
	        }       
	    }
	    protected HashMap referenceData(HttpServletRequest request) throws Exception {
			HashMap referenceData = new HashMap();	
	        referenceData.put("testcnt", mastersservice.getproductTestscnt(intprodid));
	 		return referenceData;
		}
	  
}  

