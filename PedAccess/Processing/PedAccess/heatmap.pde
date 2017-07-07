float WALK_DISTANCE = 0.3; // 300 m
int IDEAL_POI_ACCESS = 6; // #POIs

int ageDemographic = 0;
// 0 = young
// 1 = working
// 2 = senior

float[][][] walkAccess = new float[3][displayU][displayV];
float[] avgWalkAccess = new float[3];

float[][] walkQuality = new float[displayU][displayV];

void initWalkAccess() {
  for (int i=0; i<walkAccess.length; i++) {
    for (int u=0; u<walkAccess[0].length; u++) {
      for (int v=0; v<walkAccess[0][0].length; v++) {
        walkAccess[i][u][v] = 0;
      }
    }
  }
}

void initWalkAccess(int ageDemo) {
  for (int u=0; u<walkAccess[ageDemo].length; u++) {
    for (int v=0; v<walkAccess[ageDemo][0].length; v++) {
      walkAccess[ageDemo][u][v] = 0;
    }
  }
}

void calcWalkAccess(int ageDemo) {
  initWalkAccess();
  
  for (int i=0; i<amenity.size(); i++) {
    addWalkAccess(amenity.getJSONObject(i), ageDemo);
  }
  for (int i=0; i<transit.size(); i++) {
    addWalkAccess(transit.getJSONObject(i), ageDemo);
  }
  for (int i=0; i<newPOIs.size(); i++) {
    addWalkAccess(newPOIs.getJSONObject(i), ageDemo);
  }
  
  calcAvgWalkAccess();
  
}

void addWalkAccess(JSONObject poi, int ageDemo) {
  
  int u = poi.getInt("u") - gridPanU;//- gridU/2;
  int v = poi.getInt("v") - gridPanV;// - gridV/2;
  String type = poi.getString("type");
  String subtype = poi.getString("subtype");
  
  boolean[] validForAge = new boolean[3];
  validForAge[0] = !subtype.equals("eldercare") && !subtype.equals("retail");
  validForAge[1] = !subtype.equals("school") && !subtype.equals("eldercare");
  validForAge[2] = !subtype.equals("school") && !subtype.equals("childcare");
  
  boolean validForFilter = true;
  if (amenityFilter == 0 && !subtype.equals("school") )
    validForFilter = false;
  if (amenityFilter == 1 && !subtype.equals("child_care") )
    validForFilter = false;
  if (amenityFilter == 2 && !subtype.equals("health") )
    validForFilter = false;
  if (amenityFilter == 3 && !subtype.equals("eldercare") )
    validForFilter = false;
  if (amenityFilter == 4 && !subtype.equals("retail") )
    validForFilter = false;
  if (amenityFilter == 5 && !subtype.equals("park") )
    validForFilter = false;
  if (amenityFilter == 6 && !type.equals("transit") )
    validForFilter = false;
  if (amenityFilter == 8 && !subtype.equals("housing") )
    validForFilter = false;
  
  if (validForAge[ageDemo] && validForFilter) {
    int area = int(WALK_DISTANCE/gridSize);
    int u_temp, v_temp;
    float dist;
    boolean valid;
    for (int dU=-area; dU<area; dU++) {
      for (int dV=-area; dV<area; dV++) {
        u_temp = u+dU;
        v_temp = v+dV;
        dist = sqrt(sq(dU*gridSize)+sq(dV*gridSize));
        valid = u_temp>=0 && u_temp<displayU && v_temp>=0 && v_temp<displayV;
        if (valid && WALK_DISTANCE > dist) {
          walkAccess[ageDemo][u_temp][v_temp] += (WALK_DISTANCE - dist) / WALK_DISTANCE;
          //println(walkAccess[ageDemo][u_temp][v_temp]);
        }
        
      }
    }
  }
}

void calcAvgWalkAccess() {
    
  for (int i=0; i<walkAccess.length; i++) {
    int IDEAL = 1;
    for (int u=0; u<walkAccess[0].length; u++) {
      for (int v=0; v<walkAccess[0][0].length; v++) {

        if (amenityFilter >= 0) {
          IDEAL = 1;
        } else if (i == 0) {
          IDEAL = IDEAL_POI_ACCESS - 2;
        } else {
          IDEAL = IDEAL_POI_ACCESS;
        }
  
        if (walkAccess[i][u][v] > IDEAL) walkAccess[i][u][v] = IDEAL;
        avgWalkAccess[i] += walkAccess[i][u][v];
      }
    }
    
    avgWalkAccess[i] /= (walkAccess[0].length*walkAccess[0][0].length*IDEAL);
    println("avgWalkAccess(" + i + "): " + avgWalkAccess[i]);
  }
}

void drawWalkAccess() {
  
  color red = #FF0000;
  color green = #00FF00;
  
  noStroke();
  float cellW = TABLE_IMAGE_WIDTH/(4.0*18);
  float cellH = TABLE_IMAGE_HEIGHT/(4.0*22);
  float cellGap = 0.2;
  int IDEAL = 1;
  if (amenityFilter >= 0) {
    IDEAL = 1;
  } else if (ageDemographic == 0) {
    IDEAL = IDEAL_POI_ACCESS - 2;
  } else {
    IDEAL = IDEAL_POI_ACCESS;
  }
  
  for (int u=0; u<walkAccess[ageDemographic].length; u++) {
    for (int v=0; v<walkAccess[ageDemographic][0].length; v++) {
      fill(lerpColor(red, green, walkAccess[ageDemographic][u][v]/IDEAL), 200);
      rect(TABLE_IMAGE_OFFSET + (u-cellGap)*cellW + 0.5*cellW, STANDARD_MARGIN + (v-cellGap)*cellH + 0.5*cellH, (1 - 2*cellGap)*cellW, (1 - 2*cellGap)*cellH);
    }
  }
}
