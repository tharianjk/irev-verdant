package ireveal.repository;


import ireveal.domain.AssetTree;
import ireveal.domain.DataLog;
import ireveal.domain.Operator;
import ireveal.domain.Product;
import ireveal.domain.ProductSerial;
import ireveal.domain.RoleDsp;
import ireveal.domain.TestData;
import ireveal.domain.TestFiles;
import ireveal.domain.TestFrequency;
import ireveal.domain.User;
import ireveal.domain.UserPref;
import ireveal.repository.JdbcAssetTreeDao.RoleMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;  
import java.util.Calendar;
import java.util.Date;

import org.springframework.jdbc.core.JdbcTemplate;  
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
 
    
  public class JdbcMastersDao extends JdbcDaoSupport implements MastersDao {
	  int compid=1; 
	  @Override
	  public List<AssetTree> getAssetTreeList() {
		  List<RoleDsp> rle =getRoleDtls();
	         compid=rle.get(0).getCompanyid();
		  List dataList = new ArrayList();  
		    
		    String sql = "select A.ASSETTREE_id,A.displayname from FWK_ASSETTREE A WHERE ASSETTREETYPE_ID NOT IN (1,2) and A.COMPANY_ID=" +compid;  
		   
		    dataList = getJdbcTemplate().query(sql, new DataAssettreeMapper());  
		    return dataList;  
		    
	  }
	  private static class DataAssettreeMapper implements ParameterizedRowMapper<AssetTree> {
		   
	       public AssetTree mapRow(ResultSet rs, int rowNum) throws SQLException {
	    	   AssetTree assettree = new AssetTree();
	    	   assettree.setAssetid(rs.getInt("assettree_id"));  
	    	   assettree.setAssetname(rs.getString("displayname"));  	    	   
	           return assettree;
	       }
	   }
	  @Override
	  public List<UserPref> getUserFav() {
	  	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	      String uname = auth.getName();
	      String sql="select FAVOPERATION from FWK_USER U INNER JOIN FWK_USER_FAVORITE UF ON U.USER_ID=UF.USER_ID  "+
	      " where username='"+uname+"'";
	      try{
	      	 List<UserPref> userpref = getJdbcTemplate().query(sql, new UsrFavMapper());
	      	 return userpref;
	      }
	      catch(Exception e)
	      {
	      	return null;
	      }
	  }
 //************************User List**********************
	  @Override
	  public List<User> getUserList() {
		  List<RoleDsp> rle =getRoleDtls();
	      compid=rle.get(0).getCompanyid();
	  	  logger.info("inside userlist"); 
	      List<User> userlist = new ArrayList();  
	      
	      String sql = "SELECT DISTINCT M.USER_ID,USERNAME FROM FWK_USER M INNER JOIN FWK_USER_ROLE UR ON M.USER_ID= UR.USER_ID "+
	      " INNER JOIN FWK_ROLE R ON UR.ROLE_ID=R.ROLE_ID WHERE R.COMPANY_ID= "+compid;  
	     
	      userlist = getJdbcTemplate().query(sql, new DataUserListTypeMapper());     
	      
	      return userlist;
	  }
	  private static class DataUserListTypeMapper implements ParameterizedRowMapper<User> {
	  	   
	      public User mapRow(ResultSet rs, int rowNum) throws SQLException {
	      	User userlist = new User();
	      	userlist.setUser_id(rs.getInt("USER_ID"));
	      	userlist.setUsername(rs.getString("USERNAME"));  
	      			
	          return userlist;
	      }

	  }
	   
List<Operator> opeList = new ArrayList<Operator>();

public List<Operator> getOpeList() {
    if(opeList.isEmpty()){            
    	opeList.add(new Operator( "<","<"));
    	opeList.add(new Operator( ">",">"));
    	opeList.add(new Operator( "<=","<="));
    	opeList.add(new Operator( ">=",">="));
    	opeList.add(new Operator( "AND","&&"));
    	opeList.add(new Operator( "OR","||"));
    	opeList.add(new Operator( "(","("));
    	opeList.add(new Operator( ")",")"));
    }
    return opeList;
}
 

public void setOpeList(List<Operator> opeList) {
    this.opeList = opeList;
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
/**
 * 
 * Get list of roles 
 *
 * @param  none
 * @return List of RoleDsp fr main controller
 */    
 public List<RoleDsp> getLogUserRole(){
     Authentication auth = SecurityContextHolder.getContext().getAuthentication();
     String uname = auth.getName();
     List<RoleDsp>	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,r.company_id,r.role_id,r.b_reports,r.b_events,r.b_tools,r.b_settings,c.expirydate from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
     "inner join fwk_user u on ur.user_id=u.user_id inner join fwk_company c on r.company_id=c.company_id where r.rolename <> 'ROLE_USER' and u.username ='" +uname +"'", new RoleLogMapper());
 	logger.info("roledsp.size "+ roledsp.size());
 	
  	return roledsp;
 }
 /**
  * 
  * Helper Class 
  *
  * @param  
  * @return 
  */
  private static class RoleLogMapper implements ParameterizedRowMapper<RoleDsp> {  	
      public RoleDsp mapRow(ResultSet rs, int rowNum) throws SQLException {
          RoleDsp role = new RoleDsp();
          Calendar cal = Calendar.getInstance();
 	     cal.setTime(new Date()); // Now use today date.
 	     cal.add(Calendar.DATE, 1); // Adding 5 days
 	
 	     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
          role.setRole_id(rs.getInt("ROLE_ID"));
          role.setRolename(rs.getString("ROLENAME")); 
          
          role.setCompany(rs.getString("companyname")); 
          role.setCompanyid(rs.getInt("company_id"));
          role.setExpirydate(rs.getString("expirydate"));
          
         
          try{
          role.setBln_reports((rs.getString("B_REPORTS").equals("true"))?true:false);
	            }
	            catch(Exception e){role.setBln_reports(false);}
          try{
          role.setBln_events((rs.getString("B_EVENTS").equals("true"))?true:false);
	        }
	        catch(Exception e){role.setBln_events(false);}
	        try{
	                role.setBln_tools((rs.getString("B_TOOLS").equals("true"))?true:false);   
	        }
	        catch(Exception e){role.setBln_tools(false);}
          try{
          role.setBln_settings((rs.getString("B_SETTINGS").equals("true"))?true:false); 
			}
			catch(Exception e){role.setBln_settings(false);}
       
          return role;
      }
   }
public static class StringRowMapper implements ParameterizedRowMapper<String>{
public String mapRow(ResultSet rs, int rowNum) throws SQLException {
    return rs.getString(1);
        }}


List<Operator> opeListtag = new ArrayList<Operator>();

public List<Operator> getOpeListTag() {
    if(opeListtag.isEmpty()){ 
    	
    	opeListtag.add(new Operator( "+","+"));
    	opeListtag.add(new Operator( "-","-"));
    	opeListtag.add(new Operator( "*","*"));
    	opeListtag.add(new Operator( "/","/"));
    	opeListtag.add(new Operator( "=","="));
    	opeListtag.add(new Operator( "AND","&&"));
    	opeListtag.add(new Operator( "OR","||"));
    	opeListtag.add(new Operator( "(","("));
    	opeListtag.add(new Operator( ")",")"));
    }
    return opeListtag;
}

private static class UsrFavMapper implements ParameterizedRowMapper<UserPref> {  	
public UserPref mapRow(ResultSet rs, int rowNum) throws SQLException {
	UserPref userpref = new UserPref();
	userpref.setFavoperation(rs.getString("FAVOPERATION"));    
	
	return userpref;
}
}

    /**
   * 
   * Update details of existing user 
   *
   * @param  
   * @return 
   */
   public boolean updateUserLogin(String uname){
   	logger.info("Going to udpate user : "+uname);

   	final String SQL_UPD_USR = "update fwk_user set dt_lastlogin = ? where username = ?";
   	
   	Calendar cal = Calendar.getInstance();
   	Date curTime = cal.getTime();
   	
   	final JdbcTemplate jdt = getJdbcTemplate();
   	jdt.update(SQL_UPD_USR,	curTime, uname );
   	
  	return true;
   }
   
   public List<TestFrequency> getFreqList(int testid){
	   
	   logger.info("***inside getFreqList** ");
	   List<TestFrequency> dataList =null;
    String sql = "select frequency,lineargain from testFreq  where test_id =" + testid;  
   try
   {
	   dataList = getJdbcTemplate().query(sql, new TestFreqMapper());
  
   }
   catch(Exception e)
   {
    logger.info("***Exception** "+ e.getMessage() );
   }
    return dataList;  
   }  
   private static class TestFreqMapper implements ParameterizedRowMapper<TestFrequency> {
	   
       public TestFrequency mapRow(ResultSet rs, int rowNum) throws SQLException {
    	   TestFrequency testfreq = new TestFrequency();
    	   testfreq.setFrequency(rs.getDouble("frequency"));  
    	   testfreq.setLineargain(rs.getDouble("lineargain"));  
    	       	   
           return testfreq;
       }

   }
   
   //import test data
   @Transactional
   public int insertTestData(TestData testdata,List<TestFrequency> testfreqlist,List<DataLog> dataloglist,String strmode,String action ){
	  
	   int testid=0;
	   logger.info(" strmode "+strmode);
	   try{
	   
if(strmode.equals("new")){
	   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
   final String  sql = "INSERT INTO testdata(TestName,TestDesc,ProdSerial_id,TestDate,frequnit,testcenter,instruments,calibration,testproc) VALUES  (?,?,?,?,?,?,?,?,?)";    
	     KeyHolder keyHolder = new GeneratedKeyHolder();
	    
	     final String testname = testdata.getTestname();
	     final String testdesc = testdata.getTestdesc();	    
	     final int prdserid = testdata.getProductserialid();
	     final String testdate=sdf.format(testdata.getDttestdate());
	     final String frequnit="MHz";//testdata.getFrequnit();
	     final String testcenter=testdata.getTestcenter();
	     final String instruments=testdata.getInstruments();
	     final String calibration=testdata.getCalibration();
	     final String testproc=testdata.getTestproc();
	  	getJdbcTemplate().update(
	  	    new PreparedStatementCreator() {
	  	        public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
	  	            PreparedStatement ps =
	  	                connection.prepareStatement(sql, new String[] {"TEST_ID"});
	  	           
	  	            ps.setString(1, testname);
	  	            ps.setString(2, testdesc);
	  	            ps.setInt(3, prdserid);	  	           
	  	            ps.setString(4, testdate);
	  	            ps.setString(5, frequnit);
	  	            ps.setString(6, testcenter);
	  	            ps.setString(7, instruments);
	  	            ps.setString(8, calibration);
	  	            ps.setString(9, testproc);
	  	            return ps;
	  	        }
	  	    },
	  	    keyHolder);
	  	testid= keyHolder.getKey().intValue();
	  	logger.info(" TestData record inserted. Key = "+testid); 
	  	 
	   }
	   else{testid=testdata.getTestid();
	   }
	  	  	
	  	
	  	// test freq
	  	String sqltestfreq=	"INSERT INTO testfreq(Test_id,Frequency,lineargain)  VALUES   (?,?,?)";  
	  	for (int i=0;i<testfreqlist.size();i++){
	  		int cnt =getJdbcTemplate().queryForInt("select count(*) from testfreq where Test_id=? and Frequency=?",testid,testfreqlist.get(i).getFrequency());
		if(cnt==0){
			logger.info("lg"+testfreqlist.get(i).getLineargain());
	  		getJdbcTemplate().update(  
				sqltestfreq,  
		 new Object[] {testid, testfreqlist.get(i).getFrequency(), testfreqlist.get(i).getLineargain()==0.00?null:testfreqlist.get(i).getLineargain() });}

		}
	  	
	 // datalog
	  	 String sqltest="";
	  	if(testdata.getFiletype().equals("Vdata"))
	  	{
	  		sqltest="insert into Vdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?);"; 
	  	}
	  	else if(testdata.getFiletype().equals("Hdata"))
	  	{
	  		sqltest="insert into Hdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?);"; 
	  	}
	  	else {
	  		sqltest="insert into CPdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?);"; 
		  	
	  	}
	  	for (int i=0;i<dataloglist.size();i++){		 
		getJdbcTemplate().update(  
				sqltest,  
		 new Object[] {testid, dataloglist.get(i).getFreq(), dataloglist.get(i).getAngle(),dataloglist.get(i).getAmplitude() });

		}
	  	if(action.equals("Done"))
	  	{
	  		final String ptype = testdata.getPtype()=="Linear"?"L":"C";
	  		//final String funit = testdata.getFrequnit()=="MHz"?"M":"G";
	  		final String funit = "M";
	  		getJdbcTemplate().update("call Calculate_params (?,?)", testid,ptype);
	  		
	  	}	  	
	   }
	   catch(Exception e){
		   if(!strmode.equals("new")){
			   
		   }
	   }
	    return testid;	    
	   }
   
   
   
   public int InsertProduct(Product prod) {
	   
	   int primaryKey;
	   
   final String  sql = "INSERT INTO product(Productname,Version,PType,ImageFileName,b_withcp) VALUES   (?,?,?,?,?)";    
	     KeyHolder keyHolder = new GeneratedKeyHolder();
	    
	     final String prdname = prod.getProductname();
	     final String version = prod.getVersion();	    
	     final String ptype = prod.getPtype();
	     final String iname = prod.getImagefilename();
	     final Boolean bwithcp = prod.getBwithcp();
	  	getJdbcTemplate().update(
	  	    new PreparedStatementCreator() {
	  	        public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
	  	            PreparedStatement ps =
	  	                connection.prepareStatement(sql, new String[] {"PRODUCT_ID"}); 
	  	            ps.setString(1, prdname);	
	  	            ps.setString(2, version);
	  	            ps.setString(3, ptype);	  
	  	          ps.setString(4, iname);
	  	        ps.setBoolean(5, bwithcp);
	  	            return ps;
	  	        }
	  	    },
	  	    keyHolder);
	  	primaryKey= keyHolder.getKey().intValue();
	  	logger.info(" Product record inserted. Key = "+primaryKey); 	       
	    return primaryKey;	
	   }
   
   //product
   public List<Product> getProductList() {  
	    List dataList = new ArrayList();  
	   
	    String sql = "select Product_id,Productname,Version,PType,ImageFileName,b_withcp from product";  
	   
	    dataList = getJdbcTemplate().query(sql, new ProductMapper());  
	    return dataList;  
	   }  
	    
	   @Transactional
	   public boolean deleteproduct(int id) { 
		   String sql = ""; 
		   
			   try{
	     sql = "delete from product where product_id=" + id;  
	    getJdbcTemplate().update(sql);
	   
	    return true;
	    }
			   catch(Exception e)
			   {
				   logger.info("prduct Delete error " +e.getMessage()); 
				   return false;
			   }
		   
	   }
	    
	     
	   public boolean updateProduct(Product prduct) {  
		   try{
	    String sql = "UPDATE Product set productname = ?,version = ?,ptype=?,imagefilename=?,b_withcp=? where product_id = ?";  
	    getJdbcTemplate().update(  
	      sql,  
	      new Object[] { prduct.getProductname(), prduct.getVersion(),  prduct.getPtype(),prduct.getImagefilename(),prduct.getBwithcp(),
	    		  prduct.getProductid() }); 
	    
	   
	    return true;    
	    }
	    catch(Exception e ){
			   logger.info("prduct Update error " +e.getMessage()); 
			   return false;
		   }
	   }  
	    
	   
	   public Product getProduct(int id) {  
		   logger.info("***inside prduct** ");
		   List<Product> dataList =null;
	    String sql = "select Product_id,Productname,Version,PType,ImageFileName,b_withcp from product  where Product_id =" + id;  
	   try
	   {
		   dataList = getJdbcTemplate().query(sql, new ProductMapper());
	  
	   }
	   catch(Exception e)
	   {
	    logger.info("***Exception** "+ e.getMessage() );
	   }
	    return dataList.get(0);  
	   }  
	   private static class ProductMapper implements ParameterizedRowMapper<Product> {
		   
	       public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
	    	   Product product = new Product();
	    	   product.setProductid(rs.getInt("product_id"));  
	    	   product.setProductname(rs.getString("productname"));  
	    	   product.setPtype(rs.getString("ptype"));  
	    	   product.setVersion(rs.getString("version")); 	    	  
	    	   product.setImagefilename(rs.getString("imagefilename"));
	    	   product.setBwithcp(rs.getBoolean("b_withcp"));
	           return product;
	       }

	   }
