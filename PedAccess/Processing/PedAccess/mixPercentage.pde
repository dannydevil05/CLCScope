int totalB1,totalCommercial,totalResidential;

void calculateSpace(){
  JSONObject poi;
  totalB1=0;
  totalCommercial=0;
  totalResidential=0;
  for (int i=0; i<newPOIs.size (); i++) {
    poi = newPOIs.getJSONObject(i);
    int currentB1 = newPOIs.getJSONObject(i).getInt("b1");
    int currentCommercial= newPOIs.getJSONObject(i).getInt("commercial");
    int currentResidential= newPOIs.getJSONObject(i).getInt("residential");
    totalB1+=currentB1;
    totalCommercial+=currentCommercial;
    totalResidential+=currentResidential;
  }
}
  
  
