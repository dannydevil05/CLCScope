/*
This is a simple demo of using the giCentre geoMap library to draw a simple interactive map
*/

import org.gicentre.geomap.*;

GeoMap geoMap;
GeoMap geoMap1;
GeoMap geoMap2;


int offset = 400;

// 96 x 96
// scale: 10m / Lego unit
// scale: 5m  / Lego Unit

void setup()
{
  size(800, 800);
  geoMap = new GeoMap(this);
  geoMap1 = new GeoMap(this);
  geoMap2 = new GeoMap(this);
//  
//    geoMap = new GeoMap(-offset, -offset, width+offset, height+offset, this);
//  geoMap1 = new GeoMap(-offset, -offset, width+offset, height+offset, this);
//  geoMap2 = new GeoMap(-offset, -offset, width+offset, height+offset, this);
  
  geoMap.readFile("JE Land Use");
  geoMap1.readFile("JE Road Network");
  geoMap2.readFile("JE pedestrian network v2");
  //also want amenities 
  
  // Set up text appearance.
  textAlign(LEFT, BOTTOM);
  textSize(12);
  println("Data read...");
// println(geoMap.getAttributes().writeAsTable(10));
}
 
void draw()
{
  //draw the maps
  background(255);  
  stroke(#6633ff);        //lines      
  fill(#99ff99);          // Land colour
  geoMap.draw();    
  stroke(255, 0, 0);              //roadnetwork color
  strokeWeight(1);
//  geoMap1.draw();
  stroke(0);
//  geoMap2.draw();
  
  //call hover interactive function
  hover();
  
//draw a grid  
//  stroke(#FF0000);
//  for (int i=0; i<=22; i++)
//    line((i)/22.0*height/2, 0, (i)/22.0*height/2, width/2);
//  
//  for (int i=0; i<=22; i++) 
//    line(0, (i)/22.0*width/2, height/2, (i)/22.0*width/2);
  
    
}
