package ireveal.web;


import java.util.HashMap;
import java.util.List;

import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.service.SetupManager;
import ireveal.domain.User;
import ireveal.domain.RoleDsp;

@SuppressWarnings("deprecation")
public class UserController extends SimpleFormController {

    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());

    private SetupManager setupManager;
    private HttpSession cursess;
    private String cur_role;

    /**
    * 
    * 
    *
    * @param  
    * @return 
    */
    public ModelAndView onSubmit(Object command)
            throws ServletException {
    	String edituser = (String)cursess.getAttribute("currUser");
    	User user = (User)command;
        logger.info("*** in onsubmit** ");
        if (user.getUsername() == null){
        	// End user must have pressed cancel button.
        	return new ModelAndView(new RedirectView(getSuccessView()));
        }
        logger.info(" username = "+user.getUsername()+", curruser="+edituser+" , userrole="+user.getRole());
        if (edituser == null){
        	logger.info("*** in onsubmit .. going to create new user** ");
            setupManager.saveUser(user);        	
        }else{
        	logger.info("*** in onsubmit .. going to update user** ");
        	setupManager.updateUser(user);
        }

        logger.info("returning view to " + getSuccessView());

        return new ModelAndView(new RedirectView(getSuccessView()));
    }

    protected Object formBackingObject(HttpServletRequest request) throws ServletException {
        String username = request.getParameter("usr");
        cursess = request.getSession();
        User  cur_user;
        
        if (username == null){
        	logger.info(" going to creaate new user");
        	request.getSession().setAttribute("currUser", null);
        	return new User();
        }else{
        	request.getSession().setAttribute("currUser", username);
            logger.info(" going to retrieve details of user="+username);
            cur_user = setupManager.getUser(username);
            cur_role = cur_user.getRole(); // store this for use during call to referenceData
        	return cur_user;
        }       
    }
    
    
    
    protected HashMap<String, Object> referenceData(HttpServletRequest request) throws Exception {
		HashMap<String, Object> referenceData = new HashMap<String, Object>();
        List<RoleDsp> rolelist = setupManager.getAssignableRoles();        
       
        referenceData.put("AllRoles", rolelist);
        referenceData.put("cur_role", cur_role);
        
 		return referenceData;
	}
   
    
    public void setSetupManager(SetupManager mngr) {
        this.setupManager = mngr;
    }

    public SetupManager getSetupManager() {
        return setupManager;
    }

}
