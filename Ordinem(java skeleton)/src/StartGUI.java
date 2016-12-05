//package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
//import javafx.geometry.Insets;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import javafx.geometry.*;
import javafx.scene.*;

//import java.awt.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;

//import java.awt.*;

public class StartGUI extends Application {

    Stage window;
    private String emailStr = null;
    private String passwordStr = null;


    @Override
    public void start(Stage primaryStage) throws Exception{
        /*
        Parent root = FXMLLoader.load(getClass().getResource("sample.fxml"));
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(new Scene(root, 300, 275));
        primaryStage.show();
        */
        window = primaryStage;
        window.setTitle("Ordinem");

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(10,10,10,10));

        grid.setAlignment(Pos.CENTER);
        grid.setVgap(8);
        grid.setHgap(10);

        Label loginLabel = new Label("Organization Login Portal");
        GridPane.setConstraints(loginLabel,2,0);

        Label emailLabel = new Label("Email:");
        GridPane.setConstraints(emailLabel,0,1);

        TextField emailInput = new TextField();
        GridPane.setConstraints(emailInput,2,1);

        Label passLabel = new Label("Password:");
        GridPane.setConstraints(passLabel,0,2);

        //password input
        TextField passInput = new TextField();
        passInput.setPromptText("password");

        GridPane.setConstraints(passInput,2,2);

        Button loginButton = new Button("Log In");
        GridPane.setConstraints(loginButton,2,3);
        String email = "";
        String password;


        loginButton.setOnAction(e -> {
            if(login(emailInput.getText(), passInput.getText())){
                try {
                    FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/fxml/myEvents.fxml"));
                    Parent root1 = (Parent) fxmlLoader.load();
                    Stage stage = new Stage();
                    stage.setScene(new Scene(root1));
                    stage.show();
                } catch(Exception a) {
                    a.printStackTrace();
                }

            }else{
                Alert alert = new Alert(Alert.AlertType.INFORMATION);
                alert.setTitle("Error");
                alert.setHeaderText("Invalid Input");
                alert.setContentText("Email or Password does not match");
                alert.showAndWait().ifPresent(rs -> {
                    if (rs == ButtonType.OK) {
                        System.out.println("Pressed OK.");
                    }
                });
            }
        });

        grid.getChildren().addAll(loginLabel,emailLabel,emailInput,passLabel,passInput,loginButton);

        Scene scene = new Scene(grid, 550,200);
        window.setScene(scene);
        window.show();
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