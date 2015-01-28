package ireveal.repository;
import ireveal.domain.Company;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

 
  import java.util.ArrayList;  
import java.util.List;  
import javax.sql.DataSource;  
import javax.swing.tree.RowMapper;

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;  
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
 
    
  public class JdbcCompanyDao extends JdbcDaoSupport implements CompanyDao {  
    
    
    
   public boolean insertData(Company company) {  
    
    String sql = "INSERT INTO fwk_company "  
      + "(company_id,companyname, address) VALUES (?, ?, ?)";     
      
    getJdbcTemplate().update(  
      sql,  
      new Object[] { company.getCompanyid(), company.getCompanyname(),  
    		  company.getCompanyAddress() });  
    return true;
    
   }  
    
   public List<Company> getCompanyList() {  
    List companyList = new ArrayList();  
    
    String sql = "select C.company_id,c.companyName,c.Address from FWK_COMPANY C ";  
   
    companyList = getJdbcTemplate().query(sql, new CompanyMapper());  
    return companyList;  
   }  
    
     
   public boolean deleteData(int id) {  
    String sql = "delete from FWK_COMPANY where company_id=" + id;  
    getJdbcTemplate().update(sql);  
    return true;
   }  
    
     
   public boolean updateData(Company company) {  
    
    String sql = "UPDATE fwk_company set companyname = ?,address = ? where company_id = ?";  
    getJdbcTemplate().update(  
      sql,  
      new Object[] { company.getCompanyname(), company.getCompanyAddress(),  
    		  company.getCompanyid() }); 
    
    
    return true;    
   }  
    
   
   public Company getCompany(int id) {  
	   logger.info("***inside JDBCCompany** ");
	   List<Company> companyList =null;
    String sql = "select C.company_id,c.companyName,c.Address from FWK_COMPANY C  where c.company_id=?";  
   try
   {
    companyList = getJdbcTemplate().query(sql, new CompanyMapper(),id);
    logger.info("***companyList companyname** "+ companyList.get(0).getCompanyname() );
	  
   }
   catch(Exception e)
   {
    logger.info("***Exception** "+ e.getMessage() );
   }
    return companyList.get(0);  
   }  
   private static class CompanyMapper implements ParameterizedRowMapper<Company> {
	   
       public Company mapRow(ResultSet rs, int rowNum) throws SQLException {
           Company company = new Company();
           company.setCompanyid(rs.getInt("company_id"));
    	   company.setCompanyname(rs.getString("companyName"));  
    	   company.setCompanyAddress(rs.getString("Address")); 
    	   
           return company;
       }

   }
   
  /*public class CompanyRowMapper implements RowMapper<Company> {  
	  
	  public Company mapRow(ResultSet resultSet, int line) throws SQLException {  
	   CompanyExtractor CompanyExtractor = new CompanyExtractor();  
	   return CompanyExtractor.extractData(resultSet);  
	  }  
	   
	 } 
  public class CompanyExtractor implements ResultSetExtractor<Company> {  
	  
	  public Company extractData(ResultSet resultSet) throws SQLException,  
	    DataAccessException {  
	     
		  Company company = new Company();  
	     
		  company.setcompanyid(resultSet.getInt(1));  
	   company.setdisplayname(resultSet.getString(2));  
	   company.setcompanyname(resultSet.getString(3));  
	   company.setcompanyAddress(resultSet.getString(4));  
	    
	     
	   return company;  
	  }  
	   
	 }*/
  }


