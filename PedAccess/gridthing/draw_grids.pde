void drawGrid() {
      stroke(#ff0000);
      strokeWeight(.00001);
      noFill();
    
      Polygon cell;
    
      for (int y=0; y<nrows; y++) {
        for (int x=0; x<ncols; x++) {
          cell = grid.getCell(x, y);
    
          Coordinate[] coords = cell.getCoordinates();
          beginShape();
          for (Coordinate coord : coords) {
            vertex((float)coord.x, (float)coord.y);
            thing.add(new PVector((float)(coord.x), (float)(coord.y)));
          }
          endShape(CLOSE);
        }
      }
      
   
//      println("---");
//      println("Area of each Cell   = " + sq(cellwidth) + " square meters.");
//      println("Total Area of Cells = " + nrows*ncols*sq(cellwidth) + " square meters.");
}


boolean drawGrid = true;

void drawMinimap(){
        stroke(#00ff00);
        noFill();
        strokeWeight(2.5);
        rect(width*2/3, height/3, width/4, width/4);
        float x = width*2/3;
        float y = height/3;
        //draw mirror grid
            for(int i =0; i<nrows; i++){
              line(x, height/3, x, height/3+width/4);
              x+= (width/4)/nrows;
            }
            for(int i =0; i<ncols; i++){
              line(width*2/3, y, (width*2/3)+(width/4), y);
              y+= (width/4)/ncols;
            }
        
         fill(0);
        text("Click to make a grid", width*2/3, height/3 - width/65 - 60);  
        text("Key 'a' to add dim, 's' to subtract", width*2/3, height/3 - width/65 - 40);  
        text("Key 'l'to rotate left, 'r' to go right", width*2/3, height/3 - width/65 - 20);  
        text("Key + and - to increase cell size", width*2/3, height/3 - width/65);  
        
       text("Dim: " + nrows + "x" + ncols, width*2/3, height/3 + width/4 + 20);  
       text("Rotation: " + degrees(theta) + " degrees", width*2/3, height/3 + width/4 + 40);  
       text("Area of each Cell   = " + " square meters", width*2/3, height/3 + width/4 + 60);
       text("Total Area of Cells = " + " square meters", width*2/3, height/3 + width/4 + 80);
       
}

