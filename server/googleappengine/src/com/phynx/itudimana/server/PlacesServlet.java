package com.phynx.itudimana.server;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.ConcurrentModificationException;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.JDOObjectNotFoundException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.phynx.itudimana.EntityUtil;
import com.phynx.itudimana.auth.AuthChecker;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

/**
 * Servlet that process Places request from a common HTTP request. 
 * Doesn't have much feature in this version
 * 
 * @author pandupradhana
 * @version 0.1
 *
 */
public class PlacesServlet extends HttpServlet {

	/* --- A Servlet Names --- */
	/**
	 * Servlet name for putting place
	 */
	static final String PUT_PLACE = "putplace";
	
	/**
	 * Servlet name for deleting place
	 */
	static final String DEL_PLACE = "delplace";	
	
	/**
	 * Servlet name for deleting place
	 */
	static final String UPD_PLACE = "updplace";	
	
	/**
	 * Servlet name for deleting place
	 */
	static final String FIND_PLACE = "findplace";
	
	/**
	 * To handle near place
	 */
	static final String NEAR_PLACE = "nearplace";	
	
	/* --- End Servlet Names --- */
		
	/**
	 * Number of retry in a query before it give up
	 */
	static final int NUM_RETRIES = 5;
	
	/**
	 * The DAO
	 */
	private CommonPlacesServiceDAOImpl placesServiceDAO = new CommonPlacesServiceDAOImpl();
	
	/**
	 * Loger
	 */
	private Logger logger = Logger.getLogger(PlacesServlet.class.getName());
	
