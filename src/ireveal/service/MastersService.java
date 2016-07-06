package ireveal.service;

import java.util.List;  

import java.util.Map;

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
import ireveal.domain.UserPref;

public interface MastersService { 
	public List<RoleDsp> getRoleDtls();
	public List<AssetTree> getAssetTreeList();
	public List<Operator> getOpeListTag();
	
	public List<UserPref> getUserFav();
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
		 public int CalcProc(String ptype,int testid);
		 public int getproductTestscnt(int prodid);
		 public boolean deletescaling(double freq,int prodid);
		 public boolean deletescaleProduct(int prodid);

		 public boolean IsAdminUser();

		 // PVTest
		 public int InsertPVtest(PVTest pvtest);
		 public boolean UpdatePVTest(PVTest pvtest);
		 public boolean deletePVTest(int id);
		 public List<PVTest> getPVTestList();
		 public PVTest getPVTest(int id);
		 public List<PVSerialData> getPVSerialList(int testid);
// PV Serial
		 public int insertPVSerialData(PVSerialData testdata,List<TestFrequency> testfreqlist,List<DataLog> dataloglist,String strmode,String testtype );
		 public PVSerialData getPVSerialData(int serialid);
		 public String getPVFreqdatafile(String typ,int serialid,String datatype );
		 public List<TestFrequency> getPVFreqList(int testid);
		 public void UpdateGainSTD(List<GainSTDHorn> scalelist,int testid);
		 public List<GainSTDHorn> getGainSTD(int testid);
		 public int insertRASTDHorn(PVSerialData testdata,List<TestFrequency> rastdlist,String strmode) ;
		 public String getPVFreqdataGM(int serialid);
		 public boolean deletePVSerial(int id);
		 public int PV_CalcProc(int testid,int serialid);
		 public int PV_serialcount(int testid);
		 public int PV_CalcProcSum(int testid);
		 public  int checkGainSTD(int testid);
} 