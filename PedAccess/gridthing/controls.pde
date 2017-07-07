//sets centerlon and lat as where pressed, goes off based on the scale 
void mousePressed() {
      float x = mouseX;
      float y = mouseY;
    
      x -= width/3;
      y -= height/2;
    
      x /= xscale;
      y /= -yscale;
    
      x += objx;
      y += objy;
    
      centerlon = x;
      centerlat = y;
    
      makeGridAndResample(true);
      loop();
}

void keyPressed() {
      //change rotation, do want this for beta testing 
      if (key=='r') {
        theta -= PI/120;
        makeGridAndResample(true);
        loop();
      }
     
      else if (key=='l') {
        theta += PI/120;
        makeGridAndResample(true);
        loop();
      } 
      
      else if (key=='+') {
        cellwidth *= 1.1;
        makeGridAndResample(true);
        loop();
      } 
      
      else if (key=='-') {
        cellwidth /= 1.1;
        makeGridAndResample(true);
        loop();
      } 
      
      else if (key=='g') {
        if (drawGrid) {
          drawGrid = false;
        } else {
          drawGrid = true;
        }
        loop();
      } 
      
      else if (key=='a') {
        nrows += 1;
        ncols += 1;
        makeGridAndResample(true);
        loop();
      } 
      
      else if (key=='s') {
        nrows -= 1;
        ncols -= 1;
        makeGridAndResample(true);
        loop();
      }
}
