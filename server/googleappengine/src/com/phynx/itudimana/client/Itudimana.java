package com.phynx.itudimana.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.event.dom.client.KeyUpEvent;
import com.google.gwt.event.dom.client.KeyUpHandler;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.DecoratedTabPanel;
import com.google.gwt.user.client.ui.DialogBox;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.RootPanel;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.phynx.itudimana.client.vo.Place;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public class Itudimana implements EntryPoint {


	/**
	 * Create a remote service proxy to talk to the server-side Greeting service.
	 */
	public final PlacesServiceAsync placesService = GWT.create(PlacesService.class);

	/**
	 * Just bunch of logos
	 */
	public SitesLogo logos;
	
	
	/**
	 * This is the entry point method.
	 */
	public void onModuleLoad() {		
		logos = GWT.create(SitesLogo.class); 
		DecoratedTabPanel tabPanel = new DecoratedTabPanel();
		//Don't expose this for a while
		//tabPanel.add(new CreateEntryTab(this), "Create entry");
		tabPanel.add(new LookEntryTab(this), "Places");
		tabPanel.setStyleName("main-body");		
		tabPanel.selectTab(0);
		
		RootPanel.get("main").add(tabPanel);
		
	}

}
