package ireveal.repository;
import ireveal.domain.ProductSerial;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.ParameterizedRowMapper;



public class JdbcDataDao implements DataDao {
	private DataSource dataSource;
	protected final Log logger = LogFactory.getLog(getClass());
	private JdbcTemplate jdbcTemplate;
	
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
		this.jdbcTemplate = new JdbcTemplate(this.dataSource);
	}
	
	
	public List<ProductSerial> getDWProductSerial(String prodid){
		String sql="";
		logger.info("JdbcDataDao inside getDWProductSerial prodid "+prodid);
		
	      sql = "SELECT distinct T.ProdSerial_ID, Serialno "+
	  		  						" FROM product_serial T WHERE product_id ="+prodid + " and t.prodserial_id in (select prodserial_id from vw_ampphase) ";
		
	    List<ProductSerial> prodser = jdbcTemplate.query(sql, new ProdSerMapper());
	  
		return prodser; 
	}
	private static class ProdSerMapper implements ParameterizedRowMapper<ProductSerial> {  	
	    public ProductSerial mapRow(ResultSet rs, int rowNum) throws SQLException {
	    	ProductSerial prodser = new ProductSerial();
	    	prodser.setProductserialid(rs.getInt("ProdSerial_ID"));                 
	    	prodser.setProductserial(rs.getString("Serialno")); 
	        
	        return prodser;
	    }
	} 

}
