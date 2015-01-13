package ireveal.service;
import java.util.Date;
import java.util.List;

import ireveal.repository.MastersDao;
import ireveal.domain.AssetTree;
import ireveal.domain.Company;
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
public int insertTestData(TestData testdata,List<TestFrequency> testfreqlist,List<DataLog> datalogvdata,List<DataLog> dataloghdata,String strmode,String action ) {
	return mastersdao.insertTestData(testdata, testfreqlist,datalogvdata, dataloghdata, strmode,action);
}

@Override
public List<TestFrequency> getFreqList(int testid) {
	return mastersdao.getFreqList(testid);
}
@Override
public boolean deleteproductser(int id) {
	return mastersdao.deleteproductser(id);
}


}

