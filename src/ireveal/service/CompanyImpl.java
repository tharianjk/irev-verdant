package ireveal.service;
import java.util.List;
import ireveal.repository.CompanyDao;
import ireveal.domain.Company;


public class CompanyImpl implements CompanyService {

	 
 CompanyDao companydao;

 @Override
 public boolean insertData(Company company) {
	return companydao.insertData(company);
 }

 @Override
 public boolean updateData(Company company) {
	return companydao.updateData(company);
  
 }

@Override
public List<Company> getCompanyList() {
	return companydao.getCompanyList();
	
}

@Override
public boolean deleteData(int id) {
	return companydao.deleteData(id);
	
}

@Override
public Company getDetails(int id) {
	return companydao.getCompany(id);
	
}
public void setCompanyDao(CompanyDao companyDao) {
    this.companydao = companyDao;
}
public CompanyDao getCompanyDao() {
	return companydao;
}
 
}

