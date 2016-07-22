package ireveal.repository;


import ireveal.domain.RoleDsp;
import ireveal.domain.User;
import ireveal.domain.UserPref;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;	
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;


public class JdbcSetupDao extends JdbcDaoSupport implements SetupDao {

    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());

    /**
    * 
    * Get list of all users from database 
    *
    * @param  
    * @return 
    */
    public List<User> getUserList() {
    	int compid =1;
    	 List<RoleDsp> rle =getRoleDtls();
         compid=rle.get(0).getCompanyid();
    	final String SQL_SEL_USR = "select u.user_id, u.username, u.password, u.b_enabled, r.rolename,u.mobilno,u.email,ur.role_id , u.dt_lastlogin"+
    								" from fwk_user u, fwk_role r,  fwk_user_role ur "+
    								" where u.user_id = ur.user_id and ur.role_id = r.role_id and r.rolename <> 'ROLE_USER' and r.company_id=?" ;
       // logger.info("Getting users! SQL_SEL_USR" +SQL_SEL_USR);
        List<User> users = getJdbcTemplate().query(SQL_SEL_USR,  new UserMapper(),compid );
        return users;
    }
     
    
    public int grtUserid(String uname)
    {
    	
        return  getJdbcTemplate().queryForObject("Select user_id from fwk_user where username=?",Integer.class,uname); 
    }
    /**
    * 
    * Insert a new user record into database
    *
    * @param  
    * @return 
    */
    public boolean createUser(User user){
    	List<RoleDsp> rle =getRoleDtls();
        int pcompid=rle.get(0).getCompanyid();
    	logger.info("Going to create user : "+user.getUsername());
    	final String INSERT_SQL = "insert into fwk_user (username, password,email,mobilno) values(?, ?,?,?)";
    	final String INSERT_ROLE = "insert into fwk_user_role (user_id, role_id) values(?, ?)";    	
    	final String username = user.getUsername();
    	final String pswd = user.getPassword();
    	final String mobileno = user.getMobileno();
    	final String email = user.getEmail();
    	JdbcTemplate jdt = getJdbcTemplate();
    	KeyHolder keyHolder = new GeneratedKeyHolder();
    	getJdbcTemplate().update(
    	    new PreparedStatementCreator() {
    	        public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
    	            PreparedStatement ps =
    	                connection.prepareStatement(INSERT_SQL, new String[] {"USER_ID"});
    	            ps.setString(1, username);
    	            ps.setString(2, pswd);
    	            ps.setString(3,email );
    	            ps.setString(4,mobileno );
    	            return ps;
    	        }
    	    },
    	    keyHolder);
    	int userid = keyHolder.getKey().intValue();
    	logger.info(" User record inserted. Key = "+userid);
    	int roleuserid=getJdbcTemplate().queryForObject("select role_id from fwk_role where company_id=? and rolename='ROLE_USER'",Integer.class,pcompid);
    	// Every user should have the ROLE_USER role. Insert record corresponding to that role
    	jdt.update(INSERT_ROLE, userid, roleuserid);
    	//Now insert the user-role selected for this user    	
    	jdt.update(INSERT_ROLE, userid, user.getRole_id());
       	return true;
    }


    /**
    * 
    * Update details of existing user 
    *
    * @param  
    * @return 
    */
    public boolean updateUser(User user){
    	List<RoleDsp> rle =getRoleDtls();
        int pcompid=rle.get(0).getCompanyid();
    	int roleuserid=getJdbcTemplate().queryForObject("select role_id from fwk_role where company_id=? and rolename='ROLE_USER'",Integer.class,pcompid);
    	logger.info("Going to udpate user : "+user.getUsername()+",pswd="+user.getPassword()+",enabled="+user.isEnabled());
    	final String SQL_DEL_ROLE = "delete from fwk_user_role where user_id = ? and role_id <> ?";    	
    	final String SQL_INS_ROLE = "insert into fwk_user_role (USER_ID, ROLE_ID) values (?, ?)";
    	final String SQL_UPD_USR = "update fwk_user set password = ?, b_enabled = ?,email=?,mobilno=? where username = ?";
    	
    	final JdbcTemplate jdt = getJdbcTemplate();
    	jdt.update(SQL_UPD_USR,	user.getPassword(), user.isEnabled(),user.getEmail(),user.getMobileno(), user.getUsername() );
    	
    	// delete the currently assigned role
    	jdt.update(SQL_DEL_ROLE, user.getUser_id(), roleuserid );  
    
    	jdt.update(SQL_INS_ROLE, user.getUser_id(), user.getRole_id());
    	return true;
    }
    
    /**
     * 
     * Delete selected User
     *
     * @param  userid
     * 
     */ 
    @Transactional
    public boolean deleteUser(int id) { 
  	  logger.info(" delete user id = "+id);
  	   String sql = "";  
  	   try
  	   {  		 
  		 sql = "delete from fwk_user_favorite where user_id=?";        
  	     getJdbcTemplate().update(sql,id);
     sql = "delete from fwk_user_role where user_id=?";        
     getJdbcTemplate().update(sql,id);
     sql = "delete from FWK_user where user_id=?" ;  
     getJdbcTemplate().update(sql,id);
     return true;
  	   }
  	   catch(Exception e)
  	   {
  		   return false;
  	   }
    } 
    
    /**
    * 
    * Get list of roles 
    *
    * @param  none
    * @return List of RoleDsp objects
    */    
    public List<RoleDsp> getRoles(){
    	
    	final String SQL_SEL_ROLE = "select r.role_id, r.rolename,r.b_reports,r.b_settings,b_tools from fwk_role r "+
        "  where  rolename not in ('ROLE_USER')";
     	logger.info("Getting roles!");
     	List<RoleDsp> roles = getJdbcTemplate().query(SQL_SEL_ROLE, new  RoleDtlsMapper());
     	return roles;
    }

    /**
    * 
    * Get list of roles that are assignable to a user
    *
    * @param  none
    * @return List of RoleDsp objects
    */    
    public List<RoleDsp> getAssignableRoles(){
    	int compid =1;
   	    List<RoleDsp> rle =getRoleDtls();
        compid=rle.get(0).getCompanyid();
        final String SQL_SEL_ROLE = "select role_id, rolename from fwk_role where company_id=? and rolename <> 'ROLE_USER'";
     	logger.info("Getting assignable roles!");
     	List<RoleDsp> roles = getJdbcTemplate().query(SQL_SEL_ROLE,  new RoleMapperRole(),compid);
     	return roles;
    }

    
    /**
    * 
    * Save a new role and associated sections 
    *
    * @param  RoleDsp object
    * @return true or false
    */    
    public boolean createRole(RoleDsp role){
    	
   	    List<RoleDsp> rle =getRoleDtls();
        final int compid=rle.get(0).getCompanyid();
        final String SQL_INS_ROLE = "insert into fwk_role (rolename,company_id,b_reports,b_settings,b_tools) values (?,?,?,?,?)";

        final String rolename = role.getRolename();        
        final String breports = (role.getBln_reports()==true)?"true":"false";       
        final String bsettings = (role.getBln_settings()==true)?"true":"false";
        final String btools = (role.getBln_tools()==true)?"true":"false";
      	logger.info("JdbcSetupDao: Going to create role:"+rolename);
    	KeyHolder keyHolder = new GeneratedKeyHolder();
    	getJdbcTemplate().update(
    	    new PreparedStatementCreator() {
    	        public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
    	            PreparedStatement ps =
    	                connection.prepareStatement(SQL_INS_ROLE, new String[] {"ROLE_ID"});
    	            ps.setString(1, rolename);
    	            ps.setInt(2, compid);    	          
    	            ps.setString(3, breports);    	          
    	            ps.setString(4, bsettings);
    	            ps.setString(5, btools);
    	            return ps;
    	        }
    	    },
    	    keyHolder);
    	int roleid = Integer.valueOf(""+keyHolder.getKey());
    	logger.info(" roleinserted. Key = "+roleid);
    	
    	//Now insert all the sections associated with this role
    	return true;

    };
    
    
    /**
    * 
    * Get details of a Role
    *
    * @param  Roleid
    * @return RoleDsp object
    */        
    public RoleDsp getRole(String roleid_s){
    	final String SQL_SEL_ROLE = "select r.role_id, r.rolename,r.b_reports,r.b_settings,b_tools from fwk_role r "+
    	        " where role_id = ?";
      	logger.info("JdbcSetupDao: Getting details of role:"+roleid_s);
      	if (roleid_s.length() == 0){
      		logger.info("JdbcSetupDao: ERRROR: roleid is null!!"); 
      		return null;
      	}
      	JdbcTemplate jdt = getJdbcTemplate();
      	
      List<RoleDsp> role=jdt.query(SQL_SEL_ROLE, new RoleDtlsMapper(),roleid_s);
      	return role.get(0);
    }
    
    
    /**
    * 
    * Get names of sections assigned to Role
    *
    * @param  Roleid
    * @return List of Section names
    */    
   

    /**
    * 
    * Update details of existing Role
    *
    * @param  Roleid
    * @return List of Section names
    */    
    public boolean updateRole(RoleDsp role){
       	final String SQL_UPD_ROLENM = "update fwk_role set rolename = ?,b_reports=?,b_tools=?,b_settings=? where role_id = ?";
       	
       	JdbcTemplate jdt = getJdbcTemplate();
       	
       	logger.info("updating details of role:" +role.getRole_id());
       	jdt.update(SQL_UPD_ROLENM, role.getRolename(),(role.getBln_reports()==true)?"true":"false",
       			(role.getBln_tools()==true)?"true":"false",(role.getBln_settings()==true)?"true":"false",role.getRole_id());
       	
       	return true;      	
 	
    }
    
    /**
     * 
     * Delete selected  Role
     *
     * @param  Roleid
     * 
     */ 
    @Transactional
    public boolean deleteRole(int id) { 
  	  logger.info(" delete role id = "+id);
  	   String sql = "";  
  	   try
  	   {  		 
   
     sql = "delete from FWK_ROLE where role_id=?" ;  
     getJdbcTemplate().update(sql,id);
     return true;
  	   }
  	   catch(Exception e)
  	   {
  		   return false;
  	   }
    }  
    
  
    
     
     /**
      * 
      * Gets user preferences
      *
      * @param  
      * @return 
      */    
     public UserPref getUserPreferences(String user){
         final String SQL_SEL_USERP = " SELECT uf.user_id,FAVOPERATION,bln_showtip FROM FWK_USER_FAVORITE uf inner join " +
" fwk_user u on uf.user_id=u.user_id  where  u.username =  ?";
    
      	logger.info("Getting User preference details of user:"+user);
      	try{
       List<UserPref> userps = getJdbcTemplate().query(SQL_SEL_USERP, new UserPrefMapper(), user);

    	return userps.get(0);  // This list will contain only 1 element, corresponding to one record.
      	}
      	catch(Exception e)
      	{
      		return null;
      	}
     };
     
     /**
      * 
      * insert user preferences
      *
      * @param UserPref object 
      * @return true or false
      */      
     public boolean InsertUserPreferences(UserPref userp){
    	 final String SQL_UPD_PREF = " INSERT INTO fwk_user_favorite (FAVOPERATION,USER_ID,bln_showtip) VALUES (?,?,?)";
    	 logger.info("updating user pref of user:"+userp.getUser_id());
    	 JdbcTemplate jdt = getJdbcTemplate();
    	 jdt.update(SQL_UPD_PREF, userp.getFavoperation(),userp.getUser_id(),userp.getShowtip());    	
    	 return true;
     } 
     /**
      * 
      * Update user preferences
      *
      * @param UserPref object 
      * @return true or false
      */      
     public boolean updateUserPreferences(UserPref userp){
    	 final String SQL_UPD_PREF = "update fwk_user_favorite set FAVOPERATION=?,bln_showtip=? where user_id = ?";
    	 logger.info("updating user pref of user:"+userp.getUser_id());
    	 JdbcTemplate jdt = getJdbcTemplate();
    	 jdt.update(SQL_UPD_PREF, userp.getFavoperation(),userp.getShowtip(),  userp.getUser_id());    	
    	 return true;
     }
     
     public List<RoleDsp> getRoleDtls()
     {
    	 
     	List<RoleDsp> roledsp=null;
     	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
         String uname = auth.getName();
         String qry="select distinct rolename,companyname,r.company_id,r.role_id from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
                 "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username= ?";
         //logger.info("RoleDsp qry "+qry );
     	roledsp=  getJdbcTemplate().query(qry, new RoleMapper(),uname);
     	
     	return roledsp;
     }
     
    /**
    * 
    * Helper Class
    *
    * @param  
    * @return 
    */
    private static class UserPrefMapper implements ParameterizedRowMapper<UserPref> {

        public UserPref mapRow(ResultSet rs, int rowNum) throws SQLException {
            UserPref userp = new UserPref();
            userp.setUser_id(rs.getInt("USER_ID"));
           
            userp.setFavoperation(rs.getString("FAVOPERATION"));
            
            userp.setShowtip(rs.getString("bln_showtip"));
            return userp;
        }

    }
    


    
    /**
    * 
    * Helper Class
    *
    * @param  
    * @return 
    */
    private static class UserMapper implements ParameterizedRowMapper<User> {

        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setUser_id(rs.getInt("USER_ID"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("PASSWORD"));
            user.setEnabled(rs.getBoolean("b_enabled"));
            user.setRole(rs.getString("ROLENAME"));
            user.setMobileno(rs.getString("MOBILNO"));
            user.setEmail(rs.getString("EMAIL"));
            user.setRole_id(rs.getInt("role_id"));
			user.setLastlogin(rs.getDate("DT_LASTLOGIN"));
            return user;
        }

    }
    

       
    
     
     /**
      * 
      * Helper Class 
      *
      * @param  
      * @return 
      */
      private static class RoleMapper implements ParameterizedRowMapper<RoleDsp> {  	
          public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
              RoleDsp role = new RoleDsp();
              role.setRole_id(rs.getInt("ROLE_ID"));
              role.setRolename(rs.getString("ROLENAME")); 
              role.setCompanyid(rs.getInt("COMPANY_ID"));
              role.setCompany(rs.getString("companyname"));
              return role;
          }
       }
      /**
       * 
       * Helper Class 
       *
       * @param  
       * @return 
       */
       private static class RoleMapperRole implements ParameterizedRowMapper<RoleDsp> {  	
           public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
               RoleDsp role = new RoleDsp();
               role.setRole_id(rs.getInt("ROLE_ID"));
               role.setRolename(rs.getString("ROLENAME")); 
            
               return role;
           }
        }
       /**
        * 
        * Helper Class 
        *
        * @param  
        * @return 
        */
        private static class RoleDtlsMapper implements ParameterizedRowMapper<RoleDsp> {  	
            public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
                RoleDsp role = new RoleDsp();
                role.setRole_id(rs.getInt("ROLE_ID"));
                role.setRolename(rs.getString("ROLENAME")); 
               
                try{
                role.setBln_reports((rs.getString("B_REPORTS").equals("true"))?true:false);
		            }
		            catch(Exception e){role.setBln_reports(false);}
               
                try{
                role.setBln_settings((rs.getString("B_SETTINGS").equals("true"))?true:false); 
				}
				catch(Exception e){role.setBln_settings(false);}
                try{
	                role.setBln_tools((rs.getString("B_TOOLS").equals("true"))?true:false);   
	        }
	        catch(Exception e){role.setBln_tools(false);}
                return role;
            }
         }
 }
