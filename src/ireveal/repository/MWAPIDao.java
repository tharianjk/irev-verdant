
package ireveal.repository;


import ireveal.domain.JsonSerials;
import ireveal.domain.JsonSlno;
import ireveal.domain.RoleDsp;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;	
import org.springframework.jdbc.core.JdbcTemplate;

@SuppressWarnings("deprecation")
public class MWAPIDao extends JdbcDaoSupport {

	
    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());
 
  
    private String site2smsuserid;   
    private String site2smspswd;
         
	  /**
       * 
       * Validate user 
       *
       * @param  
       * @return 
       */
       public String validateuser(String usrname){
       	logger.info("Going to validate user : "+usrname);
       	try{
       	int cnt =getJdbcTemplate().queryForInt("select count(*) from FWK_USER where username='" +usrname+"'");
       	if(cnt==0){
       	return "0";}
       	else{
       		return "1";}
       	}
       	catch(Exception e)
       	{
       		return "1";
       	}
       }
       /**
        * 
        * Validate user 
        *
        * @param  
        * @return 
        */
        public String CheckSerialNo(String testid,String serialno){
        	logger.info("Going to CheckSeialNo testid= : "+testid+" serialno="+serialno);
        	try{
        	int cnt =getJdbcTemplate().queryForObject("select count(*) from pv_prodserial where SerialNo='" +serialno+"' and test_id="+testid,Integer.class);
        	if(cnt==0){
        	return "0";}
        	else{
        		return "1";}
        	}
        	catch(Exception e)
        	{
        		return "1";
        	}
        }
        
        /**
         * 
         * Serial list 
         *
         * @param  
         * @return 
         */
         public JsonSerials SerialNos(String testid){
         	logger.info("Going to SerialNos testid= : "+testid);
         	JsonSerials jserials=new JsonSerials();
         	List<JsonSlno> JsonSlnos = new ArrayList<JsonSlno>();
         	try{         		
            	
            	String sql="select prodserial_id,serialno from pv_prodserial where test_id=? ";
            	JsonSlnos=  getJdbcTemplate().query(sql, new Object[] {testid}, new int[] {java.sql.Types.VARCHAR},new SerialMapper());
            	logger.info("JsonSlnos ="+JsonSlnos.size());
         	}
         	catch(Exception e)
         	{
         		
         	}
         	
         	jserials.setJsonSlnos(JsonSlnos);
         	return jserials;
         }
         private static class SerialMapper implements ParameterizedRowMapper<JsonSlno> {

             public JsonSlno mapRow(ResultSet rs, int rowNum) throws SQLException {
            	 JsonSlno mdtl = new JsonSlno();             
                 mdtl.setSerialid(rs.getString("prodserial_id"));
                 mdtl.setSerialno(rs.getString("serialno")); 
                
                 return mdtl;
             }
         }
       
       
     /**
      * 
      * Update user password 
      *
      * @param  
      * @return 
      */
      public boolean updatePswd(String uname, String pswd){
      	logger.info("Going to udpate user : "+uname+",pswd="+pswd);
      	final String SQL_UPD_USR = "update fwk_user set password = ? where username = ?";
      	
      	final JdbcTemplate jdt = getJdbcTemplate();
      	jdt.update(SQL_UPD_USR,	pswd, uname);
      	return true;
      }

                    public int getUserid(String uname)
              {
              	
                  return  getJdbcTemplate().queryForInt("Select user_id from fwk_user where username='"+uname+"'"); 
              }
              
              public List<RoleDsp> getRoleDtls(String uname)
              {             	 
              	List<RoleDsp> roledsp=null;
              
              	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,r.company_id,r.role_id, r.utility_id from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
                  "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username ='" +uname +"'", new RoleMapper());
              	
              	return roledsp;
              }
              public static class RoleMapper implements ParameterizedRowMapper<RoleDsp> {

                  public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
                  	RoleDsp roledsp = new RoleDsp();
                  	roledsp.setRolename(rs.getString("rolename"));
                  	roledsp.setCompanyid(rs.getInt("Company_id"));
                  	roledsp.setRole_id(rs.getInt("Role_id"));
                  	roledsp.setCompany(rs.getString("Companyname"));
                  	                      
                      return roledsp;
                  }
              }
              public int PV_Calculate(String testid,String serialid)
              {
              	   
              	   
              		//final String funit = testdata.getFrequnit().equals("MHz")?"M":"G";
              		//final String funit = "M";
              		try{
              		getJdbcTemplate().update("call pv_Calculate_params (?,?,?)", testid,"PV",serialid);
              		return 1;
              		}
              		catch(Exception e)
              		{
              			 logger.info("PV_CalcProc Exception "+e.getMessage());
              			   return 0;
              		}
              			
              }
}
