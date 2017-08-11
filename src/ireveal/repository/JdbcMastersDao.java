package ireveal.repository;


import ireveal.domain.AmpPhaseTrack;
import ireveal.domain.AssetTree;
import ireveal.domain.DataLog;
import ireveal.domain.GainSTDHorn;
import ireveal.domain.ImportData;
import ireveal.domain.Operator;
import ireveal.domain.PVSerialData;
import ireveal.domain.PVTest;
import ireveal.domain.Product;
import ireveal.domain.ProductSerial;
import ireveal.domain.RoleDsp;
import ireveal.domain.Scaling;
import ireveal.domain.TestData;

import ireveal.domain.TestFrequency;
import ireveal.domain.User;
import ireveal.domain.UserPref;
import ireveal.repository.JdbcAssetTreeDao.RoleMapper;


import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;  
import java.util.Calendar;
import java.util.Date;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;  
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;


public class JdbcMastersDao extends JdbcDaoSupport implements MastersDao {
	int compid=1; 
	public List<AssetTree> getAssetTreeList() {
		List<RoleDsp> rle =getRoleDtls();
		compid=rle.get(0).getCompanyid();
		List<AssetTree> dataList = new ArrayList<AssetTree>();  

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
	public List<User> getUserList() {
		List<RoleDsp> rle =getRoleDtls();
		compid=rle.get(0).getCompanyid();
		logger.info("inside userlist"); 
		List<User> userlist = new ArrayList<User>();  

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
		List<RoleDsp>	roledsp=  getJdbcTemplate().query("select distinct rolename,companyname,nprecision,r.company_id,r.role_id,r.b_reports,r.b_events,r.b_tools,r.b_settings,c.expirydate from fwk_role r inner join  fwk_user_role ur on r.role_id=ur.role_id " +
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

			role.setRole_id(rs.getInt("ROLE_ID"));
			role.setRolename(rs.getString("ROLENAME")); 

			role.setCompany(rs.getString("companyname")); 
			role.setCompanyid(rs.getInt("company_id"));
			role.setExpirydate(rs.getString("expirydate"));
			role.setNprecision(rs.getInt("nprecision"));

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
		String sql = "select case t.frequnit when 'GHz' then frequency/1000 else frequency end frequency, frequency frequencyid,lineargain from testFreq f inner join testdata t on f.test_id=t.test_id  where t.test_id =" + testid;  
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
			testfreq.setFrequencyid(rs.getDouble("Frequencyid"));  
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
				final String  sql = "INSERT INTO testdata(TestName,TestDesc,ProdSerial_id,TestDate,frequnit,testcenter,instruments,calibration,testproc,testtype) VALUES  (?,?,?,?,?,?,?,?,?,?)";    
				KeyHolder keyHolder = new GeneratedKeyHolder();

				final String testname = testdata.getTestname();
				final String testdesc = testdata.getTestdesc();	    
				final int prdserid = testdata.getProductserialid();
				final String testdate=sdf.format(testdata.getDttestdate());
				final String frequnit=testdata.getFrequnit();
				final String testcenter=testdata.getTestcenter();
				final String instruments=testdata.getInstruments();
				final String calibration=testdata.getCalibration();
				final String testproc=testdata.getTestproc();
				final String testtype=testdata.getTesttype();
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
								ps.setString(10, testtype);
								return ps;
							}
						},
						keyHolder);
				testid= keyHolder.getKey().intValue();
				logger.info(" TestData record inserted. Key = "+testid); 

			}
			else{testid=testdata.getTestid();
			}

			String sqlcnt="";
			String sqldelete="";
			// test freq
			String sqltestfreq=	"INSERT INTO testfreq(Test_id,Frequency,lineargain)  VALUES   (?,?,?)";  
			for (int i=0;i<testfreqlist.size();i++){
				int cnt =getJdbcTemplate().queryForObject("select count(*) from testfreq where Test_id=? and Frequency=?",Integer.class,testid,testfreqlist.get(i).getFrequency());
				if(cnt==0){
					logger.info("lg"+testfreqlist.get(i).getLineargain());
					getJdbcTemplate().update(  
							sqltestfreq,  
							new Object[] {testid, testfreqlist.get(i).getFrequency(), testfreqlist.get(i).getLineargain()==0.00?null:testfreqlist.get(i).getLineargain() });
				}
				else{

					// changed for new type CP Phase difference
					logger.info("testdata.getTesttype()="+testdata.getTesttype());
					if(testdata.getTesttype().equals("CPPD")){
						if(testdata.getFiletype().equals("Vdata"))
						{
							sqlcnt="select count(*) from vdata_phase where test_id=? and frequency=?";
							sqldelete="delete from vdata_phase where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("Hdata"))
						{
							sqlcnt="select count(*) from hdata_phase where test_id=? and frequency=?";
							sqldelete="delete from hdata_phase where test_id=? and frequency=?";
						}

					}
					else{
						if(testdata.getFiletype().equals("Vdata"))
						{
							sqlcnt="select count(*) from Vdata where test_id=? and frequency=?";
							sqldelete="delete from vdata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("Hdata"))
						{
							sqlcnt="select count(*) from hdata where test_id=? and frequency=?";
							sqldelete="delete from hdata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("CPdata"))
						{
							sqlcnt="select count(*) from cpdata where test_id=? and frequency=?";
							sqldelete="delete from cpdata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("pitch"))
						{
							sqlcnt="select count(*) from pitchdata where test_id=? and frequency=?";
							sqldelete="delete from pitchdata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("roll"))
						{
							sqlcnt="select count(*) from rolldata where test_id=? and frequency=?";
							sqldelete="delete from rolldata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("yaw"))
						{
							sqlcnt="select count(*) from yawdata where test_id=? and frequency=?";
							sqldelete="delete from yawdata where test_id=? and frequency=?";
						}
						if(testdata.getFiletype().equals("fdata"))
						{
							sqlcnt="select count(*) from fdata where test_id=? and frequency=?";
							sqldelete="delete from fdata where test_id=? and frequency=?";
						}
					}
					int cntfreq=getJdbcTemplate().queryForObject(sqlcnt,Integer.class,testid,testfreqlist.get(i).getFrequency());
					if(cntfreq >0)
					{
						getJdbcTemplate().update(sqldelete,testid,testfreqlist.get(i).getFrequency());
					}
				}

			}

			// datalog
			String sqltest="";
			
			
			if(testdata.getTesttype().equals("CPPD")){
				logger.info("inside CPPD");
				if(testdata.getFiletype().equals("Vdata"))
				{
					logger.info("inside CPPD Vdata");
					sqltest="insert into vdata_phase (test_id,Frequency,Angle,Phaseval) values (?,?,?,?)"; 
				}
				else if(testdata.getFiletype().equals("Hdata"))
				{
					logger.info("inside CPPD Hdata");
					sqltest="insert into hdata_phase (test_id,Frequency,Angle,Phaseval) values (?,?,?,?)"; 
				}
			}
			else{
					if(testdata.getFiletype().equals("Vdata"))
					{
						sqltest="insert into Vdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
					}
					else if(testdata.getFiletype().equals("Hdata"))
					{
						sqltest="insert into Hdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
					}
					else if(testdata.getFiletype().equals("CPdata")){
						sqltest="insert into CPdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 		  	
					}
					else if(testdata.getFiletype().equals("pitch")){
						sqltest="insert into pitchdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 		  	
					}
					else if(testdata.getFiletype().equals("roll")){
						sqltest="insert into rolldata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 		  	
					}
					else if(testdata.getFiletype().equals("yaw")){
						sqltest="insert into yawdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 		  	
					}
					else if(testdata.getFiletype().equals("fdata"))
					{
						sqltest="insert into fdata (test_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 	
					}
			}
			for (int i=0;i<dataloglist.size();i++){	

				getJdbcTemplate().update(  
						sqltest,  
						new Object[] {testid, dataloglist.get(i).getFreq(), dataloglist.get(i).getAngle()==360.00?0:dataloglist.get(i).getAngle(),dataloglist.get(i).getAmplitude() });

			}
			/* if(action.equals("Done"))
	  	{
	  		//CP -WIth CP Conversion
	  		//NCP - no cp conversion
	  		//DCP - direct cp
	  		//A-Azimuth
	  		//E-Elevation

	  		final String ptype = testdata.getPtype();
	  		logger.info("ptype "+ptype);
	  		final String funit = testdata.getFrequnit().equals("MHz")?"M":"G";
	  		//final String funit = "M";
	  		getJdbcTemplate().update("call Calculate_params (?,?)", testid,ptype);

	  	}	*/  	
		}
		catch(Exception e){
			logger.info("Import Test Exception "+e.getMessage());
			return 0;
		}
		return testid;	    
	}

	public int CalcProc(String ptype,int testid)
	{

		final String ptyp = ptype;//testdata.getPtype();
		logger.info("ptype "+ptype);
		//final String funit = testdata.getFrequnit().equals("MHz")?"M":"G";
		//final String funit = "M";
		try{
			getJdbcTemplate().update("call Calculate_params (?,?)", testid,ptyp);
			return 1;
		}
		catch(Exception e)
		{
			logger.info("Import Test Exception "+e.getMessage());
			return 0;
		}

	}

	public int InsertProduct(Product prod) {

		int primaryKey=0;
		try{ 
			final String  sql = "INSERT INTO product(Productname,Version,PType,ImageFileName,prodmodel) VALUES   (?,?,?,?,?)";    
			KeyHolder keyHolder = new GeneratedKeyHolder();

			final String prdname = prod.getProductname();
			final String version = prod.getVersion();	    
			final String ptype = prod.getPtype();
			final String iname = prod.getImagefilename();
			final String prodmodel = prod.getProdmodel();
			getJdbcTemplate().update(
					new PreparedStatementCreator() {
						public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
							PreparedStatement ps =
									connection.prepareStatement(sql, new String[] {"PRODUCT_ID"}); 
							ps.setString(1, prdname);	
							ps.setString(2, version);
							ps.setString(3, ptype);	  
							ps.setString(4, iname);
							ps.setString(5, prodmodel);
							return ps; 
						}
					},
					keyHolder);
			primaryKey= keyHolder.getKey().intValue();
			logger.info(" Product record inserted. Key = "+primaryKey); 	
		}catch(Exception ex){
			logger.info(" Product inserted. Exception = "+ex.getMessage()); 
		}
		return primaryKey;	
	}

	//product
	public List<Product> getProductList() {  
		List<Product> dataList = new ArrayList<Product>();  

		String sql = "select Product_id,version Productname,Version,PType,ImageFileName,prodmodel from product";  

		dataList = getJdbcTemplate().query(sql, new ProductMapper());  
		return dataList;  
	}  

	@Transactional
	public boolean deleteproduct(int id) { 
		String sql = ""; 

		try{

			sql = "delete from scaling where product_id=" + id;  
			getJdbcTemplate().update(sql);

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
			String sql = "UPDATE Product set productname = ?,version = ?,ptype=?,imagefilename=?,prodmodel=? where product_id = ?";  
			getJdbcTemplate().update(  
					sql,  
					new Object[] { prduct.getProductname(), prduct.getVersion(),  prduct.getPtype(),prduct.getImagefilename(),prduct.getProdmodel(),
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
		String sql = "select Product_id,Productname,Version,PType,ImageFileName,prodmodel from product  where Product_id =" + id;  
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
			product.setProdmodel(rs.getString("prodmodel"));
			return product;
		}

	}
	//productSerial
	public int InsertProductSer(ProductSerial prodser) {
		int primaryKey;

		final String  sql = "INSERT INTO product_serial(SerialNo,Product_id,rptheader,rptfooter)  VALUES   (?,?,?,?)";
		KeyHolder keyHolder = new GeneratedKeyHolder();

		final String prdsername = prodser.getProductserial();
		final int prodid = prodser.getProductid();	    
		final String rptheader = prodser.getRptheader();
		final String rptfooter = prodser.getRptfooter();
		getJdbcTemplate().update(
				new PreparedStatementCreator() {
					public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
						PreparedStatement ps =
								connection.prepareStatement(sql, new String[] {"Prodserial_id"}); 
						ps.setString(1, prdsername);	
						ps.setInt(2, prodid);
						ps.setString(3, rptheader);
						ps.setString(4, rptfooter);
						return ps;
					}
				},
				keyHolder);
		primaryKey= keyHolder.getKey().intValue();
		logger.info(" Product Serial record inserted. Key = "+primaryKey); 	       
		return primaryKey;	 	

	}



	public List<ProductSerial> getProductSerList() {  
		List<ProductSerial> dataList = new ArrayList<ProductSerial>();  

		String sql = "select Prodserial_id, S.Product_id ,SerialNo,productname,rptheader,rptfooter from product_serial S inner join product p on s.Product_id=p.Product_id";  

		dataList = getJdbcTemplate().query(sql, new ProductSerMapper());  
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
			String sql = "UPDATE product_serial set SerialNo = ?,product_id = ?,rptheader=?,rptfooter=? where Prodserial_id = ?";  
			getJdbcTemplate().update(  
					sql,  
					new Object[] { prduct.getProductserial(), prduct.getProductid(),  prduct.getRptheader(),prduct.getRptfooter(),  prduct.getProductserialid() }); 


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
		String sql = "select Prodserial_id, S.Product_id ,SerialNo,productname,rptheader,rptfooter from product_serial S inner join product p on s.Product_id=p.Product_id  where Prodserial_id =" + id;  
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
		String sql = " select Prodserial_id , SerialNo from product_serial S inner join product p on s.Product_id=p.Product_id  ";  
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
			product.setRptheader(rs.getString("rptheader"));
			product.setRptfooter(rs.getString("rptfooter"));

			return product;
		}

	}


	@Transactional
	public boolean deleteTestData(int id) { 
		String sql = ""; 

		try{

			//45 Deg. Pol. Aug 11th
			sql = " delete from fcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from fdata where Test_id=" + id;
			getJdbcTemplate().update(sql);


			sql = " delete from arcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from cpcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from hcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from vcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = " delete from pitchcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = " delete from rollcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = " delete from yawcalculated where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from hdata where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from vdata where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from cpdata where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pitchdata where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from rolldata where Test_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from yawdata where Test_id=" + id;
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
			String sql = "UPDATE TestData set testname = ?,testdesc = ?,ProdSerial_id=?,testdate=?,testcenter=?,instruments=?,calibration=?,testproc=? where test_id = ?";  
			getJdbcTemplate().update(  
					sql,  
					new Object[] { testdata.getTestname(), testdata.getTestdesc(),  testdata.getProductserialid(),testdata.getDttestdate(),testdata.getTestcenter(),testdata.getInstruments(),testdata.getCalibration(),testdata.getTestproc(),testdata.getTestid() }); 
			return true;    
		}
		catch(Exception e ){
			logger.info("testdata Update error " +e.getMessage()); 
			return false;
		}
	}		

	public TestData getTestData(int id) {  
		logger.info("***inside testdata** id="+id);
		List<TestData> dataList =new ArrayList<TestData>();
		String sql = "select Test_id,TestName,testdesc,T.ProdSerial_id,TestDate,SerialNo,Productname,Version,frequnit,ptype,testcenter,instruments,calibration,testproc,testtype from testdata t inner join product_serial s on t.Prodserial_id=S.Prodserial_id "+
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
			testdata.setTesttype(rs.getString("testtype"));
			return testdata;
		}

	}

	//update testfreq table with linear gain
	// test freq
	public void UpdateTestFreq(List<TestFrequency> testfreqlist,int testid){
		try{
			String sqltestfreq=	"Update testfreq set lineargain=? where Test_id =? and Frequency=? " ; 
			for (int i=0;i<testfreqlist.size();i++){

				logger.info("lg"+testfreqlist.get(i).getLineargain());
				getJdbcTemplate().update(  
						sqltestfreq,  
						new Object[] { testfreqlist.get(i).getLineargain(),testid,testfreqlist.get(i).getFrequency() });
			}
			getJdbcTemplate().update("call spCalCPGain (?)", testid);
		}
		catch(Exception ep)
		{
			logger.info("Exception in UpdateTestFreq "+ep.getMessage());  
		}

	}

	public String getType(int testid)
	{
		String sql="select count(*) from pitchdata where test_id=?";
		int cnt=getJdbcTemplate().queryForObject(sql,Integer.class,testid);
		if (cnt==0){
			// sql="select count(*) from rawdata where test_id=?";
			//cnt=getJdbcTemplate().queryForObject(sql,testid);
			return "R";
		}
		else 
			return "P";
	}

	public boolean InsertAmpPhase(List<DataLog> datalist,ImportData impdata)
	{
		String sqlinsert="";
		String sqldelete="";
		logger.info(" InsertAmpPhase "+impdata.getFiletype());
		try{
			if(impdata.getFiletype().equals("A"))
			{
				sqldelete="delete from amplitudedata where prodserial_id=? and testname=?";
				getJdbcTemplate().update(sqldelete,impdata.getProductserialid(),impdata.getTestname());  
				sqlinsert="insert into amplitudedata (prodserial_id,Frequency,ampvalue,testname) values (?,?,?,?)"; 
			}
			else if(impdata.getFiletype().equals("P"))
			{
				sqldelete="delete from phasedata where prodserial_id=? and testname=?";
				getJdbcTemplate().update(sqldelete,impdata.getProductserialid(),impdata.getTestname()); 
				sqlinsert="insert into phasedata (prodserial_id,Frequency,phasevalue,testname) values (?,?,?,?)"; 
			}

			for (int i=0;i<datalist.size();i++){	

				getJdbcTemplate().update(  
						sqlinsert,  
						new Object[] {impdata.getProductserialid(), datalist.get(i).getFreq(), datalist.get(i).getAmplitude(), impdata.getTestname()});

			}
			return true;
		}catch(Exception e)
		{
			logger.info("Exception in InsertAmpPhase "+e.getMessage());
			return false;
		}
	}
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public Map<String, Object> GetAmpPhaseValue(String prodserids,String typ) {


		// TO use CallableStatementCreator below is the code
		SqlParameter myProdSerialList = new SqlParameter(Types.VARCHAR);
		SqlParameter amp_or_phase = new SqlParameter(Types.VARCHAR);
		SqlOutParameter maxDiff = new SqlOutParameter("maxDiff", Types.DECIMAL);
		SqlOutParameter maxFreq = new SqlOutParameter("maxFreq", Types.DECIMAL);

		List<SqlParameter> paramList = new ArrayList<SqlParameter>();
		paramList.add(myProdSerialList);
		paramList.add(amp_or_phase);
		paramList.add(maxDiff);
		paramList.add(maxFreq);

		final String procedureCall = "{call calc_tracking(?, ?,?,?)}";
		final String pserids=prodserids;
		final String amporphase=typ;
		Map<String, Object> resultMap = getJdbcTemplate().call(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection connection) throws SQLException {

				CallableStatement callableStatement = connection.prepareCall(procedureCall);
				callableStatement.setString(1, pserids);
				callableStatement.setString(2, amporphase);
				callableStatement.registerOutParameter(3, Types.DECIMAL);
				callableStatement.registerOutParameter(4, Types.DECIMAL);
				return callableStatement;
			}
		}, paramList);
		if(resultMap!=null && resultMap.size()>0 && !resultMap.isEmpty() )
			logger.info("Return out value:"+resultMap.get("maxFreq"));
		return resultMap;

	}

	public TestFrequency calcTrack(String testnames,String typ){

		String sql=" select  (MAX(amplitude)-MIN(amplitude))/2 diff, frequency from vw_ampphase where testname in("+testnames+") and typ='"+typ+"'" +
				" group by frequency order by diff desc LIMIT 1";
		List<TestFrequency> dataList = getJdbcTemplate().query(sql, new trackRowMapper());  
		return dataList.get(0); 
	}

	public static class trackRowMapper implements ParameterizedRowMapper<TestFrequency>{
		public TestFrequency mapRow(ResultSet rs, int rowNum) throws SQLException {
			TestFrequency testfreq = new TestFrequency();
			testfreq.setFrequency(rs.getDouble("frequency"));  
			testfreq.setLineargain(rs.getDouble("diff"));

			return testfreq;
		}
	}

	//Product list for amplitude Phase Tracking report

	public List<Product> getProductWithAmpphase() {  
		List<Product> dataList = new ArrayList<Product>();  

		String sql = "select distinct p.Product_id,Version Productname,Version,PType,ImageFileName from product p inner join product_serial s on p.product_id=s.product_id  where s.prodserial_id in (select prodserial_id from vw_ampphase)";  

		dataList = getJdbcTemplate().query(sql, new ProductMapper());  
		return dataList;  
	}
	//Product list for amplitude Phase Tracking report

	public List<ProductSerial> getProdSerialWithAmpphase(int prdid) {  
		List<ProductSerial> dataList =null;
		String sql = " select Prodserial_id , SerialNo from product_serial S where s.Product_id=? and s.prodserial_id in (select prodserial_id from vw_ampphase) ";  
		try
		{
			dataList = getJdbcTemplate().query(sql, new ProdVerSerMapper(),prdid);

		}
		catch(Exception e)
		{
			logger.info("***Exception** "+ e.getMessage() );
		}
		return dataList;  
	} 


	public String getFreqdatafile(String typ,int testid ){
		String sql="";
		String strfreqs="";
		if(typ.equals("P"))
			sql="select distinct frequency from pitchdata where test_id=?";
		else if(typ.equals("R"))
			sql="select distinct frequency from rolldata where test_id=?";
		else if(typ.equals("Y"))
			sql="select distinct frequency from yawdata where test_id=?";
		else if(typ.equals("C"))
			sql="select distinct frequency from cpdata where test_id=?";
		else if(typ.equals("H"))
			sql="select distinct frequency from hdata where test_id=?";
		else if(typ.equals("V"))
			sql="select distinct frequency from vdata where test_id=?";
		else if(typ.equals("F"))
			sql="select distinct frequency from fdata where test_id=?";

		List<TestFrequency> freqlist=getJdbcTemplate().query(sql, new FreqdatafileMapper(),testid);  
		for (int i=0;i<freqlist.size();i++){
			if(i==0)
			{strfreqs=freqlist.get(i).getFrequency()+"";}
			else {strfreqs=strfreqs+", "+freqlist.get(i).getFrequency();}
		}
		return strfreqs;
	}
	private static class FreqdatafileMapper implements ParameterizedRowMapper<TestFrequency> {

		public TestFrequency mapRow(ResultSet rs, int rowNum) throws SQLException {
			TestFrequency testfreq = new TestFrequency();
			testfreq.setFrequency(rs.getDouble("frequency"));  

			return testfreq;
		}

	}  

	public ProductSerial getheaderfooter(int testid) {  
		List<ProductSerial> ps=new ArrayList<ProductSerial>();
		String sql = "select rptheader,rptfooter from product_serial p inner join testdata t on p.Prodserial_id=t.Prodserial_id "+
				" where t.test_id=?";  
		ps=getJdbcTemplate().query(sql, new rptheaderfooterMapper(),testid);
		if(ps!=null)
			return ps.get(0);
		else
			return null;

	} 
	private static class rptheaderfooterMapper implements ParameterizedRowMapper<ProductSerial> {

		public ProductSerial mapRow(ResultSet rs, int rowNum) throws SQLException {
			ProductSerial prdser = new ProductSerial();
			prdser.setRptheader(rs.getString("rptheader"));  
			prdser.setRptfooter(rs.getString("rptfooter"));
			return prdser;
		}

	}
	public ProductSerial getPSheaderfooter(String psids) {  

		String sql = "select distinct rptheader,rptfooter from product_serial p inner join vw_ampphase v on p.Prodserial_id=v.Prodserial_id"+
				" where v.testname in ("+psids+")";  

		return getJdbcTemplate().query(sql, new rptheaderfooterMapper()).get(0);  

	}
	public List<AmpPhaseTrack> getProdSerTracking(int prodSerid){
		String sql="";
		List<AmpPhaseTrack> strLst=new ArrayList<AmpPhaseTrack>();
		logger.info("JdbcMastersDao inside getProdSerTracking prodSerid "+prodSerid);
		try{
			sql = "SELECT distinct testname,typ,prodserial_id from vw_ampphase where  prodserial_id=? ";
			strLst=	getJdbcTemplate().query(sql, new ProdSerTrackingMapper(),prodSerid); 
		}
		catch(Exception e)
		{  logger.info("*** getProdSerTracking Exception** "+ e.getMessage() );}
		return strLst; 
	}
	private static class ProdSerTrackingMapper implements ParameterizedRowMapper<AmpPhaseTrack> {

		public AmpPhaseTrack mapRow(ResultSet rs, int rowNum) throws SQLException {
			AmpPhaseTrack prdser = new AmpPhaseTrack();
			prdser.setTtype(rs.getString("typ").equals("P")?"Phase":"Amplitude");  
			prdser.setTestname(rs.getString("testname"));
			prdser.setProdserialid(rs.getInt("prodserial_id"));
			return prdser;
		}

	}
	public boolean deleteTracking(int id,String testname,String typ) { 
		String sql = ""; 

		try{
			if(typ.equals("Phase")){

				sql = "delete from phasedata where Prodserial_id=? and testname=?";  }
			else{sql = "delete from amplitudedata where Prodserial_id=? and testname=?";}
			getJdbcTemplate().update(sql,id,testname);

			return true;
		}
		catch(Exception e){
			logger.info("*** deleteTracking Exception** "+ e.getMessage() );
			return false;
		}
	}



	public void UpdateScaling(List<Scaling> scalelist,int prodid){
		try{
			String sqlinsert=	"INSERT INTO scaling(minscale,maxscale,Frequency,product_id)  VALUES   (?,?,?,?)"; 						  	

			String sqlupdate=	"Update scaling set minscale=?,maxscale=? where  Frequency=? and product_id=?" ; 
			for (int i=0;i<scalelist.size();i++){
				int cnt =getJdbcTemplate().queryForObject("select count(*) from scaling where  Frequency=? and product_id=?",Integer.class,scalelist.get(i).getFrequency(),prodid);
				if(cnt==0){
					getJdbcTemplate().update(  
							sqlinsert,  
							new Object[] { scalelist.get(i).getMinscale(),scalelist.get(i).getMaxscale(),scalelist.get(i).getFrequency(),prodid });
				}
				else{
					getJdbcTemplate().update(  
							sqlupdate,  
							new Object[] { scalelist.get(i).getMinscale(),scalelist.get(i).getMaxscale(),scalelist.get(i).getFrequency(),prodid });
				}
			}
		}
		catch(Exception ep)
		{
			logger.info("Exception in UpdateScaling "+ep.getMessage());  
		}

	}


	public List<Scaling> getScaling(int testid){
		String sql="";
		List<Scaling> strLst=new ArrayList<Scaling>();
		logger.info("JdbcMastersDao inside getScaling");
		try{
			sql = "SELECT distinct frequency ,minscale,maxscale,p.product_id from scaling s inner join product_serial p on s.product_id=p.product_id inner join testdata t on p.prodserial_id=t.prodserial_id where t.test_id=?";
			strLst=	getJdbcTemplate().query(sql, new ScalingMapper(),testid); 
		}
		catch(Exception e)
		{  logger.info("*** getScaling Exception** "+ e.getMessage() );}
		return strLst; 
	}
	private static class ScalingMapper implements ParameterizedRowMapper<Scaling> {

		public Scaling mapRow(ResultSet rs, int rowNum) throws SQLException {
			Scaling prdser = new Scaling();
			prdser.setFrequency(rs.getDouble("frequency"));  
			prdser.setMinscale(rs.getDouble("minscale"));
			prdser.setMaxscale(rs.getDouble("maxscale"));
			prdser.setProductid(rs.getInt("product_id"));
			return prdser;
		}

	}
	public int getProductid(int testid){
		int prodid=0;
		try{
			String sql = "select distinct product_id from product_serial p inner join testdata t on p.Prodserial_id=t.ProdSerial_id "+
					"	where t.test_id= ? ";
			prodid=getJdbcTemplate().queryForObject(sql,Integer.class,testid);
		}
		catch(Exception e)
		{  logger.info("*** getScaling Exception** "+ e.getMessage() );}
		return prodid;
	}
	public int getPrecision(){
		int nprecision=1;
		try{
			String sql = "select nprecision from fwk_company where company_id=1 ";
			nprecision=getJdbcTemplate().queryForObject(sql,Integer.class);
		}
		catch(Exception e)
		{  logger.info("*** getPrecision Exception** "+ e.getMessage() );}
		return nprecision;
	}

	public int getproductTestscnt(int prodid)
	{
		int cnt=0;
		String sql = "select count(*) from product_serial p inner join testdata t on p.prodserial_id=t.prodserial_id  where product_id=? ";
		cnt=getJdbcTemplate().queryForObject(sql,Integer.class,prodid);

		return cnt;
	}


	public boolean deletescaling(double freq,int prodid){
		String sql="";
		try{						  					   
			sql = "delete from scaling where Product_id=? and frequency=?";						   
			getJdbcTemplate().update(sql,prodid,freq);			   
			return true;
		}
		catch(Exception e){
			logger.info("*** deletescaling Exception** "+ e.getMessage() );
			return false;
		}					 
	}
	public boolean deletescaleProduct(int prodid){
		String sql="";
		try{						  					   
			sql = "delete from scaling where Product_id=? ";						   
			getJdbcTemplate().update(sql,prodid);			   
			return true;
		}
		catch(Exception e){
			logger.info("*** deletescaleProduct Exception** "+ e.getMessage() );
			return false;
		}					 
	}
	public boolean IsAdminUser(){
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String uname = auth.getName();
		String sql="select count(*) from fwk_user_role r inner join fwk_user u on r.user_id=u.user_id where u.username=? and r.role_id=1 ";
		int cnt= getJdbcTemplate().queryForObject(sql,Integer.class,uname);	
		if(cnt==0)
			return false;
		else
			return true;
	}

	// PV Test Functions 


	public int InsertPVtest(PVTest pvtest) {
		logger.info("Inside InsertPVtest");
		int primaryKey;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		final String  sql = "INSERT INTO pv_testdata(TestName,Product_id,rptheader,rptfooter,TestDesc,TestDate,testcenter,instruments,calibration,testproc,frequnit,testtype,inst_slno,antennaused,otype) VALUES  (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";    

		KeyHolder keyHolder = new GeneratedKeyHolder();
		logger.info("Otype"+pvtest.getOtype());
		final String testname = pvtest.getTestname();
		final int prodid = pvtest.getProductid();	    
		final String rptheader = pvtest.getRptheader();
		final String rptfooter = pvtest.getRptfooter();
		final String testdesc = pvtest.getTestdesc();
		final String testdate=sdf.format(pvtest.getDttestdate());						    
		final String testcenter=pvtest.getTestcenter();
		final String instruments=pvtest.getInstruments();
		final String calibration=pvtest.getCalibration();
		final String testproc=pvtest.getTestproc();
		final String frequnit=pvtest.getFrequnit();
		final String testtype=pvtest.getTesttype();
		final String instslno=pvtest.getInstslno();
		final String antennaused=pvtest.getAntennaused();
		final String otype=pvtest.getOtype();
		getJdbcTemplate().update(
				new PreparedStatementCreator() {
					public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
						PreparedStatement ps =
								connection.prepareStatement(sql, new String[] {"TEST_ID"}); 
						ps.setString(1, testname);	
						ps.setInt(2, prodid);
						ps.setString(3, rptheader);
						ps.setString(4, rptfooter);						  	      
						ps.setString(5, testdesc);					  	             	           
						ps.setString(6, testdate);					  	           
						ps.setString(7, testcenter);
						ps.setString(8, instruments);
						ps.setString(9, calibration);
						ps.setString(10, testproc);
						ps.setString(11, frequnit);
						ps.setString(12,testtype);
						ps.setString(13,instslno);
						ps.setString(14,antennaused);
						ps.setString(15,otype);
						return ps;
					}
				},
				keyHolder);
		primaryKey= keyHolder.getKey().intValue();
		logger.info(" PVTest record inserted. Key = "+primaryKey); 	       
		return primaryKey;	 	

	}



	public List<PVTest> getPVTestList() {  
		List<PVTest> dataList = new ArrayList<PVTest>();  

		String sql = "select test_id, S.Product_id ,productname,TestName,rptheader,rptfooter,TestDesc,TestDate,testcenter,instruments,calibration,testproc,frequnit,testtype,inst_slno,antennaused,otype from PV_TESTDATA S inner join product p on s.Product_id=p.Product_id";  

		dataList = getJdbcTemplate().query(sql, new PVTestMapper());  
		return dataList;  
	}  

	@Transactional
	public boolean deletePVTest(int id) { 
		String sql = ""; 

		try{
			sql = "delete from pv_testdata where test_id=" + id;  
			getJdbcTemplate().update(sql);

			return true;
		}
		catch(Exception e)
		{
			logger.info("PVTest Delete error " +e.getMessage()); 
			return false;
		}

	}


	public boolean UpdatePVTest(PVTest pvtest) {  
		try{
			String sql = "UPDATE PV_TESTDATA set TestName=?,Product_id=?,rptheader=?,rptfooter=?,TestDesc=?,TestDate=?,testcenter=?,instruments=?,calibration=?,testproc=?,frequnit=?,testtype=?,inst_slno=?,antennaused=?,otype=? where test_id = ?";  
			getJdbcTemplate().update(  
					sql,  
					new Object[] { pvtest.getTestname(), pvtest.getProductid(),  pvtest.getRptheader(),pvtest.getRptfooter(),pvtest.getTestdesc(),pvtest.getDttestdate(),pvtest.getTestcenter(),pvtest.getInstruments(),pvtest.getCalibration(),pvtest.getTestproc() , pvtest.getFrequnit(),pvtest.getTesttype(),pvtest.getInstslno(),pvtest.getAntennaused(),pvtest.getOtype(), pvtest.getTestid() }); 


			return true;    
		}
		catch(Exception e ){
			logger.info("PVTest Update error " +e.getMessage()); 
			return false;
		}
	}  


	public PVTest getPVTest(int id) {  
		logger.info("***inside getPVTest** ");
		List<PVTest> dataList =null;
		String sql = "select test_id, S.Product_id ,productname,TestName,rptheader,rptfooter,TestDesc,TestDate,testcenter,instruments,calibration,testproc,frequnit,testtype,inst_slno,antennaused,otype from PV_TESTDATA S inner join product p on s.Product_id=p.Product_id where S.test_id=?";  
		try
		{
			dataList = getJdbcTemplate().query(sql, new PVTestMapper(),id);

		}
		catch(Exception e)
		{
			logger.info("***Exception** "+ e.getMessage() );
		}
		return dataList.get(0);  
	}  


	private static class PVTestMapper implements ParameterizedRowMapper<PVTest> {

		public PVTest mapRow(ResultSet rs, int rowNum) throws SQLException {
			PVTest pvtest = new PVTest(); 
			pvtest.setProductname(rs.getString("productname"));  
			pvtest.setProductid(rs.getInt("Product_id")); 	 
			pvtest.setRptheader(rs.getString("rptheader"));
			pvtest.setRptfooter(rs.getString("rptfooter"));
			pvtest.setTestid(rs.getInt("Test_id"));  
			pvtest.setTestname(rs.getString("testName"));  
			pvtest.setTestdesc(rs.getString("testdesc")); 				    	     	  
			pvtest.setDttestdate(rs.getTimestamp("testdate"));					    	   
			pvtest.setTestcenter(rs.getString("testcenter")); 
			pvtest.setInstruments(rs.getString("instruments")); 
			pvtest.setCalibration(rs.getString("calibration")); 
			pvtest.setTestproc(rs.getString("testproc")); 
			pvtest.setFrequnit(rs.getString("frequnit")); 
			pvtest.setTesttype(rs.getString("testtype")); 
			pvtest.setInstslno(rs.getString("inst_slno")); 
			pvtest.setAntennaused(rs.getString("antennaused")); 
			pvtest.setOtype(rs.getString("otype")); 
			return pvtest;
		}

	}

	// PV Serial 


	@Transactional
	public int insertPVSerialData(PVSerialData testdata,List<TestFrequency> testfreqlist,List<DataLog> dataloglist,String strmode,String action ){
		String datatype=testdata.getDatatype();
		int serialid=0;
		logger.info(" strmode "+strmode);
		try{

			if(strmode.equals("new")){
				final String  sql = "INSERT INTO pv_prodserial(SerialNo,test_id) VALUES  (?,?)";    
				KeyHolder keyHolder = new GeneratedKeyHolder();				    
				final String serial = testdata.getProductserial();					     				    
				final int testid=testdata.getTestid();
				getJdbcTemplate().update(
						new PreparedStatementCreator() {
							public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
								PreparedStatement ps =
										connection.prepareStatement(sql, new String[] {"PRODSERIAL_ID"});

								ps.setString(1, serial);   
								ps.setInt(2, testid);
								return ps;
							}
						},
						keyHolder);
				serialid= keyHolder.getKey().intValue();
				logger.info(" PVSerialData record inserted. Key = "+serialid); 

			}
			else{serialid=testdata.getProductserialid();
			}

			String sqlcnt="";
			String sqldelete="";
			// test freq
			String sqltestfreq=	"INSERT INTO pv_testfreq(test_id,Frequency)  VALUES   (?,?)";  
			for (int i=0;i<testfreqlist.size();i++){
				int cnt =getJdbcTemplate().queryForObject("select count(*) from pv_testfreq where test_id=? and Frequency=?",Integer.class,testdata.getTestid(),testfreqlist.get(i).getFrequency());
				logger.info(" PVSerialData 1");
				if(cnt==0){
					logger.info(" PVSerialData 2");
					getJdbcTemplate().update(  
							sqltestfreq,  
							new Object[] {testdata.getTestid(), testfreqlist.get(i).getFrequency() });
				}
				else
				{
					logger.info(" PVSerialData 3 testdata.getFiletype()"+testdata.getFiletype()+"datatype ="+datatype );

					logger.info(" PVSerialData 3 testdata.getFiletype()"+testdata.getFiletype()+"datatype ="+datatype );	
					if(testdata.getFiletype().equals("V"))
					{
						logger.info(" PVSerialData 4");
						if(datatype.equals("A")){
							sqlcnt="select count(*) from pv_Vdata_Azimuth where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Vdata_Azimuth where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("E")){
							sqlcnt="select count(*) from pv_Vdata_Elevation where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Vdata_Elevation where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("T")){
							sqlcnt="select count(*) from pv_Vdata_GT where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Vdata_GT where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("M")){
							sqlcnt="select count(*) from pv_Vdata_GM where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Vdata_GM where Prodserial_id=? and frequency=? ";
						}		


					}
					if(testdata.getFiletype().equals("H"))
					{
						logger.info(" PVSerialData 5");
						if(datatype.equals("A")){
							sqlcnt="select count(*) from pv_Hdata_Azimuth where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Hdata_Azimuth where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("E")){
							sqlcnt="select count(*) from pv_Hdata_Elevation where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Hdata_Elevation where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("T")){
							sqlcnt="select count(*) from pv_Hdata_GT where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Hdata_GT where Prodserial_id=? and frequency=? ";
						}
						else if(datatype.equals("M")){
							sqlcnt="select count(*) from pv_Hdata_GM where Prodserial_id=? and frequency=? ";
							sqldelete="delete from pv_Hdata_GM where Prodserial_id=? and frequency=? ";
						}
					}
					if(testdata.getFiletype().equals("M"))
					{
						sqlcnt="select count(*) from pv_radata where Prodserial_id=? and frequency=? ";
						sqldelete="delete from pv_radata where Prodserial_id=? and frequency=? ";
					}

					logger.info(" PVSerialData 6 freq"+testfreqlist.get(i).getFrequency()+" datatype="+datatype);
					//logger.info("sqlcnt="+sqlcnt);
					int cntfreq=getJdbcTemplate().queryForObject(sqlcnt,Integer.class,serialid,testfreqlist.get(i).getFrequency());
					logger.info(" PVSerialData 7");
					if(cntfreq >0)
					{
						getJdbcTemplate().update(sqldelete,serialid,testfreqlist.get(i).getFrequency());
					}
				}

			}

			// datalog
			String sqltest="";

			logger.info(" PVSerialData 8 testdata.getFiletype()"+testdata.getFiletype()+"datatype ="+datatype );
			if(testdata.getFiletype().equals("V"))
			{
				if(datatype.equals("A")){
					sqltest="insert into pv_Vdata_Azimuth (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("E")){
					sqltest="insert into pv_Vdata_Elevation (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("T")){
					sqltest="insert into pv_Vdata_GT (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("M")){
					sqltest="insert into pv_Vdata_GM (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}

			}
			else if(testdata.getFiletype().equals("H"))
			{
				if(datatype.equals("A")){
					sqltest="insert into pv_Hdata_Azimuth (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("E")){
					sqltest="insert into pv_Hdata_Elevation (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("T")){
					sqltest="insert into pv_Hdata_GT (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
				else if(datatype.equals("M")){
					sqltest="insert into pv_Hdata_GM (Prodserial_id,Frequency,Angle,Amplitude) values (?,?,?,?)"; 
				}
			}
			else if(testdata.getFiletype().equals("M"))
			{
				sqltest="insert into pv_radata (Prodserial_id,Frequency,RecvdAmp) values (?,?,?)"; 
			}
			logger.info(" PVSerialData 3 sqltest"+sqltest );
			for (int i=0;i<dataloglist.size();i++){	
				if(testdata.getFiletype().equals("M")){
					getJdbcTemplate().update(  
							sqltest,  
							new Object[] {serialid, dataloglist.get(i).getFreq(),dataloglist.get(i).getAmplitude()});

				}
				else{
					getJdbcTemplate().update(  
							sqltest,  
							new Object[] {serialid, dataloglist.get(i).getFreq(), dataloglist.get(i).getAngle()==360.00?0:dataloglist.get(i).getAngle(),dataloglist.get(i).getAmplitude()});
				}
			}
			/* if(action.equals("Done"))
	  	{
	  		//CP -WIth CP Conversion
	  		//NCP - no cp conversion
	  		//DCP - direct cp
	  		//A-Azimuth
	  		//E-Elevation

	  		final String ptype = testdata.getPtype();
	  		logger.info("ptype "+ptype);
	  		final String funit = testdata.getFrequnit().equals("MHz")?"M":"G";
	  		//final String funit = "M";
	  		getJdbcTemplate().update("call Calculate_params (?,?)", testid,ptype);

	  	}	*/  	
		}
		catch(Exception e){
			logger.info("Import PVSerial Exception "+e.getMessage());
			return 0;
		}
		return serialid;	    
	}


	public List<PVSerialData> getPVSerialList(int testid) {  
		List<PVSerialData> dataList = new ArrayList<PVSerialData>();  

		String sql = " select SerialNo,Prodserial_id,s.test_id,testname,frequnit,t.testtype  from pv_prodserial S inner join pv_testdata t on s.test_id=t.test_id where s.test_id=?";  

		dataList = getJdbcTemplate().query(sql, new PVSerialMapper(),testid);  
		return dataList;  
	}
	public PVSerialData getPVSerialData(int serialid) {  
		List<PVSerialData> dataList = new ArrayList<PVSerialData>();  

		String sql = "select SerialNo,Prodserial_id,s.test_id,testname,frequnit,t.testtype  from pv_prodserial S inner join pv_testdata t on s.test_id=t.test_id where prodserial_id=?";  

		dataList = getJdbcTemplate().query(sql, new PVSerialMapper(),serialid);  
		return (PVSerialData) dataList.get(0);  
	}

	private  class PVSerialMapper implements ParameterizedRowMapper<PVSerialData> {

		public PVSerialData mapRow(ResultSet rs, int rowNum) throws SQLException {
			PVSerialData product = new PVSerialData(); 
			product.setProductserial(rs.getString("SerialNo"));  
			product.setProductserialid(rs.getInt("Prodserial_id")); 	
			product.setTestid(rs.getInt("test_id")); 
			product.setTestname(rs.getString("testname")); 
			product.setFrequnit(rs.getString("frequnit")); 
			product.setTesttype(rs.getString("testtype")); 
			product.setCalccnt(calccount(rs.getInt("Prodserial_id"))>0?1:0);
			return product;
		}

	}



	@Transactional
	public boolean deletePVSerial(int id) { 
		String sql = ""; 
		boolean bln=true;
		try{
			sql="select test_id from pv_prodserial where Prodserial_id=?";
			int testid= getJdbcTemplate().queryForObject(sql,Integer.class,id);
			sql = " delete from pv_speccalculated where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = " delete from pv_gmcalculated where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);

			sql = " delete from pv_arcalculated where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_cpcalculated where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_gt_intermediate where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_hdata_azimuth where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_vdata_azimuth where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_cpdata_azimuth where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_hdata_elevation where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_vdata_elevation where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_cpdata_elevation where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_hdata_GT where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_vdata_GT where Prodserial_id=" + id;			   
			getJdbcTemplate().update(sql);
			sql = "delete from pv_hdata_GM where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_vdata_GM where Prodserial_id=" + id;			   
			getJdbcTemplate().update(sql);
			sql = "delete from pv_radata where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_prodserial where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);
			sql = "delete from pv_cpdata_gm where Prodserial_id=" + id;
			getJdbcTemplate().update(sql);

			sql="select count(*) from pv_prodserial where test_id=?";
			int cnt= getJdbcTemplate().queryForObject(sql,Integer.class,testid);
			if(cnt==0){
				sql = "delete from pv_testfreq where test_id=" + testid;
				getJdbcTemplate().update(sql);
			}
		}
		catch(Exception e){
			logger.error("Exception Product serial "+e.getMessage());
			bln=false;
		}

		return bln;
	}

	public String getPVFreqdatafile(String typ,int serialid,String datatype ){
		String sql="";
		String strfreqs="";
		logger.info("typ="+typ+" serialid="+serialid+" datatype="+datatype);
		if(typ.equals("H")){
			if(datatype.equals("A"))
				sql="select distinct frequency from pv_hdata_Azimuth where prodserial_id=? ";
			else if(datatype.equals("E"))
				sql="select distinct frequency from pv_hdata_Elevation where prodserial_id=? ";
			else if(datatype.equals("T"))
				sql="select distinct frequency from pv_hdata_GT where prodserial_id=? ";
			else if(datatype.equals("M"))
				sql="select distinct frequency from pv_hdata_GM where prodserial_id=? ";
		}
		else if(typ.equals("V")){
			if(datatype.equals("A"))
				sql="select distinct frequency from pv_vdata_Azimuth where prodserial_id=? ";
			else if(datatype.equals("E"))
				sql="select distinct frequency from pv_vdata_Elevation where prodserial_id=? ";
			else if(datatype.equals("T"))
				sql="select distinct frequency from pv_vdata_GT where prodserial_id=? ";
			else if(datatype.equals("M"))
				sql="select distinct frequency from pv_vdata_GM where prodserial_id=? ";
		}


		List<TestFrequency> freqlist=getJdbcTemplate().query(sql, new FreqdatafileMapper(),serialid);  
		for (int i=0;i<freqlist.size();i++){
			if(i==0)
			{strfreqs=freqlist.get(i).getFrequency()+"";}
			else {strfreqs=strfreqs+", "+freqlist.get(i).getFrequency();}
		}
		return strfreqs;
	}
	public String getPVFreqdataGM(int serialid){
		String sql="";
		String strfreqs="";

		sql="select distinct frequency from pv_radata where prodserial_id=? ";

		List<TestFrequency> freqlist=getJdbcTemplate().query(sql, new FreqdatafileMapper(),serialid);  
		for (int i=0;i<freqlist.size();i++){
			if(i==0)
			{strfreqs=freqlist.get(i).getFrequency()+"";}
			else {strfreqs=strfreqs+", "+freqlist.get(i).getFrequency();}
		}
		return strfreqs;
	} 
	public List<TestFrequency> getPVFreqList(int testid){

		logger.info("***inside getPVFreqList** ");
		List<TestFrequency> dataList =null;
		String sql = "select case t.frequnit when 'GHz' then frequency/1000 else frequency end frequency, frequency frequencyid,0.00 lineargain from pv_testFreq f inner join pv_testdata t on f.test_id=t.test_id  where t.test_id =" + testid;  
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

	//Gain od STD Horn



	public void UpdateGainSTD(List<GainSTDHorn> scalelist,int testid){
		try{
			String sqlinsert=	"INSERT INTO pv_GainSTDHorn(stdhorn,Frequency,test_id)  VALUES   (?,?,?)"; 						  	

			String sqlupdate=	"Update pv_GainSTDHorn set stdhorn=? where  Frequency=? and test_id=?" ; 
			for (int i=0;i<scalelist.size();i++){
				int cnt =getJdbcTemplate().queryForObject("select count(*) from pv_GainSTDHorn where  Frequency=? and test_id=?",Integer.class,scalelist.get(i).getFrequency(),testid);
				if(cnt==0){
					getJdbcTemplate().update(  
							sqlinsert,  
							new Object[] { scalelist.get(i).getStdhorn(),scalelist.get(i).getFrequency(),testid });
				}
				else{
					getJdbcTemplate().update(  
							sqlupdate,  
							new Object[] { scalelist.get(i).getStdhorn(),scalelist.get(i).getFrequency(),testid });
				}
			}
		}
		catch(Exception ep)
		{
			logger.info("Exception in UpdateSTDHorn "+ep.getMessage());  
		}

	}


	public List<GainSTDHorn> getGainSTD(int testid){
		String sql="";
		List<GainSTDHorn> strLst=new ArrayList<GainSTDHorn>();
		logger.info("JdbcMastersDao inside getGainSTD testid="+testid);
		try{
			sql = "SELECT distinct frequency ,stdhorn,test_id from pv_GainSTDHorn s  where s.test_id=? "+
					" union SELECT distinct frequency ,0.0 stdhorn,test_id from pv_testfreq s  where s.test_id=? and frequency not in (select frequency from pv_GainSTDHorn where test_id=?) ";
			strLst=	getJdbcTemplate().query(sql, new GainSTDMapper(),testid,testid,testid); 
		}
		catch(Exception e)
		{  logger.info("*** getStdhorn Exception** "+ e.getMessage() );}
		return strLst; 
	}
	private static class GainSTDMapper implements ParameterizedRowMapper<GainSTDHorn> {

		public GainSTDHorn mapRow(ResultSet rs, int rowNum) throws SQLException {
			GainSTDHorn prdser = new GainSTDHorn();
			prdser.setFrequency(rs.getDouble("frequency"));  
			prdser.setStdhorn(rs.getDouble("stdhorn"));
			prdser.setTestid(rs.getInt("test_id"));
			//prdser.setMaxscale(rs.getDouble("maxscale"));
			//prdser.setProductid(rs.getInt("product_id"));
			return prdser;
		}

	}

	public int insertRASTDHorn(PVSerialData testdata,List<TestFrequency> rastdlist,String strmode) {

		int serialid=0;
		logger.info(" strmode "+strmode);
		try
		{

			if(strmode.equals("new")){
				final String  sql = "INSERT INTO pv_prodserial(SerialNo,test_id) VALUES  (?,?)";    
				KeyHolder keyHolder = new GeneratedKeyHolder();				    
				final String serial = testdata.getProductserial();					     				    
				final int testid=testdata.getTestid();
				getJdbcTemplate().update(
						new PreparedStatementCreator() {
							public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
								PreparedStatement ps =
										connection.prepareStatement(sql, new String[] {"PRODSERIAL_ID"});

								ps.setString(1, serial);   
								ps.setInt(2, testid);
								return ps;
							}
						},
						keyHolder);
				serialid= keyHolder.getKey().intValue();
				logger.info(" PVSerialData record inserted. Key = "+serialid); 

				testdata.setProductserialid(serialid);
			}
			else{
				serialid=testdata.getProductserialid();


			}
			try{

				String sqlsavetags = "INSERT INTO pv_radata (Prodserial_id,Frequency,RecvdAmp) VALUES (?,?,?)";
				String sqltestfreq=	"INSERT INTO pv_testfreq(test_id,Frequency)  VALUES   (?,?)"; 
				for(int i=0;i<rastdlist.size();i++)
				{	
					getJdbcTemplate().update(sqlsavetags, serialid, rastdlist.get(i).getFrequency(), rastdlist.get(i).getLineargain());

					int cnt =getJdbcTemplate().queryForObject("select count(*) from pv_testfreq where test_id=? and Frequency=?",Integer.class,testdata.getTestid(),rastdlist.get(i).getFrequency());
					//logger.info(" PVSerialData 1");
					if(cnt==0){
						//	logger.info(" PVSerialData 2");
						getJdbcTemplate().update(  
								sqltestfreq,  
								new Object[] {testdata.getTestid(), rastdlist.get(i).getFrequency() });
					}
				}

			}
			catch(Exception e){

			}
		}
		catch(Exception ep){}
		return serialid;

	}

	public int PV_CalcProc(int testid,int serialid)
	{
		logger.info("inside PV_CalcProc testid="+testid+" serialid="+serialid);
		try{

			getJdbcTemplate().update("call pv_Calculate_params (?,?,?)", testid,"PV",serialid);

			return 1;
		}
		catch(Exception e)
		{
			logger.info("PV_CalcProc Exception "+e.getMessage());
			return 0;
		}

	}
	public int PV_CalcProcSum(int testid)
	{
		String sql="select testtype from pv_testdata where test_id=?";

		try{
			String testtype=getJdbcTemplate().queryForObject(sql, String.class,testid);
			if(testtype.equals("GT")){
				getJdbcTemplate().update("call pv_calc_gtcalculated (?)", testid);
			}
			else if(testtype.equals("CO")){
				getJdbcTemplate().update("call pv_calc_spec (?)", testid);}
			return 1;
		}
		catch(Exception e)
		{
			logger.info("PV_CalcProc Exception "+e.getMessage());
			return 0;
		}

	}
	public int PV_serialcount(int testid){
		String sql="select count(*) from pv_prodserial where test_id=?";
		int cnt=0;
		try{
			cnt=getJdbcTemplate().queryForObject(sql, Integer.class,testid);	
		}
		catch(Exception e)
		{
			logger.info("PV_serialcount Exception "+e.getMessage());
		}
		return cnt;
	}
	public  int calccount(int serialno){
		logger.info("inside calccount serialno="+serialno); 
		int cnt=0;
		String sql="select count(*) from pv_cpcalculated where prodserial_id=?";
		cnt=getJdbcTemplate().queryForObject(sql, Integer.class,serialno);
		if(cnt==0){
			sql=" select count(*) from pv_gmcalculated where prodserial_id=? ";
			cnt=getJdbcTemplate().queryForObject(sql, Integer.class,serialno);
		}
		if(cnt==0){
			sql=" select count(*) from pv_gt_intermediate where prodserial_id=? ";
			cnt=getJdbcTemplate().queryForObject(sql, Integer.class,serialno);
		}

		return cnt;
	}
	public  int checkGainSTD(int testid){
		logger.info("inside checkGainSTD testid="+testid); 
		int cnt=0;
		String sql="select count(*) from pv_gainstdhorn where test_id=?";
		cnt=getJdbcTemplate().queryForObject(sql, Integer.class,testid); 
		return cnt;
	}
}




