PImage[] networkRaster;
JSONArray rasterNodes;

void importRaster() {
  
  /* 0 = Vehicle Road Network
   * 1 = Surface Level Pedestrian Pathways
   * 2 = Surface Level Pedestrian Street Crossing
   * 3 = Covered Linkway Redestrian Pathway
   * 4 = Ground-Bridge-Ground Street Crossing
   * 5 = 2nd Level Pedestrian Causeway
   */
  
  networkRaster = new PImage[6];
  networkRaster[0] = loadImage("data/network_roads.png");
  networkRaster[1] = loadImage("data/network_groundped.png");
  networkRaster[2] = loadImage("data/network_crossingped.png");
  networkRaster[3] = loadImage("data/network_linkway.png");
  networkRaster[4] = loadImage("data/network_bridgeped.png");
  networkRaster[5] = loadImage("data/network_2ndped.png");
  
  rasterNodes = new JSONArray();
}

void processRaster(PImage raster, int U, int V, int layer) {
  
  // test 1 pixel per grid cell..
  raster.resize(U, V);
  boolean flag;
  float uWidth = float(raster.width)/U;
  float vWidth = float(raster.height)/V;
  float cellPixels = uWidth*vWidth;
  
  raster.loadPixels();
  for (int u=0; u<U; u++) {
    for (int v=0; v<V; v++) {
      flag = false;
      for (int x=0; x<uWidth; x++) {
        for (int y=0; y<vWidth; y++) {
          int index = int(v*vWidth*raster.width + y*raster.width + u*uWidth + x);
          if (index < raster.width*raster.height) {
            //if (brightness(raster.pixels[index]) < 255) {
            if (alpha(raster.pixels[index]) > 0) {
              flag = true;
            }
          } else {
            println("index: " + index);
          }
        }
      }
      if (flag) {
        JSONObject node = new JSONObject();
        node.setInt("u", u);
        node.setInt("v", v);
        
        /* 0 = Vehicle Road Network
         * 1 = Surface Level Pedestrian Pathways
         * 2 = Surface Level Pedestrian Street Crossing
         * 3 = Covered Linkway Redestrian Pathway
         * 4 = Ground-Bridge-Ground Street Crossing
         * 5 = 2nd Level Pedestrian Causeway
         */
   
        switch(layer) {
          case 0: // Vehicle Road Network
            node.setInt("z", 0);
            node.setString("type", "road");
            node.setBoolean("crossing", false);
            break;
          case 1: // Surface Level Pedestrian Pathways
            node.setInt("z", 0);
            node.setString("type", "ped_ground");
            node.setBoolean("crossing", false);
            break;
          case 2: // Surface Level Pedestrian Street Crossing
            node.setInt("z", 0);
            node.setString("type", "ped_xing");
            node.setBoolean("crossing", true);
            break;
          case 3: // Covered Linkway Redestrian Pathway
            node.setInt("z", 0);
            node.setString("type", "ped_linkway");
            node.setBoolean("crossing", false);
            break;
          case 4: // Ground-Bridge-Ground Street Crossing
            node.setInt("z", 1);
            node.setString("type", "ped_bridge");
            node.setBoolean("crossing", true);
            break;
          case 5: // 2nd Level Pedestrian Causeway
            node.setInt("z", 2);
            node.setString("type", "ped_2nd");
            node.setBoolean("crossing", false);
            break;
        }
        rasterNodes.setJSONObject(rasterNodes.size(), node);
      }
    }
  }
  println(rasterNodes.size() + " " + U + "x" + V + " RasterNodes");
}
