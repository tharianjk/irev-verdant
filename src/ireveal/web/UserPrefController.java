package ireveal.web;


import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.security.core.userdetails.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.service.SetupManager;
import ireveal.domain.UserPref;

@SuppressWarnings("deprecation")
public class UserPrefController extends SimpleFormController {

    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());

    private SetupManager setupManager;
    
    private HttpSession cursess;
    
    private String favmenutxt="";
    
    

    /**
    * 
    * 
    *
    * @param  
    * @return 
    */
    public ModelAndView onSubmit(Object command)
            throws ServletException {
    	Object uid =cursess.getAttribute("uid");
    	
    	UserPref userp = (UserPref)command;
        logger.info("*** UserPreferences in onsubmit** ");
        if(uid==null)
        {
        	setupManager.InsertUserPreferences(userp);
        }
        else
        {
        setupManager.updateUserPreferences(userp);
        }
        return new ModelAndView(new RedirectView("userpref.htm?savestat=saved"));
    }

    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
    	cursess = request.getSession();
        User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserPref  upref=new UserPref();
         upref = setupManager.getUserPreferences(user.getUsername());
        // logger.info("*** UserPreferences in uname** " +user.getUsername()); 
         
        int userid=setupManager.grtUserid(user.getUsername());
       // logger.info("*** UserPreferences in uid** " +userid); 
        if(upref==null)
        {
        	//logger.info("*** UserPreferences in upref=null"); 
        	upref=new UserPref();
        	upref.setUser_id(userid);
        	request.getSession().setAttribute("uid", null);
        	cursess.setAttribute("uid",null);
        }
        else
        {
        	
             favmenutxt=upref.getFavoperation();
             request.setAttribute("favmenutxt", favmenutxt );
             request.getSession().setAttribute("uid", upref.getUser_id());
	         cursess.setAttribute("uid", upref.getUser_id());
        }
       // logger.info("*** UserPreferences in upref ");
        return upref;       
    }
    
    

    protected Map<String, Object> referenceData(HttpServletRequest request) throws Exception {
		HashMap<String, Object> referenceData = new HashMap<String, Object>();
        referenceData.put("favmenutxt", favmenutxt);
       return referenceData;
	}
   
    
    public void setSetupManager(SetupManager mngr) {
        this.setupManager = mngr;
    }

    public SetupManager getSetupManager() {
        return setupManager;
    }
    
    
}
