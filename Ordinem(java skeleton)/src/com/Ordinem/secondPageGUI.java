package com.Ordinem;

import com.sun.javafx.collections.IntegerArraySyncer;
import com.sun.javafx.collections.ObservableListWrapper;
//import com.sun.org.apache.xpath.internal.operations.String;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.property.IntegerProperty;
import javafx.collections.ObservableList;
import java.lang.Object;
import java.net.URL;
import java.security.spec.ECField;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.control.TableColumn.CellEditEvent;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.TableView.TableViewSelectionModel;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;
import javafx.event.EventHandler;
import javafx.beans.property.BooleanProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.*;

import java.util.List;

/**
 * Created by Albert on 12/5/16.
 */
public class secondPageGUI implements Initializable {

    //Stage window;
    @FXML
    private Button createEvent;
    @FXML
    private Button orgSettings;
    @FXML
    private Button logOut;
    @FXML
    private Button startEvent;
    @FXML
    private AnchorPane myPlane;
    @FXML
    private Label viewAllEvents;
    @FXML
    private Label eventManager;
    @FXML
    private Label settings;
    @FXML
    private ImageView ordinemTitle;

    @FXML
    private TableView<Event> eventTable;
    @FXML
    private TableColumn<Event, String> eventName;
    @FXML
    private TableColumn<Event, String> eventDate;
    @FXML
    private TableColumn<Event, String> eventTime;
    @FXML
    private TableColumn<Event, String> eventPoints;
    @FXML
    private TableColumn<Event, String> eventLocation;
    @FXML
    private TableColumn<Event, String> eventLive;
    @FXML
    private TableColumn<Event, String> eventID;

    private String _email;
    private String _pass;
    private boolean willVisible = false;
    private int rowIndex;
    private int currentID;

    List<Event> items;
    List<Event> isliveCol;
    //ArrayList<String> myEvents = new ArrayList<>();
    //ObservableList<String> hey;

    public secondPageGUI() {
        //this._email = email;
        //this._pass = pass;

    }

    public void setEmail(String newVal) { this._email=newVal; }
    public void setPass(String newVal) { this._pass=newVal; }

    public static class Event {

        private String[] data;


        public Event(String... data) {

            this.data = data;

        }

        public String getID(){ return data[0]; }

        public String getName() {
            return data[1];
        }

        public String getDate() {
            return data[2];
        }

        public String getTime() {
            return data[3];
        }

        public String getLocation() {
            return data[4];
        }

        public String getPoints() {
            return data[5];
        }

        public String getLive() { return data[6]; }

        public void setLive(String newVal){
            data[6] = newVal;
        }




    }

    public void initData(String email, String pass) {
        this._email = email;
        this._pass = pass;



        Organization organization = new Organization();

        //all events in a list
        List<String> data = organization.getAllEvents(this._email, this._pass);

        //linked list of events
        items = new LinkedList<>();

        int i = 0;
        while (i < data.size()) {
            items.add(new Event(data.get(i++),data.get(i++), data.get(i++), data.get(i++), data.get(i++), data.get(i++), data.get(i++)));


        }

        setTableCol();

    }

    public void setTableCol(){
        eventTable.setItems(new ObservableListWrapper<>(items));

        eventID.setCellValueFactory(new PropertyValueFactory<>("ID"));
        eventName.setCellValueFactory(new PropertyValueFactory<>("name"));
        eventDate.setCellValueFactory(new PropertyValueFactory<>("date"));
        eventTime.setCellValueFactory(new PropertyValueFactory<>("time"));
        eventPoints.setCellValueFactory(new PropertyValueFactory<>("points"));
        eventLocation.setCellValueFactory(new PropertyValueFactory<>("location"));
        eventLive.setCellValueFactory(new PropertyValueFactory<>("live"));




    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources) {
        //Organization org = new Organization();

        startEvent.setVisible(willVisible);



        //eventTable.getItems().setAll();
        createEvent.setOnAction(e -> {
            try {
                FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("createEvent.fxml"));

                Parent root1 = fxmlLoader.load();
                Stage stage = new Stage();
                stage.setTitle("Ordinem");
                stage.setScene(new Scene(root1));
                createEventGUI controller =
                        fxmlLoader.<createEventGUI>getController();
                //controller.home = this;
                controller.initData(this._email,this._pass,this);

                stage.show();

            }catch(Exception a){
                a.printStackTrace();
            }


        });

