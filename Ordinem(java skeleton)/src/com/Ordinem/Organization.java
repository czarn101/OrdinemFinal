package com.Ordinem;


import javafx.beans.InvalidationListener;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;

import java.sql.SQLException;
import java.text.ParseException;
//import java.util.Date;
import java.util.Calendar;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
//import java.util.Scanner;
import java.util.*;
import java.io.*;

public class Organization {

    private String email;
    private String password;
    private int organID;
    private SQLConnector sql;

    public void setEmail(String _email,String _pass){
        this.email = _email;
        this.password = _pass;
    }

    public Organization() {
        this.sql = new SQLConnector("acsm_6cac058ec0c0df1", // database name
                "jdbc:mysql://us-cdbr-azure-west-b.cleardb.com:3306/acsm_6cac058ec0c0df1", //connection url
                "bdee9cb0c426b0", // username
                "624cb96a"); // password
    }


    public void printMenu(){
        int choice = 0;
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while(true){
            try{
                /*
                System.out.println("----Login Menu----");
                System.out.println("1.Edit Organization");
                System.out.println("2.View My Events");
                System.out.println("3.Create New Event");
                System.out.println("4.Delete Organization");
                System.out.println("5.Log out");
                System.out.print("Enter your choice: ");

                choice =  Integer.parseInt(reader.readLine());
                */
                if(choice == 1){ //not done
                    //edit organization
                    //stop the loop
                    editOrg(this.email,this.password);

                }
                else if(choice == 2){ //not dont
                    //view events
                    //stop loop
                    System.out.println();
                    printEventMenu();
                }
                else if(choice == 3){ //done
                    //add event
                    //stop loop
                    //addEvent(this.email,this.password);

                }
                else if(choice == 4){
                    //delete org
                    deleteOrg();
                }
                else if(choice == 5){
                    this.sql.close();
                    System.exit(0);
                    break;
                }
                else{
                    System.out.println("Input must be 1,2 or 3\n");
                }
            }catch(Exception e){
                System.out.println("Input must be 1,2 or 3\n");
            }
        }
    }

    public List<String> getTable(String _email, String _password){
        ArrayList<String> org = new ArrayList<String>();

        try{
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgName,email,password FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            if(this.sql.runSelect()){
                String[] cols = {"orgName","email","password"};
                //String orgToEdit = this.sql.getColumns(cols);
                org = this.sql.getArrayCol(cols);
                //System.out.println(orgToEdit);
            }
        }catch (Exception e){
            e.printStackTrace();

        }
        return org;
    }

