int totalB1,totalCommercial,totalResidential,totalPark,totalInstitution;
Table typology;
void loadTypologyTable(){
  typology=loadTable("data/Building_Typology_WIA.csv","header");
}
  

void calculateSpace(){
  JSONObject poi;
  totalB1=0;
  totalCommercial=0;
  totalResidential=0;
  totalPark=0;
  totalInstitution=0;
  for (int i=0; i<newPOIs.size (); i++) {
    poi = newPOIs.getJSONObject(i);
    int currentB1 = newPOIs.getJSONObject(i).getInt("b1");
    int currentCommercial= newPOIs.getJSONObject(i).getInt("commercial");
    int currentResidential= newPOIs.getJSONObject(i).getInt("residential");
    int currentPark=newPOIs.getJSONObject(i).getInt("park");
    int currentInstitution=newPOIs.getJSONObject(i).getInt("institution");
    totalB1+=currentB1;
    totalCommercial+=currentCommercial;
    totalResidential+=currentResidential;
    totalPark+=currentPark;
    totalInstitution+=currentInstitution;
  }
}

void drawEmissionBar(){
  pushMatrix();
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int maxChartHeight=int(17.0/22.0*TABLE_IMAGE_HEIGHT);
  int chartSlice=int (maxChartHeight/100.0);
  int chartHeight;
  int ycounter=int(TABLE_IMAGE_HEIGHT/22.0);

  
  //Draw Emission Offset
  color lightgreen=#bcff00; 
  color darkgreen=#16451c;
  translate(-barWidth, 0);
  fill(textColor);
  textAlign(CENTER);
  text("EMISSION", barWidth/2, ycounter);
  text("OFFSET", barWidth/2, ycounter+20);
  chartHeight=int(totalPark/30000.0*maxChartHeight);
  for (int i=chartHeight/chartSlice;i>=0;i--){
    if (i==chartHeight/chartSlice) text(nfc(totalPark),barWidth/2,maxChartHeight-chartHeight+ycounter-10);
    fill(lerpColor(darkgreen, lightgreen,i/100.0));
    rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,chartSlice);
    ycounter+=chartSlice;
  }
    
 //Draw Emission Generated 
  color lightgrey=#c1d6da;
  color darkgrey=#1c1919;
  color lightbrown=#f8de7e;
  color darkbrown=#7c5102;
  translate(-barWidth*2.0/3.0, 0);
  ycounter=int(TABLE_IMAGE_HEIGHT/22.0);
  fill(textColor);
  textAlign(CENTER);
  text("EMISSION", barWidth/2, ycounter);
  text("GENERATED", barWidth/2, ycounter+20);
  int emissionGen=totalCommercial+totalInstitution+totalB1;
  chartHeight=int((emissionGen)/300000.0*maxChartHeight);
  for (int i=chartHeight/chartSlice;i>=0;i--){
    if (i==chartHeight/chartSlice) text(nfc(emissionGen),barWidth/2,maxChartHeight-chartHeight+ycounter-10);
    fill(lerpColor(lightgrey, darkgrey,i/100.0));
    rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,chartSlice);
    ycounter+=chartSlice;
  }
    
  popMatrix();
}

void drawQuantumBar(){  
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int chartHeight = TABLE_IMAGE_HEIGHT*16/22;  
  float ycounter=TABLE_IMAGE_HEIGHT/22.0;
  textSize(16);
  fill(textColor);
  text("MIXED", barWidth/2, ycounter);
  text("USE % ", barWidth/2, ycounter+20);
  ycounter=ycounter*2;
  calculateSpace(); 
  float numPOIs[]=
    { //floor space of each category
     totalResidential,
     totalCommercial,
     totalB1,
     totalInstitution
   };
  String barLabel="";
  for (int i=0; i<4;i++){
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
    case 3:
      fill(lightblueBrick);
      barLabel="INST";
      break;
    }
    float ratio=numPOIs[i]/(numPOIs[0]+numPOIs[1]+numPOIs[2]+numPOIs[3]);
    
    if (ratio!=0){
      rect(STANDARD_MARGIN, ycounter, 0.3*barWidth, ratio*chartHeight);
      
      textSize(20);
      fill(textColor);
      //text(int(1000*ratio)/10.0 + "%",barWidth/2, 100+i*70);
  
      text(int(1000*ratio)/10.0 + "%",barWidth/2, ycounter+7+ratio*chartHeight/2);
      textSize(16);
      text(barLabel,barWidth/2, ycounter+7-20+ratio*chartHeight/2);     
      ycounter+=ratio*chartHeight;
    }
  }
    //fill(textColor);
   
}
  
  
  
  
