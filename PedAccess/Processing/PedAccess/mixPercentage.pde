int totalB1,totalCommercial,totalResidential,totalPark;


void calculateSpace(){
  JSONObject poi;
  totalB1=0;
  totalCommercial=0;
  totalResidential=0;
  totalPark=0;
  for (int i=0; i<newPOIs.size (); i++) {
    poi = newPOIs.getJSONObject(i);
    int currentB1 = newPOIs.getJSONObject(i).getInt("b1");
    int currentCommercial= newPOIs.getJSONObject(i).getInt("commercial");
    int currentResidential= newPOIs.getJSONObject(i).getInt("residential");
    int currentPark=newPOIs.getJSONObject(i).getInt("park");
    totalB1+=currentB1;
    totalCommercial+=currentCommercial;
    totalResidential+=currentResidential;
    totalPark+=currentPark;
  }
}

void drawEmissionBar(){
  pushMatrix();
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int chartHeight = TABLE_IMAGE_HEIGHT*18/22; 
  color lightgreen=#bcff00; 
  color darkgreen=#007a08;
  translate(-barWidth+10, 0);
  fill(textColor);
  textAlign(CENTER);
  text("EMISSION", barWidth/3, 10);
  text("LEVELS ", barWidth/3, 30);
  float ypixels=float(totalPark)/30000*chartHeight;
  float ycounter=0;
  for (int i=0;i<100;i++){
    fill(lerpColor(lightgreen,darkgreen,i/100.0));
    //fill(lightgreen);
    rect( barWidth/3,chartHeight-ypixels+ycounter,0.3*barWidth,ypixels/100);
    ycounter+=ypixels/100;
      //for (int i=0; i<10; i++) {
    //fill(lerpColor(green, red, i/9.0)); //gradual shading of color
    //rect(barWidth/2, -50+i*barH, 0.3*barWidth, barH); 
  //}
  }
    
  popMatrix();
}
void drawQuantumBar(){  
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int chartHeight = TABLE_IMAGE_HEIGHT*18/22;  
  textSize(16);
  fill(textColor);
  text("MIXED", barWidth/2, 10);
  text("USE % ", barWidth/2, 30);
  calculateSpace(); 
  float numPOIs[]=
    { //category of spaces
     totalResidential,
     totalCommercial,
     totalB1
   };
  int ycounter=0;
  String barLabel="";
  for (int i=0; i<3;i++){
    switch (i){
    case 0:
      fill(creamBrick);
      barLabel="RES";
      break;
    case 1:
      fill(blueBrick);
      barLabel="COM";
      break;
    case 2:
      fill(purpleBrick);
      barLabel="B1";
      break;
    }
    float ratio=numPOIs[i]/(numPOIs[0]+numPOIs[1]+numPOIs[2]);
    rect(STANDARD_MARGIN, ycounter, 0.3*barWidth, ratio*chartHeight);
    
    textSize(20);
    fill(textColor);
    //text(int(1000*ratio)/10.0 + "%",barWidth/2, 100+i*70);
    text(int(1000*ratio)/10.0 + "%",barWidth/2, ycounter+7+ratio*chartHeight/2);
    textSize(16);
    text(barLabel,barWidth/2, ycounter+7-20+ratio*chartHeight/2);     
    ycounter+=ratio*chartHeight;
  }
    fill(textColor);
   
}
  
  
