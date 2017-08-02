// Arrays that holds ID information of rectilinear tile arrangement.
int tablePieceInput[][][] = new int[displayU/4][displayV/4][2];
int rotationMod = 1;

JSONArray newPOIs = new JSONArray();
JSONArray newNodes = new JSONArray();

// Input Piece Types
ArrayList<Integer[][]> inputData;
ArrayList<Integer[][]> inputForm;

// Form Codes:
// 0 = void/no brick
// 1 = tan brick
// 2 = blue brick
// 3 = red brick
// 4 = black brick
// 5 = green brick
// 6 = white brick
// 7 = brown brick
// 8 = purple brick
// 9 = cream brick
//10 = pink brick 
//11 = light blue brick
  
  // Data Type
  /* 0 = Vehicle Road Network
   * 1 = Surface Level Pedestrian Pathways
   * 2 = Surface Level Pedestrian Street Crossing
   * 3 = Covered Linkway Redestrian Pathway
   * 4 = Ground-Bridge-Ground Street Crossing
   * 5 = 2nd Level Pedestrian Causeway
   */
   
String[] pieceNames = {
  /*"SCHOOL",
  "CHILDCARE",
  "HEALTHCARE",
  "ELDERCARE",
  "RETAIL",
  "PARK",
  "TRANSIT STOP",
  "PED. PATH",
  "HOUSING",
  "PED. BRIDGE",
  "ELEV. PATH",
  "PED-X'ING"*/
  
  "B1-LO",
  "B1-MED",
  "HEALTHCARE",
  "RES-MED",
  "RES-HI",
  "RES/COM-LO",
  "RES/COM-MED",
  "RES/COM-HI",
  "COM-LO",
  "COM-MED",
  "B1/RES-LO",
  "B1/RES-MED",
  "B1/RES-HI",
  "EDUCATIONAL",
  "PARK"
  
};

