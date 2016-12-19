package com.Ordinem;//package sample;

import com.Ordinem.secondPage.*;
import javafx.application.Application;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
//import javafx.geometry.Insets;
import javafx.scene.AccessibleRole;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.BackgroundImage;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundRepeat;
import javafx.scene.layout.BackgroundPosition;
import javafx.scene.layout.BackgroundSize;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import javafx.geometry.*;
//import java.io.*;

//import java.awt.*;
import java.io.IOException;

//import java.awt.*;

public class StartGUI extends Application {

    Stage window;
    private String emailStr = null;
    private String passwordStr = null;

    @FXML private GridPane grid;
    @FXML private Label loginLabel;
    @FXML private Label emailLabel;
    @FXML private TextField emailInput;
    @FXML private Label passLabel;
    @FXML private TextField passInput;
    @FXML private Button loginButton;
    //@FXML private ImageView backGround;


    @Override
    public void start(Stage primaryStage) throws Exception{
        /*
        Parent root = FXMLLoader.load(getClass().getResource("sample.fxml"));
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(new Scene(root, 300, 275));
        primaryStage.show();
        */
        window = primaryStage;


        //then you set to your node

        window.setTitle("Ordinem");

        grid = new GridPane();



        grid.setPadding(new Insets(10,10,10,10));
        grid.setAlignment(Pos.CENTER);
        grid.setVgap(8);
        grid.setHgap(10);
        loginLabel = new Label("Organization Login Portal");
        GridPane.setConstraints(loginLabel,2,0);
        emailLabel = new Label("Email:");
        GridPane.setConstraints(emailLabel,0,1);
        emailInput = new TextField();
        emailInput.setPromptText("email");
        GridPane.setConstraints(emailInput,2,1);
        passLabel = new Label("Password:");
        GridPane.setConstraints(passLabel,0,2);
        //password input
        passInput = new PasswordField();
        passInput.setPromptText("password");

        GridPane.setConstraints(passInput,2,2);
        loginButton = new Button("Log In");
        GridPane.setConstraints(loginButton,2,3);
        //System.out.println(this.emailStr+", "+this.passwordStr);
        grid.getChildren().addAll(loginLabel,emailLabel,emailInput,passLabel,passInput,loginButton);


        loginButton.setOnAction(e -> {
            this.setVar(emailInput.getText(), 0);
            this.setVar(passInput.getText(), 1);
            if(login(this.emailStr, this.passwordStr)){
                //open up a new scene
                try{
                    FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("secondPage.fxml"));

                    Parent root1 = fxmlLoader.load();
                    Stage stage = new Stage();
                    stage.setTitle("Ordinem");
                    stage.setScene(new Scene(root1));
                    secondPageGUI controller =
                            fxmlLoader.<secondPageGUI>getController();
                    System.out.println(this.emailStr+", "+this.passwordStr);
                    controller.initData(this.emailStr, this.passwordStr);
                    stage.show();
                    //secondPageGUI secondPageGUI = new secondPageGUI(email,password);

                    window.close();
                }catch(Exception a){
                    a.printStackTrace();
                }

            }else{
                AlertBox.display("Error!","Email Or Password Does Not Match.");
                //alert user email or password does not match
                //System.out.println("Email or password does not match");
                emailInput.clear();
                passInput.clear();

            }




        });

        Scene scene = new Scene(grid, 550,200);
        window.setScene(scene);
        window.show();
    }

    private void setVar(String value, int type) {
        switch (type) {
            case 0:
                this.emailStr = value;
                break;
            case 1:
                this.passwordStr = value;
                break;
        }
    }

    private boolean login(String _email, String _password) {
        emailStr = String.valueOf( _email);
        passwordStr = String.valueOf(_password);

        Admin admin = new Admin();
        if(admin.retrieveCredentials(emailStr,passwordStr)){
            //take them to the next login page
            return true;

        }else{
            return false;
        }

        //System.out.println("Got credentials: "+emailStr+", "+passwordStr);
    }

    private boolean isInt(TextField input, String message){
        try{
            int age = Integer.parseInt(input.getText());
            return true;
        }catch(NumberFormatException e){
            System.out.println("Input is not a integer ");
            return false;
        }
    }


    public static void main(String[] args) {
        launch(args);
    }
}