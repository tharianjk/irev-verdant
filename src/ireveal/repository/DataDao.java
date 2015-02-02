package ireveal.repository;

import ireveal.domain.ProductSerial;



import java.util.List;



public interface  DataDao {
	public List<ProductSerial> getDWProductSerial(String prodid,String typ);
	public List<String> getDWTestNames(String prodSerid,String typ);

	
}