	/**
	 * Generated serial version UID
	 */
	private static final long serialVersionUID = -2944549149585426043L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		if (PUT_PLACE.equals(getServletName())
				|| DEL_PLACE.equals(getServletName())
				|| UPD_PLACE.equals(getServletName())) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);	
			return;
		}

		//Authorization checking 
		String token = req.getHeader("X-Token");
		if (!AuthChecker.isAccessGranted(getServletName(), token)){
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		String out = req.getParameter("output");
		String order = req.getParameter("order");
		PrintWriter pw = resp.getWriter();

		//Stands for query name
		String qn = req.getParameter("qn");
		//Stands for query category
		String qc = req.getParameter("qc");
		QueryResult result = null;
		for (int i = 0; i < NUM_RETRIES; i++) {
			try {
				if (qn == null && qc == null) {
					result = placesServiceDAO.retrieveAll(0, CommonPlacesServiceDAOImpl.LIMIT_QUERY);
				} else {
					
					Double gpslat = 
						EntityUtil.getGPSCoordinate(req.getParameter("gpslat"));					
					Double gpslon = 
						EntityUtil.getGPSCoordinate(req.getParameter("gpslon"));
					
					if ((gpslat != EntityUtil.INVALID_COORDINATE)
							&& 
							(gpslon != EntityUtil.INVALID_COORDINATE)) {
						
						Place place= new Place();
						place.setName(qn);
						place.setCategory(qc);
						place.setGpsloclat(gpslat);
						place.setGpsloclon(gpslon);
						result = placesServiceDAO.findNearestPlace(place, 0, 
								CommonPlacesServiceDAOImpl.LIMIT_QUERY);		
						
					} else {
		
						Place place= new Place();
						place.setName(qn);
						place.setCategory(qc);
						result = placesServiceDAO.findPlace(place, 0, 
								CommonPlacesServiceDAOImpl.LIMIT_QUERY);		
						
						//Order only apply here
						if (order != null) {
							Collections.sort(result.getPlaces(),new SortPlace());
						}
					}
				}
				break;
			} catch (ConcurrentModificationException cme) {
				if (i == (NUM_RETRIES-1)) {
					logger.log(Level.WARNING,"Give up seems we get heavily Overloaded, " +
							"error while query to database",cme);
					resp.sendError(HttpServletResponse.SC_BAD_GATEWAY );
					return;
				} else {
					logger.log(Level.FINE,
							"Seems we get Overloaded,error while query to database. Will retry " +
							(NUM_RETRIES-i) + " more times",cme);
					try {
						Thread.sleep(10);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}

			}
		}

		if (HttpResponseType.JSON.equals(out)) {
			resp.setContentType(HttpResponseProcessor.JSON_MIME_TYPE);
			pw.println(
					HttpResponseProcessor.processReturnQueryJSON (
							result
					));
		} else {
			//XML always default
			resp.setContentType(HttpResponseProcessor.XML_MIME_TYPE);
			pw.println(
					HttpResponseProcessor.processReturnQueryXML(
							result
					));
		}
	}
	
	
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		if (FIND_PLACE.equals(getServletName())) {
			doGet(req, resp);
			return;
		}
		
		//Authorization checking 
		String token = req.getHeader("X-Token");
		if (!AuthChecker.isAccessGranted(getServletName(), token)){
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}		
		
		String out = req.getParameter("output");
		if (PUT_PLACE.equals(getServletName())) {
					
			Double gpsloclat = null;
			Double gpsloclon = null;

			
			try {
				gpsloclat = 
					Double.parseDouble(req.getParameter("gpsloclat"));
				gpsloclon = 
					Double.parseDouble(req.getParameter("gpsloclon"));
			} catch (NumberFormatException nfe) {
				String 
					msg = Thread.currentThread().getName() + 
							" not a valid GPS location is provided. Detail: " + nfe.getMessage();
				logger.log(Level.WARNING,msg );
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
						"Not valid GPS location is given. GPS lat: " + req.getParameter("gpsloclat") +
						", lon: " + req.getParameter("gpsloclon"));
				return;
			} catch (NullPointerException npe) {
				logger.log(Level.WARNING,"One of required field [gpsloclat, gpsloclon] is missing",
						npe.getMessage() );
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST,"One of required parameter is missing ");
				return;
			}
			
			String name = req.getParameter("name");
			String category = req.getParameter("category");
			
			if (name == null || category == null) {
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST,"One of required parameter is missing ");
				return;
			}			
			String notes = req.getParameter("notes");
			
			Place place = new Place();
			place.setGpsloclat(gpsloclat);
			place.setGpsloclon(gpsloclon);
			place.setName(name);
			place.setCategory(category);
			place.setNotes(notes);
			
			try {
				placesServiceDAO.putPlace(place);
				StringBuffer m = new StringBuffer(name);
				m.append(" is added to server (GPS location: ");
				m.append(gpsloclat).append(",").append(gpsloclon).append(")");
				if (HttpResponseType.JSON.equals(out)) {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransJSON(true, m.toString()));
				} else {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransXML(true, m.toString()));
				}
			} catch (Exception e) {
				String err = "Problem while inserting new place to our server";
				logger.log(Level.WARNING,"Error while inserting entry",e);
				if (HttpResponseType.JSON.equals(out)) {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransJSON(false, err));
				} else {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransXML(false, err));
				}
			}
			
		} else if (DEL_PLACE.equals(getServletName())) {
			
			Long id = null;
			try {
				id = 
					Long.parseLong(req.getParameter("id"));
			} catch (NumberFormatException nfe) {
				String 
					msg = Thread.currentThread().getName() + 
							" not a valid id " + nfe.getMessage();
				logger.log(Level.WARNING,msg );
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
						"Not id is given.");
				return;
			} catch (NullPointerException npe) {
				logger.log(Level.WARNING,npe.getMessage() );
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST,"One of required parameter is missing ");
				return;
			}
			
			try {
				Place place = new Place();
				place.setId(id);
				placesServiceDAO.deletePlace(place);
				String m = "Place with id : " + id + " is deleted";
				if (HttpResponseType.JSON.equals(out)) {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransJSON(true, m));
				} else {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransXML(true, m));
				}
			} catch (JDOObjectNotFoundException jnfe) {
				String m = "Cannot find place to delete with id: " + id;
				if (HttpResponseType.JSON.equals(out)) {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransJSON(true, m));
				} else {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransXML(true, m));
				}
			} catch (Exception e) {
				String err = "Problem while deleting place from server";
				logger.log(Level.WARNING,err + " Detail: " + e);
				if (HttpResponseType.JSON.equals(out)) {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransJSON(true, err));
				} else {
					resp.getWriter()
						.write(HttpResponseProcessor.processReturnTransXML(true, err));
				}
			}
			
		} else if (UPD_PLACE.equals(getServletName())) {
			
			
			
		} else {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);	
		}
		
	}
	
}
