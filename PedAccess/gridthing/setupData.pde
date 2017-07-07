float[] getBounds(List<Feature> feats) { 
        float[] ret = new float[4];
        float xmin = Float.POSITIVE_INFINITY;
        float xmax = Float.NEGATIVE_INFINITY;
        float ymin = Float.POSITIVE_INFINITY;
        float ymax = Float.NEGATIVE_INFINITY;
      
        //what is this doing exactly...
        //Geometry is an attribute of feature; is feature the whole shape file? 
        for (Feature feat : feats) {
          Geometry geom = (Geometry)feat.getDefaultGeometryProperty().getValue();
          //is thus the envelope for the geometry information 
          Envelope env = geom.getEnvelopeInternal();
          xmin = min(xmin, Double.valueOf(env.getMinX()).floatValue());
          xmax = max(xmax, Double.valueOf(env.getMaxX()).floatValue());
          ymin = min(ymin, Double.valueOf(env.getMinY()).floatValue());
          ymax = max(ymax, Double.valueOf(env.getMaxY()).floatValue());
        }
      
        println("Shapefile Extents: " + xmin, xmax, ymin, ymax);
      
        ret[0] = xmin;
        ret[1] = ymin;
        ret[2] = xmax;
        ret[3] = ymax;
        return ret;
}

List<Feature> feats;
Grid grid;


void setSingData() {
        shapefile_name = "singapore";
        shapefile_filesuffix = ".shp";
        shapefile_filename = shapefile_name + shapefile_filesuffix;
      
        // resampling grid parameters
        centerlat = 103.7;
        centerlon = 1.3333;
      
//        cellwidth = 70.0;
        theta = radians(0);
}

void setSingPathData() {
        shapefile_name = "road_and_ped_net";
        shapefile_filesuffix = ".shp";
        shapefile_filename = shapefile_name + shapefile_filesuffix;
      
        // resampling grid parameters
        centerlat = 103.7;
        centerlon = 1.3333;
      
//        cellwidth = 70.0;
        theta = radians(15);
}


// data-to-screen scaling variables;
float[] bounds;
float objx;
float objy;
float yscale;
float xscale;

// grid of resampled data
float[][] resampled;

STRtree index;

void setScale() {
        // get the bounding box of the shapefile
        //is the bounding box the grid that the user sees, seems like overall feature bounds
        bounds = getBounds(feats);
      
        float ll = bounds[0];
        float bb = bounds[1];
        float rr = bounds[2];
        float tt = bounds[3];
      
        objx = (rr+ll)/2;
        objy = (tt+bb)/2;
      
        yscale=ysize/(tt-bb);
        xscale=xsize/(rr-ll);
}


void scaleToBounds() {
        translate(width/3, height/2); 
        scale(xscale, -yscale); 
        translate(-objx, -objy);
}
