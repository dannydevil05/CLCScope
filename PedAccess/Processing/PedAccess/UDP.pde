// Principally, this script ensures that a string is "caught" via UDP and coded into principal inputs of:
// - tablePieceInput[][] or tablePieceInput[][][2] (rotation)
// - UMax, VMax


int portIN = 6152;

import hypermedia.net.*;
UDP udp;  // define the UDP object

boolean busyImporting = false;
boolean changeDetected = false;
boolean outputReady = false;

int changeClock = 0;
int changeClockTime = 10;

boolean allowUDP = false;
int UDPdelay = 20;

void initUDP() {
  udp = new UDP( this, portIN );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void ImportData(String inputStr[]) {
  if (inputStr[0].equals("COLORTIZER")) {
    parseColortizerStrings(inputStr);
  } else if (inputStr[0].equals("LAST_MILE_SIM")) {
    parseLastMileSimStrings(inputStr);
  } else if (inputStr[0].equals("CTL") && enableCTL) {
    //saveStrings("CTLdata.txt", inputStr);
    if (waitingForCTL) clearOutputData();
    parseCTLStrings(inputStr);
    waitingForCTL = false;
  } else {
    if (!enableCTL) {
      println("Data received from CTL, but this feature has been disabled.");
    }
  }
  busyImporting = false;
}

void parseLastMileSimStrings(String data[]) {

  outputReady = true;
}

void parseCTLStrings(String data[]) { //Singapore cityscope 

  println("CTL Strings Recieved by " + LOCAL_FRIENDLY_NAME);
  
  String dataType = "";

  for (int i=0 ; i<data.length;i++) {

    String[] split = split(data[i], ",");

    // Checks Output Data Type
    if (split.length == 1) {
      if (split[0].equals(CTL_COST_TOTAL) || split[0].equals(CTL_FACILITIES_ALLOCATION) || split[0].equals(CTL_ALLOCATION_VEHICLES) || split[0].equals(CTL_COST_PER_DELIVERY)) dataType = split[0];
      //println(dataType);
    }

    // Checks if row format is compatible with piece recognition.  3 columns for ID, U, V; 4 columns for ID, U, V, rotation
    if (split.length == 3) {

      if (dataType.equals("")) {
        // Do Nothing
        println("No Data Type Specified");
      } else {

        //println("CTL Row Processed by " + LOCAL_FRIENDLY_NAME);

        //Finds UV values of Lego Grid in CTL units
        int u_local = int(split[0]);
        int v_local = int(split[1]);

        // Adds offset assuming CTL grid is centered on same point as local Coordinate system
        // Still in CTL Units
        u_local += int( ((MAX_GRID_SIZE*displayU - CTL_KM_U)/2) / CTL_SCALE);
        v_local += int( ((MAX_GRID_SIZE*displayV - CTL_KM_V)/2) / CTL_SCALE);

        // Converts u/v coordinates to local grid.  Results in data being "lost"
        u_local = int( (CTL_SCALE/gridSize)*u_local );
        v_local = gridV - int( (CTL_SCALE/gridSize)*v_local ) - 1;
        
        //println("Choose data Type");
        if (u_local < gridU && v_local < gridV) {
          if (dataType.equals(CTL_COST_TOTAL)) {
            float value = float(split[2]);
            totalCost[u_local][v_local] += value;
          } else if (dataType.equals(CTL_COST_PER_DELIVERY)) {
            float value = float(split[2]);
            deliveryCost[u_local][v_local] = value;
          } else if (dataType.equals(CTL_FACILITIES_ALLOCATION)) {
            int value = int(split[2]);
            allocation[u_local][v_local] = value;
          } else if (dataType.equals(CTL_ALLOCATION_VEHICLES)) {
            int value = int(split[2]);
            vehicle[u_local][v_local] = value;
          }
        }
      }
    }
  }
  outputReady = true;
}

void parseColortizerStrings(String data[]) {

  for (int i=0 ; i<data.length;i++) {

    String[] split = split(data[i], "\t");

    // Checks maximum possible ID value
    if (split.length == 2 && split[0].equals("IDMax")) {
      IDMax = int(split[1]);
    }

    // Checks if row format is compatible with piece recognition.  3 columns for ID, U, V; 4 columns for ID, U, V, rotation
    if (split.length == 3 || split.length == 4) {

      //Finds UV values of Lego Grid:
      int u_temp = int(split[1]);
      int v_temp = tablePieceInput.length - int(split[2]) - 1;

      if (split.length == 3 && !split[0].equals("gridExtents")) { // If 3 columns

        // detects if different from previous value
        if ( v_temp < tablePieceInput.length && u_temp < tablePieceInput[0].length ) {
          if ( tablePieceInput[v_temp][u_temp][0] != int(split[0]) ) {
            // Sets ID
            tablePieceInput[v_temp][u_temp][0] = int(split[0]);
            changeDetected = true;
            changeClock = changeClockTime;
          }
        }

      } else if (split.length == 4) {   // If 4 columns

        // detects if different from previous value
        if ( v_temp < tablePieceInput.length && u_temp < tablePieceInput[0].length ) {
          if ( tablePieceInput[v_temp][u_temp][0] != int(split[0]) || tablePieceInput[v_temp][u_temp][1] != int(split[3])/90 ) {
            // Sets ID
            tablePieceInput[v_temp][u_temp][0] = int(split[0]);
            //Identifies rotation vector of piece [WARNING: Colortizer supplies rotation in degrees (0, 90, 180, and 270)]
            tablePieceInput[v_temp][u_temp][1] = int(split[3])/90;
            changeDetected = true;
            changeClock = changeClockTime;
          }
        }
      }
    }
  }
}

void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  if (allowUDP) {
  // get the "real" message =
    String message = new String( data );
  // println("catch!");
    //println(message);
    saveStrings("data.txt", split(message, "\n"));
    String[] split = split(message, "\n");
  //////  println("HOW LARGE: " + split.length);
//  for (int i=0; i<15; i++){
//    print("["+i+"]"+split[i]+"; ");
 // }
 
      //println("Catch!  " + split[4]);
      
    
  
    if (!busyImporting) {
      busyImporting = true;
      ImportData(split);
    }
  }
}

void sendCommand(String command, int port) {
  String dataToSend = "";
  dataToSend += command;
  udp.send( dataToSend, "localhost", port );
}
