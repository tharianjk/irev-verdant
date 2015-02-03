package ireveal.repository;
import ireveal.domain.AmpPhaseTrack;
import ireveal.domain.AssetTree;
import ireveal.domain.DataLog;
import ireveal.domain.ImportData;
import ireveal.domain.Product;
import ireveal.domain.ProductSerial;
import ireveal.domain.RoleDsp;
import ireveal.domain.Operator;
import ireveal.domain.Scaling;
import ireveal.domain.TestData;
import ireveal.domain.TestFiles;
import ireveal.domain.TestFrequency;
import ireveal.domain.UserPref;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;












import java.util.Map;

import ireveal.domain.User;

public interface MastersDao { 
	public List<RoleDsp> getRoleDtls();
	public List<AssetTree> getAssetTreeList();	
	public List<Operator> getOpeListTag();
   
    public List<UserPref> getUserFav();
    
    public List<User> getUserList();    
    
    
	// To update lastLogin date of User
	public boolean updateUserLogin(String uname);	
	
	
	public List<RoleDsp> getLogUserRole();
	public int InsertProduct(Product prod);
	public Product getProduct(int id);
	public boolean updateProduct(Product prduct);
	public boolean deleteproduct(int id);
	public List<Product> getProductList();
	
	public int insertTestData(TestData testdata,List<TestFrequency> testfreqlist,List<DataLog> dataloglist,String strmode,String action);
	
	public List<TestFrequency> getFreqList(int testid);
	 //product serial
	 public int InsertProductSer(ProductSerial prodser);
	 public List<ProductSerial> getProductSerList();
	 public boolean updateProductSer(ProductSerial prduct);
	 public ProductSerial getProductSer(int id);
	 public List<ProductSerial> getProdVerSer();
	 public boolean deleteproductser(int id);
	 //testdata
	 
	 public boolean deleteTestData(int id);
	 public boolean updateTestData(TestData testdata);
	 public TestData getTestData(int id);
	 public void UpdateTestFreq(List<TestFrequency> testfreqlist,int testid);
	 
	 public String getType(int testid);
	 public boolean InsertAmpPhase(List<DataLog> datalist,ImportData impdata);
	 public Map<String, Object> GetAmpPhaseValue(String prodserids,String typ);
	 public List<Product> getProductWithAmpphase();
	 public String getFreqdatafile(String typ,int testid );
	 public ProductSerial getheaderfooter(int testid);
	 public ProductSerial getPSheaderfooter(String psids);
	 public List<ProductSerial> getProdSerialWithAmpphase(int prdid);
	 public List<AmpPhaseTrack> getProdSerTracking(int prodSerid);
	 public boolean deleteTracking(int id,String testname,String typ);
	 public List<Scaling> getScaling(int testid);
	 public void UpdateScaling(List<Scaling> scalelist,int prodid);
	 public TestFrequency calcTrack(String testnames,String typ);
	 public int getProductid(int testid);
	 public int getPrecision();
}
