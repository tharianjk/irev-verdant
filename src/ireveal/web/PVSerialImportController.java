package ireveal.web;

import ireveal.domain.DataLog;
import ireveal.domain.PVSerialData;
import ireveal.domain.PVTest;
import ireveal.domain.ProductSerial;
import ireveal.domain.TestFrequency;
import ireveal.service.MastersService;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
 
public class PVSerialImportController extends SimpleFormController{
	String err="File Uploaded Successfully";
	public MastersService mastersservice ;
	private HttpSession cursess;
	private int serialid=0;
	private int testid=0;
	String testtype="";
	String atype="";
	
	public PVSerialImportController(){
		setCommandClass(PVSerialData.class);
		setCommandName("PVSerialData");
	}
 
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response, Object command, BindException errors)
		throws Exception,ImportException {
		String action="More";
		String strmode="new";
		String fileName="";
		int stat=-1;
		logger.info("*** Inside PVSerialcontroller in onsubmit**: btn= "+request.getParameter("fmaction"));
              
		 List<TestFrequency> rastdlist= new ArrayList<TestFrequency>();
		 String strserialid = (String)cursess.getAttribute("id");
		 strmode= (String)cursess.getAttribute("mode");
		 if(strmode==null)strmode="new";
		 logger.info("*** Inside PVSerialcontroller in onsubmit** strmode:"+strmode);
		 if(strserialid!=null && strserialid!="" && strserialid!="null" && strserialid!="0" && strmode.equals("new")){
			 strmode="addfile";
			 serialid=Integer.parseInt(strserialid)	;
		 }
		 PVSerialData file = (PVSerialData)command;
		 testtype=file.getTesttype();
         atype=file.getPtype();
         testid=file.getTestid();
         serialid=file.getProductserialid();
         String filetype=file.getFiletype();
         MultipartFile multipartFile = file.getFilename();
         logger.info("*** Inside PVSerialcontroller in onsubmit** filetype:"+filetype);
    	 if (request.getParameter("fmaction").equals("Calculate"))
	        {
	        	action="Done";
	        }
	 
		if(action.equals("Done")){
				 stat=	mastersservice.PV_CalcProc(testid,serialid);
				if(stat==0)
				{
					err="Failed to calculate";
					
				}
				else
				{
					err="Calculation completed successfully";
				}
		}
		else{
       /*  if(filetype.equals("M"))
         {
        	 List<TestFrequency> freqlist=new ArrayList<TestFrequency>();
        	 logger.info("*** Inside PVSerialcontroller in onsubmit**: Gain Measurement");
        	 JSONObject obj1 = new JSONObject(file.getStrjsonfreq());
		     try {
		      JSONArray result = obj1.getJSONArray("jsonfreq");
		      logger.info("*** Inside PVSerialcontroller in onsubmit** freqlength:"+ result.length());
		    for(int i=0;i<result.length();i++)
		     {
		    	TestFrequency testfreq= new TestFrequency();		    	
		    	JSONObject obj2 = (JSONObject)result.get(i);		    	
		    	if(file.getFrequnit().equals("GHz"))
		    	{  		  
		    	
		    		testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString())*1000);
		    	}
		    	else
		    		{testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString()));}
		    //	testfreq.setLineargain(Double.parseDouble(obj2.get("lg").toString()));
		    	freqlist.add(testfreq);
		     }
		     } catch (JSONException e) {
		    	 logger.info(" JSONException "+e.getMessage());
		    	 err=e.getMessage();
		    }
        	
        	
     		if(multipartFile!=null)
     		{
     			fileName = multipartFile.getOriginalFilename();
     			logger.info("Inside PVSerialcontroller Controller fileName" +fileName);
     			try {
     				// Read excel file 
     			      InputStream inp = multipartFile.getInputStream() ;
     			      String fileExtn = GetFileExtension(fileName);
     			      Workbook wb_xssf; //Declare XSSF WorkBook
     			      Workbook wb_hssf; //Declare HSSF WorkBook
     			      Sheet sheet = null; // sheet can be used as common for XSSF and HSSF 	WorkBook
     			      if (fileExtn.equalsIgnoreCase("xlsx"))
     			      {
     			    	   wb_xssf=  WorkbookFactory.create(inp);
     				      // wb_xssf = new XSSFWorkbook();
     				       logger.info("xlsx="+wb_xssf.getSheetName(0));
     				      sheet = wb_xssf.getSheetAt(0);
     			      }
     			      if (fileExtn.equalsIgnoreCase("xls"))
     			      {
     				  POIFSFileSystem fs = new POIFSFileSystem(inp);
     			    	  wb_hssf = new HSSFWorkbook(fs);
     			    	  logger.info("xls="+wb_hssf.getSheetName(0));
     			    	  sheet = wb_hssf.getSheetAt(0);
     			      }
     			      int rowNum = sheet.getLastRowNum()+1;
     			      int colNum = sheet.getRow(0).getLastCellNum();
     			      ArrayList<Double> freqarr= new ArrayList<Double>();
				      for(int u=1;u<rowNum;u++){
				    	  XSSFRow row =(XSSFRow) sheet.getRow(u);
				    	  freqarr.add( Double.parseDouble(row.getCell(0).toString()));
				      }
				      Double selfreq=0.00;
				      String freq="";
						for (int p=0;p<freqlist.size();p++)
						{    								
							 freq=freqlist.get(p).getFrequency()+"";
							selfreq=ClosetFreq(Double.parseDouble(freq), freqarr);
     			            for (int i=0; i<rowNum; i++)
     			            {
     						  //logger.info("introw "+i);  
     						 XSSFRow row =(XSSFRow) sheet.getRow(i);
     						  int freqfound=0;
     						 
     						  if(i>0) //header
     						  {
     							  logger.info("freq "+freq+" row.getCell(0).toString()="+row.getCell(0).toString());
     								if(selfreq.toString().equals(row.getCell(0).toString())){
     									freqfound=1;
     									logger.info("freq found"+freq);
     									logger.info("insider introw "+i); 
     									logger.info("Inside RA Std Horn import Controller rows.hasNext() " +row.getCell(0).toString());
     									TestFrequency rastd= new TestFrequency();
     									
     									String sreading;
     	     							rastd.setFrequency(Double.parseDouble(freq));	     							
     		     						if(row.getCell(1) != null && row.getCell(1).toString() != "" )
     		     						{
     	     									sreading=row.getCell(1).toString();
     	     								
     	     								logger.info("Inside serialimport Controller sreading " +sreading);
     	     								if (row.getCell(1).getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
     	     								{
     	     									rastd.setLineargain(row.getCell(1).getNumericCellValue());
     	     								}
     	     								else
     	     									rastd.setLineargain(Double.parseDouble(sreading));
     	     								 
     	     							}
     	     							rastdlist.add(rastd);
     									break;
     								}
     							
							
     						  }
     			            }	
     					  }
     				      
     				  inp.close();
     			
     				 
     					logger.info(" rastdList.size "+rastdlist.size());
     					request.setAttribute("message", "File Uploaded Successfully");
     					
     					} catch (Exception ex) {
     						err="File Upload Failed due to " + ex;
     						request.setAttribute("message", "File Upload Failed due to " + ex);
     						logger.info("Inside FileUpload Controller Exception " + ex.getMessage());
     					}
     		serialid=	mastersservice.insertRASTDHorn(file,rastdlist,strmode);
         
         if(serialid==-1){
        	 stat=0;
        	 
         }
         else{stat=1;};
         
 //**********************************************************
	 }
         }
	 else
	 {*/
	        	 logger.info("*** Inside PVSerialcontroller in onsubmit**filetype: filetype"); 
			 if(strmode.equals("edit")){
				 logger.info("*** Inside PVSerialcontroller in onsubmit**: update");
				 action="Save";
				 //mastersservice.updatePVSerialData(file);
			 }
			 else
			 {
				 if (request.getParameter("fmaction").equals("Calculate"))
			        {
			        	action="Done";
			        }
			 
			if(!action.equals("Done")){
			 
			List<DataLog> datalogList = new ArrayList<DataLog>();
			List<TestFrequency> freqlist=new ArrayList<TestFrequency>();
			
			int logid=100000;
			
			multipartFile = file.getFilename();
			
		    JSONObject obj1 = new JSONObject(file.getStrjsonfreq());
		     try {
		      JSONArray result = obj1.getJSONArray("jsonfreq");
		    for(int i=0;i<result.length();i++)
		     {
		    	TestFrequency testfreq= new TestFrequency();
		    	//logger.info(result.get(i));
		    	JSONObject obj2 = (JSONObject)result.get(i);
		    	//logger.info(obj2.get("freq"));
		    //	logger.info(obj2.get("lg"));
		    	if(file.getFrequnit().equals("GHz"))
		    	{    		  
		    	testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString())*1000);
		    	}
		    	else
		    		{testfreq.setFrequency(Double.parseDouble(obj2.get("freq").toString()));}
		    //	testfreq.setLineargain(Double.parseDouble(obj2.get("lg").toString()));
		    	freqlist.add(testfreq);
		     }
		     } catch (JSONException e) {
		    	 logger.info(" JSONException "+e.getMessage());
		    	 err=e.getMessage();
		    }
		
			 
			logger.info("Inside FileUpload Controller");
			if(multipartFile!=null){
				int startrow=0;
				fileName = multipartFile.getOriginalFilename();
				logger.info("Inside FileUpload Controller fileName" +fileName);
				try {
					// Read excel file 
				      InputStream inp = multipartFile.getInputStream() ;
				      String fileExtn = GetFileExtension(fileName);
				      Workbook wb_xssf; //Declare XSSF WorkBook
				      Workbook wb_hssf; //Declare HSSF WorkBook
				      Sheet sheet = null; // sheet can be used as common for XSSF and HSSF 	WorkBook
				      if (fileExtn.equalsIgnoreCase("xlsx"))
				      {
				    	  wb_xssf=  WorkbookFactory.create(inp);
					      sheet = wb_xssf.getSheetAt(0);
				      }
				      if (fileExtn.equalsIgnoreCase("xls"))
				      {
					  POIFSFileSystem fs = new POIFSFileSystem(inp);
				    	  wb_hssf = new HSSFWorkbook(fs);
				    	  //logger.info("xls="+wb_hssf.getSheetName(0));
				    	  sheet = wb_hssf.getSheetAt(0);
				      }
				      int rowNum = sheet.getLastRowNum()+1;
				      int colNum = sheet.getRow(0).getLastCellNum();
				      logger.info("rowNum,colNum " +rowNum +' '+colNum);
				     
				      int y=0;
				      double selfreq=0;	
				      ArrayList<Double> freqarr= new ArrayList<Double>();
				      if (fileExtn.equalsIgnoreCase("xlsx"))
				      {			    	  
				    	  XSSFRow strow =(XSSFRow) sheet.getRow(0);
				    	  logger.info("strow,1 " +strow.getCell(1));
				    	  if(strow.getCell(1) != null && strow.getCell(1).toString().toLowerCase().contains("freq") )
				    	  {
				    		  startrow=1; 
				    	  }
				    	  else{
				    	   strow =(XSSFRow) sheet.getRow(22);
				    	   logger.info("strow,22 " +strow.getCell(1));
				    	   if(strow.getCell(1) != null && strow.getCell(1).toString().toLowerCase().contains("freq") )
					    	  {
					    		  startrow=23; 
					    		  colNum=sheet.getRow(22).getLastCellNum();
					    	  }
				    	  }
				    	  logger.info("startrow " +startrow);
				      XSSFRow freqrow =(XSSFRow) sheet.getRow(startrow);
				     
				      for(int u=1;u<colNum;u++){
				    	  freqarr.add( Double.parseDouble(freqrow.getCell(u).toString()));
				      }
				      logger.info("freqarr done " );
				      for(y=0;y<freqlist.size();y++)
				      {
				    	  double colfreq=0;	
				    	  selfreq=freqlist.get(y).getFrequency();
				    	  colfreq=ClosetFreq( selfreq,freqarr);
				      for (int i=0; i<rowNum; i++){
							  //logger.info("introw "+i);  
							  if(i>startrow) //header
							  {
								  XSSFRow row =(XSSFRow) sheet.getRow(i);
								  String amplitude;		
								  
								  
								if(row.getCell(0) != null ){
									int dup=0;
									String ang=row.getCell(0).toString();
									if(y==0){
										//logger.info("ang "+ang);
									if(Double.parseDouble(ang)>360.0){
										logger.info("TestImportController Invalid angle in file");									
										 throw new ImportException("Invalid angle in file");
									}
									}
									  if(Double.parseDouble(ang)==0.1 && i >startrow+2){
										  dup=1;  
									  }
									if(dup==0){
									for(int u=1;u<colNum;u++){
										if(Double.parseDouble(freqrow.getCell(u).toString())==colfreq){
											DataLog datalog= new DataLog();
									datalog.setFreq(selfreq);
									//logger.info("Inside FileUpload Controller Freq " +selfreq);
									datalog.setAngle(Double.parseDouble(row.getCell(0).toString()));
									//logger.info("Inside FileUpload Controller Angle " +row.getCell(0));
									amplitude=row.getCell(u).toString();
									datalog.setAmplitude(Double.parseDouble(amplitude));
									//logger.info("Inside FileUpload Controller sreading " +row.getCell(u));
									datalogList.add(datalog);
									break;
									}									
									}
									}
								}							
						      }						  		
						  }
				      }
				      }
				      //xls
				      else
				      {
				    	  logger.info("inside xls");
				    	  logger.info("file.getFrequnit() "+file.getFrequnit()); 
				    	  
				    	  HSSFRow strow =(HSSFRow) sheet.getRow(0);
					      logger.info("strow,1 " +strow.getCell(1));
					      // ignore first row if it contains text
				    	  if(strow.getCell(1) != null && strow.getCell(1).toString().toLowerCase().contains("freq") )
				    	  {
				    		  logger.info("strow,1 " +strow.getCell(1));
				    		  startrow=1; 
				    	  }
				    	  else{				    		  
				    		  strow =(HSSFRow) sheet.getRow(22);
				    		  logger.info("strow,22 " +strow.getCell(1));
					    	   if(strow.getCell(1) != null && strow.getCell(1).toString().toLowerCase().contains("freq") )
						    	  {
						    		  startrow=23; 
						    		  colNum=sheet.getRow(22).getLastCellNum();
						    	  }
					    	  }
					      HSSFRow freqrow =(HSSFRow) sheet.getRow(startrow);	
					      logger.info("startrow="+startrow);
					      
					      for(int u=1;u<colNum;u++){
					    	  //logger.info("freqrow.getCell(u).toString()"+freqrow.getCell(u).toString());
					    	 
					    	  freqarr.add(Double.parseDouble(freqrow.getCell(u).toString()));
					    	  //logger.info( u +' '+freqrow.getCell(u).toString()); 
					      }
					      logger.info("freqlist.size() "+freqlist.size()); 
					      
					      
					      for(y=0;y<freqlist.size();y++)
					      {		  
					    	  double colfreq=0;	
					    	  selfreq=freqlist.get(y).getFrequency();
					    	  colfreq=ClosetFreq( selfreq,freqarr);
					    	  
					      for (int i=0; i<rowNum; i++){				
								  if(i>startrow) //header
								  {
									  HSSFRow row =(HSSFRow) sheet.getRow(i);
									  String ang=row.getCell(0).toString();
									  if(y==0){
										
											if(Double.parseDouble(ang)>360.0){
												logger.info("TestImportController Invalid angle in file");											
												 throw new ImportException("Invalid angle in file");
											}
											}
									int dup=0;								 
									String amplitude;								
									if(row.getCell(0) != null ){
										if(Double.parseDouble(ang)==0.1 && i >startrow+2){
											dup=1;  
										  }
										if(dup==0){
										for(int u=1;u<colNum;u++){										 
											if(Double.parseDouble(freqrow.getCell(u).toString())==colfreq){
												DataLog datalog= new DataLog();
										datalog.setFreq(selfreq);
										//logger.info("Inside FileUpload Controller Freq " +selfreq);
										datalog.setAngle(Double.parseDouble(row.getCell(0).toString()));
										//logger.info("Inside FileUpload Controller Angle " +row.getCell(0));
										amplitude=row.getCell(u).toString();
										datalog.setAmplitude(Double.parseDouble(amplitude));
										// logger.info("Inside FileUpload Controller sreading " +row.getCell(u));
										datalogList.add(datalog);
										break;
										}										
										}
									}
									}
							      }	
							  }
					      }
					      }
					  inp.close();		
					 
						logger.info(" datalogList.size "+datalogList.size());
						if(datalogList.size()>0)
						{
							err=fileName + "Uploaded successfully";
							stat=	mastersservice.insertPVSerialData(file,freqlist,datalogList,strmode,action);
							if(stat==0)
							{
								err="Failed to Import "+fileName	;
								stat=0;
								
							}
							else{
								serialid=stat;
								stat=1;
							}
						}
						request.setAttribute("message", "File Uploaded Successfully");
						
						} catch (Exception ex) {
							stat=0;
							err="File Upload Failed due to " + ex.getMessage() ;
							request.setAttribute("message", "File Upload Failed due to " + ex.getMessage());
							logger.info("Inside FileUpload Controller Exception " + ex.getMessage());
						}
					 logger.info(" imported serialid "+serialid);
			}
			 }       
			 }
        // }
		}
		//
		request.setAttribute("id", null);
     	cursess.setAttribute("id",null);
     	request.setAttribute("mode", null);
     	cursess.setAttribute("mode",null);
		if(action.equals("More")){
		return new ModelAndView(new RedirectView("pvserialimport.htm?id="+serialid+"&PId="+testid+"&atype="+atype+"&savestat="+stat+"&msg="+err+"&refresh=refresh"));}
		//else if (action.equals("Done")) return new ModelAndView("fileuploadresult","fileName"," " +" " +err);
		else return new ModelAndView(new RedirectView("pvserialimport.htm?id="+serialid+"&PId="+testid+"&mode=edit&savestat="+stat+"&msg="+err));
	}
	@Override
    protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder)
	throws ServletException {
 
	// Convert multipart object to byte[]
	binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
 
    }
	private static String GetFileExtension(String fname2)
	  {
	      String fileName = fname2;
	      String fname="";
	      String ext="";
	      int mid= fileName.lastIndexOf(".");
	      fname=fileName.substring(0,mid);
	      ext=fileName.substring(mid+1,fileName.length());
	      return ext;
	  }
	
	
	 protected Object formBackingObject(HttpServletRequest request) throws ServletException {
	    	cursess = request.getSession();
	    	
	    	String mode = request.getParameter("mode");
	        String id = request.getParameter("id");
	        String strtestid=request.getParameter("PId");
	        atype=request.getParameter("atype");
	        request.setAttribute("savestat", null);
	        request.setAttribute("err", null);
	        request.setAttribute("message", null);
	        cursess.setAttribute("message",null);
	        cursess.setAttribute("err",null);
	        request.setAttribute("mode", mode);
        	cursess.setAttribute("mode",mode);
        	serialid=0;
        	testid=Integer.parseInt(strtestid);
	        logger.info("inside PVSerialImportController testid"+testid); 
	        try{
	        if (id == null || id == "" || id.equals("null") || id.equals("0") ){
	        	logger.info(" atype "+atype);
	        	logger.info(" going to create new pv serial Data");
	        	request.getSession().setAttribute("id", null);
	        	cursess.setAttribute("id",null);
	        	PVSerialData testdata=new PVSerialData();	        	        	
	        	testdata.setPtype(atype);
	        	testdata.setTestid(testid);
	        	PVTest test=mastersservice.getPVTest(testid);
	        	testdata.setTestname(test.getTestname());
	        	testdata.setFrequnit(test.getFrequnit());
	        	testtype=test.getTesttype();
	        	return testdata;
	        }else{
	        	  logger.info("inside TestImportController id:" +id);
	        	request.getSession().setAttribute("id", id);
	        	cursess.setAttribute("id",id);
	        	request.getSession().setAttribute("mode", mode);
	        	cursess.setAttribute("mode",mode);
	            logger.info(" going to retrieve details of testdata="+id);
	            serialid=Integer.parseInt(id);
	            PVSerialData testdata=mastersservice.getPVSerialData(Integer.parseInt(id));
	            
	            testtype=testdata.getTesttype();
	            atype=testdata.getPtype();
	        	return testdata;
	        	}
	        }
	        catch(Exception e)
	        {
	        	logger.info(" ImportTestController Exception "+e.getMessage());
	        	return new PVSerialData();
	        }
	              
	    }

	 protected HashMap<String, Object> referenceData(HttpServletRequest request) throws Exception {

			HashMap<String, Object> referenceData = new HashMap<String, Object>();
			  logger.info(" PVSerialImportController referenceData serialid="+serialid);
			String hefreq="";
			String vefreq="";
			String hafreq="";
			String vafreq="";
			String gmfreq="";			
			String htfreq="";
			String vtfreq="";
			String vmfreq="";
			String hmfreq="";
	        List<ProductSerial> prodserlist = mastersservice.getProdVerSer();        
	        
	    	hefreq=mastersservice.getPVFreqdatafile("H",serialid,"E");
	    	vefreq=mastersservice.getPVFreqdatafile("V",serialid,"E"); 
	    	hafreq=mastersservice.getPVFreqdatafile("H",serialid,"A");
	    	vafreq=mastersservice.getPVFreqdatafile("V",serialid,"A"); 
	    	gmfreq=mastersservice.getPVFreqdataGM(serialid);
	    	vmfreq=mastersservice.getPVFreqdatafile("V",serialid,"M");
	    	hmfreq=mastersservice.getPVFreqdatafile("H",serialid,"M");
	    	vtfreq=mastersservice.getPVFreqdatafile("V",serialid,"T");
	    	htfreq=mastersservice.getPVFreqdatafile("H",serialid,"T");
	    	int gcnt=mastersservice.checkGainSTD(testid);
	        referenceData.put("prodserlist", prodserlist);
	        referenceData.put("testtype", testtype);       
	        referenceData.put("gcnt", gcnt);       
	        referenceData.put("hefreq", hefreq);
	        referenceData.put("vefreq", vefreq);
	        referenceData.put("hafreq", hafreq);
	        referenceData.put("vafreq", vafreq);
	        referenceData.put("gmfreq", gmfreq);	       
	        referenceData.put("htfreq", htfreq);
	        referenceData.put("vtfreq", vtfreq);
	        referenceData.put("testid", testid);
	        referenceData.put("hmfreq", hmfreq);
	        referenceData.put("vmfreq", vmfreq);
	        List<TestFrequency> freqlist=mastersservice.getPVFreqList(testid);  
	        String strfreqs="";
	      
	      
	        for (int i=0;i<freqlist.size();i++){
    			if(i==0)
    				{strfreqs=freqlist.get(i).getFrequency()+"";}
    			else {strfreqs=strfreqs+","+freqlist.get(i).getFrequency();}
    		}
	        referenceData.put("strfreqlist",strfreqs);
	        
	 		return referenceData;
		}
	
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }
	   private double ClosetFreq(double myNumber,ArrayList<Double> numbers)
	   {
		   double distance = Math.abs(numbers.get(0).doubleValue() - myNumber);
		   int idx = 0;
		   for(int c = 1; c < numbers.size(); c++){
			   double cdistance = Math.abs(numbers.get(c).doubleValue() - myNumber);
		       if(cdistance < distance){
		           idx = c;
		           distance = cdistance;
		       }
		   }
		   logger.info(" closetfreq="+numbers.get(idx).doubleValue());
		   return  numbers.get(idx).doubleValue();
		   
	   }

	}
class ImportException extends Exception {
	   public ImportException(String msg){
	      super(msg);
	   }
	}