//productSerial
	   public int InsertProductSer(ProductSerial prodser) {
		   int primaryKey;
		   
		   final String  sql = "INSERT INTO product_serial(SerialNo,Product_id)  VALUES   (?,?)";
			     KeyHolder keyHolder = new GeneratedKeyHolder();
			    
			     final String prdsername = prodser.getProductserial();
			     final int prodid = prodser.getProductid();	    
			     
			  	getJdbcTemplate().update(
			  	    new PreparedStatementCreator() {
			  	        public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
			  	            PreparedStatement ps =
			  	                connection.prepareStatement(sql, new String[] {"Prodserial_id"}); 
			  	            ps.setString(1, prdsername);	
			  	            ps.setInt(2, prodid);
			  	           
			  	            return ps;
			  	        }
			  	    },
			  	    keyHolder);
			  	primaryKey= keyHolder.getKey().intValue();
			  	logger.info(" Product Serial record inserted. Key = "+primaryKey); 	       
			    return primaryKey;	 	
		   
		   }
		   
		   

	   public List<ProductSerial> getProductSerList() {  
		    List dataList = new ArrayList();  
		   
		    String sql = "select Prodserial_id, S.Product_id ,SerialNo,productname from product_serial S inner join product p on s.Product_id=p.Product_id";  
		   
		    dataList = getJdbcTemplate().query(sql, new ProductMapper());  
		    return dataList;  
		   }  
		    
		   @Transactional
		   public boolean deleteproductser(int id) { 
			   String sql = ""; 
			   
				   try{
		     sql = "delete from product_serial where Prodserial_id=" + id;  
		    getJdbcTemplate().update(sql);
		   
		    return true;
		    }
				   catch(Exception e)
				   {
					   logger.info("Prodserial Delete error " +e.getMessage()); 
					   return false;
				   }
			   
		   }
		    
		     
		   public boolean updateProductSer(ProductSerial prduct) {  
			   try{
		    String sql = "UPDATE product_serial set SerialNo = ?,product_id = ? where Prodserial_id = ?";  
		    getJdbcTemplate().update(  
		      sql,  
		      new Object[] { prduct.getProductserial(), prduct.getProductid(),  prduct.getProductserialid() }); 
		    
		   
		    return true;    
		    }
		    catch(Exception e ){
				   logger.info("prduct Update error " +e.getMessage()); 
				   return false;
			   }
		   }  
		    
		   
		   public ProductSerial getProductSer(int id) {  
			   logger.info("***inside prduct** ");
			   List<ProductSerial> dataList =null;
		    String sql = "select Prodserial_id, S.Product_id ,SerialNo,productname from product_serial S inner join product p on s.Product_id=p.Product_id  where Prodserial_id =" + id;  
		   try
		   {
			   dataList = getJdbcTemplate().query(sql, new ProductSerMapper());
		  
		   }
		   catch(Exception e)
		   {
		    logger.info("***Exception** "+ e.getMessage() );
		   }
		    return dataList.get(0);  
		   }  
		   
		   public List<ProductSerial> getProdVerSer() {  
			   logger.info("***inside getProdVerSer** ");
			   List<ProductSerial> dataList =null;
		    String sql = " select Prodserial_id ,CONCAT(productname, ' ', Version,' ',SerialNo) SerialNo from product_serial S inner join product p on s.Product_id=p.Product_id  ";  
		   try
		   {
			   dataList = getJdbcTemplate().query(sql, new ProdVerSerMapper());
		  
		   }
		   catch(Exception e)
		   {
		    logger.info("***Exception** "+ e.getMessage() );
		   }
		    return dataList;  
		   } 
