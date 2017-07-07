import java.util.List;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.MultiPolygon;
import com.vividsolutions.jts.geom.MultiLineString;
import com.vividsolutions.jts.geom.Polygon;
import com.vividsolutions.jts.geom.Point;
import com.vividsolutions.jts.geom.Envelope;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.index.strtree.STRtree;

import com.vividsolutions.jts.geom.GeometryFactory;

int nrows = 2;
int ncols = nrows;
int ysize = 700; //this is the y of my map
int xsize = 700; //this is the x of my map
float cellwidth = 90;

ArrayList<PVector> thing = new ArrayList<PVector>();


String shapefile_name, shapefile_filesuffix, shapefile_filename, property_name;

float  centerlon, centerlat, theta;


void setup() {
      size(1200, 800);
    
      setSingData();
//      setSingPathData();
    
      String filename = dataPath(shapefile_filename);
    
      // read the entire shapefile
      print( "begin reading..." );
      feats = getFeatures(filename, 1000000); 
      println( "done" );
      println( "read "+feats.size()+" features" );
      println( "first feature: "+feats.get(0) );
      println( "last feature: "+feats.get(feats.size()-1));
      println("done");
    
      setScale();  
      makeGridAndResample(true);
      smooth();
      
}


void draw() {

      println("framerate is", frameRate);
      background(255);
      
      drawRenderedArea();
      drawMinimap();
      
      scaleToBounds();
    
      drawPolygons();
      drawGrid();
      
      noLoop(); //loop once through and stop
}

