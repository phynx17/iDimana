package com.phynx.itudimana.server;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.JDOCanRetryException;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.Transaction;

import com.phynx.itudimana.EntityUtil;
import com.phynx.itudimana.PMF;
import com.phynx.itudimana.client.PlacesService;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;
import com.phynx.itudimana.server.dto.SavedPlace;


/**
 * Default implementation for {@link PlacesService}
 * 
 * <pre>
 * TODO for next GAE:
 * 	- Find nearest place is done within the first query (JDOQL)
 * 
 * </pre>
 * 
 * @author pandupradhana
 * @version 0.1
 * @since August 8, 2009
 */
public class CommonPlacesServiceDAOImpl implements PlacesService {


	/**
	 * Limiting the query
	 */
	public static final int LIMIT_QUERY = 30;
	/**
	 * Number of retry in a transaction
	 */
	static final int NUM_RETRIES = 5;
	
	
	/**
	 * Loger
	 */
	private Logger logger = Logger.getLogger(CommonPlacesServiceDAOImpl.class.getName());


	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#deletePlace(com.phynx.itudimana.client.vo.Place)
	 */
	public void deletePlace(Place place) {
        PersistenceManager pm = PMF.get().getPersistenceManager();
        try {
        	SavedPlace placeToDelete = pm.getObjectById(SavedPlace.class,place.getId());
        	pm.deletePersistent(placeToDelete);
        } finally {
            pm.close();
        }
	}

