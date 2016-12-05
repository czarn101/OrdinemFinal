// SQLConnector
// Written by Shevis Johnson
// 9/27/16
//
// Description: Helper for connecting to a SQL database

//import com.intellij.ide.ui.AppearanceOptionsTopHitProvider;

import com.mysql.jdbc.exceptions.MySQLSyntaxErrorException;

import java.sql.*;
import java.util.InputMismatchException;

public class SQLConnector {


    public String connectionURL;
    public String username;
    public String password;
    public String dbname;
    public Connection mysql;
    public PreparedStatement pst;
    public ResultSet data;
    public ResultSetMetaData specialData;

    public SQLConnector() {
        //default constructor
        this.connectionURL = "";
        this.username = "";
        this.password = "";
        this.dbname = "";
        this.mysql = null;
        this.pst = null;
        this.data = null;
        this.specialData = null;
    }

    public SQLConnector(String _dbname, String _connectionURL, String _username, String _password) {
        //detailed constructor
        this.connectionURL = _connectionURL;
        this.username = _username;
        this.password = _password;
        this.dbname = _dbname;
        this.mysql = null;
        this.pst = null;
        this.data = null;
        this.specialData = null;
        this.init();
    }

    public void init() {
        // initiates the connection to the server
        try {
            Class.forName("com.mysql.jdbc.Driver");
            this.mysql = DriverManager.getConnection(this.connectionURL, this.username, this.password);

            if (this.mysql == null) {
                System.out.println("Connection Failed.");
                System.exit(0);
            }
            else {
                System.out.println("Successfully connected.\n");
            }

        }catch(MySQLSyntaxErrorException e){
            System.out.println("User exceeded max connections");
        }catch(ClassNotFoundException e){
            System.out.println("Class jdbc driver not found");
        }catch(SQLException e){
            e.printStackTrace();
        }
    }

    public void close() {
        // cloases the connection
        try {
            this.mysql.close();
            System.out.println("\nConnection closed. Goodbye!");
        } catch (Exception e) {
            System.out.println("Warning: unable to close connection...");
            //whatever
        }
    }

    public String getColumns(String[] attributes) throws Exception {
        // returns a formatted representation of the columns requested
        String output = "\n";
        for (String attr : attributes) {
            output += String.format("%20s", attr);
        }
        output += "\n";
        output +="------------------------------------------------------------------------------------------------";
        output += "\n";
        while (this.data.next()) {
            for (String attr : attributes) {
                output += String.format("%20s", this.data.getString(attr));
            }
            output += "\n";
        }

        return output;
    }

    public boolean runSelect() {
        //runs the given SQL query
        try {
            //this.pst = mysql.prepareStatement(query);
            this.data = pst.executeQuery();

            return true;
        } catch (Exception e) {
            //System.out.println("An error occurred, please try again.");
            //e.printStackTrace();
            return false;
        }
    }

    public boolean runUpdate() {
        //runs the given SQL query
        try {
            //this.pst = mysql.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            int num = this.pst.executeUpdate();
            return true;
        } catch (Exception e) {
            //System.out.println("An error occurred, please try again.");
            //e.printStackTrace();
            return false;
        }
    }

    public String printEventData(){
        String temp = "";
        try{
            while(this.data.next()){
                temp = data.getString(1);

            }

        }catch(Exception e){
            System.out.println("No data found");
        }
        return temp;
    }

    public String getGeneratedKey() {
        //returns generated key from last statement'
        ResultSet keys;
        try {
            keys = this.pst.getGeneratedKeys();
            while(keys.next()){
                try {


                    return Integer.toString(keys.getInt(1));

                } catch (Exception e) {
                    return "failed to get key";
                }
            }
            return "key not found";
        } catch (Exception e) {
            //e.printStackTrace();
            return "no keys";
        }

    }

}
