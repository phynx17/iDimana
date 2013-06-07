package com.phynx.itudimana;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManagerFactory;

/**
 * Persistence Manager Factory for JDO
 * 
 * @author Pandu Pradhana
 *
 */
public final class PMF {
	
    private static final PersistenceManagerFactory pmfInstance =
        JDOHelper.getPersistenceManagerFactory("transactions-optional");

    private PMF() {}

    /**
     * Get Persistence Managet Factory.
     * @return Persistence Managet Factory.
     */
    public static PersistenceManagerFactory get() {
        return pmfInstance;
    }
    
}