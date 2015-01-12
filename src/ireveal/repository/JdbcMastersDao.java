package ireveal.repository;

import ireveal.domain.EncryptDecrypt;
import ireveal.domain.AssetTree;
import ireveal.domain.Operator;
import ireveal.domain.RoleDsp;
import ireveal.domain.User;
import ireveal.domain.UserPref;
import ireveal.repository.JdbcAssetTreeDao.RoleMapper;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.ArrayList;  
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;  
import java.util.Map;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.sql.DataSource;  
import javax.swing.tree.RowMapper;

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;  
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
 
    
  public class JdbcMastersDao extends JdbcDaoSupport implements MastersDao {
	  int compid=1; 
	  @Override
	  public List<AssetTree> getAssetTreeList() {
		  List<RoleDsp> rle =getRoleDtls();
	         compid=rle.get(0).getCompanyid();
		  List dataList = new ArrayList();  
		    
		    String sql = "select A.ASSETTREE_id,A.displayname from FWK_ASSETTREE A WHERE ASSETTREETYPE_ID NOT IN (1,2) and A.COMPANY_ID=" +compid;  
		   
		    dataList = getJdbcTemplate().query(sql, new DataAssettreeMapper());  
		    return dataList;  
		    
	  }
	  private static class DataAssettreeMapper implements ParameterizedRowMapper<AssetTree> {
		   
	       public AssetTree mapRow(ResultSet rs, int rowNum) throws SQLException {
	    	   AssetTree assettree = new AssetTree();
	    	   assettree.setAssetid(rs.getInt("assettree_id"));  
	    	   assettree.setAssetname(rs.getString("displayname"));  	    	   
	           return assettree;
	       }
	   }
	  @Override
	  public List<UserPref> getUserFav() {
	  	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	      String uname = auth.getName();
	      String sql="select FAVOPERATION from FWK_USER U INNER JOIN FWK_USER_FAVORITE UF ON U.USER_ID=UF.USER_ID  "+
	      " where username='"+uname+"'";
	      try{
	      	 List<UserPref> userpref = getJdbcTemplate().query(sql, new UsrFavMapper());
	      	 return userpref;
	      }
	      catch(Exception e)
	      {
	      	return null;
	      }
	  }
 //************************User List**********************
	  @Override
	  public List<User> getUserList() {
		  List<RoleDsp> rle =getRoleDtls();
	      compid=rle.get(0).getCompanyid();
	  	  logger.info("inside userlist"); 
	      List<User> userlist = new ArrayList();  
	      
	      String sql = "SELECT DISTINCT M.USER_ID,USERNAME FROM FWK_USER M INNER JOIN FWK_USER_ROLE UR ON M.USER_ID= UR.USER_ID "+
	      " INNER JOIN FWK_ROLE R ON UR.ROLE_ID=R.ROLE_ID WHERE R.COMPANY_ID= "+compid;  
	     
	      userlist = getJdbcTemplate().query(sql, new DataUserListTypeMapper());     
	      
	      return userlist;
	  }
	  private static class DataUserListTypeMapper implements ParameterizedRowMapper<User> {
	  	   
	      public User mapRow(ResultSet rs, int rowNum) throws SQLException {
	      	User userlist = new User();
	      	userlist.setUser_id(rs.getInt("USER_ID"));
	      	userlist.setUsername(rs.getString("USERNAME"));  
	      			
	          return userlist;
	      }

	  }
	   
List<Operator> opeList = new ArrayList<Operator>();

public List<Operator> getOpeList() {
    if(opeList.isEmpty()){            
    	opeList.add(new Operator( "<","<"));
    	opeList.add(new Operator( ">",">"));
    	opeList.add(new Operator( "<=","<="));
    	opeList.add(new Operator( ">=",">="));
    	opeList.add(new Operator( "AND","&&"));
    	opeList.add(new Operator( "OR","||"));
    	opeList.add(new Operator( "(","("));
    	opeList.add(new Operator( ")",")"));
    }
    return opeList;
}
 

public void setOpeList(List<Operator> opeList) {
    this.opeList = opeList;
}
public List<RoleDsp> getRoleDtls()
{
	 
	List<RoleDsp> roledsp=null;
	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String uname = auth.getName();
	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,r.company_id,r.role_id from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
    "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username ='" +uname +"'", new RoleMapper());
	
	return roledsp;
}
/**
 * 
 * Get list of roles 
 *
 * @param  none
 * @return List of RoleDsp fr main controller
 */    
 public List<RoleDsp> getLogUserRole(){
     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
     String uname = auth.getName();
     List<RoleDsp>	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,r.company_id,r.role_id,r.b_reports,r.b_events,r.b_tools,r.b_settings,c.expirydate from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
     "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username ='" +uname +"'", new RoleLogMapper());
 	logger.info("roledsp.size "+ roledsp.size());
 	
  	return roledsp;
 }
 /**
  * 
  * Helper Class 
  *
  * @param  
  * @return 
  */
  private static class RoleLogMapper implements ParameterizedRowMapper<RoleDsp> {  	
      public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
          RoleDsp role = new RoleDsp();
          Calendar cal = Calendar.getInstance();
 	     cal.setTime(new Date()); // Now use today date.
 	     cal.add(Calendar.DATE, 1); // Adding 5 days
 	
 	     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
          role.setRole_id(rs.getInt("ROLE_ID"));
          role.setRolename(rs.getString("ROLENAME")); 
          
          role.setCompany(rs.getString("companyname")); 
          role.setCompanyid(rs.getInt("company_id"));
          role.setExpirydate(rs.getString("expirydate"));
          
         
          try{
          role.setBln_reports((rs.getString("B_REPORTS").equals("true"))?true:false);
	            }
	            catch(Exception e){role.setBln_reports(false);}
          try{
          role.setBln_events((rs.getString("B_EVENTS").equals("true"))?true:false);
	        }
	        catch(Exception e){role.setBln_events(false);}
	        try{
	                role.setBln_tools((rs.getString("B_TOOLS").equals("true"))?true:false);   
	        }
	        catch(Exception e){role.setBln_tools(false);}
          try{
          role.setBln_settings((rs.getString("B_SETTINGS").equals("true"))?true:false); 
			}
			catch(Exception e){role.setBln_settings(false);}
       
          return role;
      }
   }
