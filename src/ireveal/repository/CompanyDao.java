package ireveal.repository;

import ireveal.domain.Company;

import java.util.List;

public interface CompanyDao {       
    
    public List<Company> getCompanyList();
    public boolean insertData(Company company);  
    
    public boolean updateData(Company company);  
    public boolean deleteData(int id);  
    public Company getCompany(int id);
   
    
}