    public void editOrg(String _email, String _password){
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        ArrayList<String> orgNameByType = new ArrayList<String>();
        ArrayList<String> orgEmailByType = new ArrayList<String>();
        int editChoice = 0;
        int orgID = 0;
        int orgType = 0;

        try{
            /*
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgName,email,password,typeID FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            if(this.sql.runSelect()){
                String[] cols = {"orgName","email","password","typeID"};
                String orgToEdit = this.sql.getColumns(cols);
                //System.out.println(orgToEdit);
            }
            */

            //get the typeID to get all organizations with that type u are editing
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT typeID FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            if(this.sql.runSelect()){
                String tempTypeID = this.sql.printEventData().trim();

                try{
                    orgType = Integer.parseInt(tempTypeID);
                }catch(NumberFormatException e){
                    e.printStackTrace();
                }
            }

            //get that unique primary key to always insert with that id
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgID FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            if(this.sql.runSelect()){
                String tempID = this.sql.printEventData().trim();

                try{
                    orgID = Integer.parseInt(tempID);
                }catch(NumberFormatException e){
                    e.printStackTrace();
                }
            }
        }catch(SQLException e){
            System.out.println("SQL went wrong");
        }catch(Exception e){
            e.printStackTrace();
        }


        while(true){
            try{
                /*
                this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgName,email,password,typeID FROM organizations WHERE orgID =?");
                this.sql.pst.setInt(1,orgID);
                if(this.sql.runSelect()){
                    String[] cols = {"orgName","email","password","typeID"};
                    String orgToEdit = this.sql.getColumns(cols);
                    System.out.println(orgToEdit);
                }
                */
                System.out.println("----Edit Organization----");
                System.out.println("1. Edit Organization Name");
                System.out.println("2. Edit Organization Email");
                System.out.println("3. Edit Organization Password");
                System.out.println("4. Go Back");
                System.out.print("Enter Your Choice: ");
                String tempChoice = reader.readLine();
                editChoice = Integer.parseInt(tempChoice);
                orgNameByType.clear();
                orgEmailByType.clear();
                //get the organization names by type so u can compare names
                this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgName FROM organizations WHERE typeID = ?");
                this.sql.pst.setInt(1,orgType);

                if(this.sql.runSelect()){
                    while(this.sql.data.next()){
                        String orgNameType = this.sql.data.getString(1).toLowerCase();
                        orgNameByType.add(orgNameType);
                    }
                }
                //get all emails by type

                this.sql.pst = this.sql.mysql.prepareStatement("SELECT email FROM organizations WHERE typeID = ?");
                this.sql.pst.setInt(1,orgType);

                if(this.sql.runSelect()){
                    while(this.sql.data.next()){
                        String orgEmailType = this.sql.data.getString(1).toLowerCase();
                        orgEmailByType.add(orgEmailType);
                    }
                }

                if(editChoice == 1){
                    //edit name
                    String newOrgName = "";
                    while(true){
                        System.out.print("Enter The New Organization Name: ");
                        newOrgName = reader.readLine();
                        if(orgNameByType.contains(newOrgName.toLowerCase())){
                          System.out.println("The name you entered already exists.\n");
                        }
                        else{
                            //does not contain
                            orgNameByType.add(newOrgName);
                            //edit the database
                            String insert_sql_events = "UPDATE organizations SET orgName = ? WHERE orgID = ?";
                            this.sql.pst = this.sql.mysql.prepareStatement(insert_sql_events);
                            this.sql.pst.setString(1,newOrgName);
                            this.sql.pst.setInt(2,orgID);

                            if(this.sql.runUpdate()){
                                System.out.println("Successfully changed organization name!\n");
                            }
                            break;
                        }
                    }

                }else if(editChoice == 2){
                    //edit email
                    String newOrgEmail = "";
                    while(true){
                        System.out.print("Enter The New Organization Email: ");
                        newOrgEmail = reader.readLine();
                        if(orgEmailByType.contains(newOrgEmail.toLowerCase())){
                            System.out.println("The email you entered already exists.\n");
                        }
                        else{
                            //does not contain
                            orgEmailByType.add(newOrgEmail);
                            //edit the database
                            String insert_sql_events = "UPDATE organizations SET email = ? WHERE orgID = ?";
                            this.sql.pst = this.sql.mysql.prepareStatement(insert_sql_events);
                            this.sql.pst.setString(1,newOrgEmail);
                            this.sql.pst.setInt(2,orgID);
                            if(this.sql.runUpdate()){
                                System.out.println("Successfully changed organization email!\n");
                            }
                            break;
                        }
                    }

                }else if(editChoice == 3){
                    //edit pass
                    String newOrgPassword = "";
                    System.out.print("Enter The New Organization Password: ");
                    newOrgPassword = reader.readLine();
                    String insert_sql_events = "UPDATE organizations SET password = ? WHERE orgID = ?";
                    this.sql.pst = this.sql.mysql.prepareStatement(insert_sql_events);
                    this.sql.pst.setString(1,newOrgPassword);
                    this.sql.pst.setInt(2,orgID);
                    if(this.sql.runUpdate()){
                        System.out.println("Successfully changed organization password!\n");
                    }
                }else if(editChoice == 4) {
                    //go Back
                    System.out.println();
                    break;
                }
                else{
                    System.out.println("Input must be between 1 and 5!\n");
                }
            }catch(SQLException e){
                System.out.println("SQL went wrong!\n");
            }catch(Exception e){
                System.out.println("Input must be an integer!\n");
            }
        }
    }

