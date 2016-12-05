/**
 * Created by Stevenisdrew on 11/5/16.
 */
import java.util.*;
import java.io.*;

public class Main {

    public static void main(String[] args){
       System.out.println("---------------------------------Ordinem---------------------------------");
       System.out.println("--Created By: Albert Pierce, Drew Thomas, Shevis Johnson, Jason Malabed--");

       int choice = 0;
       while(true){
           BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
           System.out.println("----Main Menu----");
           System.out.println("1.Login to Organization");
           System.out.println("2.Create Organization");
           System.out.println("3.Exit");
           System.out.print("Enter your choice: ");

           try{
               choice = Integer.parseInt(reader.readLine());
           }catch(NumberFormatException e){
               System.out.println("Input must be an integer");

           }
           catch(Exception e){
               e.printStackTrace();
           }
           if(choice == 1){
               Admin administration = new Admin();
               //administration.retrieveCredentials();

           }
           else if(choice == 2){
                Admin administration = new Admin();
                administration.createOrg();
           }
           else if(choice == 3){
               System.out.println("GoodBye!");
               System.exit(0);
               break;
           }
           else if(choice < 1 || choice > 3){
               System.out.println("Enter either 1,2 or 3\n");
           }

       }
    }
}

