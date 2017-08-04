PGraphics buffer;

boolean showBuffer=true;
boolean hasConflict[][]= new boolean[18][22];

int bufferRadius=100;
int bufferMap[][]=new int[18][22];


void initBuffer(){
  buffer= createGraphics(table.width, table.height);
}

void renderBufferLayer(PGraphics a){
  float unitDist=20.0/gridWidth;
  boolean textClash=false;
  a.beginDraw();
  a.clear();
  initBufferMatrices();
  computeGridBuffer();
  for (int i=0; i<tablePieceInput.length; i++) {
    for (int j=0; j<tablePieceInput[0].length; j++) {
      int ID = tablePieceInput[i][j][0];
      if (ID ==0 || ID==1) {
        a.stroke(0,0,150);
        a.fill(0,0,255,70);
        a.rectMode(RADIUS);
        a.rect((4*i+2)*gridWidth,(4*j+2)*gridHeight,(bufferRadius+40)/unitDist,(bufferRadius+40)/unitDist);
      }
    }
  }
  for (int i=0; i<bufferMap.length; i++) {
    for (int j=0; j<bufferMap[0].length; j++) {
      hasConflict[i][j]=checkIfConflict(tablePieceInput[i][j][0], bufferMap[i][j]);
      if (bufferMap[i][j]==0 ) {
        //a.fill(0,0,200,70);
        //a.stroke(0,0,200);
        a.noFill();
        a.noStroke();
        int passedMillis=millis()-time;
        int offDuration=500;
        int onDuration=500;
        if (hasConflict[i][j]==true && passedMillis>=offDuration) {
          //Draws a flashing red box if conflict is true
          //Box turns on for 0.5s
          //and off for 0.5s
          textClash=true;
          a.fill(200,0,0);
          a.stroke(200,0,0);
          if (passedMillis>=(offDuration+onDuration)) time=millis();
        }
      }      
      else {
        a.noFill();
        a.noStroke();
      }
      a.rectMode(CORNER);
      a.rect(4*i*gridWidth,4*j*gridHeight,4*gridWidth,4*gridHeight);
       if (textClash){
        a.fill(255,255,255);
        a.textAlign(CENTER);
        a.text("CLASH",4*i*gridWidth+2*gridWidth,4*j*gridHeight+2*gridHeight);
        textClash=false;
       }
    }
  }
  a.endDraw();
}


  void computeGridBuffer(){
      int radInGrid=bufferRadius/80+1; 
      for (int i = 0; i < tablePieceInput.length; i++) {
        for (int j = 0; j < tablePieceInput[0].length; j++) {
          if (tablePieceInput[i][j][0] == 0 || tablePieceInput[i][j][0]==1) {
            for (int u=-radInGrid;u<=radInGrid;u++){
              for (int v=-radInGrid;v<=radInGrid;v++){
                if ((i+u)>=0 && (i+u)<=17 && (j+v)>=0 && (j+v)<=21){
                  bufferMap[i+u][j+v]=0;
                }
              }
            }
          }
        }
      }
  }
      
            
  void initBufferMatrices(){
      for (int i = 0; i < tablePieceInput.length; i++) {
        for (int j = 0; j < tablePieceInput[0].length; j++) {
          bufferMap[i][j]=-1;
          hasConflict[i][j]=false;
        }
      } 
  }
  
 
  boolean checkIfConflict(int building, int existingBuffer){
    // Rules:
    // distance(B1,Residential)>100m
    if (existingBuffer==0 ){
      if (building>1 && building<16) return true;
      else return false;
    }
    else return false;
  }






















/*public boolean[][] bufferValidation(int[][][] tablePieceInput, int bufferID, int bufferRange) {
  // based on tablePieceInput, for each position (i,j). check the buffer rules are violated or not.
  // Output:
  // for each (i,j), output true (rules are violated )or false.
  //
  // Rules:
  // 1. distance(Industrial-B2, Mixed Use A) > 100
  // 2. distance(Industrial-B2, H-Residential) > 100
  // 3. distance(Industrial-B2, M-Residential) > 100
  // 4. distance(Industrial-B2, L-Residential) > 100

  int nrow = tablePieceInput.length;
  int ncol = tablePieceInput[0].length;
  boolean[][] isBufferID = new boolean[nrow][ncol];
  boolean[][] needBufferValidation = new boolean[nrow][ncol];
  boolean[][] bufferValidationOutput = new boolean[nrow][ncol];

  // step 1: search positions of all target buildings  which is defined by BufferID.
  for (int i = 0; i < nrow; i++) {
    for (int j = 0; j < ncol; j++) {
      if (tablePieceInput[i][j][0] == bufferID) {
        isBufferID[i][j] = true;
      }
    }
  }
  // step 2: use bufferRange to label positions need to be check.
  for (int i = 0; i < nrow; i++) {
    for (int j = 0; j < ncol; j++) {
      if (isBufferID[i][j]) {
        for (int k = Math.max (0, i-bufferRange); k < Math.min(nrow, i+bufferRange+1); k++) {
          for (int l = Math.max (0, j-bufferRange); l< Math.min(ncol, j+bufferRange+1); l++) {
            needBufferValidation[k][l] = true;
          }
        }
      }
    }
  }
  // step 3: check all buildings to see buffer rules are violated or not.
  for (int i = 0; i < nrow; i++) {
    for (int j = 0; j < ncol; j++) {
      //                bufferValidationOutput[i][j] = false;

      if (needBufferValidation[i][j]) {

//        Set<Integer> restrictedBuildingID = new HashSet<>();
//        //Residential Building
//        restrictedBuildingID.add(0);
//        restrictedBuildingID.add(1);
//        restrictedBuildingID.add(2);
//        //Mixed Use A
//        restrictedBuildingID.add(5);


        // check tablePieceInput[i][j][0]
        int buildingID = tablePieceInput[i][j][0];
//        if (!restrictedBuildingID.add(buildingID)) {
        if (buildingID == 0 ||buildingID == 1 ||buildingID == 2 ||buildingID == 5 ) {
          bufferValidationOutput[i][j] = true;
        }
      }
    }
  }
  return bufferValidationOutput;
}
*/
