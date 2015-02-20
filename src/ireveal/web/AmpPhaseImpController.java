package ireveal.web;


import ireveal.domain.AmpPhaseTrack;
import ireveal.domain.DataLog;
import ireveal.domain.ProductSerial;
import ireveal.domain.ImportData;
import ireveal.service.MastersService;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
 
public class AmpPhaseImpController extends SimpleFormController{
	String err="File Uploaded Successfully";
	public MastersService mastersservice ;
	private HttpSession cursess;
	private int testid=0;
	private int prdserid=0;
	public AmpPhaseImpController(){
		setCommandClass(ImportData.class);
		setCommandName("ImportData");
	}
 
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response, Object command, BindException errors)
		throws Exception {
		String action="More";
		String strmode="new";
		int stat=0;  // 0 = success, 1 = error
		logger.info("*** Inside testcontroller in onsubmit**: ");
        // check if user pressed Done
        
		request.setAttribute("err", null);
        request.setAttribute("message", null);
        cursess.setAttribute("message",null);
        cursess.setAttribute("err",null);
		List<DataLog> datalogList = new ArrayList<DataLog>();
		err="File Uploaded Successfully";
		ImportData file = (ImportData)command;
		prdserid=file.getProductserialid();
		MultipartFile multipartFile = file.getFilename();
				
		String fileName="";
		 
		logger.info("Inside FileUpload Controller");
		if(multipartFile!=null){
			fileName = multipartFile.getOriginalFilename();
			logger.info("Inside FileUpload Controller fileName" +fileName);
			try {
				// Read  file 
				InputStreamReader freader = null;
		        LineNumberReader lnreader = null;
		        String line = "";
	            String fields[];
				InputStream inp = multipartFile.getInputStream() ;
				freader = new InputStreamReader(inp);
	            lnreader = new LineNumberReader(freader);
	            int rowno=0;
	            while ((line = lnreader.readLine()) != null) {
	            	//logger.info("line "+line);
	            
	            	if(rowno>0){
	                fields = line.split(",");
	                //logger.info("fields[0] "+fields[0]);
	                DataLog datalog= new DataLog();
	                datalog.setFreq(Double.parseDouble(fields[0].toString()));
	                datalog.setAmplitude(Double.parseDouble(fields[1].toString()));
	                datalogList.add(datalog);}
	            	rowno=rowno+1;
	            }						        
			      	logger.info(" datalogList.size "+datalogList.size());
					if(datalogList.size()>0)
					{
				mastersservice.InsertAmpPhase(datalogList, file);
					}
					request.setAttribute("message", "File Uploaded Successfully");					
			} catch (Exception ex) {
						stat = 1;
						err="File Upload Failed!! Reason: " + ex;
						request.setAttribute("message", "File Upload Failed due to " + ex);
						logger.info("Inside FileUpload Controller Exception " + ex.getMessage());
			}			
		}
		return new ModelAndView(new RedirectView("ampphaseimp.htm?PId="+prdserid+"&savestat="+stat+"&msg="+err));
			
		// ampphaseimp.htm?PId=${prev.prodserialid}&oper=deltrack&testname=${prev.testname}&ttype=${prev.type}
	}
	@Override
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder)
	throws ServletException {
 
	// Convert multipart object to byte[]
	binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
 
    }
	
	
	
	 protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	    	String oper = request.getParameter("oper");	    	
	        String PId=request.getParameter("PId");
	        String atype=request.getParameter("atype");
	        request.getSession().setAttribute("savestat", null);
	        logger.info("inside AmpPhaseController"); 
	      if(oper!=null && oper!="")
	      {
	    	  if(oper.equals("deltrack"))
	    	  {
	    		  String testname= request.getParameter("testname");
	    		  String typ= request.getParameter("ttype");
	    	  mastersservice.deleteTracking(Integer.parseInt(PId), testname, typ);
	    	  }
	      }
	        	logger.info(" going to create new import");
	        	request.getSession().setAttribute("id", null);
	        	cursess.setAttribute("id",null);
	        	ImportData testdata=new ImportData();
	        	testdata.setProductserialid(Integer.parseInt(PId));
	        	testdata.setPtype(atype);
	        	prdserid=Integer.parseInt(PId);
	        	return testdata;
	        
	              
	    }
	    protected HashMap referenceData(HttpServletRequest request) throws Exception {
			HashMap referenceData = new HashMap();	
	        List<ProductSerial> prodserlist = mastersservice.getProdVerSer();        
	        List<AmpPhaseTrack> tracklist= mastersservice.getProdSerTracking(prdserid);
	        
	        referenceData.put("prodserlist", prodserlist);
	        referenceData.put("preventries", tracklist);
	        referenceData.put("listsize", tracklist.size());
	 		return referenceData;
		}
	
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
	  

	}

