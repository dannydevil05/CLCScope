class Grid{
  //Create the unit conversion ratios. Equatorial Earth Radius = 6378.1km; Polar Earth Radius = 6356.8km;
  //I find the km per Longitude from the center and assume its constant over the region
  float eq_m_per_londeg = 2*PI*6378100.0/360;
  float m_per_londeg;
  float m_per_latdeg = 2*PI*6356800.0/360;
  
  List<Polygon> cells;
  int ncols;
  int nrows;
  
  //proj vs. unproj....??? Is this just to clear as you press elsewhere on map? 
  Coordinate proj(Coordinate coord){
    // deg * m/deg = m
    return new Coordinate(coord.x * m_per_londeg, coord.y * m_per_latdeg);
  }
  
  Coordinate unproj(Coordinate coord){
    // m / (m/deg) = m * (deg/m) = deg
    return new Coordinate(coord.x / m_per_londeg, coord.y / m_per_latdeg);
  }
  
  void unproj(Coordinate[] coords){
    for(int i=0; i<coords.length; i++){
      coords[i] = unproj(coords[i]);
      //this prints lat lon of each cell?
//      println(coords[i]); 
    }
  }
  
  Coordinate rotate(Coordinate coord, Coordinate center, float theta){
    double x = coord.x - center.x;
    double y = coord.y - center.y;
    double xprime = cos(theta)*x - sin(theta)*y;
    double yprime = sin(theta)*x + cos(theta)*y;
    return new Coordinate(center.x + xprime, center.y+yprime);
  }
  
  void rotate(Coordinate[] coords, Coordinate center, float theta){
    for(int i=0; i<coords.length; i++){
      coords[i] = rotate(coords[i], center, theta);
    }
  }
    
//creates the grid     
  Grid(float centerlat, float centerlon, float cellwidth, int ncols, int nrows, float theta) throws Exception{    
    m_per_londeg = cos( radians(centerlat) )*eq_m_per_londeg;
    
    Coordinate center = proj( new Coordinate(centerlon,centerlat) );
    float totalwidth = cellwidth*ncols;
    float totalheight = cellwidth*nrows;
    float left = (float)center.x - totalwidth/2;
    float bottom = (float)center.y - totalheight/2;
    
    this.nrows = nrows;
    this.ncols = ncols;
        
    List<Polygon> cells = new ArrayList<Polygon>();
    GeometryFactory fact = new GeometryFactory();
    for(int y=0; y<nrows; y++){
      for(int x=0; x<ncols; x++){

        // create coordinates of corners
        Coordinate[] coords = new Coordinate[5];
        coords[0] = new Coordinate(left+x*cellwidth,    bottom+y*cellwidth); //lower left
        coords[1] = new Coordinate(left+(x+1)*cellwidth,bottom+y*cellwidth); //lower right
        coords[2] = new Coordinate(left+(x+1)*cellwidth,bottom+(y+1)*cellwidth); //upper right
        coords[3] = new Coordinate(left+x*cellwidth,    bottom+(y+1)*cellwidth); //upper left
        coords[4] = new Coordinate(left+x*cellwidth,    bottom+y*cellwidth); //lower left
        
        this.rotate( coords, center, theta );
        this.unproj( coords );
        
        LinearRing linear = new GeometryFactory().createLinearRing(coords);
        Polygon poly = new Polygon(linear, null, fact);
        
        cells.add( poly );
      }
    }
    
    this.cells = cells;
  }
  
  String toString(){
    return "["+this.ncols+"x"+this.nrows+"]";
  }
  
  float[][] resample(STRtree index, String propname){
    
    float[][] ret = new float[nrows][ncols];
    
    for(int y=0; y<nrows; y++){
      for(int x=0; x<ncols; x++){
        //println("cell: ("+x+","+y+")");
        float sum = 0;
        
        Polygon cell = this.cells.get(y*ncols+x);
        
        List<Feature> queryFeats = index.query( cell.getEnvelopeInternal() );
        
        int nOverlaps = 0;
        for(Feature feat : queryFeats){
          MultiPolygon featgeom = (MultiPolygon) feat.getDefaultGeometryProperty().getValue();
          int ind = (Integer)feat.getProperty(propname).getValue();
          Geometry overlap = featgeom.intersection(cell);
          
          float fracOverlap = (float)(overlap.getArea()/featgeom.getArea());
          if(fracOverlap>0){
            nOverlaps += 1;
//            println( "  feat "+ind+" * "+(fracOverlap*100)+"% = "+(fracOverlap*ind) );
          }
          
          sum += fracOverlap*ind;
        }
//        println( "cell ("+x+","+y+") has "+nOverlaps+" overlapping features, sum:"+sum+"" );
        
        ret[y][x] = sum;
      }
    }
    
    return ret;
  }
  
  Polygon getCell(int x, int y){
    return this.cells.get(y*ncols+x);
  }
}
