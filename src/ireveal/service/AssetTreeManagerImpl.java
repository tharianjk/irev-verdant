package ireveal.service;


import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ireveal.domain.AssetTree;
import ireveal.repository.AssetTreeDao;


@SuppressWarnings({ "deprecation", "serial" })
public class AssetTreeManagerImpl implements AssetTreeManager {

	
	protected final Log logger = LogFactory.getLog(getClass());
    private AssetTreeDao assetTreeDao;
    
    public String sbAssetName() {
        return assetTreeDao.sbAssetName();
    }
    public List<AssetTree> getAssetList() {
//      return users;
  	 return assetTreeDao.getAssetList();
  }
    
    public void setAssetTreeDao(AssetTreeDao assetTreeDao) {
        this.assetTreeDao = assetTreeDao;
    }
    public AssetTreeDao getAssetTreeDao() {
    	return assetTreeDao;
    }
   
   
    public AssetTree getAsset(String assetname){
    	logger.info("came to getAssetDetails for assetname:"+assetname);
    	List<AssetTree> assetlist = assetTreeDao.getAssetList();
    	for (AssetTree asset : assetlist){
    		if (asset.getAssetname().equals(assetname)){
    			return asset;
    		}
    	}
    	logger.info("** could not find asset !!");
    	return null;
    }    
}