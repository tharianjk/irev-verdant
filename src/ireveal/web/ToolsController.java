package ireveal.web;

import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.Date;
import java.text.DateFormat;
import ireveal.service.MastersService;



public class ToolsController implements Controller {

    protected final Log logger = LogFactory.getLog(getClass());
    
	public MastersService mastersservice ;
	
 	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
    
	@Value("${appl.is_url}")
    private String is_url; // Holds the URL to Integration Server. Picked from application.properties
	
    /**
    * 
    * 
    *
    * @param  
    * @return 
     * @throws ParseException 
    */
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
        logger.info("*** Inside Tools controller ");
        Calendar cal = Calendar.getInstance();
     	Date curTime = cal.getTime();
     	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> myModel = new HashMap<String, Object>();
        String operstr = request.getParameter("oper");
        
        if (operstr == null){
    		logger.info("*** error condition. operstr is null !!**");
    		operstr = "null";
        }else{
        		
			if (operstr.contains("eventanalysis")){
        		logger.info("*** Event Analysis **");
                return new ModelAndView("eventchart", "model", myModel);        	
        	}
			        }
        logger.info("*** not able to identify tools options!!**");
		return new ModelAndView("tagvallist", "model", myModel);
    }
    
    
    
}

