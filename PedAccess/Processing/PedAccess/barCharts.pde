//Initialize parameters
// GFA of mixed uses
int b1GFA,commercialGFA,residentialGFA,parkGFA,institutionGFA; 
int resPOP,b1POP,comPOP;

int prevPark,prevPOP=0;
int transitionRate=10;
//transition pixels
int parkTransition=0; 
int popTransition=0;

Table typology;
void loadTypologyTable(){
  typology=loadTable("data/WIA_building_typology_gfa.csv","header");
}
  

void calculateGFA(){
  JSONObject poi;
  b1GFA=0;
  commercialGFA=0;
  residentialGFA=0;
  parkGFA=0;
  institutionGFA=0;
  for (int i=0; i<newPOIs.size (); i++) {
    poi = newPOIs.getJSONObject(i);
    int currentB1 = newPOIs.getJSONObject(i).getInt("b1");
    int currentCommercial= newPOIs.getJSONObject(i).getInt("commercial");
    int currentResidential= newPOIs.getJSONObject(i).getInt("residential");
    int currentPark=newPOIs.getJSONObject(i).getInt("park");
    int currentInstitution=newPOIs.getJSONObject(i).getInt("institution");
    b1GFA+=currentB1;
    commercialGFA+=currentCommercial;
    residentialGFA+=currentResidential;
    parkGFA+=currentPark;
    institutionGFA+=currentInstitution;
  }
}


void calculatePOP(){
  
  resPOP=b1POP=comPOP=0;
  float POPperResArea=3.4/85.0; // people per m^2 of residential area
  float POPperComArea=1/20.0;
  float POPperB1Area=1/30.0;
 resPOP=int(residentialGFA*POPperResArea);
 comPOP=int(commercialGFA*POPperComArea);
 b1POP=int(b1GFA*POPperB1Area);
}
  
  
  
  
  
void drawBarCharts(){
  pushMatrix();
  calculatePOP();
  
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int maxChartHeight=int(16.0/22.0*TABLE_IMAGE_HEIGHT);
  int chartHeight;
  int ycounter=int(3*TABLE_IMAGE_HEIGHT/22.0);

  
  //Draw employment population
  color lightgreen=#bcff00; 
  color darkgreen=#16451c;
  translate(-barWidth*0.8, 0);
  employmentChart.initBar();
  employmentChart.setColor(darkgreen,lightgreen);
  employmentChart.setVar (b1POP+comPOP,5000);
  employmentChart.drawThisChart();
     
    
 //Draw Residential Population
  color lightgrey=#c1d6da;
  color darkgrey=#1c1919;
  color lightbrown=#f8de7e;
  color darkbrown=#7c5102;
  translate(-barWidth*2.0/3.0, 0);
  residentChart.initBar();
  residentChart.setColor(lightgrey,darkgrey);
  residentChart.setVar(resPOP,5000);
  residentChart.drawThisChart();

    
  popMatrix();
}

void drawQuantumBar(){  
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int chartHeight = TABLE_IMAGE_HEIGHT*15/22;  
  float ycounter=3*TABLE_IMAGE_HEIGHT/22.0;
  textSize(16);
  fill(textColor);
  textAlign(CENTER);
  text("MIXED", STANDARD_MARGIN+0.15*barWidth, ycounter);
  text("USE %", STANDARD_MARGIN+0.15*barWidth, ycounter+20);
  textAlign(LEFT);
  ycounter+=TABLE_IMAGE_HEIGHT/22.0;
  calculateGFA(); 
  float categoryGFA[]=
    { //floor space of each category
     residentialGFA,
     commercialGFA,
     b1GFA,
     institutionGFA
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
    float ratio=categoryGFA[i]/(categoryGFA[0]+categoryGFA[1]+categoryGFA[2]+categoryGFA[3]);
    
    if (ratio!=0){
      rect(STANDARD_MARGIN, ycounter, 0.3*barWidth, ratio*chartHeight);
      
      textSize(20);
      fill(textColor);
      //text(int(1000*ratio)/10.0 + "%",barWidth/2, 100+i*70);
  
      text(int(1000*ratio)/10.0 + "%",barWidth/2, ycounter+7+ratio*chartHeight/2);
      textSize(16);
      text(barLabel,barWidth/2, ycounter+7-20+ratio*chartHeight/2);     
      textSize(12);
      text(nfc(int(categoryGFA[i]))+"m2",barWidth/2, ycounter+7+20+ratio*chartHeight/2);     
      ycounter+=int(ratio*chartHeight);
    }
  }
    //fill(textColor);
   
}

