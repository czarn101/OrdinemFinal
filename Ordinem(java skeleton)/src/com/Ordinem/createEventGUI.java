package com.Ordinem;

import com.Ordinem.control.DateTimePicker;
import com.sun.org.apache.xml.internal.security.Init;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.Initializable;
import java.net.URL;
import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.*;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.control.*;
import javafx.application.Application;
import java.util.ResourceBundle;
import javafx.collections.*;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;



import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;


/**
 * Created by Albert on 12/7/16.
 */
public class createEventGUI implements Initializable{

    @FXML
    private AnchorPane myPlane;
    @FXML
    private Label createAnEvent;
    @FXML
    private ImageView ordinemTitle;
    @FXML
    private Label eventName;
    @FXML
    private TextField nameText;
    @FXML
    private Label eventDiscription;
    @FXML
    private TextField eventDiscriptionText;
    @FXML
    private DatePicker eventDatePicker;
    @FXML
    private Label eventDate;
    @FXML
    private Label eventTimeLength;
    @FXML
    private ComboBox timeComboBox;
    @FXML
    private Slider eventPointSlider;
    @FXML
    private Label eventLocation;
    @FXML
    private TextField eventLocationText;
    @FXML
    private Label eventPoints;
    @FXML
    private TextField eventPointsText;
    @FXML
    private Button createEventButton;

    private ObservableList list = FXCollections.observableArrayList("12:00 AM","1:00 AM","2:00 AM","3:00 AM","4:00 AM","5:00 AM","6:00 AM","7:00 AM","8:00 AM","9:00 AM","10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM","9:00 PM","10:00 PM","11:00 PM");
    private String _email;
    private String _pass;
    private String nameOfEvent;
    private String description;
    private String location;
    private int points;
    private String eventDateFromPicker;
    private String time;
    public secondPageGUI home;

    public createEventGUI(){
    }

    public void initData(String email, String password,secondPageGUI curr){
        this._email = email;
        this._pass = password;
        this.home = curr;
        System.out.println(this._email + "," + this._pass);

    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources){

        try{
            timeComboBox.setItems(this.list);
            timeComboBox.setVisibleRowCount(4);
            timeComboBox.setValue("12:00 AM");
            this.time = "12:00 AM";
            LocalDate timmer;
            eventDatePicker.setValue(LocalDate.now());

            eventPointSlider.valueProperty().addListener(new ChangeListener<Number>() {
                @Override
                public void changed(ObservableValue<? extends Number> observable, Number oldValue, Number newValue) {
                    eventPointsText.textProperty().setValue(String.valueOf((int)eventPointSlider.getValue()));
                }
            });

            BooleanBinding bb = new BooleanBinding() {
                {
                    super.bind(nameText.textProperty(),eventDiscriptionText.textProperty(),
                            eventLocationText.textProperty(),eventPointsText.textProperty(),
                            timeComboBox.valueProperty(), eventDatePicker.valueProperty());
                }
                @Override
                protected boolean computeValue() {
                    return (nameText.getText().isEmpty()
                    || eventDiscriptionText.getText().isEmpty()
                    || eventLocationText.getText().isEmpty()
                    || eventPointsText.getText().isEmpty()
                    || timeComboBox.getItems().isEmpty()
                    || eventDatePicker.getValue().toString().isEmpty()
                    );
                }

            };

            createEventButton.disableProperty().bind(bb);
            getAllText();

        }catch(Exception e){
            e.printStackTrace();
        }

    }

    private void getAllText(){

        createEventButton.setOnAction(e -> {

            this.setVar(nameText.getText(),0);
            this.setVar(eventDiscriptionText.getText(),1);
            this.setVar(eventLocationText.getText(),2);
            this.setVar(eventPointsText.getText(),3);


            if(createEvent(this._email,this._pass,this.nameOfEvent,this.description,this.eventDateFromPicker,this.time,this.location,this.points)){
                //System.out.println("successsssss\n");
                home.initData(this._email,this._pass);
                AlertBox.display("Success","Successfully Created An Event");
                Stage stage = (Stage) createEventButton.getScene().getWindow();
                stage.close();
                //display alertbox
            }


            //System.out.print("name: " + this.nameOfEvent + "\ndesc: " + this.description + "\nloc: " + this.location + "\npoints: "+ this.points + "\ndate: " + this.eventDateFromPicker + "\ntime: " + this.time +"\n");
        });



        eventDatePicker.setOnAction(e -> {
            this.eventDateFromPicker = eventDatePicker.getValue().toString();
        });

        timeComboBox.setOnAction(e -> {
            this.time = timeComboBox.getValue().toString();

        });

    }

    private boolean createEvent(String _email, String _pass, String _nameOfEvent,String _description,String _eventDateFromPicker,String _time,String _location,int _points) {
        //emailStr = String.valueOf( _email);
        //passwordStr = String.valueOf(_password);


        Organization org = new Organization();
        try{
            org.addEvent(_email,_pass,_nameOfEvent,_description,_eventDateFromPicker,_time,_location,_points);

            return true;
        }catch(ParseException a){
            return false;
            //a.printStackTrace();
        }




        //System.out.println("Got credentials: "+emailStr+", "+passwordStr);
    }



    private void setVar(String value, int type) {
        switch (type) {
            case 0:
                this.nameOfEvent = value;
                break;
            case 1:
                this.description = value;
                break;
            case 2:
                this.location = value;
                break;
            case 3:
                try{
                    this.points = Integer.parseInt(value);
                }catch(NumberFormatException e){
                    e.printStackTrace();
                }
                //this.points = value;
                break;
        }
    }

}
