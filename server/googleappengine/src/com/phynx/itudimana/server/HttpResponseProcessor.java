package com.phynx.itudimana.server;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

/**
 * Class that responsible for handling the HTTP response
 * 
 * @author Pandu Pradhana
 * @version 0.2
 */
class HttpResponseProcessor {

	/* -- Listed MIME TYPE -- */
	static final String XML_MIME_TYPE = "text/xml";	
	static final String JSON_MIME_TYPE = "text/plain";
	/* -- End MIME TYPE -- */
	
	
	/**
	 * Process transaction information in an XML response
	 * @param isok whether its is ok or not
	 * @param message a message
	 * @return XML
	 */
	static String processReturnTransXML(boolean isok, String message) {
		StringBuffer buf = new StringBuffer("<?xml version=\"1.0\"?>\n");
		buf.append("<place>");
		buf.append("<put><status>").append(isok ? "OK" : "NOK").append("</status>");
		buf.append("<message>").append(message).append("</message></put>");
		buf.append("</place>");
		return buf.toString();
	}
	
	
	/**
	 * Get query with an XML output
	 * @param result result
	 * @return XML result
	 */
	static String processReturnQueryXML(QueryResult result) {
		StringBuffer buf = new StringBuffer("<?xml version=\"1.0\"?>\n");		
		if (result != null) {
			buf.append("<places rows=\"").append(result.getTotalRow()).append("\">");
			try {
				for (Place place : result.getPlaces()) {
					buf.append("<place>");
					buf.append("<id>").append(place.getId()).append("</id>");
					buf.append("<gps>");
					buf.append("<lat>").append(place.getGpsloclat()).append("</lat>");
					buf.append("<lon>").append(place.getGpsloclon()).append("</lon>");
					buf.append("</gps>");
					buf.append("<name><![CDATA[").append(place.getName()).append("]]></name>");
					buf.append("<category><![CDATA[").append(place.getCategory()).append("]]></category>");
					buf.append("<notes><![CDATA[")
						.append(place.getNotes() == null ? " " : place.getNotes()).append("]]></notes>");
					buf.append("</place>");
				}				
			} catch (NullPointerException npe) {
				npe.printStackTrace();
			}
		} else {
			buf.append("<places rows=\"0\">");
		}
		buf.append("</places>");
		return buf.toString();
	}
	
	
	/**
	 * Process transaction information in an JSON response
	 * @param isok whether its is ok or not
	 * @param message a message
	 * @return JSON
	 */
	static String processReturnTransJSON(boolean isok, String message) {
		JSONObject jo = new JSONObject();
		try {
			jo.put("status", isok ? "OK" : "NOK");
			jo.put("message",message);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return jo.toString();
	}
	

	/**
	 * Get query with an JSON output
	 * @param result result
	 * @return JSON result
	 */
	static String processReturnQueryJSON(QueryResult result) {
		JSONArray json = new JSONArray();
		if (result != null) {
			try {			
				json.put(new JSONObject().put("rows",result.getTotalRow()));
				for (Place place : result.getPlaces()) {
					JSONObject jo = new JSONObject();
					jo.put("id",place.getId());                
					jo.put("gps_lat",place.getGpsloclat()); 
					jo.put("gps_lon",place.getGpsloclon()); 
					jo.put("name",place.getName());  
					jo.put("category",place.getCategory());             
					jo.put("notes",place.getNotes() == null ? " " : place.getNotes());    
					json.put(jo);
				}				
			} catch (NullPointerException npe) {
				npe.printStackTrace();
			} catch (JSONException e) {
				e.printStackTrace();
			}  
		}
		return json.toString();
	}
	
}
