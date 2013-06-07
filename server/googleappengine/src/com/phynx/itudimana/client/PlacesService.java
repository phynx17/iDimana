package com.phynx.itudimana.client;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

/**
 * The client side stub for the RPC service.
 * @author Pandu Pradhana
 * @version 0.2
 */
@RemoteServiceRelativePath("gwtplacesservlet")
public interface PlacesService extends RemoteService {
	
	/**
	 * Put a new place 
	 * @param aPlace some place. Definitely cannot be null
	 * @return inserted Place
	 */
	Place putPlace(Place aPlace);
	
	/**
	 * Update place information
	 * @param aPlace a place
	 * @return updated Place
	 */
	Place updatePlace(Place aPlace);
	
	/**
	 * Deleta a place
	 * @param aPlace a place
	 */
	void deletePlace(Place aPlace);
	
	/**
	 * Get place by Id
	 * @param id
	 * @return
	 */
	Place getById(Long id);
	
	/**
	 * Find a place, whether from its name, of category
	 * @param aPlace a place. Definitely cannot be null
	 * @param aOffSet off set result
	 * @param aLimit 
	 * @return the query result
	 */
	QueryResult findPlace(Place aPlace, int aOffSet, int aLimit);
	
	
	/**
	 * Find nearest place
	 * @param aPlace
	 * @return the query result
	 */
	QueryResult findNearestPlace(Place aPlace, int aOffSet, int aLimit);
	
	/**
	 * Get all placess
	 * @param aOffSet
	 * @param aLimit
	 * @return results
	 */
	QueryResult retrieveAll(int aOffSet, int aLimit);
	
}
