/******************************************************************************************************
    iRev-Base RESTFUL APIs
   =========================
 * /fs/{comname}
 * /taglist/{meterid}
 * /alert/{fsip}
 * /sampleapi
 * /sample
 * /CompanyRegister
 * /alrtRsp
 * /ctrlRsp
 * /jsalertsetup
 * /jscontrolconfig
 * /eventchart/{ctype}/{duration}/{summarizeby}/{selentity}/{selentitytype}
 * /getdefectivemeter/{reqstring}
 * /CheckMeterCount/{compid}
 * /validateuser/{usrname}
 * /usagesummary/{ctype}/{duration}/{assettreeid}
 

******************************************************************************************************/

package ireveal.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import javax.annotation.Resource;

import ireveal.domain.JsonSerials;
import ireveal.repository.MWAPIDao;



@Controller
//@RequestMapping("/fs")
public class MWAPIController {
	
	protected final Log logger = LogFactory.getLog(getClass());
// to dynamically inject MeterTagDao bean into this class	
	@Resource(name="MWAPIDao")
	private MWAPIDao metertagmngr;
	
    		
		@RequestMapping(value = "/validateuser/{usrname}",  method = RequestMethod.GET)
		@ResponseBody
			public String validateuser(@PathVariable String usrname){
				logger.info("** inside validateuser...: user="+usrname);
				return metertagmngr.validateuser(usrname);
		}
		
	@RequestMapping(value = "/updatepswd/{npswd}",  method = RequestMethod.GET)
	@ResponseBody
		public String updatePswd(@PathVariable String npswd){
			User user = (User)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			logger.info("** inside updatepswd...: user="+user.getUsername()+",newpswd="+npswd);
			metertagmngr.updatePswd(user.getUsername(), npswd);
			
			return "Success";
	}
		
	@RequestMapping(value = "/checkserialno/{testid}/{serialid}",  method = RequestMethod.GET)
	@ResponseBody
		public String checkserialno(@PathVariable String testid,@PathVariable String serialid){			
		return metertagmngr.CheckSerialNo(testid,serialid);
	}
	/**
	    * Handler function for returning serials nos for a test id. 
	    * 
	    *
	    * @param  
	    * @return JSON struct like: {"slnos": [{"serialid":"1","serialno":"01"},{"serialid":"2","serialno":"02"}]}
	    */
		@RequestMapping(value = "/serialsnos/{testid}", method = RequestMethod.GET)
		public @ResponseBody
		JsonSerials SerialNos(@PathVariable String testid) {
			logger.info("*** Inside MWAPI.SerialNos***:param="+testid);
			JsonSerials serials = metertagmngr.SerialNos(testid);
			return serials;
		}
		
		@RequestMapping(value = "/pvcalculate/{testid}/{serialid}",  method = RequestMethod.GET)
		@ResponseBody
			public String pvcalculate(@PathVariable String testid,@PathVariable String serialid){	
			String rtn="0";
			try{
			 rtn=metertagmngr.PV_Calculate(testid,serialid);
			}
			catch(Exception e ){
				logger.info("Exception pvcalculate "+e.getMessage());
			}
			return rtn;
		}

}
    
 