package ireveal.repository;

import ireveal.domain.AssetTree;
import ireveal.domain.RoleDsp;

import java.util.List;

public interface AssetTreeDao {

	 public List<RoleDsp> getRoleDtls();    
    public List<AssetTree> getAssetList();
    public String sbAssetName();
   // public AssetTree getAsset(String assetname);
    
}
