package com.phynx.itudimana.server.dto;

import java.util.ArrayList;
import java.util.List;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.phynx.itudimana.client.vo.Place;

/**
 * Persistent object in the server side
 * 
 * @author Pandu Pradhana
 * 
 */
@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class SavedPlace {
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Long id;

	@Persistent
	private Double gpsloclat;

	@Persistent
	private Double gpsloclon;

	@Persistent
	private String name;

	@Persistent
	private String category;

	@Persistent
	private String notes;

	@Persistent
	private List<String> tags = new ArrayList<String>();

	/**
	 * Empty constructor
	 */
	public SavedPlace() {
	}
	
	/**
	 * Constructor with given place
	 * @param aplace
	 */
	public SavedPlace(Place aplace) {
		setPlace(aplace);
	}

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

	public void addTag(String tag) {
		this.tags.add(tag);
	}

	public void addTags(List<String> atag) {
		this.tags.addAll(atag);
	}

	public void setTags(List<String> atags) {
		tags = atags;
	}
	
	public List<String> getTags() {
		return tags;
	}
	
	/**
	 * Set place
	 * @param aplace
	 */
	public void setPlace(Place aplace) {
		if (aplace == null) {
			throw new IllegalArgumentException("Place cannot null");
		}
		setId(aplace.getId());		
		setName(aplace.getName());
		setNotes(aplace.getNotes());
		setGpsloclat(aplace.getGpsloclat());
		setGpsloclon(aplace.getGpsloclon());
		setCategory(aplace.getCategory());
		
	}
	

	/*
	 * (non-Javadoc)
	 * 
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
		bu.append("\nTags = ").append(getTags());
		return bu.toString();
	}

}