        orgSettings.setOnAction(e -> {

            try {
                FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("orgSettingsPage.fxml"));

                Parent root1 = fxmlLoader.load();
                Stage stage = new Stage();
                stage.setTitle("Ordinem");
                stage.setScene(new Scene(root1));
                orgSettingPageGUI controller =
                        fxmlLoader.<orgSettingPageGUI>getController();
                //controller.home = this;
                controller.initData(this._email,this._pass, this);

                stage.show();

            }catch(Exception a){
                a.printStackTrace();
            }

        });

        logOut.setOnAction(e -> {
            System.exit(0);
        });

        eventTable.setRowFactory( tv -> {
            TableRow<Event> row = new TableRow<>();
            row.setOnMouseClicked(event -> {
                if (event.getClickCount() == 1 && (! row.isEmpty()) ) {
                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    //DateFormat dateFormat2 = new SimpleDateFormat("HH:mm");

                    Event rowData = row.getItem();
                    currentID = Integer.parseInt(rowData.getID());
                    rowIndex = row.getIndex();
                    //System.out.println(rowIndex);
                    Date todayDate = new Date();

                    String time1 = rowData.getTime();

                    String time = "";

                    if(time1.trim().equals("Midnight")){
                        time = "24:00";
                    }else if(time1.trim().equals("12:00 PM")){
                        time = "12:00";
                    }else if(time1.trim().equals("12:30 PM")){
                        time = "12:30";
                    }else if(time1.trim().equals("00:00 AM")){
                        time = "00:00";
                    }else if(time1.trim().equals("00:30 AM")){
                        time = "00:30";
                    }else if(time1.trim().equals("1:00 PM")){
                        time = "13:00";
                    }else if(time1.trim().equals("1:30 PM")){
                        time = "13:30";
                    }else if(time1.trim().equals("2:00 PM")){
                        time = "14:00";
                    }else if(time1.trim().equals("2:30 PM")){
                        time = "14:30";
                    }else if(time1.trim().equals("3:00 PM")){
                        time = "15:00";
                    }else if(time1.trim().equals("3:30 PM")){
                        time = "15:30";
                    }else if(time1.trim().equals("4:00 PM")){
                        time = "16:00";
                    }else if(time1.trim().equals("4:30 PM")){
                        time = "16:30";
                    }else if(time1.trim().equals("5:00 PM")){
                        time = "17:00";
                    }else if(time1.trim().equals("5:30 PM")){
                        time = "17:30";
                    }else if(time1.trim().equals("6:00 PM")){
                        time = "18:00";
                    }else if(time1.trim().equals("6:30 PM")){
                        time = "18:30";
                    }else if(time1.trim().equals("7:00 PM")){
                        time = "19:00";
                    }else if(time1.trim().equals("7:30 PM")){
                        time = "19:30";
                    }else if(time1.trim().equals("8:00 PM")){
                        time = "20:00";
                    }else if(time1.trim().equals("8:30 PM")){
                        time = "20:30";
                    }else if(time1.trim().equals("9:00 PM")){
                        time = "21:00";
                    }else if(time1.trim().equals("9:30 PM")){
                        time = "21:30";
                    }else if(time1.trim().equals("10:00 PM")){
                        time = "22:00";
                    }else if(time1.trim().equals("10:30 PM")){
                        time = "22:30";
                    }else if(time1.trim().equals("11:00 PM")){
                        time = "23:00";
                    }else if(time1.trim().equals("11:30 PM")){
                        time = "23:30";
                    }else{
                        time = time1.substring(0, time1.length()-2);
                    }
                    String eventTime = rowData.getDate() + " " + time;
                    Date eventFullDate = new Date();
                    try{
                        eventFullDate = dateFormat.parse(eventTime);
                        String temp = dateFormat.format(eventFullDate);
                        String temp2 = dateFormat.format(todayDate);
                        System.out.println(temp);
                        System.out.println(temp2);
                    }catch(Exception e){
                        e.printStackTrace();
                    }

                    long diff = eventFullDate.getTime() - todayDate.getTime();
                    System.out.println("diff: " + diff);
                    long diffSeconds = diff / 1000 % 60;
                    long diffMinutes = diff / (60 * 1000) % 60;

                    long diffHours = diff / (60 * 60 * 1000);
                    System.out.println("diffMin: " + diffMinutes);
                    System.out.println("diffHours: " + diffHours);
                    //System.out.print(todayDate.getTime());
                    int diffInDays = (int) ((eventFullDate.getTime() - todayDate.getTime()) / (1000 * 60 * 60 * 24));

                    //
                    if(diffHours < 1){
                        if ((diffMinutes >= 0) && (diffMinutes <= 30)){
                            System.err.println("minutes");
                            willVisible = true;
                            startEvent.setVisible(willVisible);

                            //return false;
                        }else{
                            willVisible = false;
                            startEvent.setVisible(willVisible);
                        }
                    }

                }
            });
            return row;

        });

        startEvent.setOnAction(e -> {
            Organization org = new Organization();

            try{
                org.editLive("Live",this.currentID);
                initData(this._email,this._pass);

                FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("startEvent.fxml"));

                Parent root1 = fxmlLoader.load();
                Stage stage = new Stage();
                stage.setTitle("Ordinem");
                stage.setScene(new Scene(root1));
                startEventGUI controller = fxmlLoader.<startEventGUI>getController();
                //controller.home = this;
                controller.initData(this.currentID);

                stage.show();


            }catch(Exception a){
                a.printStackTrace();

            }

        });


    }

}
