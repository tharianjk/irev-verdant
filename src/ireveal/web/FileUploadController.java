package ireveal.web;


import ireveal.domain.VDataLog;
import ireveal.service.MastersService;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
 
public class FileUploadController extends SimpleFormController{
	String err="File Uploaded Successfully";
	public MastersService mastersservice ;
	 
	public FileUploadController(){
		setCommandClass(VDataLog.class);
		setCommandName("fileupload");
	}
 
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response, Object command, BindException errors)
		throws Exception {
		 Map<String, Object> myModel = new HashMap<String, Object>();
		List<VDataLog> meterlogList = new ArrayList<VDataLog>();
		VDataLog file = (VDataLog)command;
		int logid=100000;
		MultipartFile multipartFile = file.getFilename();
 
		String fileName="";
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
			      
				
			      for (int i=0; i<rowNum; i++){
						  logger.info("introw "+i);  
						  if(i>0) //header
						  {
							  XSSFRow row =(XSSFRow) sheet.getRow(i);
							  logger.info("insider introw "+i); 
						   logger.info("Inside FileUpload Controller rows.hasNext() " +row.getCell(0).toString());
							VDataLog meterlog= new VDataLog();
							
							String sreading;
							
							if(row.getCell(0) != null ){
								meterlog.setMetername(row.getCell(0).toString());
								logger.info("Inside FileUpload Controller meterame " +row.getCell(0).toString());
								meterlog.setAttribute(row.getCell(1).toString());
								logger.info("Inside FileUpload Controller Attribute " +row.getCell(1).toString());
								sreading=row.getCell(2).toString();
								meterlog.setNreading(Double.parseDouble(sreading));
								logger.info("Inside FileUpload Controller sreading " +row.getCell(2).toString());
								try
							    {
									
									/*if (row.getCell(2).getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
									{
										logger.info("Inside FileUpload Controller sreading numeric ");
										try{
											//String val=row.getCell(2).getNumericCellValue() +"";
											sreading=row.getCell(2).toString();
										}
										//meterlog.setNreading((Double)val);}
										catch(Exception enn)
										{
											logger.info("exception numeric  "+enn.getMessage() );
											  
										}
									}
									else
									{
										//meterlog.setNreading(Double.parseDouble(row.getCell(2).toString()));
										logger.info("Inside FileUpload Controller sreading not numeric ");
								      
									}*/
									if (row.getCell(3).getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
									{
										logger.info("Inside FileUpload Controller dtdate not numeric ");
									if (HSSFDateUtil.isCellDateFormatted(row.getCell(3)))
									{
										logger.info("Inside FileUpload Controller dtdate not numeric ");
										meterlog.setDtlogdate(row.getCell(3).getDateCellValue());
									}}
									else
									{
										logger.info("Inside FileUpload Controller dtdate not date ");
									meterlog.setDtlogdate(new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(row.getCell(3).toString()));
									}

							    }
							    catch (ParseException ex)
							    {
							    	logger.info("exception setDtlogdate "+ex.getMessage() );
							        //System.out.println("Exception "+ex);
							    }
							}
							 meterlogList.add(meterlog);
							
					      }
						  		
					  }
				      
				  inp.close();
			
				 
					logger.info(" meterlogList.size "+meterlogList.size());
					request.setAttribute("message", "File Uploaded Successfully");
					
					} catch (Exception ex) {
						err="File Upload Failed due to " + ex;
						request.setAttribute("message", "File Upload Failed due to " + ex);
						logger.info("Inside FileUpload Controller Exception " + ex.getMessage());
					}
			
			 //logid= mastersservice.insertMeterLogImport(meterlogList);
			 logger.info(" imported logid "+logid);
		}
		    Calendar cal = Calendar.getInstance();
	     	Date curTime = cal.getTime();
	     	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		   myModel.put("sectionid",0);
		   myModel.put("meterid",0);
		   myModel.put("tagid",0);
		   myModel.put("fromdt",sdf.format(curTime)+"T00:00");
		   myModel.put("todt",sdf.format(curTime)+"T23:59");
		   myModel.put("sectionid",0);
		   myModel.put("meterid",0);
		   myModel.put("tagid",0);
		  // myModel.put("sectionlist",mastersservice.getUserSectionList());
		  // myModel.put("tags", this.mastersservice.getMeterLogImport(logid));
		return new ModelAndView("tagvallist", "model", myModel);      	
		//return new ModelAndView("fileuploadresult","fileName",fileName +" " +err);
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
	 public void setMastersManager(MastersService mastersservice) {
	       this.mastersservice = mastersservice;
	   }   

	   public MastersService getMastersManager() {
	       return mastersservice;
	   }

	}
