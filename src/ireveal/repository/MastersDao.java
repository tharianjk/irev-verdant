package ireveal.repository;
import ireveal.domain.AssetTree;
import ireveal.domain.RoleDsp;
import ireveal.domain.Operator;
import ireveal.domain.UserPref;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


import ireveal.domain.User;

public interface MastersDao { 
	public List<RoleDsp> getRoleDtls();
	public List<AssetTree> getAssetTreeList();	
	public List<Operator> getOpeListTag();
   
    public List<UserPref> getUserFav();
    
    public List<User> getUserList();    
    
    
	// To update lastLogin date of User
	public boolean updateUserLogin(String uname);	
	
	
	public List<RoleDsp> getLogUserRole();
	
		
	
}
