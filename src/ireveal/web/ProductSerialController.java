package ireveal.web;
  
import java.util.HashMap;  
import java.util.List;  


import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;



import org.springframework.web.servlet.ModelAndView;  
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;

import ireveal.domain.Product;
import ireveal.domain.ProductSerial;
import ireveal.service.MastersService;
  
  
public class ProductSerialController  extends SimpleFormController{  
  
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
	    	String prodserid = (String)cursess.getAttribute("prodserid");
	    	logger.info("*** in onsubmit** ");
	    	ProductSerial productser = (ProductSerial)command;
	        logger.info("*** Product onsubmit** prodid =" +prodserid);
	       
	    	 if (prodserid == null){
	        	logger.info("*** in onsubmit .. going to create new product Serial** ");
	        	primarykey=	mastersservice.InsertProductSer(productser);
	        	if(primarykey!=0)
		         {
	        		prodserid=Integer.toString(primarykey);
		        	 stat=1;
		        	 refresh="true";
		         }
	        }else{
	        	logger.info("*** in onsubmit .. going to update product** ");
	        	Boolean blnstat=true;
	        	blnstat=mastersservice.updateProductSer(productser);
	        	 if(blnstat==true)
	 	        {
	 	        	 stat=1;
	 	        	 refresh="true";
	 	        }
	        }

	       
	        return new ModelAndView(new RedirectView("productserial.htm?prodserid="+prodserid+"&refresh="+refresh+"&savestat="+stat));
	       
	    }

	    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	        String id = request.getParameter("prodserid");
	        String PId=request.getParameter("PId");
	        request.getSession().setAttribute("savestat", null);
	        logger.info("inside ProductSerialController"); 
	        if (id == null || id == "" || id.equals("null")){
	        	
	   	        logger.info("inside productController id:" +id);
	   	       
	        	logger.info(" going to create new Product Serial");
	        	request.getSession().setAttribute("prodserid", null);
	        	cursess.setAttribute("prodserid",null);
	        	ProductSerial prod=new ProductSerial();
	        	prod.setProductid(Integer.parseInt(PId));
	        	return prod;
	        }else{
	        	request.getSession().setAttribute("prodserid", id);
	            logger.info(" going to retrieve details of product serial="+id);
	        	return mastersservice.getProductSer(Integer.parseInt(id));
	        }       
	    }
	    
	    protected Map<String, Object> referenceData(HttpServletRequest request) throws Exception {
			HashMap<String, Object> referenceData = new HashMap<String, Object>();
	        List<Product> prodlist = mastersservice.getProductList();        
	       
	        referenceData.put("prodlist", prodlist);
	        
	        
	 		return referenceData;
		}
	  
}  

