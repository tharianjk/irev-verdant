package ireveal.service;


import java.io.Serializable;
import java.util.List;

import ireveal.domain.AssetTree;

public interface AssetTreeManager extends Serializable{

      
    public List<AssetTree> getAssetList();   
    public String sbAssetName();
    
    //public AssetTree getAssetTree();
    
  //  public void setAssetTree(AssetTree assettree);
    
}

