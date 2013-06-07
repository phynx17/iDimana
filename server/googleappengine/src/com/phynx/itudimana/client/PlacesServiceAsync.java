package com.phynx.itudimana.client;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

/**
 * The async counterpart of <code>GreetingService</code>.
 */
public interface PlacesServiceAsync {
	
	/**
	 * Put a new place 
	 * @param aPlace some place. Definitely cannot be null
	 */
	void putPlace(Place aPlace, AsyncCallback<Place> callback);
	
	/**
	 * Update place information
	 * @param aPlace a place
	 */
	void updatePlace(Place aPlace, AsyncCallback<Place> callback);
	
	/**
	 * Deleta a place
	 * @param aPlace a place
	 */
	@SuppressWarnings("unchecked")
	void deletePlace(Place aPlace, AsyncCallback callback);
	
	/**
	 * Get place by Id
	 * @param id
	 * @return
	 */
	void getById(Long id, AsyncCallback<Place> callback);
	
	/**
	 * Find a place, whether from its name, of category
	 * @param aPlace a place. Definitely cannot be null
	 * @param aOffSet off set result
	 * @param aLimit 
	 * @return the query result
	 */
	void findPlace(Place aPlace, int aOffSet, int aLimit, AsyncCallback<QueryResult> callback);
	
	
	/**
	 * Find nearest place
	 * @param aPlace
	 * @return the query result
	 */
	void findNearestPlace(Place aPlace, int aOffSet, int aLimit, AsyncCallback<QueryResult> callback);
	
	/**
	 * Query all data
	 * @param aOffSet
	 * @param aLimit
	 * @param callback
	 * @return result
	 */
	void retrieveAll(int aOffSet, int aLimit, AsyncCallback<QueryResult> callback);
}
