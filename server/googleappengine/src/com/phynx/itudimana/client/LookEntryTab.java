package com.phynx.itudimana.client;

import java.util.Iterator;
import java.util.List;

import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.event.dom.client.KeyUpEvent;
import com.google.gwt.event.dom.client.KeyUpHandler;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.FlexTable;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.Hyperlink;
import com.google.gwt.user.client.ui.Image;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.FlexTable.FlexCellFormatter;
import com.phynx.itudimana.client.vo.Place;
import com.phynx.itudimana.client.vo.QueryResult;

/**
 * Tab for Look entry
 * 
 * @author Pandu Pradhana
 *
 */
final class LookEntryTab extends Composite {

	/* ------------- CSS -------------------- */
	static final String CSS_BTN_NAV = "queryBtnNav";
	
	
	/* ------------- Private Widget -------------------- */

	/* ---- Private widget ---- */
	private Button nextButton = new Button("Next");
	private Button previousButton = new Button("Previous");
	
	private static final int MAX_FETCH = 30;
	
	private Itudimana parent;	
	private FlexTable tableEntry = new FlexTable();
	private FlexCellFormatter cellFormatter;
	private Image waitingLogo;	
	private HorizontalPanel hPanel = new HorizontalPanel();
	
	int currentOffSet = 0;
	
	
	
	
	static class DeleteLink extends Hyperlink {		
		private long id;
		
		DeleteLink(long anId) {
			super("Delete",null);
			id = anId;
			addClickHandler(new ClickHandler() {

				public void onClick(ClickEvent event) {
					getId();
				}
				
			});
		}
		
		long getId(){
			Window.alert("Going to delete entry with id: " + id);
			return id;
		}
		
	}
	
	
	
	
	
	
	
	/**
	 * Constructor
	 * @param aParent
	 */
	LookEntryTab(Itudimana aParent) {
		parent = aParent;
		cellFormatter = tableEntry.getFlexCellFormatter();
		tableEntry.setCellSpacing(5);
		tableEntry.setCellPadding(3);
		 
		// Create a handler for the sendButton and nameField
		final class MyLookupEntryHandler implements ClickHandler, KeyUpHandler {
			// Fired when the user clicks on the sendButton.
			public void onClick(ClickEvent event) {
				queryToServer();
			}

			//Fired when the user types in the nameField.
			public void onKeyUp(KeyUpEvent event) {
				if (event.getNativeKeyCode() == KeyCodes.KEY_ENTER) {
					queryToServer();
				}
			}

		}

		nextButton.addClickHandler(new ClickHandler() {

			public void onClick(ClickEvent event) {
				currentOffSet+= MAX_FETCH;
				queryToServer();
			}
			
		});
		nextButton.setVisible(false);
		nextButton.setStyleName(CSS_BTN_NAV);
		previousButton.addClickHandler(new ClickHandler() {

			public void onClick(ClickEvent event) {
				currentOffSet-= MAX_FETCH;
				queryToServer();
			}
			
		});
		previousButton.setVisible(false);	
		previousButton.setStyleName(CSS_BTN_NAV);
		waitingLogo = new Image("images/waiting.gif");
		
		//hPanel.add(previousButton);
		hPanel.add(nextButton);
		//hPanel.add(waitingLogo);
		//hPanel.setSpacing(10);
		//hPanel.setStyleName(CSS_NAV);
		
		//waitingLogo.setVisible(true);
		createLayoutAndHeader();
		queryToServer();
		
		VerticalPanel vPanel = new VerticalPanel();
		vPanel.add(hPanel);
		vPanel.add(tableEntry);
		initWidget(vPanel);
	}

	
	//Send the name from the nameField to the server and wait for a response.
	@SuppressWarnings("unchecked")
	void queryToServer() {
		preQuery();
		parent.placesService.retrieveAll(
			currentOffSet,
			MAX_FETCH, 
			new AsyncCallback<QueryResult>() {
				public void onFailure(Throwable caught) {
					postQuery();
					if (caught == null) {
						Window.alert("Arrgh.. problem while calling to server. If the " +
								"problem still occur please reload this page.");					
					} else if ("".equals(caught.getMessage().trim())) {
						Window.alert("Oops.. cannot connect to server. Please check your network status");
					} else {
						Window.alert("Error while calling to server:" + 
								caught.getMessage());
					}
				}

				public void onSuccess(QueryResult result) {
					postQuery();
					try {
						List l = result.getPlaces();
						transformResult(l);
						long tot = result.getTotalRow();
						nextButton.setVisible(tot > MAX_FETCH);
						if ((currentOffSet + MAX_FETCH) >= tot) {
							nextButton.setEnabled(false);
						}
						previousButton.setVisible(currentOffSet >= MAX_FETCH);
						hPanel.insert(previousButton, 
								hPanel.getWidgetIndex(nextButton));
					} catch (Exception e) {
						Window.alert(e.getMessage());
					}
					
				}
			});
	}

	
	
	private void createLayoutAndHeader() {
		tableEntry.setText(0,0,"Id");
		tableEntry.setText(0,1,"Name");
		tableEntry.setText(0,2,"Category");
		tableEntry.setText(0,3,"GPS Latitude");
		tableEntry.setText(0,4,"GPS Longitude");
		tableEntry.setText(0,5,"Notes");
	}
	
	
	private void transformResult(List entries) {
		if (entries.isEmpty()) {
			tableEntry.setText(0, 0, "No data found");
			cellFormatter.setColSpan(1,1, 5);
		} else {
			int i = 1;
			//Make sure the colspan thing is ok
			cellFormatter.setColSpan(1, 1, i);
			for (Iterator<Place> it = entries.iterator(); it.hasNext();) {
				Place place = it.next();
				tableEntry.setText(i,0,String.valueOf(place.getId()));
				tableEntry.setText(i,1,String.valueOf(place.getName()));
				tableEntry.setText(i,2,String.valueOf(place.getCategory()));
				tableEntry.setText(i,3,String.valueOf(place.getGpsloclat()));
				tableEntry.setText(i,4,String.valueOf(place.getGpsloclon()));
				tableEntry.setText(i,5,
						place.getNotes() == null ? " -- " : place.getNotes());		
				tableEntry.setWidget(i, 6, new DeleteLink(place.getId()));		
				i++;
			}
			//do swap here!
		}
	}
	
	
	private void preQuery(){
		hPanel.add(waitingLogo);
		nextButton.setEnabled(false);
		previousButton.setEnabled(false);
	}
	
	private void postQuery(){
		hPanel.remove(waitingLogo);
		nextButton.setEnabled(true);
		previousButton.setEnabled(true);
	}
}
