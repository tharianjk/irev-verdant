package ireveal.service;
import java.util.Date;
import java.util.List;
import java.util.Map;

import ireveal.repository.MastersDao;
import ireveal.domain.AmpPhaseTrack;
import ireveal.domain.AssetTree;
import ireveal.domain.Company;
import ireveal.domain.DataLog;
import ireveal.domain.ImportData;
import ireveal.domain.Operator;
import ireveal.domain.PVSerialData;
import ireveal.domain.PVTest;
import ireveal.domain.Product;
import ireveal.domain.ProductSerial;
import ireveal.domain.RoleDsp;
import ireveal.domain.Scaling;
import ireveal.domain.TestData;
import ireveal.domain.TestFiles;
import ireveal.domain.TestFrequency;
import ireveal.domain.User;
import ireveal.domain.UserPref;




public class MastersImpl implements MastersService {

	 
 MastersDao mastersdao;


public void setMastersDao(MastersDao mastersDao) {
    this.mastersdao = mastersDao;
}
public MastersDao getMastersDao() {
	return mastersdao;
}
@Override
public List<AssetTree> getAssetTreeList() {
	return mastersdao.getAssetTreeList();
}
@Override
public List<Operator> getOpeListTag() {
	return mastersdao.getOpeListTag();
}

@Override
public List<UserPref> getUserFav(){
	return mastersdao.getUserFav();
}


@Override
public List<RoleDsp> getRoleDtls() {
	return mastersdao.getRoleDtls();
}



public boolean updateUserLogin(String uname){
	return mastersdao.updateUserLogin(uname);
}

@Override
public List<RoleDsp> getLogUserRole() {
	return mastersdao.getLogUserRole();
}
@Override
public int InsertProduct(Product prod) {
	return mastersdao.InsertProduct(prod);
}

@Override
public Product getProduct(int id) {
	return mastersdao.getProduct(id);
}
@Override
public boolean updateProduct(Product prduct) {
	return mastersdao.updateProduct(prduct);
}
@Override
public boolean deleteproduct(int id) {
	return mastersdao.deleteproduct(id);
}
@Override
public List<Product> getProductList() {
	return mastersdao.getProductList();
}
@Override
public int InsertProductSer(ProductSerial prodser) {
	return mastersdao.InsertProductSer(prodser);
}
@Override
public List<ProductSerial> getProductSerList() {
	return mastersdao.getProductSerList();
}
@Override
public boolean updateProductSer(ProductSerial prduct) {
	return mastersdao.updateProductSer(prduct);
}
@Override
public ProductSerial getProductSer(int id) {
	return mastersdao.getProductSer(id);
}

@Override
public boolean deleteTestData(int id) {
	return mastersdao.deleteTestData( id);
}
@Override
public boolean updateTestData(TestData testdata) {
	return mastersdao.updateTestData(testdata);
}
@Override
public TestData getTestData(int id) {
	return mastersdao.getTestData(id);
}

@Override
public List<ProductSerial> getProdVerSer() {
	return mastersdao.getProdVerSer();
}
@Override
public int insertTestData(TestData testdata, List<TestFrequency> testfreqlist,
		List<DataLog> dataloglist,String strmode,String action) {
	return mastersdao.insertTestData(testdata, testfreqlist, dataloglist, strmode,action);
}

@Override
public List<TestFrequency> getFreqList(int testid) {
	return mastersdao.getFreqList(testid);
}
@Override
public boolean deleteproductser(int id) {
	return mastersdao.deleteproductser(id);
}
@Override
public void UpdateTestFreq(List<TestFrequency> testfreqlist,int testid) {
	 mastersdao.UpdateTestFreq( testfreqlist,testid );
	
}
@Override
public String getType(int testid) {
	return mastersdao.getType(testid);
}
@Override
public boolean InsertAmpPhase(List<DataLog> datalist, ImportData impdata) {
	return mastersdao.InsertAmpPhase(datalist,impdata);
}
@Override
public Map<String, Object> GetAmpPhaseValue(String prodserids, String typ) {
	return mastersdao.GetAmpPhaseValue(prodserids,typ);
}
@Override
public List<Product> getProductWithAmpphase() {
	return mastersdao.getProductWithAmpphase();
}
@Override
public String getFreqdatafile(String typ, int testid) {
	return mastersdao.getFreqdatafile(typ,testid);
}
@Override
public ProductSerial getheaderfooter(int testid) {
	return mastersdao.getheaderfooter(testid);
}
@Override
public ProductSerial getPSheaderfooter(String psids) {
	return mastersdao.getPSheaderfooter(psids);
}
@Override
public List<ProductSerial> getProdSerialWithAmpphase(int prdid) {
	return mastersdao.getProdSerialWithAmpphase(prdid);
}
@Override
public List<AmpPhaseTrack> getProdSerTracking(int prodSerid) {
	return mastersdao.getProdSerTracking(prodSerid);
}
@Override
public boolean deleteTracking(int id, String testname, String typ) {
	return mastersdao.deleteTracking(id,testname,typ);
}
@Override
public List<Scaling> getScaling(int testid) {
	return mastersdao.getScaling(testid);
}
@Override
public void UpdateScaling(List<Scaling> scalelist,int prodid) {
	 mastersdao.UpdateScaling(scalelist,prodid);
	
}
@Override
public TestFrequency calcTrack(String testnames, String typ) {
	return mastersdao.calcTrack(testnames,typ);
}
@Override
public int getProductid(int testid) {
	return mastersdao.getProductid(testid);
}
@Override
public int getPrecision() {
	return mastersdao.getPrecision();
}
@Override
public int CalcProc(String ptype, int testid) {
	return mastersdao.CalcProc(ptype,testid);
}
@Override
public int getproductTestscnt(int prodid) {
	return mastersdao.getproductTestscnt(prodid);
}
@Override
public boolean deletescaling(double freq, int prodid) {
	return mastersdao.deletescaling(freq,prodid);
}
@Override
public boolean deletescaleProduct(int prodid) {
	return mastersdao.deletescaleProduct(prodid);
}
@Override

public boolean IsAdminUser() {
	return mastersdao.IsAdminUser();
}
public int InsertPVtest(PVTest pvtest) {
	return mastersdao.InsertPVtest( pvtest);
}
@Override
public boolean UpdatePVTest(PVTest pvtest) {
	return mastersdao.UpdatePVTest( pvtest);
}
@Override
public boolean deletePVTest(int id) {
	return mastersdao.deletePVTest( id);
}
@Override
public List<PVTest> getPVTestList() {
	return mastersdao.getPVTestList();
}
@Override
public PVTest getPVTest(int id) {
	return mastersdao.getPVTest( id);
}
@Override
public List<PVSerialData> getPVSerialList(int testid) {
	return mastersdao.getPVSerialList(testid);

}
@Override
public int insertPVSerialData(PVSerialData testdata,
		List<TestFrequency> testfreqlist, List<DataLog> dataloglist,
		String strmode, String testtype) {
	return mastersdao.insertPVSerialData( testdata,testfreqlist,dataloglist, strmode,  testtype);
}
@Override
public PVSerialData getPVSerialData(int serialid) {
	return mastersdao.getPVSerialData(serialid);
}
@Override
public String getPVFreqdatafile(String typ, int serialid, String testtype) {
	return mastersdao.getPVFreqdatafile(typ,serialid,testtype);
}
@Override
public List<TestFrequency> getPVFreqList(int testid) {
	return mastersdao.getPVFreqList(testid);
}



}

