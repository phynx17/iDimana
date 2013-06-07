package com.phynx.itudimana.client.vo;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * <p>A class that holds places information, specific to GWT 
 * 
 * @author Pandu Pradhana
 * @version 1.0
 * @see com.phynx.itudimana.server.dto.SavedPlace
 */
public class Place implements IsSerializable {

	private Long id;
    private Double gpsloclat;
    private Double gpsloclon;
    private String name;
    private String category;
    private String notes;
    
    
    /**
     * Empty constructor
     */
    public Place() {}


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public Double getGpsloclat() {
		return gpsloclat;
	}


	public void setGpsloclat(Double gpsloclat) {
		this.gpsloclat = gpsloclat;
	}


	public Double getGpsloclon() {
		return gpsloclon;
	}


	public void setGpsloclon(Double gpsloclon) {
		this.gpsloclon = gpsloclon;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getCategory() {
		return category;
	}


	public void setCategory(String category) {
		this.category = category;
	}


	public String getNotes() {
		return notes;
	}


	public void setNotes(String notes) {
		this.notes = notes;
	}
	
    
	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		StringBuffer bu = new StringBuffer("Place: (Id:");
		bu.append(getId()).append(")");
		bu.append("\nGPS Loc: (lat) = ").append(getGpsloclat());
		bu.append(", (lon) = ").append(getGpsloclon());
		bu.append("\nName = ").append(getName());
		bu.append("\nCategory = ").append(getCategory());
		bu.append("\nNotes = ").append(getNotes());
		return bu.toString();
	}
	
}
