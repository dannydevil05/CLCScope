// Principally, this script ensures that a string is "caught" via UDP:

String LOCAL_IP = "127.0.0.1";
int LOCAL_PORT = 6252;

String CLIENT_IP = "127.0.0.1";
int CLIENT_PORT = 6152;

import hypermedia.net.*;
UDP udp;  // define the UDP object

boolean busyImporting = false;
boolean importReady = false;

void initUDP() {
  udp = new UDP( this, LOCAL_PORT );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void ImportData(String data[]) {
  
  for (int i=0 ; i<data.length;i++) {
    
    String[] split = split(data[i], "\t");
    
    if (split.length == 1) {
      // Check for Input Tag Type (i.e. "facilities")
    }
    if (split.length == 3) {
      // Check for (ID,  U,  V) row format
    }
  }
  busyImporting = false;
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  // get the "real" message =
  String message = new String( data ); 
  String[] split = split(message, "\n");
  //println(message);
  //println(ip, port);
  //saveStrings("data.txt", split);
  
  if (!busyImporting) {
    busyImporting = true;
    ImportData(split);
    importReady = true;
  }
}

void sendCommand(String command, int port) {
  String dataToSend = "";
  dataToSend += command;
  udp.send( dataToSend, CLIENT_IP, CLIENT_PORT );
}