	/**
	 * Here, we don't use offset and limit 
	 * We always use 0 as offset and limit to 30
	 * 
	 * @see com.phynx.itudimana.client.PlacesService#findNearestPlace(com.phynx.itudimana.client.vo.Place, int, int)
	 */
	@SuppressWarnings("unchecked")
	public QueryResult findNearestPlace(Place place, int offSet, int limit) {
		if (place == null) {
			throw new IllegalArgumentException("Place cannot be null!");
		}
		//QueryResult result = new QueryResult();
        PersistenceManager pm = PMF.get().getPersistenceManager();
    	StringBuffer f = new StringBuffer();
    	StringBuffer p = new StringBuffer();
    	int totres = 0;
    	String[] paramvals = null;
		int idx = 0;
		String _category = place.getCategory();
		String _name = place.getName();
    	Class table = SavedPlace.class;   
    	
       	//NEVER USE THIS in Google JDO's query
    	//Transaction tx = pm.currentTransaction();
    	//tx.begin();

    	//Emang ini ngaruh? :p
    	//pm.setMultithreaded(true);
        try {
        	//String query = "select from " + Place.class.getName();        	
        	//Query queryCount = pm.newQuery(SavedPlace.class);        	     	
			paramvals = new String[2];

        	/**
        	 * Here we query from Tag. 
        	 * The first priority
        	 */
        	if (_name != null) {
        		//Contains is supported in GAE 1.2.2
        		f.append("this.tags.contains(tagParam)");
        		p.append("String tagParam");
        		paramvals[idx] = _name;       		
        		//order = "tag asc";
        	} else if (_category != null) {
        		//f.append("category == '").append(place.getCategory()).append("' ");
        		f.append("category == catParam");
        		p.append("String catParam");
        		paramvals[idx] = _category.toLowerCase();
        	}
        	
        	Query query = pm.newQuery(table);
        	query.setFilter(f.toString());
        	query.declareParameters(p.toString());            	
			//query.setRange(offSet, LIMIT_QUERY);
			
			List<Place> tmpplaces = new ArrayList<Place>();
			long l = System.currentTimeMillis();
			if (_name != null) {
	        	for (Iterator<SavedPlace> it = 
	        		(idx < 1 ?
	        			(List<SavedPlace>) query.execute(paramvals[0])
	        			:
	        			(List<SavedPlace>) query.execute(paramvals[0],paramvals[1])).iterator(); 
	        		it.hasNext(); ) {	        		
	        		Place _p = new Place();
	        		//TaggedNamePlace pp = it.next();
	        		//SavedPlace cc = pp.getSavedPlace();
	        		//System.out.println("TaggedNamePlace : " + pp);
	        		//System.out.println("Place : " + cc);
	        		transformPlace(it.next(), _p);
	        		tmpplaces.add(_p);
	        	}	
			} else {
	        	for (Iterator<SavedPlace> it = 
	        			((List<SavedPlace>) query.execute(paramvals[0])).iterator(); it.hasNext(); ) {
	        		Place _p = new Place();
	        		transformPlace(it.next(), _p);
	        		tmpplaces.add(_p);
	        	}	        					
			}
			
			// --- 	A heavy duty task is done here 	--- //
			// --- And we ONLY take first 30 record --- //
			Collections.sort(tmpplaces,new SortNearestPlace(place));	
			
			int _size = tmpplaces.size() > LIMIT_QUERY ? LIMIT_QUERY : tmpplaces.size();
			List<Place> places = new ArrayList<Place>(_size);
			for (int i = 0; i < _size; i++) {
				places.add(tmpplaces.get(i));
			}
			logger.log(Level.FINER,"Query takes: " + (System.currentTimeMillis()-l) + " ms");			
			return new QueryResult(places.size(),places);
			
			/*
			logger.log(Level.WARNING,"Query takes: " + (System.currentTimeMillis()-l) + " ms");
			return new QueryResult(tmpplaces.size(),tmpplaces);
			*/
        } finally {
			//if (tx.isActive()) {
			//	tx.rollback();
			//}
            pm.close();
        }
	}

	
	@SuppressWarnings("unchecked")
	public QueryResult findPlace(Place place, int offSet, int limit) {
		if (place == null) {
			throw new IllegalArgumentException("Place cannot be null!");
		}
		//QueryResult result = new QueryResult();
        PersistenceManager pm = PMF.get().getPersistenceManager();
    	StringBuffer f = new StringBuffer();
    	StringBuffer p = new StringBuffer();
    	String var = null;
    	String funccount = null;
    	String order = null;
    	int totres = 0;
    	String[] paramvals = null;
		int idx = 0;
		String _category = place.getCategory();
		String _name = place.getName();
    	Class table = SavedPlace.class;   
    	
    	
    	//Transaction tx = pm.currentTransaction();
    	//tx.begin();
    	pm.setMultithreaded(true);
    	
        try {
        	//String query = "select from " + Place.class.getName();        	
        	//Query queryCount = pm.newQuery(SavedPlace.class);        	     	
			paramvals = new String[2];

        	/**
        	 * Here we query from Tag. 
        	 * The first priority
        	 */
        	if (_name != null) {
        		//Contains is supported GAE 1.2.2
        		f.append("this.tags.contains(tagParam)");
        		p.append("String tagParam");
        		paramvals[idx] = _name; 
        		//var = "SavedPlace savedPlace";
        		/*
        		 * NOT Supporte at a moment 
        		 * GAE 1.2.0

        		if (_category != null) {
        			f.append(" && savedPlace.category == catParam");
        			p.append(", String catParam");
        			paramvals[++idx] = _category.toLowerCase();
        		}
        		*/        		
        		funccount = "count(this)";
        		//order = "savedPlace.name asc";
        	} else if (_category != null) {
        		//f.append("category == '").append(place.getCategory()).append("' ");
        		f.append("category == catParam");
        		p.append("String catParam");
        		paramvals[idx] = _category.toLowerCase();
        		funccount = "count(id)";
        		order = "name asc";
        	}

        	Query queryCount = pm.newQuery(table);

        	//Find count first
        	queryCount.setFilter(f.toString());
        	queryCount.declareParameters(p.toString());    
        	queryCount.setResult(funccount);
        	if (var != null) {
        		queryCount.declareVariables(var);
        	}
        	
			//List _res = 
			//totres = (Integer)queryCount.execute("arkadia");
        	totres = idx < 1 ?
        				(Integer)queryCount.executeWithArray(paramvals[0])
        				:
        				(Integer)queryCount.executeWithArray(paramvals[0],paramvals[1]);
        } finally {
			//if (tx.isActive()) {
			//	tx.rollback();
			//}
            pm.close();
        }
        
        List<Place> places = new ArrayList<Place>();
        if (totres == 0) {
        	//don't bother
        	return new QueryResult(totres,places);
        }
        
        //Continue with the data
        //THIS IS WRONG MUST in be ONE TRANSACTION
        pm = PMF.get().getPersistenceManager();
    	//tx = pm.currentTransaction();
    	//tx.begin();
    	
        try {
        	Query query = pm.newQuery(table);
        	query.setFilter(f.toString());
			query.declareParameters(p.toString());      
        	if (var != null) {
        		query.declareVariables(var);
        	}
        	if (order != null) {
        		query.setOrdering(order);
        	}
			query.setRange(offSet, limit < 0 ? (LIMIT_QUERY+offSet) : (limit+offSet));
			//query.setr

			if (_name != null) {
	        	for (Iterator<SavedPlace> it = 
	        		(idx < 1 ?
	        			(List<SavedPlace>) query.execute(paramvals[0])
	        			:
	        				(List<SavedPlace>) query.execute(paramvals[0],paramvals[1])).iterator(); 
	        		it.hasNext(); ) {	        		
	        		Place _p = new Place();	        		
	        		transformPlace(it.next(), _p);
	        		places.add(_p);
	        	}	
			} else {
	        	for (Iterator<SavedPlace> it = 
	        			((List<SavedPlace>) query.execute(paramvals[0])).iterator(); it.hasNext(); ) {
	        		Place _p = new Place();
	        		transformPlace(it.next(), _p);
	        		places.add(_p);
	        	}	        					
			}
			return new QueryResult(totres,places);
        } finally {
			//if (tx.isActive()) {
			//	tx.rollback();
			//}
            pm.close();
        }
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#getById(java.lang.Long)
	 */
	public Place getById(Long id) {		
        PersistenceManager pm = PMF.get().getPersistenceManager();
        try {
            return pm.getObjectById(Place.class,id);
        } finally {
            pm.close();
        }
	}

	/*
	 * (non-Javadoc)
	 * @see com.phynx.itudimana.client.PlacesService#putPlace(com.phynx.itudimana.client.vo.Place)
	 */
	public Place putPlace(Place place) {
		if (place == null) {
			throw new IllegalArgumentException("Place information cannot be null");
		}
        PersistenceManager pm = PMF.get().getPersistenceManager();
        
        for (int i = 0; i < NUM_RETRIES; i++) {
	        Transaction trans = pm.currentTransaction();
	        trans.begin();
	        try {
	        	analyzeOnPut(place);
	        	SavedPlace splace = new SavedPlace(place);
	        	splace.setTags(EntityUtil.nameToTag(place.getName()));
	        	/*
	            for (Iterator<String> it = EntityUtil.nameToTag(place.getName()).iterator();it.hasNext();) {
	            	TaggedNamePlace tag = new TaggedNamePlace();
	            	//tag.setPlaceId(theid);            	
	            	//tag.setName((String) it.next());
	            	tag.setTag((String) it.next());
	            	//pm.makePersistent(tag);
	            	splace.addTag(tag);
	            }
	            */
	            Long theid = pm.makePersistent(splace).getId();            
	            splace.setId(theid);
	            trans.commit();
	            break;
	        } catch (JDOCanRetryException ex) {
                if (i == (NUM_RETRIES - 1)) { 
                    throw ex;
                }
            } finally {
	        	if (trans.isActive()) {
	        		trans.rollback();
	        	}
	            pm.close();
	        }
        }
        return place;
	}

	/*
	 * This may throw exception
	 * 
	 * @see com.phynx.itudimana.client.PlacesService#updatePlace(com.phynx.itudimana.client.vo.Place)
	 */
	public Place updatePlace(Place place) {
		if (place != null && place.getId() != null) {
	        PersistenceManager pm = PMF.get().getPersistenceManager();
	        for (int i = 0; i < NUM_RETRIES; i++) {
		        Transaction tx = pm.currentTransaction();
		        tx.begin();
		        try {
		        	analyzeOnPut(place);
		        	SavedPlace upobj = 
		        		pm.getObjectById(
		        			SavedPlace.class, 
		        			place.getId());
		        	upobj.setCategory(place.getCategory());
		        	upobj.setName(place.getName());
		        	upobj.setNotes(place.getNotes());
		        	tx.commit();
		        	break;
		        } catch (JDOCanRetryException ex) {
	                if (i == (NUM_RETRIES - 1)) { 
	                    throw ex;
	                }
		        } finally {
		            if (tx.isActive()) {
		                tx.rollback();
		            } 
		            pm.close();
		        }			
			}
        	return place;
		} else {
			throw new IllegalArgumentException("Place information cannot be null");
		}

	}

	
	
	@SuppressWarnings("unchecked")
	public QueryResult retrieveAll(int offSet, int limit) {
		//QueryResult result = new QueryResult();
        PersistenceManager pm = PMF.get().getPersistenceManager();
        /**
         * Gotta int, if you set it to long, there will be a class cast exception
         * It is strange though the doc said it is Long data type for count() function
         */
        int count = 0;
        try {
        	Query queryCount = pm.newQuery(SavedPlace.class);
        	queryCount.setResult("count(this)");
    		//System.out.println("FUCK ::" + queryCount.execute());
        	count = (Integer)queryCount.execute();
        	//count = (Long)_count[0];
        } finally {
            pm.close();
        }
        
        pm = PMF.get().getPersistenceManager();
        try {
        	//String query = "select from " + Place.class.getName();
        	Query query = pm.newQuery(SavedPlace.class);
        	query.setOrdering("id desc");
        	query.setRange(offSet, limit < 0 ? (LIMIT_QUERY+offSet) : (limit+offSet));
        	List<Place> places = new ArrayList<Place>();
        	for (Iterator<SavedPlace> it = 
        		((List<SavedPlace>)query.execute()).iterator(); it.hasNext(); ) {
        		Place p = new Place();
        		transformPlace(it.next(), p);
        		places.add(p);
        	}
			return new QueryResult(count,places);
        } finally {
            pm.close();
        }
	}
	
	
	/**
	 * Do the analyze, for Datestore indexing purpose 
	 * @param aplace MUST NEVER NULL
	 */
	void analyzeOnPut(Place aplace) {
		if (aplace == null) {
			throw new IllegalArgumentException("Place cannot be null");
		}
		if (aplace.getCategory() != null) {
			aplace.setCategory(aplace.getCategory().toLowerCase());
		}		
	}

	
	/**
	 * 
	 * @param aSavedPlace
	 * @param aPlace
	 */
	void transformPlace(SavedPlace aSavedPlace, Place aPlace) {
		if (aSavedPlace == null || aPlace == null) {
			throw new IllegalArgumentException("Either SavedPlace or Place cannot be null");
		}
		aPlace.setId(aSavedPlace.getId());
		aPlace.setGpsloclat(aSavedPlace.getGpsloclat());
		aPlace.setGpsloclon(aSavedPlace.getGpsloclon());
		aPlace.setName(aSavedPlace.getName());
		aPlace.setNotes(aSavedPlace.getNotes());
		aPlace.setCategory(aSavedPlace.getCategory());
	}
	
}