    public void addEvent(String _email, String _password,String _eventName,String _eventDesc, String _eventDate,String _startTime, String _location, int _points) throws ParseException {

        try{
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgID FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            this.sql.runSelect();
            int orgID = 0;
            if(this.sql.runSelect()){
                String temp = this.sql.printEventData().trim();
                try{
                    orgID = Integer.parseInt(temp);
                }catch(NumberFormatException e){
                    System.out.println("OrgID must be a number!");
                }

            }

            String insert_sql_events = "INSERT INTO events (eventName,description,hostOrgID,eventDate,startTime,location,pointsForAttending) " + "VALUES (?,?,?,?,?,?,?)";
            this.sql.pst = this.sql.mysql.prepareStatement(insert_sql_events);
            this.sql.pst.setString(1,_eventName);
            this.sql.pst.setString(2,_eventDesc);
            this.sql.pst.setInt(3,orgID);
            this.sql.pst.setString(4,_eventDate);
            this.sql.pst.setString(5,_startTime);
            this.sql.pst.setString(6,_location);
            this.sql.pst.setInt(7,_points);

            if(this.sql.runUpdate()){
                System.out.println("Successfully added an event!\n");
            }
            //date created
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void deleteOrg(){
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        //display all organizations
        String choice = "";
        int ID = 0;
        boolean isActive = true;
        boolean isOrgID = true;
        try{
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgID,orgName,email FROM organizations");
            if(this.sql.runSelect()){
                String[] cols = {"orgID","orgName","email"};
                String orgs = this.sql.getColumns(cols);
                System.out.println(orgs);
            }
        }catch(SQLException e){
            System.out.println("SQL went wrong.");
        }
        catch (Exception e){
            e.printStackTrace();
        }

        while(true){
            try {
                System.out.print("Enter organization ID(type 'goback' to return): ");
                String tempID = reader.readLine();
                if (tempID.toLowerCase().trim().equals("goback")) {
                    break;
                }else{
                    ID = Integer.parseInt(tempID);
                    this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgID,orgName,email FROM organizations where orgID = ?");
                    this.sql.pst.setInt(1,ID);
                    //this.sql.runSelect();
                    if(this.sql.runSelect()){
                        if(this.sql.data.next() == false){
                            System.out.println("Organization not found. Try again\n");
                        }else{
                            String[] cols = {"orgID","orgName","email"};
                            String theOrg2Delete = this.sql.getColumns(cols);
                            System.out.println("Would you like to delete this organization?(y/n): ");
                            choice = reader.readLine();
                            if(choice.toLowerCase().trim().equals("y")){
                                //delete the org
                                this.sql.pst = this.sql.mysql.prepareStatement("DELETE FROM organizations where orgID = ?");
                                this.sql.pst.setInt(1,ID);
                                if(this.sql.runUpdate()){
                                    System.out.println("Successfully deleted organization!");
                                    isActive = false;
                                    break;
                                }
                            }
                            else if(choice.toLowerCase().trim().equals("n")){
                                isActive = false;
                            }
                            else{
                                System.out.println("Input must be either 'y' or 'n'\n");
                            }
                        }
                    }
                    break;
                }
            }catch(NumberFormatException e){
                System.out.println("Input must be an integer\n");
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    public void printEventMenu(){
        int viewChoice = 0;
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while(true){
            try{
                System.out.println("----View My Events----");
                System.out.println("1.View All Events");
                System.out.println("2.View Past Events");
                System.out.println("3.View Future Events");
                System.out.println("4.Go Back");
                System.out.print("Enter your choice: ");
                viewChoice = Integer.parseInt(reader.readLine());

                if(viewChoice == 1){
                    //view all events
                    //System.out.println("email: " + this.email + "\npass: " + this.password);
                    getAllEvents(this.email,this.password);
                    //break;
                }
                else if(viewChoice == 2){
                    //view past
                    break;
                }
                else if(viewChoice == 3){
                    //view future
                    break;
                }
                else if(viewChoice == 4){
                    //go back
                    System.out.println();
                    break;
                }
                else{
                    System.out.println("Input must be 1,2 or 3");
                }
            }catch(Exception e){
                System.out.println("Input must be 1,2 or 3\n");
            }
        }
    }

    public List<String> getAllEvents(String _email, String _password){
        ArrayList<String> events = new ArrayList<String>();

        try {
            this.sql.pst = this.sql.mysql.prepareStatement("SELECT orgID FROM organizations WHERE email=? AND password=?");
            this.sql.pst.setString(1,_email);
            this.sql.pst.setString(2,_password);
            //this.sql.runSelect();
            if(this.sql.runSelect()){
                //int orgID = 0;
                //orgID = this.sql.printData();
                String[] cols = {"orgID"};
                String temp = this.sql.getSeperateCol(cols).trim();
                //System.out.println(temp);
                int orgID = Integer.parseInt(temp);
                //System.out.println(Integer.toString(orgID));
                this.organID = orgID;
                this.sql.pst = this.sql.mysql.prepareStatement("SELECT * FROM events WHERE hostOrgID=?");
                this.sql.pst.setInt(1,orgID);
                this.sql.runSelect();
                String[] list = {"eventName","eventDate","startTime","location","pointsForAttending"};
                //String colums = this.sql.getColumns(list);
                //System.out.println(colums);

                events = this.sql.getArrayCol(list);

                //events.add("");

                /*
                for(int i = 0; i < events.size(); ++i){
                    System.out.print(events.get(i));

                }
                */

                //System.out.println(output);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return events;
    }

    public void viewPastEvents(){

        //TODO display all past events for the specified organizer
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //get current date time with Date()
        Date date = new Date();


        //get current date time with Calendar()
        Calendar cal = Calendar.getInstance();
        System.out.println(dateFormat.format(cal.getTime()));

        //if date on the added events is less than current date, then display
        //search database & compare to current time given above
    }

    public void viewFutureEvents(){

        //TODO display all future events for the specified organizer
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //get current date time with Date()
        Date date = new Date();


        //get current date time with Calendar()
        Calendar cal = Calendar.getInstance();
        System.out.println(dateFormat.format(cal.getTime()));

        //if date on the added events is greater than current date, then display
        //search database & compare to current time given above
    }
}

