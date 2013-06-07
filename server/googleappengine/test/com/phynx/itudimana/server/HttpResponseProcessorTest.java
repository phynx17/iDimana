package com.phynx.itudimana.server;

import java.util.ArrayList;
import java.util.List;

import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

import junit.framework.TestCase;

/**
 * Unit Test
 * @author pandupradhana
 *
 */
public class HttpResponseProcessorTest extends TestCase {

	public void testNull(){
		String res = 
			"<?xml version=\"1.0\"?><places rows=\"0\"></places>";		
		assertEquals(res, HttpResponseProcessor.processReturnQueryXML(null));
		assertNotNull(HttpResponseProcessor.processReturnQueryXML(null));
	}
	
	
	public void testList(){
		String res = 
			"<?xml version=\"1.0\"?><places></places>";
		List<Place> l = new ArrayList<Place>();
		Place p = new Place();
		p.setId(Long.parseLong("120"));
		p.setGpsloclat(Double.parseDouble("-6.24323432"));
		p.setGpsloclon(Double.parseDouble("122.24323432"));
		p.setName("Somewhere");
		p.setCategory("Some category");
		p.setNotes("Off course, some test");
		l.add(p);
		QueryResult q = new QueryResult(100,l);
		assertFalse(HttpResponseProcessor.processReturnQueryXML(q).equals(res));
		System.out.println(HttpResponseProcessor.processReturnQueryXML(q));
	}
	
}
