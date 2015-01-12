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


@SuppressWarnings("deprecation")
public class JdbcAssetTreeDao extends JdbcDaoSupport implements AssetTreeDao {
	
    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());

    private int roleid=1;
    private int compid=1;
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
        compid=rle.get(0).getCompanyid();
        role=rle.get(0).getRolename();
        logger.info("role "+ role);
        List<AssetTree> AssetTree=null;
        if(role.equalsIgnoreCase("ROLE_ADMIN"))
        {
        	logger.info("inside admin role "+ role);
        	String sql="select displayName assetname, Assettree_id,PARENT_ID,FA.ASSETTREETYPE_ID N_treelevel,N_LEVEL,T.ASSETTREETYPE,FA.COMPANY_ID "+ 
" from FWK_ASSETTREE FA INNER JOIN FWK_ASSETTREE_TYPE T ON FA.ASSETTREETYPE_ID=T.ASSETTREETYPE_ID WHERE FA.company_id="+compid+
		 "  order by PARENT_ID,assettree_id ";
        	//logger.info("***Asset tree sql** " + sql);
        	AssetTree = getJdbcTemplate().query(
                     sql, 
                     new AssetTreeMapper());
        }
        else
        {
        	/**
     	    * 
     	    * Getting asset list for populating assettree rolewise
     	    *
     	    * @param  
     	    * @return 
     	    */
        fillTemp();
        String sql ="select displayName assetname, Assettree_id,PARENT_ID,T.ASSETTREETYPE_ID N_treelevel,N_LEVEL,T.ASSETTREETYPE,FA.COMPANY_ID " +
        " from FWK_ASSETTREE_TMP FA INNER JOIN FWK_ASSETTREE_TYPE T ON FA.ASSETTREETYPE_ID=T.ASSETTREETYPE_ID "+        		
        " where M.PARENT_ID in (select Assettree_id from FWK_ASSETTREE_TMP) order by PARENT_ID,assettree_id" ;
        
         AssetTree = getJdbcTemplate().query(
               sql , 
                new AssetTreeMapper());
        }
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
    private void fillTemp()
    {
    	
    	String sql=	"";
    	try{
    		List<RoleDsp> roledsp=getRoleDtls();
    		 roleid = roledsp.get(0).getRole_id();
    		 compid = roledsp.get(0).getRole_id();
    	sql="Delete from FWK_ASSETTREE_TMP";
    	 getJdbcTemplate().update(sql);
    	
    	 logger.info("***FWK_ASSETTREE_TMP deleted** ");
    	 int maxlevel = getJdbcTemplate().queryForInt("select MAX(N_LEVEL) from FWK_ASSETTREE T WHERE T.company_id="+compid);
    	 logger.info("***FWK_ASSETTREE_TMP maxlevel** " +maxlevel);
    	 
    	    	 
        sql=	"INSERT INTO FWK_ASSETTREE_TMP ( ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID,N_treelevel,N_LEVEL,COMPANY_ID) "+
    	" select A.ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID,0,N_LEVEL,A.COMPANY_ID from FWK_ASSETTREE A "+
    	" inner join FWK_ROLE_ASSET R ON R.ASSETTREE_ID=A.ASSETTREE_ID where ROLE_ID= " +roleid ;
        getJdbcTemplate().update(sql);
        logger.info("***FWK_ASSETTREE_TMP first insert** ");
        int i=0;
        for(int j=0;j<=maxlevel;j++)
        {
        i=j+1;
       /* List<AssetTree> AssetTree = getJdbcTemplate().query(
        " select displayName assetname, Assettree_id,PARENT_ID,ASSETTREETYPE_ID,N_LEVEL,N_treelevel "+
        " from FWK_ASSETTREE_TMP where N_treelevel="+j+"  order by PARENT_ID", new AssetTreeMapper());
        logger.info("***AssetTree.size()** " +AssetTree.size());*/
        //assets and meters
        if(j==0)
        {
        	 sql=	"INSERT INTO FWK_ASSETTREE_TMP ( ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID,N_treelevel,N_LEVEL,COMPANY_ID) "+
                 	" select A.ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID," + maxlevel+2 + ",N_LEVEL,A.COMPANY_ID from FWK_ASSETTREE A where "+
             		"  A.ASSETTREE_ID not in ( select T.ASSETTREE_ID from FWK_ASSETTREE_TMP T) and A.PARENT_ID in (select ASSETTREE_ID from FWK_ASSETTREE_TMP)";
             getJdbcTemplate().update(sql);
        }
              	
        
        sql=	"INSERT INTO FWK_ASSETTREE_TMP ( ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID,N_treelevel,N_LEVEL,COMPANY_ID) "+
            	" select A.ASSETTREE_ID, DISPLAYNAME, PARENT_ID, ASSETTREETYPE_ID," + i + ",N_LEVEL,A.COMPANY_ID from FWK_ASSETTREE A where "+
        		"  A.ASSETTREE_ID not in ( select T.ASSETTREE_ID from FWK_ASSETTREE_TMP T ) and A.ASSETTREE_ID in (select PARENT_ID from FWK_ASSETTREE_TMP where N_treelevel="+j+")"; 
        getJdbcTemplate().update(sql);
        
        
        
        logger.info("***FWK_ASSETTREE_TMP insert** " +j);
        }
        
    	}
    	catch(Exception e)
    	{
    		logger.info("***Exception** "+ e.getMessage() );
    	}
        
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
            assettree.setNlevel(rs.getInt("N_LEVEL"));
            assettree.setAssettype(rs.getString("ASSETTREETYPE"));
            assettree.setCompanyid(rs.getInt("COMPANY_ID"));
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
