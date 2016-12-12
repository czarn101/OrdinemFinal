package com.Ordinem;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Admin {

    private String email;
    private String password;
    private int organID;

    public Admin() {

        this.sql = new SQLConnector("acsm_6cac058ec0c0df1", // database name
                "jdbc:mysql://us-cdbr-azure-west-b.cleardb.com:3306/acsm_6cac058ec0c0df1", //connection url
                "bdee9cb0c426b0", // username
                "624cb96a"); // password

    }

    private SQLConnector sql;

    public void setEmail(String _email,String _pass){
        this.email = _email;
        this.password = _pass;
    }


    public boolean createOrg(){
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        String orgName = "";
        String orgPass = "";
        String orgEmail = "";
        int orgType = 0;

        System.out.println("----Create Organization----\n");
        ArrayList<String> orgNameByType = new ArrayList<String>();
        ArrayList<String> orgEmailByType = new ArrayList<String>();

        while(true){
            try{
                System.out.print("----Organization Types-----\n     1. Honor Society\n     2. Diversity/Cultural\n     3. Religious/Spiritual\n" +
                        "     4. Recreational\n     5. Greek Chapter\n     6. Leisure\n     7. Civic Engagement\n     8. Academic/Professional\nEnter Your Choice: ");
                String tempType = reader.readLine();
                orgType = Integer.parseInt(tempType);
                if(orgType <= 0 || orgType > 8){
                    System.out.println("Input must be between 1 and 8.\n");
                }
                else{
                    this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgName FROM organizations WHERE typeID = ?");
                    this.sql.pst.setInt(1,orgType);

                    if(this.sql.runSelect()){
                        while(this.sql.data.next()){
                            String orgNameType = this.sql.data.getString(1).toLowerCase();
                            orgNameByType.add(orgNameType);
                        }
                    }

                    this.sql.pst = this.sql.mysql.prepareStatement("SELECT email FROM organizations WHERE typeID = ?");
                    this.sql.pst.setInt(1,orgType);

                    if(this.sql.runSelect()){
                        while(this.sql.data.next()){
                            String orgEmailType = this.sql.data.getString(1).toLowerCase();
                            orgEmailByType.add(orgEmailType);
                        }
                    }
                    break;
                }
            }catch(NumberFormatException e){
                System.out.println("Input must be an integer.\n");
            }
            catch(IOException e){
                e.printStackTrace();
            }
            catch(SQLException e){
                System.out.println("SQL statement went wrong");
            }
        }

        try{
            while(true){
                System.out.print("Enter An Organization Name: ");
                orgName = reader.readLine();
                String tempName = orgName.toLowerCase();

                if(orgNameByType.contains(tempName)){
                    System.out.println("The Organization Name Already Exists.\n");
                }
                else{
                    while(true){
                        System.out.print("Enter An Organization Email: ");
                        orgEmail = reader.readLine();
                        String tempEmail = orgEmail.toLowerCase();
                        if(orgEmailByType.contains(tempEmail)){
                            System.out.println("The Organization Email Already Exists.\n");
                        }
                        else{
                            break;
                        }
                    }
                    System.out.print("Enter An Organization Password: ");
                    orgPass = reader.readLine();
                    break;
                }
            }
        }catch(IOException e){
            e.printStackTrace();
        }

        //you got all info to make an organization
        //update the organization database with that info

        try{
            String insert_sql_events = "INSERT INTO organizations (orgName,email,password,typeID)" + "VALUES (?,?,?,?)";
            this.sql.pst = this.sql.mysql.prepareStatement(insert_sql_events);
            this.sql.pst.setString(1,orgName);
            this.sql.pst.setString(2,orgEmail);
            this.sql.pst.setString(3,orgPass);
            this.sql.pst.setInt(4,orgType);

            if(this.sql.runUpdate()){
                System.out.println("Successfully Created An Organization\n");
            }

        }catch(SQLException e){
            System.out.println("Error Entering Organization");
        }
        return true;
    }



    public boolean retrieveCredentials(String _email, String _password) {
        //System.out.println("----Organization Login Portal----");
        //Scanner input = new Scanner(System.in);
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        while(true){
            try{
                //System.out.print("Email: ");
                //this.email = reader.readLine();
                //System.out.print("Password: ");
                //this.password = reader.readLine();

                //System.out.println("One moment please...");
                this.sql.pst = this.sql.mysql.prepareStatement("SELECT email FROM organizations WHERE email=?");
                this.sql.pst.setString(1,_email);
                String databaseEmail = "";
                if(this.sql.runSelect()){
                    if(this.sql.data.next()){
                        databaseEmail = this.sql.data.getString(1);
                    }
                }
                this.sql.pst = this.sql.mysql.prepareStatement("SELECT password FROM organizations WHERE email=?");
                this.sql.pst.setString(1,_email);

                String databasePassword = "";
                if(this.sql.runSelect()){
                    if(this.sql.data.next()){
                        databasePassword = this.sql.data.getString(1);
                    }
                }

                if(databaseEmail.trim().equals(_email) && databasePassword.trim().equals(_password)){
                    //System.out.println("Successfully Logged In\n");

                    //Organization org = new Organization();
                    setEmail(_email,_password);
                    //org.printMenu();

                    return true;
                }
                else{
                    //System.out.println("Email Or Password Does Not Match\n");
                    return false;

                }
            }catch(SQLException e ){
                //System.out.println("SQL went wrong\n");
                return false;
            }
        }
    }

}




