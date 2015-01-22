package ireveal.web;

import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.ModelAndView;



import ireveal.domain.EncryptDecrypt;
import ireveal.domain.RoleDsp;
import ireveal.domain.UserPref;
import ireveal.service.MastersService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.beans.factory.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class MainController implements Controller {

    protected final Log logger = LogFactory.getLog(getClass());
    public MastersService mastersservice ;
	
@Value("${appl.is_url}")
    private String is_url; // Holds the URL to Integration Server. Picked from application.properties
@Value("${appl.precision}")
private String precision; // Holds the precision for value in monitor
    
    /**
    * 
    *  Main form controller. Called from spring dispatch serevlet
    *
    * @param  
    * @return view based on URI
     * @throws ParseException 
    */
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {

    	String pathinfo = request.getContextPath();
    	String requri = request.getRequestURI();
    	String uname = request.getParameter("username");
    	String pswd = request.getParameter("password");
    	String errstr = request.getParameter("error");
    	String logoutstr = request.getParameter("logout");
		Boolean climob = false;
		
		 Calendar cal = Calendar.getInstance();
	     Date curTime = cal.getTime();
	     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
    	//Check the type of client: Desktop or mobile
    	String clitype = request.getHeader("user-agent").toLowerCase();
    	if (clitype.contains("android") || clitype.contains("webos") || clitype.contains("iphone") || clitype.contains("ipad") || clitype.contains("blackberry") )
    		climob = true;
    	
       	logger.info("*** from MainController.. pathinfo=" + pathinfo +"...requri = " + requri+",errr="+errstr+",logout="+logoutstr+",climob="+climob);
        Map<String, Object> myModel = new HashMap<String, Object>();

        if (requri.contains("login")){
        	ModelAndView model = new ModelAndView("login");
        	logger.info("*** Inside MainCtrl... going to display login page");
    		if (errstr != null) {
    			logger.info("*** Inside MainCtrl... putting invalid login msg");
    			model.addObject("error", " ");
    		}
    		if (logoutstr != null) {
    			logger.info("*** Inside MainCtrl... putting logout msg");
    			model.addObject("msg", " ");
    		}
        	return model;
        }
        
        // Authorisation check.  Access denied.
        if (requri.contains("403")){
        	return new ModelAndView("403", "model", myModel);
        }
       
        if (requri.contains("dropdown")){
        	String prodid = request.getParameter("prodid");
        	
        	return new ModelAndView("dropdown", "model", myModel);
        }
		// User has been successfully authenticated. Log her last login date
		 if (requri.contains("start")){
        	User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        	logger.info("******* Going to update user Login Date ***:"+user.getUsername());
        	mastersservice.updateUserLogin(user.getUsername());
        }
        // Fallback to main page	

       	
       	myModel.put("uname", uname);
      // 	return new ModelAndView("main", "model", myModel);
       	
       	List<RoleDsp> rle =mastersservice.getLogUserRole();
		String compname=rle.get(0).getCompany();
		int compid=rle.get(0).getCompanyid();
		
		String expirydate="";
		Date dtexpiry=null;
		if(rle.get(0).getExpirydate()!=null && rle.get(0).getExpirydate()!=""){
		EncryptDecrypt myEncryptor;
		try {
			myEncryptor = new EncryptDecrypt();			
			expirydate=myEncryptor.decrypt(rle.get(0).getExpirydate());
			dtexpiry = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(expirydate);
			logger.info("dtexpiry "+dtexpiry +" curTime " +curTime);
			if(dtexpiry.compareTo(curTime)<=0){
				return new ModelAndView("403", "model", myModel);}
			} catch (Exception e) {
				logger.info("dtexpiry Exception" + e.getMessage());
				return new ModelAndView("403", "model", myModel);
			}
       }
		else
		{
			return new ModelAndView("403", "model", myModel);
		}		
		
		myModel.put("compname", compname);
		myModel.put("compid", compid);		
		myModel.put("blnreports", rle.get(0).getBln_reports());
		myModel.put("blnevents", rle.get(0).getBln_events());
		myModel.put("blntools", rle.get(0).getBln_tools());
		myModel.put("blnsettings", rle.get(0).getBln_settings());
		
       	List<UserPref> usrpref= mastersservice.getUserFav();
       	String favmenu="about:blank";
       	//List<Location> loc=mastersservice.getLocations(compid);
       	int usrsecid =compid;
       	int seltype=1;
     	String usrsecname=compname;
//       	if(loc !=null && loc.size()>0)
//       	{
//       		usrsecid = loc.get(0).getLocationid(); 
//       		usrsecname = loc.get(0).getLocationname();
//       	}
       	if(usrpref != null && usrpref.size()!=0){
       		//logger.info("*** Inside MainCtrl usrpref**");
		 favmenu = usrpref.get(0).getFavoperation();	
		
		 seltype=3;
		}       
        request.setAttribute("favmenu", favmenu);
		myModel.put("favmenu", favmenu);
		myModel.put("usrsecid", usrsecid);
		myModel.put("seltype", seltype);
		myModel.put("usrsecname", usrsecname);
		myModel.put("is_url", is_url);
		myModel.put("precision", precision);
		
		logger.info("*** Inside MainCtrl usrsecid**" + usrsecid + "");
		// Depending on type of client, display either mobile menu or main menu		
		if (climob)
			 return new ModelAndView("mobilemain", "model", myModel);
		 else
			 return new ModelAndView("main", "model", myModel);  
    }
    
	
	/*
	 * Setter/Getter methods
	 */
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
    
}
