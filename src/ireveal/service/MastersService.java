package ireveal.service;

import java.util.Date;
import java.util.List;  








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
		
		
		public int insertTestData(TestData testdata,List<TestFrequency> testfreqlist,List<DataLog> datalogvdata,List<DataLog> dataloghdata,String strmode,String action );
		
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
		 

		 
} 