private static class ProdVerSerMapper implements ParameterizedRowMapper<ProductSerial> {
			   
		       public ProductSerial mapRow(ResultSet rs, int rowNum) throws SQLException {
		    	   ProductSerial product = new ProductSerial(); 
		    	   product.setProductserial(rs.getString("SerialNo"));  
		    	   product.setProductserialid(rs.getInt("Prodserial_id")); 	 
		           return product;
		       }

		   }
		   
		   
		   private static class ProductSerMapper implements ParameterizedRowMapper<ProductSerial> {
			   
		       public ProductSerial mapRow(ResultSet rs, int rowNum) throws SQLException {
		    	   ProductSerial product = new ProductSerial();
		    	   product.setProductid(rs.getInt("product_id"));  
		    	   product.setProductname(rs.getString("productname"));  
		    	   product.setProductserial(rs.getString("SerialNo"));  
		    	   product.setProductserialid(rs.getInt("Prodserial_id")); 	    	  
		    	   
		    	   
		           return product;
		       }

		   }
		   
		
			   @Transactional
	public boolean deleteTestData(int id) { 
				   String sql = ""; 
				   
					   try{
						   sql = " delete from arcalculated where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from cpcalculated where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from hcalculated where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from vcalculated where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from hdata where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from vdata where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from cpdata where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from testfreq where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						   sql = "delete from testdata where Test_id=" + id;
						   getJdbcTemplate().update(sql);
						     sql = "delete from testdata where Test_id=" + id;  
						    getJdbcTemplate().update(sql);
			   
			    return true;
			    }
					   catch(Exception e)
					   {
						   logger.info("Test Delete error " +e.getMessage()); 
						   return false;
					   }
				   
			   }
			    
			     
			   public boolean updateTestData(TestData testdata) {  
				   try{
			    String sql = "UPDATE TestData set testname = ?,testdesc = ?,ProdSerial_id,testdate where test_id = ?";  
			    getJdbcTemplate().update(  
			      sql,  
			      new Object[] { testdata.getTestname(), testdata.getTestdesc(),  testdata.getProductserialid(),testdata.getDttestdate() }); 
			    
			   
			    return true;    
			    }
			    catch(Exception e ){
					   logger.info("testdata Update error " +e.getMessage()); 
					   return false;
				   }
			   }
			
			   
			   public TestData getTestData(int id) {  
				   logger.info("***inside testdata** ");
				   List<TestData> dataList =null;
			    String sql = "select Test_id,TestName,testdesc,T.ProdSerial_id,TestDate,SerialNo,Productname,Version,frequnit,ptype,testcenter,instruments,calibration,testproc from testdata t inner join product_serial s on t.Prodserial_id=S.Prodserial_id "+
			    		" inner join product p on s.Product_id=p.Product_id  where TEST_id =" + id;  
			   try
			   {
				   dataList = getJdbcTemplate().query(sql, new TestDataMapper());
			  
			   }
			   catch(Exception e)
			   {
			    logger.info("***Exception** "+ e.getMessage() );
			   }
			    return dataList.get(0);  
			   }  
			   
			   
			   private static class TestDataMapper implements ParameterizedRowMapper<TestData> {
				   
			       public TestData mapRow(ResultSet rs, int rowNum) throws SQLException {
			    	   TestData testdata = new TestData();
			    	   testdata.setTestid(rs.getInt("Test_id"));  
			    	   testdata.setTestname(rs.getString("testName"));  
			    	   testdata.setTestdesc(rs.getString("testdesc"));  
			    	   testdata.setProductserial(rs.getString("productname") +" " +rs.getString("Version") +" "+rs.getString("SerialNo") );  
			    	   testdata.setProductserialid(rs.getInt("Prodserial_id")); 	    	  
			    	   testdata.setDttestdate(rs.getTimestamp("testdate"));
			    	   testdata.setFrequnit(rs.getString("frequnit"));  
			    	   testdata.setPtype(rs.getString("ptype")); 
			    	   testdata.setTestcenter(rs.getString("testcenter")); 
			    	   testdata.setInstruments(rs.getString("instruments")); 
			    	   testdata.setCalibration(rs.getString("calibration")); 
			    	   testdata.setTestproc(rs.getString("testproc")); 
			    	   
			           return testdata;
			       }

			   }
   
  }




  