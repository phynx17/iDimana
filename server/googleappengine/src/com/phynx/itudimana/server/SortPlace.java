package com.phynx.itudimana.server;

import java.text.Collator;
import java.util.Comparator;

import com.phynx.itudimana.client.vo.Place;

/**
 * A default comparator class for Place
 * 
 * @author Pandu Pradhana
 * @version 1.0
 */
final class SortPlace implements Comparator<Place> {

	/*
	 * (non-Javadoc)
	 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
	 */
	public int compare(Place o1, Place o2) {
		if (o1 != null && o2 != null) {
			String _1 = o1.getName();
			String _2 = o2.getName();
			return Collator.getInstance().compare(_1,_2);
		}
		return 0;
	}

}
