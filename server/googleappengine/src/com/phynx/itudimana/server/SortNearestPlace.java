package com.phynx.itudimana.server;

import java.util.Comparator;

import com.phynx.itudimana.client.vo.Place;

/**
 * A default comparator class for Nearest Place
 * 
 * @author Pandu Pradhana
 * @version 1.0
 */
final class SortNearestPlace implements Comparator<Place> {

	private Place place;
	
	/**
	 * Constructor
	 * @param aplace aplace 
	 */
	SortNearestPlace(Place aplace) {
		place = aplace;
	}

	
	public int compare(Place o1, Place o2) {
		if (o1 != null && o2 != null) {
			double _1 = o1.getGpsloclat() - place.getGpsloclat();
			double _2 = o1.getGpsloclon() - place.getGpsloclat();
			return (int) Math.abs((_1 + _2));
		}
		return 0;
	}

}
