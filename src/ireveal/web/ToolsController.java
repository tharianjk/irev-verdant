package ireveal.web;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import ireveal.domain.PVSerialData;
import ireveal.domain.PVTest;
import ireveal.domain.ProductSerial;
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
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String uname = auth.getName();

		//  boolean isadmin=mastersservice.IsAdminUser();

		logger.info("*** Inside Tools controller "+request.getParameter("oper")+ " unam "+uname);
		Map<String, Object> myModel = new HashMap<String, Object>();
		String operstr = request.getParameter("oper");
		String atype=request.getParameter("atype");
		String ptype=request.getParameter("ptype");
		String testid="0";
		testid=	request.getParameter("testid");
		String freq=request.getParameter("freq");
		String treetype=request.getParameter("treetype");
		String rptheader="";
		String rptfooter="";
		int nprecision=1;
		nprecision=mastersservice.getPrecision();
		if(treetype==null || treetype.equals("") || treetype=="null" ||  treetype.equals("undefined")){
			treetype="0";
		}
		logger.info("*** treetype="+treetype);
		if(testid==null || testid.equals("") || testid=="null" ||  testid.equals("undefined")){
			testid="0";
		}

		if (operstr == null){
			logger.info("*** error condition. operstr is null !!**");
			operstr = "null";

			myModel.put("now", operstr);
			return new ModelAndView("setup", "model", myModel);
		}else
		{
			if(treetype.equals("4"))
			{
				ProductSerial lstp=mastersservice.getheaderfooter(Integer.parseInt(testid));
				if(lstp!=null ){
					rptheader=lstp.getRptheader();
					rptfooter=lstp.getRptfooter();}

				if(rptheader==null || rptheader.equals("") || rptheader=="null")
					rptheader="No Header";
				if(rptfooter==null || rptfooter.equals("") || rptfooter=="null")
					rptfooter="No Footer";

				if(freq==null || freq.equals("") || freq=="null" ||  freq.equals("undefined") ){
					freq="-1";
				}


				if (operstr.contains("rset")){
					logger.info("*** rset ** testid "+testid);
					String strfreqs="";
					String typ="";
					List<TestFrequency> freqlist=this.mastersservice.getFreqList(Integer.parseInt(testid));
					for (int i=0;i<freqlist.size();i++){
						if(i==0)
						{strfreqs=freqlist.get(i).getFrequency()+"";}
						else {strfreqs=strfreqs+","+freqlist.get(i).getFrequency();}
					}
					if(atype.equals("E") && ptype.equals("L") )
					{
						typ=mastersservice.getType(Integer.parseInt(testid));
					}
					if(atype.equals("A") && ptype.equals("L"))
					{
						typ="Y";
					}
					logger.info("*** strfreqs ** "+strfreqs);
					//myModel.put("freqlist", this.mastersservice.getFreqList(Integer.parseInt(testid)));
					myModel.put("testid",testid);
					myModel.put("strfreqs",strfreqs);
					myModel.put("freqlist",freqlist);
					myModel.put("atype",atype);
					myModel.put("type",typ);
					myModel.put("rptheader",rptheader);
					myModel.put("rptfooter",rptfooter);
					myModel.put("nprecision",nprecision);
					return new ModelAndView("reportset", "model", myModel);        	
				}
				else if (operstr.contains("hpolar")){
					String frequnit="MHz";
					logger.info("*** hpolar ** testid "+testid);
					TestData pd=mastersservice.getTestData(Integer.parseInt(testid));
					frequnit=pd.getFrequnit();
					ptype=pd.getPtype();
					if(atype.equals("E") && ptype.equals("L") )
					{
						atype=mastersservice.getType(Integer.parseInt(testid));
					}
					if(atype.equals("A") && ptype.equals("L"))
					{
						atype="Y";
					}
					String strfreqs="";
					List<TestFrequency> freqlist=this.mastersservice.getFreqList(Integer.parseInt(testid));
					for (int i=0;i<freqlist.size();i++){
						if(i==0)
						{strfreqs=freqlist.get(i).getFrequency()+"";}
						else {strfreqs=strfreqs+","+freqlist.get(i).getFrequency();}
					}
					logger.info("*** strfreqs ** "+strfreqs);
					//myModel.put("freqlist", this.mastersservice.getFreqList(Integer.parseInt(testid)));

					myModel.put("strfreqs",strfreqs);
					myModel.put("freqlist", freqlist);
					myModel.put("testid",testid);
					myModel.put("freq",freq);
					myModel.put("atype",atype);
					myModel.put("rptheader",rptheader);
					myModel.put("rptfooter",rptfooter);
					myModel.put("nprecision",nprecision);
					myModel.put("uname",uname);
					myModel.put("frequnit",frequnit);
					return new ModelAndView("hpolar", "model", myModel);        	
				}
				//polar multiple

				else if (operstr.contains("db")){
					TestData pd=mastersservice.getTestData(Integer.parseInt(testid));
					ptype=pd.getPtype();
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
					myModel.put("rptheader",rptheader);
					myModel.put("rptfooter",rptfooter);
					myModel.put("nprecision",nprecision);
					return new ModelAndView("xdb_bw_bs", "model", myModel);        	
				}
				else if (operstr.contains("ar")){
					String typ = request.getParameter("typ");
					logger.info("*** db ** testid "+testid);

					myModel.put("testid",testid);
					myModel.put("typ",typ);
					myModel.put("atype",atype);
					myModel.put("rptheader",rptheader);
					myModel.put("rptfooter",rptfooter);
					myModel.put("nprecision",nprecision);
					return new ModelAndView("ar", "model", myModel);   

				}

				else if(operstr.equals("od")){
					atype=request.getParameter("atype");
					ptype=request.getParameter("ptype");
					if(ptype.equals("L")){					
						return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/LinAzimuthOD.rptdesign&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));}
					else{
						return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/SlantAzimuthOD.rptdesign&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));

					}
				}
				else if(operstr.equals("blobe")){

					atype=request.getParameter("atype");
					ptype=request.getParameter("ptype");
					logger.info("*** blobe ** atype "+atype+" ptype "+ptype); 
					if(atype.equals("NCP")){
						return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/BlobWithOutCP.rptdesign&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));
					}
					else if(ptype.equals("C") && !atype.equals("NCP")){
						return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/BlobWithCP.rptdesign&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));
					}
					else if(ptype.equals("S") && atype.equals("E") ){
						return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/BlobWithOutCP.rptdesign&testid="+testid+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));
					}
				}


			}//treetype=4

			else if (!treetype.equals("4"))
			{
				if(treetype.equals("3"))
				{
					PVTest pd=mastersservice.getPVTest(Integer.parseInt(testid));
					rptheader=pd.getRptheader();
					rptfooter=pd.getRptfooter();
					String frequnit="MHz";
					frequnit=pd.getFrequnit();
					if(rptheader==null || rptheader.equals("") || rptheader=="null")
						rptheader="No Header";
					if(rptfooter==null || rptfooter.equals("") || rptfooter=="null")
						rptfooter="No Footer";
					if (operstr.contains("pvpolar")){

						logger.info("*** pvpolar ** testid "+testid);


						atype=pd.getTesttype();
						String typ=request.getParameter("typ");
						String strfreqs="";
						List<TestFrequency> freqlist=this.mastersservice.getPVFreqList(Integer.parseInt(testid));
						for (int i=0;i<freqlist.size();i++){
							if(i==0)
							{strfreqs=freqlist.get(i).getFrequency()+"";}
							else {strfreqs=strfreqs+","+freqlist.get(i).getFrequency();}
						}
						logger.info("*** strfreqs ** "+strfreqs);
						//myModel.put("freqlist", this.mastersservice.getFreqList(Integer.parseInt(testid)));
						myModel.put("typ",typ);
						myModel.put("strfreqs",strfreqs);
						myModel.put("freqlist", freqlist);
						myModel.put("testid",testid);
						myModel.put("freq",freq);
						myModel.put("atype",atype);
						myModel.put("rptheader",rptheader);
						myModel.put("rptfooter",rptfooter);
						myModel.put("nprecision",nprecision);
						myModel.put("uname",uname);
						myModel.put("frequnit",frequnit);
						myModel.put("seriallist", mastersservice.getPVSerialList(Integer.parseInt(testid)));
						return new ModelAndView("pvpolar", "model", myModel);        	
					}
					else if (operstr.equals("gm") || operstr.equals("gt") || operstr.equals("threedb") || operstr.equals("tendb") || operstr.equals("axial") || operstr.equals("bsbl")  ){

						List<PVSerialData> seriallist=mastersservice.getPVSerialList(Integer.parseInt(testid));
						int serialcnt=mastersservice.PV_serialcount(Integer.parseInt(testid));
						String strslno="";
						for (int i=0;i<seriallist.size();i++){
							if(i==0)
							{strslno=seriallist.get(i).getProductserialid()+"";}
							else {strslno=strslno+","+seriallist.get(i).getProductserialid();}
						}

						String typ = request.getParameter("typ");
						logger.info("*** db ** testid= "+testid +" atype= "+atype);
						myModel.put("atype",atype);
						myModel.put("testid",testid);
						myModel.put("typ",typ);
						myModel.put("rptheader",rptheader);
						myModel.put("rptfooter",rptfooter);
						myModel.put("nprecision",nprecision);
						myModel.put("seriallist", seriallist);
						myModel.put("strslno",strslno);
						myModel.put("oper",operstr);
						myModel.put("serialcnt", serialcnt);
						myModel.put("frequnit",frequnit);
						return new ModelAndView("pvreports", "model", myModel);        	
					}


				}
				if (operstr.equals("ampphase"))
				{				
					logger.info("*** ampphase ** ");
					String prodid = request.getParameter("prodid");
					List<ProductSerial> dataList = new ArrayList<ProductSerial>();

					if(!prodid.equals("") && prodid!=null)
						dataList=mastersservice.getProdSerialWithAmpphase(Integer.parseInt(prodid));
					logger.info("*** dataList.size() ** "+dataList.size());
					if(dataList.size()>0){
						myModel.put("prodserlist",dataList);
						// myModel.put("rptheader",rptheader);
						// myModel.put("rptfooter",rptfooter);
						return new ModelAndView("ampphaserpt", "model", myModel);   
					}
					else{
						myModel.put("text","Please Select Product from asset tree with Tracking Data uploaded!! ");
						return new ModelAndView("blank", "model", myModel);
					}

				}
				if (operstr.equals("phasediff"))
				{	
					String testid1 = request.getParameter("testid");		
					ProductSerial lstp=mastersservice.getheaderfooter(Integer.parseInt(testid1));
						if(lstp!=null){
							rptheader=lstp.getRptheader();
							rptfooter=lstp.getRptfooter();
						}	
						if(rptheader==null || rptheader.equals("") || rptheader=="null")
							rptheader="No Header";
						if(rptfooter==null || rptfooter.equals("") || rptfooter=="null")
							rptfooter="No Footer";
					
					logger.info("*** phasediff ** testid="+testid);
					
					if(!testid1.equals("") && testid1!=null){	
						if(mastersservice.getCheckPhaseDiff(Integer.parseInt(testid1))>0){							
							return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/PhaseDifference.rptdesign&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision));
						}
						else{
							myModel.put("text","Please Select Test from asset tree with Phase Difference Data uploaded!! ");
							return new ModelAndView("blank", "model", myModel);
						}
					}
					else{
						myModel.put("text","Please Select Test from asset tree with Phase Difference Data uploaded!! ");
						return new ModelAndView("blank", "model", myModel);
					}
				}
				else if (operstr.contains("viewaptracking")){
					String maxDiff="0";
					String maxFreq="0";
					String typ = request.getParameter("typ");
					String prodseriallist = request.getParameter("prodseriallist");

					String var="";
					if(prodseriallist!=null && !prodseriallist.equals("")){
						String tests[]=prodseriallist.split(",");
						for (int i=0;i<tests.length;i++)
						{
							if(i==0)
								var="'"+tests[0]+"'";
							else
								var=var+",'"+tests[i]+"'";
						}
					}
					ProductSerial lstp=mastersservice.getPSheaderfooter(var);
					if(lstp!=null){
						rptheader=lstp.getRptheader();
						rptfooter=lstp.getRptfooter();
					}
					if(rptheader==null || rptheader.equals("") || rptheader=="null")
						rptheader="No Header";
					if(rptfooter==null || rptfooter.equals("") || rptfooter=="null")
						rptfooter="No Footer";

					TestFrequency track=mastersservice.calcTrack(var,typ);
					logger.info("viewaptracking prodseriallist="+var);

					if(track!=null )
					{
						if(track.getLineargain()!=0 && track.getFrequency()!=0){
							maxDiff="±"+track.getLineargain();
							maxFreq=track.getFrequency()+"";}
					}
					logger.info("*** ampphase ** typ "+typ+" prodseriallist "+var+" maxDiff= "+maxDiff+" freq ="+freq);    
					//type,prodserialids,maxamp,freq
					return new ModelAndView(new RedirectView("/birt-viewer/frameset?__report=verdant/PhaseTracking.rptdesign&type="+typ+"&prodserialids="+var+"&maxamp="+maxDiff+"&freq="+maxFreq+"&rpth="+rptheader+"&rptf="+rptfooter+"&pc="+nprecision)); 
				}
				else{
					String msg="Please make a Selection from the Asset Tree on the left side";
					myModel.put("text",msg);
					return new ModelAndView("blank", "model", myModel); 

				}

			}

			if(operstr.contains("blank")){
				String msg="Please make a Selection from the Asset Tree on the left side";
				myModel.put("text",msg);
				return new ModelAndView("blank", "model", myModel);   
			}



		}
		return new ModelAndView("setup", "model", myModel);

	}    


}


