package ireveal.web;

import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.view.RedirectView;
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

import ireveal.domain.Product;
import ireveal.domain.TestData;
import ireveal.domain.TestFrequency;
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
    	
        logger.info("*** Inside Tools controller "+request.getParameter("oper"));
        Calendar cal = Calendar.getInstance();
     	Date curTime = cal.getTime();
     	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> myModel = new HashMap<String, Object>();
        String operstr = request.getParameter("oper");
        String atype=request.getParameter("atype");
        String testid="0";
        testid=	request.getParameter("testid");
        String freq=request.getParameter("freq");
        if(testid==null || testid=="" || testid=="null" ||  testid.equals("undefined")){
        	testid="0";
        }
        if(freq==null || freq=="" || freq=="null" ||  freq.equals("undefined") ){
        	freq="-1";
        }
        if (operstr == null){
    		logger.info("*** error condition. operstr is null !!**");
    		operstr = "null";
        }else{
        		
			if (operstr.contains("rset")){
        		logger.info("*** rset ** testid "+testid);
        		String strfreqs="";
        		List<TestFrequency> freqlist=this.mastersservice.getFreqList(Integer.parseInt(testid));
        		for (int i=0;i<freqlist.size();i++){
        			if(i==0)
        				{strfreqs=freqlist.get(i).getFrequency()+"";}
        			else {strfreqs=strfreqs+","+freqlist.get(i).getFrequency();}
        		}
        		logger.info("*** strfreqs ** "+strfreqs);
        		 //myModel.put("freqlist", this.mastersservice.getFreqList(Integer.parseInt(testid)));
        		 myModel.put("testid",testid);
        		 myModel.put("strfreqs",strfreqs);
        		 myModel.put("freqlist",freqlist);
        		 myModel.put("atype",atype);
                return new ModelAndView("reportset", "model", myModel);        	
        	}
			else if (operstr.contains("hpolar")){
        		logger.info("*** hpolar ** testid "+testid);
        		TestData pd=mastersservice.getTestData(Integer.parseInt(testid));
        		String ptype=pd.getPtype();
        		if(atype.equals("E") && ptype.equals("L") )
        		{
        			atype=mastersservice.getType(Integer.parseInt(testid));
        		}
        		if(atype.equals("A") && ptype.equals("L"))
        		{
        			atype="Y";
        		}
        		 myModel.put("freqlist", this.mastersservice.getFreqList(Integer.parseInt(testid)));
        		 myModel.put("testid",testid);
        		 myModel.put("freq",freq);
        		 myModel.put("atype",atype);
                return new ModelAndView("hpolar", "model", myModel);        	
        	}
			else if (operstr.contains("db")){
				TestData pd=mastersservice.getTestData(Integer.parseInt(testid));
        		String ptype=pd.getPtype();
        		if(atype.equals("E") && ptype.equals("L") )
        		{
        			atype=mastersservice.getType(Integer.parseInt(testid));
        		}
				//String ptype="L";
				
				String typ = request.getParameter("typ");
        		logger.info("*** db ** testid= "+testid +" atype= "+atype);
        		myModel.put("atype",atype);
       		    myModel.put("testid",testid);
       		    myModel.put("typ",typ);
               return new ModelAndView("xdb_bw_bs", "model", myModel);        	
       	}
			else if (operstr.contains("ar")){
				String typ = request.getParameter("typ");
        		logger.info("*** db ** testid "+testid);
       
       		 myModel.put("testid",testid);
       		 myModel.put("typ",typ);
       		 myModel.put("atype",atype);
             return new ModelAndView("ar", "model", myModel);   
             
       	    }
			else if (operstr.contains("ampphase")){
				
        		logger.info("*** ampphase ** ");
       
       		 myModel.put("prodlist",mastersservice.getProductList());
       		
             return new ModelAndView("ampphaserpt", "model", myModel);   
             
       	    }
			else if (operstr.contains("viewaptracking")){
				String maxDiff="";
				String maxFreq="";
				String typ = request.getParameter("typ");
				String prodseriallist = request.getParameter("prodseriallist");
				Map<String, Object> resultset=mastersservice.GetAmpPhaseValue(prodseriallist,typ);
				//logger.info("Return out value:"+resultset.get("maxDiff"));
				if(resultset!=null)
				{
					maxDiff=resultset.get("maxDiff").toString();
					freq=resultset.get("maxFreq").toString();
				}
        		logger.info("*** ampphase ** typ "+typ+" prodseriallist "+prodseriallist);    
       		//type,prodserialids,maxamp,freq
             return new ModelAndView(new RedirectView("/birt-verdant/frameset?__report=CPGain.rptdesign&type="+typ+"&prodserialids="+prodseriallist+"&maxamp="+maxDiff+"&freq="+maxFreq)); 
			        }
        }
        logger.info("*** not able to identify tools options!!**");
        return new ModelAndView("setup", "model", myModel);
    }
    
    
    
}

