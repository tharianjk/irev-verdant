package ireveal.web;


import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.service.MastersService;
import ireveal.service.SetupManager;
import ireveal.domain.RoleDsp;



@SuppressWarnings("deprecation")
public class RoleController extends SimpleFormController {

    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());
    private MastersService mstrService;
    private SetupManager setupManager;    
    private HttpSession cursess;
    

    /**
    * 
    * 
    *
    * @param  
    * @return 
    */
    public ModelAndView onSubmit(Object command)
            throws ServletException {
    	String editrole = (String)cursess.getAttribute("currRole");
    	RoleDsp role = (RoleDsp)command;
        logger.info("*** in onsubmit** :rolename="+role.getRolename());
        if (role.getRolename().isEmpty()){
        	// user pressed cancel
        	return new ModelAndView(new RedirectView(getSuccessView()));
        }
        // Is this for editing an existing Role or creating a new role
        if (editrole == null){
        	logger.info("*** in onsubmit .. going to create new role**:" );
        	
            setupManager.createRole(role);        	
        }else{
        	logger.info("*** in onsubmit .. going to update role: id="+editrole);
        	/*if(role.getAllowedSections().length==0){
        	List<Section> seclist = sectionMngr.getSectionList();
            String[] sectionList = new String[seclist.size()];
            for (int i=0; i<seclist.size(); i++){
            	sectionList[i] = seclist.get(i).getDisplayname();
            }
            role.setAllowedSections(sectionList);
        	}*/
        	role.setRole_id(Integer.parseInt(editrole));
        	setupManager.updateRole(role);
        }

        return new ModelAndView(new RedirectView(getSuccessView()));
    }

    

	protected Object formBackingObject(HttpServletRequest request) throws ServletException {
        String roleid_s = request.getParameter("id");
        cursess = request.getSession();
//        List<Section> seclist = sectionMngr.getSectionList();
RoleDsp rle=new RoleDsp();
        if (roleid_s == null){
        	logger.info(" going to create new role");
        	request.getSession().setAttribute("currRole", null);
       
        }else{
        	request.getSession().setAttribute("currRole", roleid_s);
            logger.info(" going to retrieve details of role="+roleid_s);
            rle=setupManager.getRole(roleid_s);
            
        }       
     	return rle;
    }
    
 
	 protected HashMap<String, Object> referenceData(HttpServletRequest request) throws Exception {
			HashMap<String, Object> referenceData = new HashMap<String, Object>();

		return referenceData;
	}
    
    
    public void setSetupManager(SetupManager mngr) {
        this.setupManager = mngr;
    }

    public SetupManager getSetupManager() {
        return setupManager;
    }

    public void setMstrService(MastersService msvc){
    	this.mstrService = msvc;
    }
}
