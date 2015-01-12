package ireveal.service;

import java.util.Date;
import java.util.List;  


import ireveal.domain.AssetTree;

import ireveal.domain.Operator;

import ireveal.domain.RoleDsp;

import ireveal.domain.User;
import ireveal.domain.UserPref;

public interface MastersService { 
	public List<RoleDsp> getRoleDtls();
	public List<AssetTree> getAssetTreeList();
	public List<Operator> getOpeListTag();
	
	public List<UserPref> getUserFav();
	public boolean updateUserLogin(String uname);
	
		public List<RoleDsp> getLogUserRole();
		
 		
} 