class BarChart{
  
  color bottomCol,topCol; 
  int barWidth;
  int barHeight;
  int maxChartHeight;
  int chartHeight;
  int ycounter;
  int maxVar;
  int prevVar=0;
  int curVar;
  int dy=0;
  
  String label[]=new String[2];
  
  BarChart(){
  }
  
  void initBar(){
    barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
    barHeight = TABLE_IMAGE_HEIGHT;
    maxChartHeight=int(16.0/22.0*TABLE_IMAGE_HEIGHT);
    ycounter=int(3*TABLE_IMAGE_HEIGHT/22.0);
  }
    
  
  void setVar(int var, int max){
    curVar=var;
    maxVar=max;
  }
    
  void setLabel(String label){
   this.label=split(label," ");
  }
  
  void setColor(color bottom, color top){
    bottomCol=bottom;
    topCol=top;
  }
  
  void drawThisChart(){                                                                      
    fill(textColor);
    textSize(16);
    textAlign(CENTER);
    text(label[0], barWidth/2 , ycounter);
    text(label[1], barWidth/2, ycounter+20);
    chartHeight=int(prevVar/float(maxVar)*maxChartHeight)+dy;
    String varReading=nfc(prevVar+int(float(dy)/maxChartHeight*maxVar));
    //chartHeight=map(parkGFA,0,maxVar,0,maxChartHeight);
    //print("y : "+ ycounter+"\n");
    for (int i=chartHeight; i>=0; i--){
      if (i==chartHeight) text(varReading,barWidth/2,maxChartHeight-chartHeight+ycounter-10);
      fill(lerpColor(bottomCol, topCol,i/float(maxChartHeight)));
      rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,1);
      ycounter+=1;
    }
    if( curVar>prevVar &&(map(curVar,0,maxVar,0,maxChartHeight)>=chartHeight+transitionRate)){
      dy+=transitionRate;
    }
    else if( curVar<prevVar &&(map(curVar,0,maxVar,0,maxChartHeight)<=chartHeight-transitionRate)){
      dy-=transitionRate;
    }
    else {
      prevVar=curVar;
      dy=0;
    }
    ycounter=int(3*table.height/22.0);
  }
}
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
/*  //Draw Emission Offset
  color lightgreen=#bcff00; 
  color darkgreen=#16451c;
  translate(-barWidth*0.8, 0);
  fill(textColor);
  textSize(16);
  textAlign(CENTER);
  text("EMISSION", barWidth/2, ycounter);
  text("OFFSET", barWidth/2, ycounter+20);
  chartHeight=int(prevPark/30000.0*maxChartHeight)+parkTransition;
  String indicator=nfc(prevPark+int(float(parkTransition)/maxChartHeight*30000));
  //chartHeight=map(parkGFA,0,30000,0,maxChartHeight);
  for (int i=int(chartHeight/chartSlice); i>=0; i--){
    if (i==chartHeight/chartSlice) text(indicator,barWidth/2,maxChartHeight-chartHeight+ycounter-10);
    fill(lerpColor(darkgreen, lightgreen,i/300.0));
    rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,chartSlice);
    ycounter+=chartSlice;
  }
  //fill(darkgreen);
  //rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,chartHeight);
  if( parkGFA>prevPark &&(map(parkGFA,0,30000,0,maxChartHeight)>=chartHeight+transitionRate)){
    parkTransition+=transitionRate;
  }
  else if( parkGFA<prevPark &&(map(parkGFA,0,30000,0,maxChartHeight)<=chartHeight-transitionRate)){
    parkTransition-=transitionRate;
  }
  else {
    prevPark=parkGFA;
    parkTransition=0;
  }*/
  
  
  
  
  /*
  void drawBarCharts(){
  pushMatrix();
  calculatePOP();
  
  int barWidth = int(4.0*TABLE_IMAGE_WIDTH/18);
  int barHeight = TABLE_IMAGE_HEIGHT;
  int maxChartHeight=int(16.0/22.0*TABLE_IMAGE_HEIGHT);
  int chartHeight;
  int ycounter=int(3*TABLE_IMAGE_HEIGHT/22.0);

  
  //Draw employment population
  color lightgreen=#bcff00; 
  color darkgreen=#16451c;
  translate(-barWidth*0.8, 0);
  
  fill(textColor);
  textSize(16);
  textAlign(CENTER);
  text("EMPLOY.", barWidth/2, ycounter);
  text("POP", barWidth/2, ycounter+20);
  chartHeight=int(prevPark/5000.0*maxChartHeight)+parkTransition;
  String indicator=nfc(prevPark+int(float(parkTransition)/maxChartHeight*5000));
  //chartHeight=map(parkGFA,0,5000,0,maxChartHeight);
  for (int i=chartHeight; i>=0; i--){
    if (i==chartHeight) text(indicator,barWidth/2,maxChartHeight-chartHeight+ycounter-10);
    fill(lerpColor(darkgreen, lightgreen,i/float(maxChartHeight)));
    rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,1);
    ycounter+=1;
  }
  //fill(darkgreen);
  //rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,chartHeight);
  if( (b1POP+comPOP)>prevPark &&(map((b1POP+comPOP),0,5000,0,maxChartHeight)>=chartHeight+transitionRate)){
    parkTransition+=transitionRate;
  }
  else if( b1POP+comPOP<prevPark &&(map((b1POP+comPOP),0,5000,0,maxChartHeight)<=chartHeight-transitionRate)){
    parkTransition-=transitionRate;
  }
  else {
    prevPark=b1POP+comPOP;
    parkTransition=0;
  }
    
    
 //Draw Residential Population
  color lightgrey=#c1d6da;
  color darkgrey=#1c1919;
  color lightbrown=#f8de7e;
  color darkbrown=#7c5102;
  translate(-barWidth*2.0/3.0, 0);
  ycounter=int(3*TABLE_IMAGE_HEIGHT/22.0);
  fill(textColor);
  textAlign(CENTER);
  text("RESID.", barWidth/2, ycounter);
  text("POP", barWidth/2, ycounter+20);
  //int emissionGen=commercialGFA+institutionGFA+b1GFA;
  chartHeight=int((prevPOP)/5000.0*maxChartHeight)+popTransition;
  //indicator=nfc(resPOP+int(float(popTransition)/maxChartHeight*5000));    
  for (int i=chartHeight; i>=0; i--){
    if (i==chartHeight) text(nfc(resPOP),barWidth/2,maxChartHeight-chartHeight+ycounter-10);
    fill(lerpColor(lightgrey, darkgrey,i/float(maxChartHeight)));
    rect( barWidth/3,maxChartHeight-chartHeight+ycounter,0.3*barWidth,1);
    ycounter+=1;
  }
  
  if( resPOP>prevPOP &&(map(resPOP,0,5000,0,maxChartHeight)>=chartHeight+transitionRate)){
    popTransition+=transitionRate;
  }
  else if( resPOP<prevPOP &&(map(resPOP,0,5000,0,maxChartHeight)<=chartHeight-transitionRate)){
    popTransition-=transitionRate;
  }
  else {
    prevPOP=resPOP;
    popTransition=0;
  }
    
  popMatrix();
}*/
