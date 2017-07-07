int dataProtocol = 1;
// 0 - UDP
// 1 - TCP

// CTL Web Address
String CTL_ADDRESS = "localhost";
int CTL_PORT = 6252;
//String CTL_ADDRESS = "192.168.173.97";
//int CTL_PORT = 5678;

// CTL Dimension Constants
float CTL_SCALE = 0.5; //km per pixel unit
int CTL_KM_U = 90;
int CTL_KM_V = 110;
int CTL_GRID_U = int(CTL_KM_U/CTL_SCALE);
int CTL_GRID_V = int(CTL_KM_V/CTL_SCALE);

String LOCAL_FRIENDLY_NAME = "PIXELIZER";

String CTL_COST_TOTAL = "cost_total";
String CTL_COST_PER_DELIVERY = "cost_per_delivery";
String CTL_FACILITIES_ALLOCATION = "allocation_facilities";
String CTL_ALLOCATION_VEHICLES = "allocation_vehicles";

ClientPackage dataForCTL;
OutputPackage dataFromCTL;

boolean waitingForCTL = false;
boolean enableCTL = false;

void sendCTLData() {
  if (!waitingForCTL) {
    waitingForCTL = true;
    println("sending data to stl ...");
    dataForCTL.addToPackage("facilities", facilities, gridSize);
    dataForCTL.addToPackage("market", market, gridSize);
    dataForCTL.addToPackage("obstacles", obstacles, gridSize);
    dataForCTL.sendPackage();
    println("data sent to CTL");
  }
}

// A Class that handles and sends a matrix of data formatted for the scale of the reciever
class ClientPackage {
  
  String packageString;
  int VOID_VALUE = 0;
  
  String clientAddress;
  int clientPort;
  float clientScale;
  
  ClientPackage(String address, int port, float scale) {
    packageString = "";
    // Define Package Name
    packageString += LOCAL_FRIENDLY_NAME;
    packageString += "\n";
    
    clientAddress = address;
    clientPort = port;
    clientScale = scale;
  }
  
  // addToPackage() appends a TSV-style matrix to the packageString:
  //  PIXELIZER
  //  gridU  72
  //  gridV  88
  //  facilities
  //  34  101  1       //  U  V  ID
  //  104  165  5
  //  76  181  4
  //  ...
  //  market
  //  6  9  9
  //  6  137  10
  //  26  101  9
  //  ...
  //  obstacles
  //  6  9  1
  //  6  137  1
  //  26  101  1
  //  ... 
  
  void addToPackage( String packageName, int[][] input, float localScale) {
    
    // Define Package Name
    packageString += packageName;
    packageString += "\n";
    
    int uDisaggregated, vDisaggregated;
    
    // Define Package Data
    for (int u=0; u<input.length; u++) {
      for (int v=0; v<input[0].length; v++) {
        if (input[u][v] != VOID_VALUE) {
          
          // Converts local u,v values to client coordinate system
          uDisaggregated = int(u*localScale/clientScale) + 2;
          vDisaggregated = int(v*localScale/clientScale) + 1;
          
          packageString += uDisaggregated;
          packageString += ",";
          packageString += vDisaggregated;
          packageString += ",";
          packageString += input[u][v];
          packageString += "\n";
        }
      }
    }
  }
  
  void clearPackage() {
    // Define Package Name
    packageString = "";
    packageString += LOCAL_FRIENDLY_NAME;
    packageString += "\n";
  }
  
  void sendPackage() {
    switch(dataProtocol) {
      case 0:
        udp.send( packageString, clientAddress, clientPort );
        //println(packageString);
        clearPackage();
        break;
      case 1:
        clientSocket = new SocketClient( packageString, clientAddress, clientPort );
        clearPackage();
        break;
    }
  }
}

// A Class that receives and handles a matrix of data from an external client
class OutputPackage {
  
  String packageString;
  int VOID_VALUE = 0;
  
  float clientScale;
  
  OutputPackage(float scale) {
    packageString = "";
    clientScale = scale;
  }
  
  void readPackage( String output, float localScale) {
    this.packageString = output;
  }
  
  void clearPackage() {
    packageString = "";
  }
}
