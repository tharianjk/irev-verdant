package ireveal.service;

import java.util.List;  
import ireveal.domain.Company;  
  
public interface CompanyService {  
  
 public boolean insertData(Company company);  
 public List<Company> getCompanyList();  
 public boolean deleteData(int id);  
 public Company getDetails(int id);  
 public boolean updateData(Company company);  
  
} 