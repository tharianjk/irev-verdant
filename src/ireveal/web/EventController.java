package ireveal.web;

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
import java.util.Date;

public class EventController implements Controller {

    protected final Log logger = LogFactory.getLog(getClass());
    
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        logger.info("*** Inside event controller ");
        Map<String, Object> myModel = new HashMap<String, Object>();
        return new ModelAndView("event", "model", myModel);
             
    }
    
}
