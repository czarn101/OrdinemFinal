package com.Ordinem;

import com.sun.javafx.collections.IntegerArraySyncer;
import com.sun.javafx.collections.ObservableListWrapper;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.BubbleChart;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.AnchorPane;
import javafx.scene.image.*;
import java.net.URL;
import java.util.LinkedList;
import java.util.List;
import java.util.ResourceBundle;


/**
 * Created by Albert on 12/14/16.
 */
public class startEventGUI implements Initializable{


    @FXML
    private AnchorPane myPlane;
    @FXML
    private ImageView ordinemBack;
    @FXML
    private TableView<CheckIn> checkInTable;
    @FXML
    private TableColumn<CheckIn,String> checkInStudentID;
    @FXML
    private TableColumn<CheckIn,String> checkInDate;
    @FXML
    private ImageView ordinemLogo;
    @FXML
    private TextField enterIDText;
    @FXML
    private Label enterstudLbl;
    @FXML
    private Button enterButton;

    private int eventID;
    private String studID;
    List<CheckIn> items;


    public static class CheckIn {

        private String[] data;

        public CheckIn(String... data) {
            this.data = data;
        }

        public String getStudentID() {
            return data[0];
        }

        public String getDate() {
            return data[1];
        }



    }

    public startEventGUI(){

    }

    public void initData(int _eventID) {

        this.eventID = _eventID;

        System.out.println(this.eventID);
        Organization organization = new Organization();

        List<String> data = organization.getCheckIn(this.eventID);
        //System.out.print(data);
        items = new LinkedList<>();

        int i = 0;
        while (i < data.size()) {
            items.add(new CheckIn(data.get(i++), data.get(i++)));
        }
        setTableCol();

    }

    public void setTableCol() {
        checkInTable.setItems(new ObservableListWrapper<>(items));
        checkInStudentID.setCellValueFactory(new PropertyValueFactory<>("StudentID"));
        checkInDate.setCellValueFactory(new PropertyValueFactory<>("Date"));

    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources) {
        enterButton.setOnAction(e -> {

            this.setVar(enterIDText.getText());

            try{
                int studentID = Integer.parseInt(this.studID);
                Organization org = new Organization();
                org.insertID(studentID,this.eventID);

                initData(this.eventID);
                //System.out.println("id: " + this.studID);
                enterIDText.clear();

            }catch(Exception a){
                AlertBox.display("Error!","Input Must Be An Integer.");
                enterIDText.clear();
                //a.printStackTrace();
            }







        });

    }

    private void setVar(String value) {
        this.studID = value;
    }


}
