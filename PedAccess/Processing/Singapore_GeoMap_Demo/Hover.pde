void hover(){

//see region at mouse position
  int loc = geoMap.getID(mouseX, mouseY);
  if (loc != -1)
  {
    //give it a different fill
    fill(#ffff66);
    
    //assign specific fills given different attributes
    if(geoMap.getAttributes().getString(loc, 2).equals("WATERBODY")){
      fill( #99ccff);
    }
    if(geoMap.getAttributes().getString(loc, 2).equals("RESIDENTIAL")){
      fill( #cc99cc);
    }
    if(geoMap.getAttributes().getString(loc, 2).equals("ROAD")){
      fill(255);
    }
    if(geoMap.getAttributes().getString(loc, 2).equals("UTILITY")){
      fill(#cc6633);
    }
    if(geoMap.getAttributes().getString(loc, 2).equals("RESERVE SITE")){
       fill(#009966);
    }
    if(geoMap.getAttributes().getString(loc, 2).equals("HOTEL")){
       fill(#3399ff);
    }
     if(geoMap.getAttributes().getString(loc, 2).equals("BUSINESS 1")){
       fill(#00ffff);
    }
    geoMap.draw(loc);
   
    //print attribute
    String name = geoMap.getAttributes().getString(loc, 2);
    fill(0);
    text(name, mouseX+5, mouseY-5);
  }
}
