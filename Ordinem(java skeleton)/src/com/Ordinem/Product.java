package com.Ordinem;

//import com.sun.org.apache.xpath.internal.operations.String;
import java.util.*;
import java.lang.*;
import java.io.*;


/**
 * Created by Albert on 12/6/16.
 */
public class Product {

     String eventName;
     String eventTime;
     String eventLength;
     String eventPoints;
     String eventLocation;



    public Product(String eventName, String eventTime, String eventLength,String eventPoints, String eventLocation){
        this.eventName = eventName;
        this.eventTime = eventTime;
        this.eventLength = eventLength;
        this.eventLocation = eventLocation;
        this.eventPoints = eventPoints;
    }



}
