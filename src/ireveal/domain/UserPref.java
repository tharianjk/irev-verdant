package ireveal.domain;

import java.io.Serializable;

public class UserPref implements Serializable {

	private int user_id;
    private String username;
   
    private String favoperation;
   
    private String showtip;
    
    
	public String getShowtip() {
		return showtip;
	}
	public void setShowtip(String showtip) {
		this.showtip = showtip;
	}
	
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getFavoperation() {
		return favoperation;
	}
	public void setFavoperation(String favoperation) {
		this.favoperation = favoperation;
	}
	}