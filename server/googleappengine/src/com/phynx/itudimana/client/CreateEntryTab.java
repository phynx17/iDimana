package com.phynx.itudimana.client;

import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.event.dom.client.KeyUpEvent;
import com.google.gwt.event.dom.client.KeyUpHandler;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.DialogBox;
import com.google.gwt.user.client.ui.FlexTable;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.FlexTable.FlexCellFormatter;
import com.phynx.itudimana.client.vo.Place;

/**
 * Tab for creating entry
 * 
 * @author Pandu Pradhana
 *
 */
final class CreateEntryTab extends Composite {
	
	/**
	 * The message displayed to the user when the server cannot be reached or
	 * returns an error.
	 */
	private static final String SERVER_ERROR = 
			"An error occurred while "
			+ "attempting to contact the server. Please check your network "
			+ "connection and try again.";
	
	
	/* Define UI Element */
	final Button sendButton = new Button("Put place");
	final Label lblgpsLat = new Label("GPS Decimal Latitude");
	final TextBox txtgpsLat = new TextBox();
	final Label lblgpsLon = new Label("GPS Decimal Longitude");
	final TextBox txtgpsLon = new TextBox();
	final Label lblName = new Label("Name");
	final TextBox txtName = new TextBox();
	final Label lblCat = new Label("Category");
	final TextBox txtCat = new TextBox();	
	/* End define UI Element */

	private Itudimana parent;
	
	/**
	 * Default constructor
	 */
	CreateEntryTab(Itudimana aParentInstance) {
		parent = aParentInstance;
		
		// We can add style names to widgets
		sendButton.addStyleName("sendButton");

		// Add the nameField and sendButton to the RootPanel
		// Use RootPanel.get() to get the entire body element
		int i = 0;

		// Focus the cursor on the name field when the app loads
		txtgpsLat.setFocus(true);
		txtgpsLat.selectAll();

		// Create the popup dialog box
		final DialogBox dialogBox = new DialogBox();
		dialogBox.setText("Remote Procedure Call");
		dialogBox.setAnimationEnabled(true);
		final Button closeButton = new Button("Close");
		// We can set the id of a widget by accessing its Element
		closeButton.getElement().setId("closeButton");
		final Label textToServerLabel = new Label();
		final HTML serverResponseLabel = new HTML();
		
		VerticalPanel dialogVPanel = new VerticalPanel();
		dialogVPanel.addStyleName("dialogVPanel");
		dialogVPanel.add(new HTML("<b>Sending name to the server:</b>"));
		dialogVPanel.add(textToServerLabel);
		dialogVPanel.add(new HTML("<br><b>Server replies:</b>"));
		dialogVPanel.add(serverResponseLabel);
		dialogVPanel.setHorizontalAlignment(VerticalPanel.ALIGN_RIGHT);
		dialogVPanel.add(closeButton);
		dialogBox.setWidget(dialogVPanel);

		// Add a handler to close the DialogBox
		closeButton.addClickHandler(new ClickHandler() {
			public void onClick(ClickEvent event) {
				dialogBox.hide();
				sendButton.setEnabled(true);
				sendButton.setFocus(true);
			}
		});

		// Create a handler for the sendButton and nameField
		final class MyHandler implements ClickHandler, KeyUpHandler {
			// Fired when the user clicks on the sendButton.
			public void onClick(ClickEvent event) {
				sendNameToServer();
			}

			//Fired when the user types in the nameField.
			public void onKeyUp(KeyUpEvent event) {
				if (event.getNativeKeyCode() == KeyCodes.KEY_ENTER) {
					sendNameToServer();
				}
			}

			//Send the name from the nameField to the server and wait for a response.
			@SuppressWarnings("unchecked")
			private void sendNameToServer() {
				//Window.alert("OI");
				sendButton.setEnabled(false);
				//Window.alert("OI1");
				serverResponseLabel.setText("");
				//Window.alert("OI2");
				Place place = new Place();
				double gpslat = MiscUtil.isGPSValuesValid(txtgpsLat.getText());
				//Window.alert("OI3");
				double gpslon = MiscUtil.isGPSValuesValid(txtgpsLon.getText());
				//Window.alert("OI4");
				if (gpslat == MiscUtil.INVALID_COORDINATE 
						|| gpslon == MiscUtil.INVALID_COORDINATE) {
					setUIStandby();
					return;
				}
				place.setGpsloclat(Double.valueOf(gpslat));
				place.setGpsloclon(Double.valueOf(gpslon));
				
				String nm = txtName.getText();
				String cat = txtCat.getText();
				if (MiscUtil.isTextValuesValid(nm) && MiscUtil.isTextValuesValid(cat)) {
					place.setName(nm);
					place.setCategory(cat);
				} else {
					Window.alert("Name and category cannot be empty");
					setUIStandby();
					if (!MiscUtil.isTextValuesValid(nm)) {
						txtName.setFocus(true);
					} else {
						txtCat.setFocus(true);
					}
					return;
				}
				parent.placesService.putPlace(place, 
						new AsyncCallback() {
							public void onFailure(Throwable caught) {
								// Show the RPC error message to the user
								dialogBox
										.setText("Remote Procedure Call - Failure");
								serverResponseLabel
										.addStyleName("serverResponseLabelError");
								serverResponseLabel.setHTML(SERVER_ERROR);
								dialogBox.center();
								closeButton.setFocus(true);
							}

							public void onSuccess(Object result) {
								dialogBox.setText("Successfully add new place");
								serverResponseLabel.removeStyleName("serverResponseLabelError");
								if (result != null) {
									//Never happened though :p
									serverResponseLabel.setHTML	(result.toString());
								} else {
									serverResponseLabel.setHTML	("New record is inserted");
								}
								dialogBox.center();
								closeButton.setFocus(true);
							}
						});
			}
		}

		// Add a handler to send the name to the server
		MyHandler handler = new MyHandler();
		sendButton.addClickHandler(handler);
		//nameField.addKeyUpHandler(handler);
	
		
		final FlexTable table = new FlexTable();
		FlexCellFormatter cellFormatter = table.getFlexCellFormatter();
		table.setWidth("70%");
		
		
		table.setHTML(0, 0, "What is the place");
		table.setWidget(1, 0, lblgpsLat);
		table.setWidget(1, 1, txtgpsLat);
		table.setWidget(2, 0, lblgpsLon);
		table.setWidget(2, 1, txtgpsLon);
		table.setWidget(3, 0, lblName);
		table.setWidget(3, 1, txtName);
		table.setWidget(4, 0, lblCat);
		table.setWidget(4, 1, txtCat);
		table.setWidget(5, 0, sendButton);
		cellFormatter.setColSpan(0,0, 2);
		cellFormatter.setColSpan(5,0, 2);
		
		initWidget(table);
	}
	
	
	/* --- Privates --- */
	
	void setUIWhileSend() {
		sendButton.setEnabled(false);
	}
	void setUIStandby() {
		sendButton.setEnabled(true);
		
	}	

	
}
