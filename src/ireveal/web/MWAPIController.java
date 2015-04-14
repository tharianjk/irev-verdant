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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import javax.annotation.Resource;

import java.util.List;
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
		
    

}
    
 