package ireveal.repository;

import ireveal.domain.AssetTree;
import ireveal.domain.RoleDsp;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;	
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;


public class JdbcAssetTreeDao extends JdbcDaoSupport implements AssetTreeDao {
	
    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());

    String role ="";
    public List<AssetTree> getAssetList() {
    	 /**
    	    * 
    	    * Getting asset list for populating assettree 
    	    *
    	    * @param  
    	    * @return 
    	    */
        logger.info("Getting AssetTree!");      
        
        List<RoleDsp> rle =getRoleDtls();
        rle.get(0).getCompanyid();
        role=rle.get(0).getRolename();
        logger.info("role "+ role);
        List<AssetTree> AssetTree=null;
       
        	logger.info("inside admin role "+ role);
        	String sql="select companyname assetname,company_id Assettree_id,0 PARENT_ID,1 N_treelevel,0 N_level,'Company' assettype,'X' ATYPE, 'X' PVtype from fwk_company "+
" union select version assetname,product_id Assettree_id,1 PARENT_ID, 2  N_treelevel,1 N_level,'Product' assettype,FA.PTYPE ATYPE,'X' PVtype from PRODUCT FA "+ 
" union select testname assetname,test_id Assettree_id,FA.Product_id PARENT_ID, 3  N_treelevel,2 N_level,'PVTest' assettype,P.PTYPE ATYPE,TESTTYPE PVtype from PV_TESTDATA FA inner join product p on FA.product_id=p.product_id "+
" union select SerialNo assetname,Prodserial_id Assettree_id,ps.Product_id PARENT_ID,3 N_treelevel,2 N_level,'ProductSer' assettype,P.PTYPE ATYPE,'X' PVtype from product_serial ps inner join product p on ps.product_id=p.product_id "+
" union select TestName assetname,Test_id Assettree_id,ProdSerial_id PARENT_ID,4 N_treelevel,3 N_level,'TestData' assettype,TESTTYPE ATYPE,TESTTYPE PVtype from testdata "+
		 "  order by n_level,PARENT_ID,assettree_id ";
        	//logger.info("***Asset tree sql** " + sql);
        	AssetTree = getJdbcTemplate().query(
                     sql, 
                     new AssetTreeMapper());
       
        return AssetTree;
    }
    public List<RoleDsp> getRoleDtls()
    {
    	List<RoleDsp> roledsp=null;
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String uname = auth.getName();
    	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,r.company_id,r.role_id from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
        "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username ='" +uname +"'", new RoleMapper());
    	
    	return roledsp;
    }
   
     public String sbAssetName()
     {   	 
         List<RoleDsp> roledsp=getRoleDtls();
         role =roledsp.get(0).getRolename();    	
    	 return  getJdbcTemplate().queryForObject("select a.displayName from fwk_Assettree a inner join fwk_role r on a.assettree_id=r.company_id  where r.role_name= = '"+role+"'",String.class);
               //  return Integer.toString(user1);
     }
    
    private static class AssetTreeMapper implements ParameterizedRowMapper<AssetTree> {

        public AssetTree mapRow(ResultSet rs, int rowNum) throws SQLException {
            AssetTree assettree = new AssetTree();
            assettree.setAssetname(rs.getString("assetname"));
            assettree.setAssetid(rs.getInt("assettree_id"));
            assettree.setAssetparentid(rs.getInt("PARENT_ID"));
            assettree.setTreelevel(rs.getInt("N_treelevel"));            
            assettree.setAtype(rs.getString("ATYPE"));
            assettree.setAssettype(rs.getString("assettype"));
            assettree.setNlevel(rs.getInt("N_level"));  
            assettree.setPvtype(rs.getString("PVTYPE"));
            return assettree;
        }

    }
    public static class RoleMapper implements ParameterizedRowMapper<RoleDsp> {

        public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
        	RoleDsp roledsp = new RoleDsp();
        	roledsp.setRolename(rs.getString("rolename"));
        	roledsp.setCompanyid(rs.getInt("Company_id"));
        	roledsp.setRole_id(rs.getInt("Role_id"));
        	roledsp.setCompany(rs.getString("Companyname"));            
            return roledsp;
        }

    }
 }