void setupPieces() {
  
  inputData = new ArrayList<Integer[][]>();
  inputForm = new ArrayList<Integer[][]>();
  
  // 0: B1-LO
  Integer[][] data_0 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 1, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_0 = {
    { 0, 0, 0, 0 },
    { 8, 8, 8, 8 },
    { 8, 8, 8, 8 },
    { 0, 0, 0, 0 } };
  inputData.add(data_0);
  inputForm.add(form_0);
  
  // 1: B1-MED
  Integer[][] data_3 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 3, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_3 = {
    { 10,10,10,10 },
    { 10,10,10,10 },
    { 0, 0, 8, 8 },
    { 0, 0, 8, 8 } };
  inputData.add(data_3);
  inputForm.add(form_3);
  
  // 2: Healthcare
  Integer[][] data_2 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 2, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_2 = {
    { 0, 0, 3, 0 },
    { 0, 3, 3, 3 },
    { 0, 0, 3, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_2);
  inputForm.add(form_2);
  
  // 3: RES-MED
  Integer[][] data_1 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 4, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_1 = {
    { 0, 0, 0, 0 },
    { 0, 3, 3, 0 },
    { 0, 1, 1, 1 },
    { 0, 0, 0, 0 } };
  inputData.add(data_1);
  inputForm.add(form_1);
  
  // 4: RES-HI
  Integer[][] data_4 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 7, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_4 = {
    { 9, 9, 1, 1 },
    { 9, 9, 1, 1 },
    { 1, 1, 1, 1 },
    { 1, 1, 1, 1 } };
  inputData.add(data_4);
  inputForm.add(form_4);  
  
  // 5: RES/COM-LO
  Integer[][] data_5 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 6, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_5 = {
    { 0, 0, 0, 0 },
    { 0, 1, 1, 0 },
    { 0, 2, 2, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_5);
  inputForm.add(form_5);
  
  // 6: RES/COM-MED
  Integer[][] data_6 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 5, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_6 = {
    { 0, 6, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_6);
  inputForm.add(form_6);  
  
  // 7: RES/COM-HI
  Integer[][] data_7 = {
    { 0, 0, 0, 0 },
    { 1, 1, 1, 1 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_7 = {
    { 1, 1, 1, 1 },
    { 1, 1, 1, 1 },
    { 2, 2, 2, 2 },
    { 2, 2, 2, 2 } };
  inputData.add(data_7);
  inputForm.add(form_7);

  // 8: COM-LO
  Integer[][] data_8 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_8 = {
    { 0, 0, 0, 0 },
    { 2, 2, 0, 0 },
    { 2, 2, 2, 0 },
    { 2, 2, 2, 0 } };
  inputData.add(data_8);
  inputForm.add(form_8);

  // 9: COM-MED
  Integer[][] data_9 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_9 = {
    { 0, 0, 0, 0 },
    { 2, 2,11,11 },
    { 2, 2,11,11 },
    { 2, 2, 2, 2 } };
  inputData.add(data_9);
  inputForm.add(form_9);
  
  // 10: B1/RES-LO
  Integer[][] data_10 = {
    { 0, 0, 0, 4 },
    { 4, 4, 4, 4 },
    { 4, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_10 = {
    { 0, 0, 0, 0 },
    { 0, 8, 8, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 0, 0 }};
  inputData.add(data_10);
  inputForm.add(form_10);

  // 11: B1/RES-MED
  Integer[][] data_11 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_11 = {
    { 1, 1, 1, 1 },
    { 1, 1, 1, 1 },
    { 1, 8, 8, 1 },
    { 8, 8, 8, 8 } };
  inputData.add(data_11);
  inputForm.add(form_11);
  
  // 12: B1/RES-HI
  Integer[][] data_12 = {
    { 0, 0, 0, 0 },
    { 5, 5, 5, 5 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_12 = {
    { 2, 0, 0, 2 },
    { 6, 6, 6, 6 },
    { 2, 0, 0, 2 },
    { 2, 0, 0, 2 } };
  inputData.add(data_12);
  inputForm.add(form_12);
  
  // 13: EDUCATION
  Integer[][] data_13 = {
    { 0, 2, 0, 0 },
    { 2, 2, 2, 2 },
    { 0, 2, 0, 0 },
    { 0, 2, 0, 0 } };
  Integer[][] form_13 = {
    { 0, 6, 0, 0 },
    { 6, 6, 6, 6 },
    { 0, 6, 0, 0 },
    { 0, 6, 0, 0 } };
  inputData.add(data_13);
  inputForm.add(form_13);
  
  // 14: Delete
  Integer[][] data_14 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_14 = {
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 } };
  inputData.add(data_14);
  inputForm.add(form_14);
  
  // 15: PARK
  Integer[][] data_15 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 6, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_15 = {
    { 0, 5, 5, 5 },
    { 0, 5, 5, 0 },
    { 0, 5, 5, 0 },
    { 0, 5, 5, 5  } };
  inputData.add(data_15);
  inputForm.add(form_15);
}

void decodePieces() {
  
  clearInputData();
  //renderBufferMap(buffer);
  for (int i=0; i<tablePieceInput.length; i++) {
    for (int j=0; j<tablePieceInput[0].length; j++) {
      int ID = tablePieceInput[i][j][0];
      if (ID >= 0 && ID <= IDMax) {
        
        // Rotation Parameters
        int rotation = (tablePieceInput[i][j][1] + rotationMod)%4;
        int X =0;
        int Y =0;
        
        // Update "Form" Layer
        Integer[][] form = inputForm.get(ID);
        for (int u=0; u<form.length; u++) {
          for (int v=0; v<form[0].length; v++) {
            
            if (rotation == 0) {
              X = 4*i + u;
              Y = 4*j + v;
            } else if (rotation == 1) {
              X = 4*i + v;
              Y = 4*j + (3-u);
            } else if (rotation == 2) {
              X = 4*i + (3-u);
              Y = 4*j + (3-v);
            } else if (rotation == 3) {
              X = 4*i + (3-v);
              Y = 4*j + u;
            }
          
            this.form[gridPanU+X][gridPanV+Y] = form[v][u];
          }
        }
        
        // Update Point of Interest Data
        String type = "";
        String subtype ="";
        boolean crossing = false;
        int z = 0;
        //initialize floorspace
        int b1=0;
        int commercial=0;
        int residential=0;
        int park=0;
        int institution=0;
        TableRow buildingArea=typology.getRow(ID);
        
        if (ID !=14) {
          
           switch (ID) {
            case 0:
            //b1-lo
              type = "amenity";
              subtype = "school";
              break;
            case 1:
            //b1-med
              type = "amenity";
              subtype = "child_care";
              break;
            case 2:
            //health
              type = "amenity";
              subtype = "health";
              break;
            case 3:
            //res-med
              type = "amenity";
              subtype = "eldercare";
              break;
            case 4:
            //res-hi
              type = "amenity";
              subtype = "retail";
              break;
            case 5:
            //rescom-lo
              type = "amenity";
              subtype = "park";
              //park=6400;
              break;
            case 6:
            //rescom-med
              type = "transit";
              subtype = "bus_stop";
              break;
            case 7:
            //rescom-hi
              type = "amenity";
              subtype = "res/com_hi";
              break;
            case 8:
            //com-lo
              type = "amenity";
              subtype = "com_lo";
              break;
            case 9: 
            // com-med
              type = "transit";
              subtype = "housing";
              break;
            case 10: 
            // busres-low
              type = "amenity";
              subtype = "b1/res_lo";
              break;
           case 11: 
            // busres-med
              type = "amenity";
              subtype = "b1/res_med";
              break;
           case 12: 
            // busres-hi
              type = "amenity";
              subtype = "bus/res_hi";
              break;
           case 13: 
            // education
              type = "amenity";
              subtype = "com_med";
              break;
           case 15: 
            // park
              type = "amenity";
              subtype = "park";
              break;            
        
           }       
          
          
          JSONObject newPOI = new JSONObject();
          newPOI.setInt("u", i*4 + 2 + gridPanU + gridU/2);
          newPOI.setInt("v", j*4 + 2 + gridPanV + gridV/2);
          newPOI.setString("type", type);
          newPOI.setString("subtype", subtype);
          newPOI.setInt("b1", buildingArea.getInt("B1/m2"));
          newPOI.setInt("commercial", buildingArea.getInt("Commercial/m2"));
          newPOI.setInt("residential", buildingArea.getInt("Residential/m2"));
          newPOI.setInt("institution", buildingArea.getInt("Institution/m2"));
          newPOI.setInt("park", buildingArea.getInt("Park Space/m2"));
          newPOIs.setJSONObject(newPOIs.size(), newPOI);
          
        }
        
       else if (false) {
        
          // Update Pedestrian Network
          Integer[][] data = inputData.get(ID);
          for (int u=0; u<data.length; u++) {
            for (int v=0; v<data[0].length; v++) {
              
              if (rotation == 0) {
                X = 4*i + u;
                Y = 4*j + v;
              } else if (rotation == 1) {
                X = 4*i + v;
                Y = 4*j + (3-u);
              } else if (rotation == 2) {
                X = 4*i + (3-u);
                Y = 4*j + (3-v);
              } else if (rotation == 3) {
                X = 4*i + (3-v);
                Y = 4*j + u;
              }
              
              
            // Data Type
            /* 0 = Vehicle Road Network
             * 1 = Surface Level Pedestrian Pathways
             * 2 = Surface Level Pedestrian Street Crossing
             * 3 = Covered Linkway Redestrian Pathway
             * 4 = Ground-Bridge-Ground Street Crossing
             * 5 = 2nd Level Pedestrian Causeway
             */
 
              if (data[v][u] > 0) {
                switch (data[v][u]) {
                  case 1:
                    type = "ped_ground";
                    crossing = false;
                    z = 0;
                    break;
                  case 2:
                    type = "ped_xing";
                    crossing = true;
                    z = 0;
                    break;
                  case 3:
                    type = "ped_linkway";
                    crossing = false;
                    z = 0;
                    break;
                  case 4:
                    type = "ped_bridge";
                    crossing = true;
                    z = 1;
                    break;
                  case 5:
                    type = "ped_2nd";
                    crossing = false;
                    z = 2;
                    break;
                }
          
                JSONObject newNode = new JSONObject();
                newNode.setInt("u", X + gridPanU + gridU/2);
                newNode.setInt("v", Y + gridPanV + gridV/2);
                newNode.setInt("z", z);
                newNode.setString("type", type);
                newNode.setBoolean("crossing", crossing);
                newNodes.setJSONObject(newNodes.size(), newNode);
                
                //println(newNode.getInt("u"), newNode.getInt("v"));
              }
              
  //            if (ID >= 0 && ID <= 6) {
  //              this.facilities[gridPanU+X][gridPanV+Y] = data[v][u];
  //            } else if (ID ==8 || ID == 9) {
  //              this.market[gridPanU+X][gridPanV+Y] = data[v][u];
  //            } 
  
            }
          }
        }
      }
    }
  }
  
  println("New Ped Nodes: " + newNodes.size());
  
}

void clearInputData() {
  for (int u=0; u<gridU; u++) {
    for (int v=0; v<gridV; v++) {
      this.form[u][v] = 0;
      this.facilities[u][v] = 0;
      this.market[u][v] = 0;
    }
  }
  newPOIs = new JSONArray();
  newNodes = new JSONArray();
}

void fauxPieces(int code, int[][][] pieces, int maxID) {
  if (code == 2 ) {
    
    // Sets all grids to have "no object" (-1) with no rotation (0)
    for (int i=0; i<pieces.length; i++) {
      for (int j=0; j<pieces[0].length; j++) {
        pieces[i][j][0] = -1;
        pieces[i][j][1] = 0;
      }
    }
  } else if (code == 1 ) {
    
    // Sets grids to be alternating one of each N piece types (0-N) with no rotation (0)
    for (int i=0; i<pieces.length; i++) {
      for (int j=0; j<pieces[0].length; j++) {
        pieces[i][j][0] = i  % maxID+1;
        //pieces[i][j][0] = -1; // set to -1 since laggy
        pieces[i][j][1] = 0;
      }
    }
  } else if (code == 0 ) {
    
    // Sets grids to be random piece types (0-N) with random rotation (0-3)
    for (int i=0; i<pieces.length; i++) {
      for (int j=0; j<pieces[0].length; j++) {
        if (random(0, 1) > 0.95) {
          pieces[i][j][0] = int(random(-1.99, maxID+1));
          pieces[i][j][1] = int(random(0, 4));
        } else { // 95% of pieces are blank
          pieces[i][j][0] = -1;
          pieces[i][j][1] = 0;
        }
      }
    }
  }
  
  decodePieces();
}
  
