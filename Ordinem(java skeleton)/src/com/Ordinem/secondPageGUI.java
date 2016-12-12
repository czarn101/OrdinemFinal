package com.Ordinem;

import com.sun.javafx.collections.ObservableListWrapper;
//import com.sun.org.apache.xpath.internal.operations.String;
import javafx.collections.ObservableList;

import java.net.URL;
import java.util.*;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;

import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;

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
    private TableColumn<Event, String> eventTime;
    @FXML
    private TableColumn<Event, String> eventLength;
    @FXML
    private TableColumn<Event, String> eventPoints;
    @FXML
    private TableColumn<Event, String> eventLocation;

    private String _email;
    private String _pass;
    List<Event> items;
    //ArrayList<String> myEvents = new ArrayList<>();
    //ObservableList<String> hey;

    public secondPageGUI() {
        //this._email = email;
        //this._pass = pass;
    }

    public static class Event {

        private String[] data;

        public Event(String... data) {
            this.data = data;
        }


        public String getName() {
            return data[0];
        }

        public String getTime() {
            return data[1];
        }

        public String getLength() {
            return data[2];
        }

        public String getLocation() {
            return data[3];
        }

        public String getPoints() {
            return data[4];
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
            items.add(new Event(data.get(i++), data.get(i++), data.get(i++), data.get(i++), data.get(i++)));
        }

        setTableCol();

    }

    public void setTableCol(){
        eventTable.setItems(new ObservableListWrapper<>(items));
        eventName.setCellValueFactory(new PropertyValueFactory<>("name"));
        eventTime.setCellValueFactory(new PropertyValueFactory<>("time"));
        eventLength.setCellValueFactory(new PropertyValueFactory<>("length"));
        eventPoints.setCellValueFactory(new PropertyValueFactory<>("points"));
        eventLocation.setCellValueFactory(new PropertyValueFactory<>("location"));
    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources) {
        //Organization org = new Organization();


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
                controller.initData(this._email,this._pass);

                stage.show();

            }catch(Exception a){
                a.printStackTrace();
            }

        });
    }
    /*
    public ArrayList<String> parseUserList() {
       return myEvents;
    }
    */


    /*
    public void start(Stage primaryStage){


        window = primaryStage;
        //window.setTitle("Ordinem");

        myPlane.getChildren().addAll(createEvent,orgSettings,logOut,viewUpcomingEvents,eventTable,ordinemLogo);



        createEvent.setOnAction(e -> {
            System.out.println("hi");
        });



        Scene scene = new Scene(myPlane);
        window.setScene(scene);
        window.show();

    }




    public static void main(String[] args) {
        launch(args);
    } */
}
