package ireveal.service;


import java.io.Serializable;
import java.util.List;
import ireveal.domain.User;
import ireveal.domain.UserPref;
import ireveal.domain.RoleDsp;

public interface SetupManager extends Serializable{
    
   
    public List<User> getUsers();
    
    public boolean saveUser(User user);
    
    public User getUser(String username);
    
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

