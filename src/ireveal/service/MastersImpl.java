package ireveal.service;
import java.util.Date;
import java.util.List;

import ireveal.repository.MastersDao;
import ireveal.domain.AssetTree;
import ireveal.domain.Company;
import ireveal.domain.Operator;
import ireveal.domain.RoleDsp;
import ireveal.domain.User;
import ireveal.domain.UserPref;




public class MastersImpl implements MastersService {

	 
 MastersDao mastersdao;


public void setMastersDao(MastersDao mastersDao) {
    this.mastersdao = mastersDao;
}
public MastersDao getMastersDao() {
	return mastersdao;
}
@Override
public List<AssetTree> getAssetTreeList() {
	return mastersdao.getAssetTreeList();
}
@Override
public List<Operator> getOpeListTag() {
	return mastersdao.getOpeListTag();
}

@Override
public List<UserPref> getUserFav(){
	return mastersdao.getUserFav();
}


@Override
public List<RoleDsp> getRoleDtls() {
	return mastersdao.getRoleDtls();
}



public boolean updateUserLogin(String uname){
	return mastersdao.updateUserLogin(uname);
}

@Override
public List<RoleDsp> getLogUserRole() {
	return mastersdao.getLogUserRole();
}


}