public static class StringRowMapper implements ParameterizedRowMapper<String>{
public String mapRow(ResultSet rs, int rowNum) throws SQLException {
    return rs.getString(1);
        }}


List<Operator> opeListtag = new ArrayList<Operator>();

public List<Operator> getOpeListTag() {
    if(opeListtag.isEmpty()){ 
    	
    	opeListtag.add(new Operator( "+","+"));
    	opeListtag.add(new Operator( "-","-"));
    	opeListtag.add(new Operator( "*","*"));
    	opeListtag.add(new Operator( "/","/"));
    	opeListtag.add(new Operator( "=","="));
    	opeListtag.add(new Operator( "AND","&&"));
    	opeListtag.add(new Operator( "OR","||"));
    	opeListtag.add(new Operator( "(","("));
    	opeListtag.add(new Operator( ")",")"));
    }
    return opeListtag;
}

private static class UsrFavMapper implements ParameterizedRowMapper<UserPref> {  	
public UserPref mapRow(ResultSet rs, int rowNum) throws SQLException {
	UserPref userpref = new UserPref();
	userpref.setFavoperation(rs.getString("FAVOPERATION"));    
	
	return userpref;
}
}

    /**
   * 
   * Update details of existing user 
   *
   * @param  
   * @return 
   */
   public boolean updateUserLogin(String uname){
   	logger.info("Going to udpate user : "+uname);

   	final String SQL_UPD_USR = "update fwk_user set dt_lastlogin = ? where username = ?";
   	
   	Calendar cal = Calendar.getInstance();
   	Date curTime = cal.getTime();
   	
   	final JdbcTemplate jdt = getJdbcTemplate();
   	jdt.update(SQL_UPD_USR,	curTime, uname );
   	
  	return true;
   }
   
  }




  