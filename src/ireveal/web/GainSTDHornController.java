package ireveal.web;


import ireveal.domain.GainSTDHorn;
import ireveal.domain.ProductSerial;
import ireveal.domain.TestData;
import ireveal.domain.TestFrequency;
import ireveal.service.MastersService;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;





import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.view.RedirectView;
 
public class GainSTDHornController implements Controller{
	
	public MastersService mastersservice ;
	private HttpSession cursess;
	private int testid=0;
	private String frequnit;
	 protected final Log logger = LogFactory.getLog(getClass());
 
	@Override
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException ,JSONException {
		
		 logger.info("inside GainSTDHornController inside onsubmit");
		 Map<String, Object> myModel = new HashMap<String, Object>();
		 String operstr = request.getParameter("oper");
		 String id = request.getParameter("testid");
		 String strjsonfreq = request.getParameter("strjsonfreq");
		 String frequnit = request.getParameter("frequnit");
		 testid= Integer.parseInt(id);
		logger.info("inside GainSTDHornController operstr="+operstr);
		if(operstr.equals("gainstd"))
		{
			TestData testdata=mastersservice.getTestData(testid);
			frequnit=testdata.getFrequnit();
			
			 myModel.put("testid",testid);
			 myModel.put("testname",testdata.getTestname());
			 myModel.put("freqlist",mastersservice.getGainSTD(testid));
			 myModel.put("frequnit",frequnit);
            return new ModelAndView("gainstdhorn", "model", myModel);     
		}
		else{
		List<GainSTDHorn> freqlist=new ArrayList<GainSTDHorn>();
		
				
	    JSONObject obj1 = new JSONObject(strjsonfreq);
	     try {
	      JSONArray result = obj1.getJSONArray("jsonfreq");
	    for(int i=0;i<result.length();i++)
	     {
	    	GainSTDHorn testfreq= new GainSTDHorn();
	    	logger.info(result.get(i));
	    	JSONObject obj2 = (JSONObject)result.get(i);
	    	logger.info(obj2.get("freq"));
	    	logger.info(obj2.get("lg"));
	    	if(frequnit.equals("GHz"))
	    	{    		  
	    	testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString())*1000);
	    	}
	    	else
	    		{testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString()));}
	    	testfreq.setStdhorn(Double.parseDouble(obj2.get("lg").toString()));
	    	freqlist.add(testfreq);
	     }
	    mastersservice.UpdateGainSTD(freqlist, testid);
	     } catch (JSONException e) {
	         e.printStackTrace();
	    }
	     TestData testdata=mastersservice.getTestData(testid);
	     myModel.put("testid",testid);
		 myModel.put("testname",testdata.getTestname());
		 myModel.put("freqlist",mastersservice.getGainSTD(testid));
		 myModel.put("frequnit",frequnit);
	     return new ModelAndView("gainstdhorn?oper=save&testid="+testid, "model", myModel); 
		}
	
	     
	}
	
	
	
	 
	
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
	  

	}
