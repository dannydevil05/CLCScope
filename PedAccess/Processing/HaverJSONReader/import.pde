void importNodes() {
  
  switch(scale) {
    case 5:
      nodes = loadJSONArray("data/" + data5);
      break;
    case 10:
      nodes = loadJSONArray("data/" + data10);
      break;
    case 20:
      nodes = loadJSONArray("data/" + data20);
      break;
    case 40:
      nodes = loadJSONArray("data/" + data40);
      break;
  }
  
  println("Number of nodes: " + nodes.size());
  
  amenity = loadJSONArray("data/ammenities_" + scale + "m.json");
  transit = loadJSONArray("data/transitStops_" + scale + "m.json");
  
}

void cleanNodes(JSONArray nodes, int arrayWidth) {
  
  printNode(nodes, 0);
  
  // Nina's node values are in arbitrary pixelsaccording to the following:
  float gridScale = 800.0/arrayWidth;
  
  JSONObject node;
  float u, v;
  
  for (int i=0; i<nodes.size(); i++) {
    node = nodes.getJSONObject(i);
    u = node.getFloat("u");
    v = node.getFloat("v") + 72;
    node.setInt("u", int(u/gridScale));
    node.setInt("v", int(v/gridScale));
  }
  
  printNode(nodes, 0);
}

void printNode(JSONArray nodes, int i) {
  if (nodes.size() > 0) {
    println("Node(" + i + ").u: " + nodes.getJSONObject(i).getInt("u") );
    println("Node(" + i + ").v: " + nodes.getJSONObject(i).getInt("v") );
    println("Node(" + i + ").z: " + nodes.getJSONObject(i).getInt("z") );
    println("Node(" + i + ").crossing: " + nodes.getJSONObject(i).getBoolean("crossing") );
  }  
}
