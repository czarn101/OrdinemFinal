/**
 * Created by Stevenisdrew on 11/5/16.
 */
import java.util.Scanner;
import java.util.Date;
import java.text.*;
import java.text.ParseException;
public class EventManager {

    private Date date2;
    private Date startTime;
    private Date endTime;
    private String location;
    private String description;
    private int pointsGiven;

    public EventManager() {
    }

    public Date getDate2() {
        return date2;
    }

    public Date getStartTime() {
        return startTime;
    }
    public Date getEndTime(){
        return endTime;
    }

    public String getLocation(){
        return location;
    }

    public String getDescription(){
        return description;
    }

    public Date setDate() {
        // To take the input
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the Date ");

        String date = scanner.next();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        date2 = null;
        try {
            //Parsing the String
            date2 = dateFormat.parse(date);
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        System.out.println(date2);
        return date2;
    }

    public Date[] getTime() throws ParseException {
        Scanner input = new Scanner(System.in);
        System.out.print("Enter first time (hh:mm aa): ");
        String time = input.nextLine();
        System.out.println();
        System.out.print("Enter second time (hh:mm aa): ");
        String time2 = input.nextLine();
        System.out.println();
        DateFormat sdf = new SimpleDateFormat("hh:mm aa");
        startTime = sdf.parse(time);
        endTime = sdf.parse(time2);

        System.out.println("Time: " + sdf.format(startTime));
        System.out.println("Time: " + sdf.format(endTime));
        if(startTime.after(endTime)){
            long diffMs = startTime.getTime() - endTime.getTime();
            long diffSec = diffMs / 1000;
            long min = diffSec / 60;
            long sec = diffSec % 60;
            System.out.println("The difference is "+min+" minutes and "+sec+" seconds.");
        }

        if(startTime.before(endTime)){
            long diffMs = endTime.getTime() - startTime.getTime();
            long diffSec = diffMs / 1000;
            long min = diffSec / 60;
            long sec = diffSec % 60;
            System.out.println("The difference is "+min+" minutes and "+sec+" seconds.");
        }

        if(startTime.equals(endTime)){
            System.out.println("The difference is 0 minutes and 0 seconds.");
        }

        return new Date[]{startTime , endTime};

    }

    public String setLocation(){
        Scanner scanLoc = new Scanner(System.in);
        System.out.println("Enter Location (The more specific the better): ");
        String loc = scanLoc.next();

        location = loc;
        return location;
    }

    public String setDescription(){
        Scanner scanDesc = new Scanner(System.in);
        System.out.println("Description of event: ");
        String desc = scanDesc.next();

        description = desc;
        return description;
    }

    public int setPoints(){
        Scanner scanPts = new Scanner(System.in);
        System.out.println("Total points given for event: ");
        int pts = scanPts.nextInt();

        pointsGiven = pts;
        return pointsGiven;
    }





}
