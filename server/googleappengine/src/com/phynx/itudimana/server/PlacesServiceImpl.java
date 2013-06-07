package com.phynx.itudimana.server;

import com.phynx.itudimana.client.PlacesService;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;

/**
 * The server side implementation of the RPC service.
 * Made for GWT apps
 */
@SuppressWarnings("serial")
public class PlacesServiceImpl extends RemoteServiceServlet implements PlacesService {

	/**
	 * The DAO
	 */
	private CommonPlacesServiceDAOImpl placesServiceDAO = new CommonPlacesServiceDAOImpl();
	
	
	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#deletePlace(com.phynx.itudimana.client.vo.Place)
	 */
	public void deletePlace(Place place) {
		placesServiceDAO.deletePlace(place);
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#findNearestPlace(com.phynx.itudimana.client.vo.Place, int, int)
	 */
	public QueryResult findNearestPlace(Place place, int offSet, int limit) {
		return placesServiceDAO.findNearestPlace(place, offSet, limit);
	}

	
	@SuppressWarnings("unchecked")
	public QueryResult findPlace(Place place, int offSet, int limit) {
		return placesServiceDAO.findPlace(place, offSet, limit);
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#getById(java.lang.Long)
	 */
	public Place getById(Long id) {		
		return placesServiceDAO.getById(id);
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#putPlace(com.phynx.itudimana.client.vo.Place)
	 */
	public Place putPlace(Place place) {
		return placesServiceDAO.putPlace(place);
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#updatePlace(com.phynx.itudimana.client.vo.Place)
	 */
	public Place updatePlace(Place place) {
		return placesServiceDAO.updatePlace(place);

	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#retrieveAll(int, int)
	 */
	public QueryResult retrieveAll(int offSet, int limit) {
		return placesServiceDAO.retrieveAll(offSet, limit);
	}
}
