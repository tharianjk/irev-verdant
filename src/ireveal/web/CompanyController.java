package ireveal.web;


import java.util.List;  

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

 
import org.springframework.web.servlet.ModelAndView;  
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
import ireveal.domain.Company;

import ireveal.service.CompanyService;  
  
  
public class CompanyController  extends SimpleFormController{  
  
	private String viewName = null;
	public CompanyService companyService ;
	public Company company; 
	public void setViewName(String viewName) {
	      this.viewName = viewName;
	   }
	   public String getViewName() {
	      return viewName;
	   }
	   public List<Company> getAList ()
	   {		   
		   return  companyService.getCompanyList();
	   }
	   public void setCompanyManager(CompanyService companyService) {
	       this.companyService = companyService;
	   }

	   public CompanyService getCompanyManager() {
	       return companyService;
	   }
	   public void setCompany(Company company) {
	       this.company = company;
	   }

	   public Company getCompany() {
	       return company;
	   }
	   
	   private HttpSession cursess;

	   public ModelAndView onSubmit(Object command)
	            throws ServletException{
		   logger.info("*** in onsubmit** ");
	    	String ComId = (String)cursess.getAttribute("comId");
	    	Company company = (Company)command;
	        
	        logger.info(" bean returned companyName = "+company.getCompanyname()+", curruser="+ComId);
	        if (ComId == null){
	        	logger.info("*** in onsubmit .. going to create new company** ");
	        	companyService.updateData(company);        	
	        }else{
	        	logger.info("*** in onsubmit .. going to update company** ");
	        	companyService.updateData(company);
	        }
	        return new ModelAndView(new RedirectView("company.htm?ComId="+ComId+"&refresh=true&savestat=1"));
	        
	    }

	    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	        String id = request.getParameter("ComId");
	        cursess = request.getSession();
	        logger.info("***Company formBackingObject ");
	        if (id == null){
	        	logger.info(" going to creaate new company");
	        	request.getSession().setAttribute("comId", null);
	        	return new Company();
	        }else{
	        	request.getSession().setAttribute("comId", id);
	        	cursess.setAttribute("comId", id);
	            logger.info(" going to retrieve details of company="+id);
	        	return companyService.getDetails(Integer.parseInt(id));
	        }       
	    }
	  
}  

