package ireveal.repository;

import ireveal.domain.User;
import java.util.List;
import ireveal.domain.RoleDsp;

import ireveal.domain.UserPref;

public interface SetupDao {
 
    public List<User> getUserList();
    
    public boolean createUser(User user);
    
    public boolean updateUser(User user);
       
    public List<RoleDsp> getRoles();
    
    public List<RoleDsp> getAssignableRoles();
    
    public boolean createRole(RoleDsp role);
    
    public RoleDsp getRole(String roleid_s);   
    
    
    public boolean updateRole(RoleDsp role);   
    
    
    public UserPref getUserPreferences(String user);
    public boolean InsertUserPreferences(UserPref userp);
    public boolean updateUserPreferences(UserPref userp);
    
    public int grtUserid(String uname);
    public boolean deleteUser(int id);
    public boolean deleteRole(int id);
}
