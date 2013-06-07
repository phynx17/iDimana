package com.phynx.itudimana.client.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * Holds information of query result. Made specific for JDO Query
 * 
 * @author Pandu Pradhana
 *
 */
public class QueryResult implements IsSerializable, Serializable {

	/**
	 * Generated serial version UID
	 */
	private static final long serialVersionUID = 8150607193800854179L;
	private long totalRow;
	private List<Place> places;
	
	/**
	 * Really its a MUST for GWT compiler
	 */
	public QueryResult(){}
	
	public QueryResult(long aTotalRow, List<Place> aPlaces) {
		totalRow = aTotalRow;
		if (aPlaces == null) {
			throw new IllegalArgumentException("List of data cannot be null");
		}
		//We created new list here, to make sure 
		//aPlaces is detached
		places = new ArrayList<Place>(aPlaces);
	}

	public long getTotalRow() {
		return totalRow;
	}

	public void setTotalRow(long totalRow) {
		this.totalRow = totalRow;
	}

	public List<Place> getPlaces() {
		return places;
	}

	public void setPlaces(List<Place> places) {
		this.places = places;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((places == null) ? 0 : places.hashCode());
		result = prime * result + (int)totalRow;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		QueryResult other = (QueryResult) obj;
		if (places == null) {
			if (other.places != null)
				return false;
		} else if (!places.equals(other.places))
			return false;
		if (totalRow != other.totalRow)
			return false;
		return true;
	}
	
	
}
