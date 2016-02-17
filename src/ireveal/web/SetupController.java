package ireveal.web;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.util.Map;
import java.util.HashMap;
import java.util.List;

import ireveal.domain.PVSerialData;
import ireveal.service.SetupManager;
import ireveal.service.MastersService; 


public class SetupController implements Controller {
	@Value("${appl.is_url}")
    private String is_url; // Holds the URL to Integration Server. Picked from application.properties
    protected final Log logger = LogFactory.getLog(getClass());
    private SetupManager setupManager;
    
    String deletemsg="Deleted";
  	int meterid; // to store meter_id of currently viewing/editing meter
  	public MastersService mastersservice ;
  	
  	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
    
    /**
    * 
    * 
    *
    * @param  
    * @return 
    */
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	Map<String, Object> myModel = new HashMap<String, Object>();
      	String operstr = request.getParameter("oper");
      	int stat =-1;
      	
        logger.info("*** Inside setup controller, operation="+operstr+",is_url="+is_url);

        if (operstr == null){
    		logger.info("*** error condition. operstr is null !!**");
    		operstr = "null";
        }
        //source
        
        //user
        else if (operstr.contains("user")){
        		logger.info("*** user settings**");
        		myModel.put("users", this.setupManager.getUsers()); 
        		myModel.put("stat", stat );
                return new ModelAndView("userlist", "model", myModel);
        	}
        else if (operstr.contains("deleteusr")){
    		deletemsg="Deleted";
        	String userid = request.getParameter("userid");
        	String user = request.getParameter("user");
    		logger.info("*** User delete**" +userid);
    		boolean blnstat=this.setupManager.deleteUser(Integer.parseInt(userid));
 		    stat=1;
    		
    		if(blnstat==false)
    		{
    			stat=0;
    			deletemsg=user +" could not be deleted reference exists";
    		}
    		myModel.put("msg", deletemsg );
    		myModel.put("stat", stat );
    		myModel.put("users", this.setupManager.getUsers()); 
    		 return new ModelAndView("userlist", "model", myModel);
        }
        
      //assettree
        else if (operstr.contains("assettree")){
        		logger.info("*** asset tree settings**");
        		
        		
        	}
        
        //role
        	else if (operstr.contains("role")){
        		logger.info("*** Role settings**");
        		myModel.put("roles", this.setupManager.getRoles()); 
        		myModel.put("stat", stat );
        		return new ModelAndView("rolelist", "model", myModel);
        		
        	}
        	else if (operstr.contains("deleterle")){
        		deletemsg="Deleted";
            	String roleid = request.getParameter("roleid");
            	String role = request.getParameter("role");
        		logger.info("*** Role delete**" +roleid);
        		boolean blnstat=this.setupManager.deleteRole(Integer.parseInt(roleid));
     		    stat=1; 
        		if(blnstat==false)
        		{
        			stat=0;
        			deletemsg=role +" could not be deleted reference exists";
        		}
        		myModel.put("msg", deletemsg );
        		myModel.put("stat", stat );
        		myModel.put("roles", this.setupManager.getRoles()); 
        		return new ModelAndView("rolelist", "model", myModel);
            }
        	else if (operstr.equals("pvserial")){
        		logger.info("*** PVSerial settings**");
        		
        		String testid = request.getParameter("testid");
        		List<PVSerialData> pvserial=this.mastersservice.getPVSerialList(Integer.parseInt(testid));
        		myModel.put("pvserial", pvserial); 
        		myModel.put("stat", stat );
        		myModel.put("testid", testid );        		
        		myModel.put("testname", mastersservice.getPVTest(Integer.parseInt(testid)).getTestname() );
        		return new ModelAndView("pvseriallist", "model", myModel);
        		
        	}
        	else if (operstr.equals("deletepvserial")){
        		deletemsg="Deleted";
            	String id = request.getParameter("pvserialid");
            	String serialno = request.getParameter("serialno");
            	String testid=request.getParameter("testid");
        		logger.info("*** serial delete**" +id);
        		boolean blnstat=this.mastersservice.deletePVSerial(Integer.parseInt(id));
     		    stat=1; 
        		if(blnstat==false)
        		{
        			stat=0;
        			deletemsg=serialno +" could not be deleted reference exists";
        		}
        		myModel.put("msg", deletemsg );
        		myModel.put("stat", stat );
        		myModel.put("testid", testid );   
        		List<PVSerialData> pvserial=this.mastersservice.getPVSerialList(Integer.parseInt(testid));
        		myModel.put("pvserial", pvserial); 
        		myModel.put("testname", mastersservice.getPVTest(Integer.parseInt(testid)).getTestname() );
        		return new ModelAndView("pvseriallist", "model", myModel);
            }
                return new ModelAndView("setup", "model", myModel);
             
    }
    
    public void setSetupManager(SetupManager Mngr) {
        this.setupManager = Mngr;
    }
    
   
   
}
