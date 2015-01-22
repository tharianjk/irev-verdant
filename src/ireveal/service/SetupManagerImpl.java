package ireveal.service;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.domain.RoleDsp;
import ireveal.domain.User;
import ireveal.domain.UserPref;
import ireveal.repository.SetupDao;


public class SetupManagerImpl implements SetupManager {

	protected final Log logger = LogFactory.getLog(getClass());
    private SetupDao setupDao;    
 
       
    public void setSetupDao(SetupDao Dao) {
        this.setupDao = Dao;
    }
   
    
    public List<User> getUsers() {
//      return users;
  	 return setupDao.getUserList();
  }

    
    public boolean saveUser(User user){
    	return setupDao.createUser(user);
    }
    
    public boolean updateUser(User user){
    	return setupDao.updateUser(user);
    }
    
    
   
    /**
    *  Return details of user
    * 
    *
    * @param  
    * @return User object
    */
    public User getUser(String userid){
    	logger.info("came to getUser for userid:"+userid);
    	List<User> userlist = setupDao.getUserList();
    	for (User user : userlist){
    		if (user.getUser_id() == Integer.valueOf(userid)){
    			return user;
    		}
    	}
    	logger.info("** could not find user !!");
    	return null;
    }    

    /**
    *  Return details of user preferences
    * 
    *
    * @param  
    * @return UserPref object
    */    
    public UserPref getUserPreferences(String user){
    	return setupDao.getUserPreferences(user);
    }
    
    
    /**
    *  Update user preferences
    * 
    *
    * @param  UserPref object
    * @return true or false
    */        
    public boolean updateUserPreferences(UserPref userp){
    	return setupDao.updateUserPreferences(userp);
    }
    
    
    /**
    *  Return list of Roles that are editable. This list does not include the seeded roles of ROLE_USER and ROLE_ADMIN
    * 
    *
    * @param  
    * @return List of Role object
    */
    public List<RoleDsp> getRoles(){
    	logger.info("came to getRoles");
    	List<RoleDsp> rolelist = setupDao.getRoles();
    	return rolelist;
    	
    }
    
    
    /**
     *  Return list of Roles that are assignable to a user
     * 
     *
     * @param  
     * @return List of Role object
     */
     public List<RoleDsp> getAssignableRoles(){
     	logger.info("came to getAssignableRoles");
     	List<RoleDsp> rolelist = setupDao.getAssignableRoles();
     	return rolelist;
     	
     }
    /**
    *  Return list of Roles
    * 
    *
    * @param  
    * @return List of Role object
    */    
    public boolean createRole(RoleDsp role){
    	return setupDao.createRole(role);
    }
 
    /**
     *  Return details of a Role
     * 
     *
     * @param  roleid
     * @return RoleDsp object
     */    
    public RoleDsp getRole(String roleid_s){
    	return setupDao.getRole(roleid_s);
    }
    
   
    
    /**
     *  Update details of a Role
     * 
     *
     * @param  roleid
     * @return RoleDsp object
     */    
    public boolean updateRole(RoleDsp role){
    	return setupDao.updateRole(role);
    }

   

	@Override
	public int grtUserid(String uname) {
		return setupDao.grtUserid(uname);
	}

	@Override
	public boolean InsertUserPreferences(UserPref userp) {
		return setupDao.InsertUserPreferences(userp);
	}

	@Override
	public boolean deleteUser(int id) {
		return setupDao.deleteUser(id);
	}

	@Override
	public boolean deleteRole(int id) {
		return setupDao.deleteRole(id);
	}
    
 
}