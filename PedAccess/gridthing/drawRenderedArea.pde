void drawRenderedArea(){
  Table box;
  
  box = loadTable("export/" + nrows + "_" + centerlon  + "_" + centerlat + ".csv", "header");
   if(box.getRowCount() >= 0){
        float[] xcorn = new float[box.getRowCount()];
        float[] ycorn = new float[box.getRowCount()];
     for(int i = 0; i<box.getRowCount(); i++){
     xcorn[i] = box.getFloat(i, "xcorn");
     ycorn[i] = box.getFloat(i, "ycorn");
     }
     if(xcorn.length > 0){
         fill(0);
         ellipse(width*2/3, height/3, 30, 30);
     }
   }
}
