// Initialize amenity and Bus Stop Data

JSONArray ammenities, transitStops;
Table POI_CSV;

void processPointsOfInterest() {
  
  ammenities = new JSONArray();
  transitStops = new JSONArray();

  String[] fileNames = {     
    /* 0 */ "JE AquaticSG.csv",
    /* 1 */ "JE Busstop.csv",
    /* 2 */ "JE childcare.csv",
    /* 3 */ "JE clinic.csv",
    /* 4 */ "JE communityclubs.csv",
    /* 5 */ "JE eldercare.csv",
    /* 6 */ "JE hawkercenter.csv",
    /* 7 */ "JE Hospitals.csv",
    /* 8 */ "JE hotels.csv",
    /* 9 */ "JE kindergartens.csv",
    /* 10 */ "JE library.csv",
    /* 11 */ "JE Malls.csv",
    /* 12 */ "JE MRTs.csv",
    /* 13 */ "JE museum.csv",
    /* 14 */ "JE PrivateEducationInstitution.csv",
    /* 15 */ "JE Religious Places.csv",
    /* 16 */ "JE schools.csv"
  };

  String type, subtype;
  for (int i=0; i<fileNames.length; i++) {
    POI_CSV = loadTable("data/POI/" + fileNames[i], "header");
    
    type = "";
    subtype = "";
    
    switch(i) {
      case 0:
        type = "amenity";
        subtype = "health";
        break;
      case 1:
        type = "transit";
        subtype = "bus_stop";
        break;
      case 2:
        type = "amenity";
        subtype = "child_care";
        break;
      case 3:
        type = "amenity";
        subtype = "health";
        break;
      case 4:
        type = "amenity";
        subtype = "eldercare";
        break;
      case 5:
        type = "amenity";
        subtype = "eldercare";
        break;
      case 6:
        type = "amenity";
        subtype = "retail";
        break;
      case 7:
        type = "amenity";
        subtype = "health";
        break;
      case 8:
        type = "amenity";
        subtype = "retail";
        break;
      case 9:
        type = "amenity";
        subtype = "school";
        break;
      case 10:
        type = "amenity";
        subtype = "school";
        break;
      case 11:
        type = "amenity";
        subtype = "retail";
        break;
      case 12:
        type = "transit";
        subtype = "mrt";
        break;
      case 13:
        type = "amenity";
        subtype = "school";
        break;
      case 14:
        type = "amenity";
        subtype = "school";
        break;
      case 15:
        type = "amenity";
        subtype = "retail";
        break;
      case 16:
        type = "amenity";
        subtype = "school";
        break;
    }
    
    float lat, lon;
    int uv[];
    for (int j=0; j<POI_CSV.getRowCount(); j++) {
      lat = POI_CSV.getFloat(j, "Y");
      lon = POI_CSV.getFloat(j, "X");
      
      // Fetch grid location of Customer coordinate
      uv = LatLontoGrid(lat, lon, centerLatitude, centerLongitude, azimuth, gridSize, gridV, gridU);
      
      JSONObject POI = new JSONObject();
      
      POI.setInt("u", -uv[0]);
      POI.setInt("v", uv[1] - int(85.0/scale));
      POI.setString("type", type);
      POI.setString("subtype", subtype);
      
      if (type.equals("amenity")) {
        ammenities.setJSONObject(ammenities.size(), POI);
      } else if(type.equals("transit")) {
        transitStops.setJSONObject(transitStops.size(), POI);
      }
    }
  }
  println("Ammenities Loaded: " + ammenities.size());
  println("Transit Loaded: " + transitStops.size());
    
}
