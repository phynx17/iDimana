package com.phynx.itudimana;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 * Utility class
 * 
 * @author pandupradhana
 * @version 1.0.1
 */
public final class EntityUtil {

	/**
	 * Invalid coordinate value
	 */
	public static final double INVALID_COORDINATE = -9999;
	
	/**
	 * 
	 * @param aName
	 * @return
	 */
	public static List<String> nameToTag(String aName) {
		List<String> tags = new ArrayList<String>();
		if (aName != null) {
			StringTokenizer strtok = new StringTokenizer(aName," :-~`+=_#$%^&*/?>.<,,\\\"'");
			while (strtok.hasMoreTokens()){				
				String _t = strtok.nextToken().toLowerCase();
				/**
				 * Make sure we don't put two tag for a place. 
				 * e.i. Hoka-Hoka Bento, just put the hoka, and then bento
				 */
				if (!tags.contains(_t)) {
					tags.add(_t);
				}
			}
		}
		return tags;
	}
	
	
	public static double getGPSCoordinate(String aTxt) {
		try {
			return Double.parseDouble(aTxt);
		}catch(Exception e) {
			return INVALID_COORDINATE;
		}
	}
	
}
