package com.phynx.itudimana.client;

import com.google.gwt.user.client.Window;

public final class MiscUtil {

	/**
	 * Invalid coordinate
	 */
	public static final double INVALID_COORDINATE = -9999;
	
	
	/**
	 * Is GPS coordinate valid
	 * @param aTxt
	 * @return
	 */
	public static double isGPSValuesValid(String aTxt) {
		try {
			return Double.parseDouble(aTxt);
		}catch(Exception e) {
			Window.alert("GPS coordinate value is not valid");
			return INVALID_COORDINATE;
		}
	}	
	
	
	/**
	 * Is text valid?
	 * @param aTxt
	 * @return
	 */
	public static boolean isTextValuesValid(String aTxt) {
		return aTxt != null && !"".equals(aTxt);
	}	
	
}
