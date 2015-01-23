package ireveal.web;


import ireveal.domain.DataLog;
import ireveal.domain.ProductSerial;
import ireveal.domain.TestData;
import ireveal.domain.TestFrequency;
import ireveal.service.MastersService;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;
 
public class TestImportController extends SimpleFormController{
	String err="File Uploaded Successfully";
	public MastersService mastersservice ;
	private HttpSession cursess;
	private int testid=0;
	public TestImportController(){
		setCommandClass(TestData.class);
		setCommandName("TestData");
	}
 
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response, Object command, BindException errors)
		throws Exception {
		String action="More";
		String strmode="new";
		String fileName="";
		logger.info("*** Inside testcontroller in onsubmit**: btn= "+request.getParameter("fmaction"));
              
		
		 String strtestid = (String)cursess.getAttribute("id");
		 strmode= (String)cursess.getAttribute("mode");
		 if(strmode==null)strmode="new";
		 logger.info("*** Inside testcontroller in onsubmit** strmode:"+strmode);
		 if(strtestid!=null && strtestid!="" && strtestid!="null" && strtestid!="0" && strmode.equals("new")){
			 strmode="addfile";
		 }
		 TestData file = (TestData)command;
		 if(strmode.equals("edit")){
			 logger.info("*** Inside testcontroller in onsubmit**: update");
			 action="Save";
			 mastersservice.updateTestData(file);
		 }
		 else
		 {
			 if (request.getParameter("fmaction").equals("Done"))
		        {
		        	action="Done";
		        }
		List<DataLog> datalogList = new ArrayList<DataLog>();
		List<TestFrequency> freqlist=new ArrayList<TestFrequency>();
		
		Date dtfrom = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH).parse(file.getStrtestdate().replace("T", " "));
    	
		file.setDttestdate(dtfrom);
		int logid=100000;
		
		MultipartFile multipartFile = file.getFilename();
		
	    JSONObject obj1 = new JSONObject(file.getStrjsonfreq());
	     try {
	      JSONArray result = obj1.getJSONArray("jsonfreq");
	    for(int i=0;i<result.length();i++)
	     {
	    	TestFrequency testfreq= new TestFrequency();
	    	logger.info(result.get(i));
	    	JSONObject obj2 = (JSONObject)result.get(i);
	    	logger.info(obj2.get("freq"));
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
	         e.printStackTrace();
	    }
	
		 
		logger.info("Inside FileUpload Controller");
		if(multipartFile!=null){
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
			      XSSFRow freqrow =(XSSFRow) sheet.getRow(1);
			      for(int u=1;u<colNum;u++){
			    	  freqarr.add( Double.parseDouble(freqrow.getCell(u).toString()));
			      }
			      
			      for(y=0;y<freqlist.size();y++)
			      {
			    	  double colfreq=0;	
			    	  selfreq=freqlist.get(y).getFrequency();
			    	  colfreq=ClosetFreq( selfreq,freqarr);
			      for (int i=0; i<rowNum; i++){
						  //logger.info("introw "+i);  
						  if(i>1) //header
						  {
							  XSSFRow row =(XSSFRow) sheet.getRow(i);
							  String amplitude;							
							if(row.getCell(0) != null ){
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
			      //xls
			      else
			      {
			    	  logger.info("inside xls");
			    	  logger.info("file.getFrequnit() "+file.getFrequnit()); 
				      HSSFRow freqrow =(HSSFRow) sheet.getRow(1);		
				      for(int u=1;u<colNum;u++){
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
							  if(i>1) //header
							  {
								  HSSFRow row =(HSSFRow) sheet.getRow(i);
								String amplitude;								
								if(row.getCell(0) != null ){									
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
				  inp.close();		
				 
					logger.info(" datalogList.size "+datalogList.size());
					if(datalogList.size()>0)
					{
				testid=	mastersservice.insertTestData(file,freqlist,datalogList,strmode,action);
					}
					request.setAttribute("message", "File Uploaded Successfully");
					
					} catch (Exception ex) {
						err="File Upload Failed due to " + ex;
						request.setAttribute("message", "File Upload Failed due to " + ex);
						logger.info("Inside FileUpload Controller Exception " + ex.getMessage());
					}
				 logger.info(" imported testid "+testid);
		}
		 }       	
		//
		request.setAttribute("id", null);
     	cursess.setAttribute("id",null);
     	request.setAttribute("mode", null);
     	cursess.setAttribute("mode",null);
		if(action.equals("More")){
		return new ModelAndView(new RedirectView("testimport.htm?id="+testid));}
		else if (action.equals("Done")) return new ModelAndView("fileuploadresult","fileName",fileName +" " +err);
		else return new ModelAndView(new RedirectView("testimport.htm?id="+testid+"&mode=edit"));
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
	    	Calendar cal = Calendar.getInstance();
         	Date curTime = cal.getTime();
         	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         	SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
	    	String mode = request.getParameter("mode");
	        String id = request.getParameter("id");
	        String PId=request.getParameter("PId");
	        String atype=request.getParameter("atype");
	        request.setAttribute("savestat", null);
	        request.setAttribute("mode", mode);
        	cursess.setAttribute("mode",mode);
	        logger.info("inside ProductSerialController"); 
	        if (id == null || id == "" || id.equals("null")){
	        	logger.info(" atype "+atype);
	        	logger.info(" going to create new Test Data");
	        	request.getSession().setAttribute("id", null);
	        	cursess.setAttribute("id",null);
	        	TestData testdata=new TestData();
	        	testdata.setProductserialid(Integer.parseInt(PId));
	        	testdata.setStrtestdate(sdf.format(curTime)+"T"+sdftime.format(curTime));
	        	testdata.setTestcenter("Verdant");
	        	testdata.setPtype(atype);
	        	return testdata;
	        }else{
	        	  logger.info("inside fileuploadcontroller id:" +id);
	        	request.getSession().setAttribute("id", id);
	        	cursess.setAttribute("id",id);
	        	request.getSession().setAttribute("mode", mode);
	        	cursess.setAttribute("mode",mode);
	            logger.info(" going to retrieve details of testdata="+id);
	            testid=Integer.parseInt(id);
	            TestData testdata=mastersservice.getTestData(Integer.parseInt(id));
	            String strdate=sdf.format(testdata.getDttestdate())+"T"+sdftime.format(testdata.getDttestdate());	           
	            testdata.setStrtestdate(strdate);
	        	return testdata;
	        	}
	              
	    }
	    protected HashMap referenceData(HttpServletRequest request) throws Exception {
			HashMap referenceData = new HashMap();	
	        List<ProductSerial> prodserlist = mastersservice.getProdVerSer();        
	       
	        referenceData.put("prodserlist", prodserlist);
	        
	       // referenceData.put("freqlist",mastersservice.getFreqList(testid));
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
