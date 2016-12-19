package com.Ordinem;

import javafx.beans.binding.BooleanBinding;
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
import javafx.stage.Stage;


/**
 * Created by Albert on 12/8/16.
 */
public class orgSettingPageGUI  implements Initializable {

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
    private TableColumn<Org, String> Name;
    @FXML
    private TableColumn<Org, String> Email;
    @FXML
    private TableColumn<Org, String> Password;
    @FXML
    private ComboBox choiceSelector;
    @FXML
    private Button updateSettings;
    @FXML
    private Label selectorChoiceLbl;
    @FXML
    private TextField selectorChoiceText;


    private String _email;
    private String _pass;
    private String labelName;
    private String newName;
    private String newEmail;
    private String newPassword;

    private String confirmPassword;
    private int prevVal = 0;
    private int val = 3;
    private String choice;
    private int indexOfComboBox;
    private secondPageGUI home;

    //private String choice;
    List<Org> items;
    private ObservableList list = FXCollections.observableArrayList("Name", "Email", "Password");

    public orgSettingPageGUI() {

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


    public void initData(String email, String password, secondPageGUI _home) {
        this._email = email;
        this._pass = password;
        this.home = _home;
        System.out.println(this._email + "," + this._pass);

        Organization organization = new Organization();
        List<String> data = organization.getTable(this._email.trim(), this._pass.trim());
        System.out.print(data);
        items = new LinkedList<>();
        //organization.editOrg(this._email.trim(),this._pass.trim());
        int i = 0;
        while (i < data.size()) {
            items.add(new Org(data.get(i++), data.get(i++), data.get(i++)));
        }
        setTableCol();

    }

    public void setTableCol() {
        orgTable.setItems(new ObservableListWrapper<>(items));
        Name.setCellValueFactory(new PropertyValueFactory<>("name"));
        Email.setCellValueFactory(new PropertyValueFactory<>("email"));
        Password.setCellValueFactory(new PropertyValueFactory<>("password"));

    }

    @Override
    public void initialize(URL fxmlFileLocation, ResourceBundle resources) {
        choiceSelector.setItems(this.list);
        choiceSelector.setVisibleRowCount(4);
        //choiceSelector.setValue("Name");
        //choice = "Name".trim();
        //this.setVar(selectorChoiceText.getText(),0);
        //System.out.println("newName: " + this.newName + "\nnewEmail: " + this.newEmail + "\nnewPass: " + this.newPassword + "\nconfirm: " + this.confirmPassword + "\n");

        BooleanBinding bb = new BooleanBinding() {
            {
                super.bind(selectorChoiceText.textProperty(),choiceSelector.valueProperty());
            }
            @Override
            protected boolean computeValue() {
                return (selectorChoiceText.getText().isEmpty()
                        || choiceSelector.getItems().isEmpty()

                );
            }

        };

        updateSettings.disableProperty().bind(bb);
        getSettingsText();

    }

    private void getSettingsText() {

        choiceSelector.setOnAction(e -> {

            choice = choiceSelector.getValue().toString().trim();

            if(choice.equals("Name")){

                this.selectorChoiceLbl.setText("New Name:");
                //this.setVar(selectorChoiceText.getText(),prevVal);
                //prevVal = 0;

            }else if(choice.equals("Email")){

                this.selectorChoiceLbl.setText("New Email:");
                //this.setVar(selectorChoiceText.getText(),prevVal);
                prevVal = 1;

            }else if(choice.equals("Password")){

                this.selectorChoiceLbl.setText("New Password:");

                prevVal = 2;
            }
            //selectorChoiceText.clear();
        });

        updateSettings.setOnAction(a -> {
            Organization org = new Organization();
            if(choice.equals("Name")){
                setVar(selectorChoiceText.getText(),0);
                setIndex(1);

                if(org.editOrg(this._email,this._pass,this.indexOfComboBox,this.newName,null,null)){
                    initData(this._email,this._pass, this.home);
                    AlertBox.display("Success","Successfully Updated The Database.");
                    //Stage stage = (Stage) updateSettings.getScene().getWindow();
                    //stage.close();
                }else{
                    System.out.println("error name");
                }

            }
            else if(choice.equals("Email")){
                setVar(selectorChoiceText.getText(),1);
                setIndex(2);
                if(org.editOrg(this._email,this._pass,this.indexOfComboBox,null,this.newEmail,null)){
                    this._email = newEmail;
                    initData(this._email,this._pass, this.home);

                    this.home.setEmail(newEmail);
                    AlertBox.display("Success","Successfully Updated The Database.");
                    //Stage stage = (Stage) updateSettings.getScene().getWindow();
                    //stage.close();

                }else{
                    System.out.println("error email");
                }

            }
            else if(choice.equals("Password")){
                setVar(selectorChoiceText.getText(),2);
                setIndex(3);

                if(org.editOrg(this._email,this._pass,this.indexOfComboBox,null,null,this.newPassword)){
                    this._pass = newPassword;
                    initData(this._email,this._pass, this.home);
                    this.home.setPass(newPassword);
                    AlertBox.display("Success","Successfully Updated The Database.");
                    //Stage stage = (Stage) updateSettings.getScene().getWindow();
                    //stage.close();
                }else{
                    System.out.println("error pass");
                }

            }
            //System.out.println("name: " + this.newName + "\nemail: " + this.newEmail + "\npass: " + this.newPassword + "\n");

            selectorChoiceText.clear();
        });

    }

    private void setIndex(int type){
        switch (type) {
            case 1:
                this.indexOfComboBox = type;
                break;
            case 2:
                this.indexOfComboBox = type;
                break;
            case 3:
                this.indexOfComboBox = type;
                break;

        }
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

        }
    }

}
