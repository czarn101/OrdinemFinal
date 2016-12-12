package com.Ordinem;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.image.ImageView;
import com.sun.javafx.collections.ObservableListWrapper;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.AnchorPane;

import java.net.URL;
import java.util.LinkedList;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by Albert on 12/8/16.
 */
public class orgSettingPageGUI  implements Initializable{

    @FXML
    private AnchorPane myPlane;
    @FXML
    private Label orgSettings;
    @FXML
    private ImageView ordinemBackground;
    @FXML
    private ImageView ordinemLogo;
    @FXML
    private TableView<Org> orgTable;
    @FXML
    private TableColumn<Org,String> Name;
    @FXML
    private TableColumn<Org,String> Email;
    @FXML
    private TableColumn<Org,String> Password;
    @FXML
    private ComboBox choiceSelector;
    @FXML
    private Button updateSettings;
    @FXML
    private Label selectorChoiceLbl;
    @FXML
    private TextField selectorChoiceText;
    @FXML
    private TextField passConfirmText;
    @FXML
    private Label passConfirmLbl;

    private String _email;
    private String _pass;
    private String labelName;
    private String newName;
    private String newEmail;
    private String newPassword;
    private String confirmPassword;
    private int prevVal = 0;
    private int val = 3;

    //private String choice;
    List<Org> items;
    private ObservableList list = FXCollections.observableArrayList("Name","Email","Password");

    public orgSettingPageGUI(){

    }
    public static class Org {

        private String[] data;

        public Org(String... data) {
            this.data = data;
        }

        public String getName() {
            return data[0];
        }

        public String getEmail() {
            return data[1];
        }

        public String getPassword() {
            return data[2];
        }

    }

    public void initData(String email, String password){
        this._email = email;
        this._pass = password;
        System.out.println(this._email + "," + this._pass);
        selectorChoiceLbl.setText("New Name: ");
        Organization organization = new Organization();
        List<String> data = organization.getTable(this._email.trim(),this._pass.trim());
        items = new LinkedList<>();
        //organization.editOrg(this._email.trim(),this._pass.trim());
        int i = 0;
        while (i < data.size()) {
            items.add(new Org(data.get(i++), data.get(i++), data.get(i++)));
        }
        setTableCol();

    }

    public void setTableCol(){
        orgTable.setItems(new ObservableListWrapper<>(items));
        Name.setCellValueFactory(new PropertyValueFactory<>("name"));
        Email.setCellValueFactory(new PropertyValueFactory<>("email"));
        Password.setCellValueFactory(new PropertyValueFactory<>("password"));

    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources){
        choiceSelector.setItems(this.list);
        choiceSelector.setVisibleRowCount(4);
        choiceSelector.setValue("Name");
        this.setVar(selectorChoiceText.getText(),0);
        System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");


        this.setVar("",0);
        getSettingsText();
        //selectorChoiceLbl.setText(labelName);


    }

    private void getSettingsText(){



        choiceSelector.setOnAction(e -> {

            String choice = choiceSelector.getValue().toString();


            if(choice.trim().equals("Name")){
                //selectorChoiceText.clear();
                selectorChoiceLbl.setText("New Name: ");
                passConfirmLbl.setVisible(false);
                passConfirmText.setVisible(false);

                this.setVar(selectorChoiceText.getText(),prevVal);

                System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");

                prevVal = 0;

            }else if(choice.trim().equals("Email")){
                //
                selectorChoiceLbl.setText("New Email: ");
                passConfirmLbl.setVisible(false);
                passConfirmText.setVisible(false);

                this.setVar(selectorChoiceText.getText(),prevVal);

                System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");
                prevVal = 1;
            }else if(choice.trim().equals("Password")){

                selectorChoiceLbl.setText("New Password: ");
                passConfirmLbl.setVisible(true);
                passConfirmText.setVisible(true);

                this.setVar(selectorChoiceText.getText(),prevVal);
                this.setVar(passConfirmText.getText(),val);
                System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");

                prevVal = 2;
                val = 3;
            }

            //System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");
            selectorChoiceText.clear();
            passConfirmText.clear();
            this.setVar("",0);
            this.setVar("",1);
            this.setVar("",2);
            this.setVar("",3);
            choice = null;

        });




    }

    private void setVar(String value, int type) {
        switch (type) {
            case 0:
                this.newName = value;
                break;
            case 1:
                this.newEmail = value;
                break;
            case 2:
                this.newPassword = value;
                break;
            case 3:
                this.confirmPassword = value;
                //this.points = value;
                break;
        }
    }
}
