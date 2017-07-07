void drawPolygons() {
  noStroke();
  strokeWeight(.00001);

  MultiPolygon geom;

  for (Feature feat : feats ) {
    geom = (MultiPolygon) feat.getDefaultGeometryProperty().getValue();

    fill(255); 

    for (int i=0; i<geom.getNumGeometries (); i++) {

      Geometry subgeom = geom.getGeometryN(i); //returns the subgeometry 
      Coordinate[] coords = subgeom.getCoordinates(); 
      beginShape();
      for (Coordinate coord : coords) {
        vertex((float)coord.x, (float)coord.y);
        stroke(0);
      }
      endShape(CLOSE);
    }
  }
}


//void drawLines() {
//  noStroke();
//  strokeWeight(.00001);
//
//  MultiLineString geom;
//
//  for (Feature feat : feats ) {
//    geom = (MultiLineString) feat.getDefaultGeometryProperty().getValue();
//
//    fill(255); 
//
//    for (int i=0; i<geom.getNumGeometries (); i++) {
//
//      Geometry subgeom = geom.getGeometryN(i); //returns the subgeometry 
//      Coordinate[] coords = subgeom.getCoordinates(); 
//      beginShape();
//      for (Coordinate coord : coords) {
//        vertex((float)coord.x, (float)coord.y);
//        stroke(0);
//      }
//      endShape(CLOSE);
//    }
//  }
//}
