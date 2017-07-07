import java.io.*;
import java.net.*;
import java.util.*;

SingleSocketServer myServer;

int wait = 0;
void initTCP(int port) {
  wait++;
  if (wait == 2) {
    myServer = new SingleSocketServer(port);
  }
}

public class SingleSocketServer {

 ServerSocket socket1;
 Socket connection;

 boolean first;
 StringBuffer process;
 String TimeStamp;
 
 SingleSocketServer(int port) {
    try{
      socket1 = new ServerSocket(port);
      System.out.println("SingleSocketServer Initialized");
      int character;
      
      while (true) {
        connection = socket1.accept();

        BufferedInputStream is = new BufferedInputStream(connection.getInputStream());
        InputStreamReader isr = new InputStreamReader(is);
        process = new StringBuffer();
        while((character = isr.read()) != 13) {
          process.append((char)character);
        }
        //System.out.println(process);
        //need to wait 1/2 second for the app to update database
        //for demo purpose only
        try {
          Thread.sleep(500);
        }
        catch (Exception e){}
        TimeStamp = new java.util.Date().toString();
        //String returnCode = "SingleSocketServer repsonded at "+ TimeStamp + (char) 13;
        
        BufferedOutputStream os = new BufferedOutputStream(connection.getOutputStream());
        OutputStreamWriter osw = new OutputStreamWriter(os, "US-ASCII");
        String returnCode = "";
        for (int i=0; i<CTL_OUTPUT.size(); i++) {
          returnCode += CTL_OUTPUT.getString(i);
        }
        returnCode +=  (char) 13;
        osw.write(returnCode);
        osw.flush();
     }
    }
    catch (IOException e) {}
      try {
        connection.close();
      }
      catch (IOException e) {}
  }
}
