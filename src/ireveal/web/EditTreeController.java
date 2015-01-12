package ireveal.web;

import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Date;

public class EditTreeController implements Controller {
	
    protected final Log logger = LogFactory.getLog(getClass());
    
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	  logger.info("*** Inside edit controller " +request.getSession().getAttribute("treemode"));
    	request.getSession().setAttribute("treemode","edit");
        logger.info("*** Inside edit controller ");
        Map<String, Object> myModel = new HashMap<String, Object>();
        myModel.put("treemode","edit");
        request.getSession().setAttribute("treemode","edit");
		//request.getRequestDispatcher("/WEB-INF/jsp/assettree.jsp").forward(request, response);
		logger.info("*** meeters and tags settings**");
		//myModel.put("section", this.sectionService.getSectionList()); 
		
        return new ModelAndView("edittree", "model", myModel);
             
    }
    
}
