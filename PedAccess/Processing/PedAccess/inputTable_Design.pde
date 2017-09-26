String[] amenityNames = {
  "SCHOOL",
  "CHILDCARE",
  "HEALTHCARE",
  "ELDERCARE",
  "RETAIL",
  "PARK",
  "TRANSIT STOP",
  "PED. PATH",
  "HOUSING",
  "PED. BRIDGE",
  "ELEV. PATH",
  "PED-X'ING"
};

// Form Codes:
// 0 = void/no brick
// 1 = tan brick
// 2 = blue brick
// 3 = red brick
// 4 = black brick
// 5 = green brick
// 6 = white brick
// 7 = brown brick
// 8 = purple brick
// 9 = cream brick
//10 = lavender brick 
//11 = light blue brick
//12 = turquoise brick
  
  // Data Type
  /* 0 = Vehicle Road Network
   * 1 = Surface Level Pedestrian Pathways
   * 2 = Surface Level Pedestrian Street Crossing
   * 3 = Covered Linkway Redestrian Pathway
   * 4 = Ground-Bridge-Ground Street Crossing
   * 5 = 2nd Level Pedestrian Causeway
   */
   

void setupPiecesDesign() {
  
  inputData = new ArrayList<Integer[][]>();
  inputForm = new ArrayList<Integer[][]>();


  // 0: School
  Integer[][] data_0 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 1, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_0 = {
    { 1, 1, 1, 1 },
    { 1, 1, 1, 1 },
    { 0, 0, 1, 1 },
    { 0, 0, 0, 0 } };
  inputData.add(data_0);
  inputForm.add(form_0);
  
  // 1: Childcare
  Integer[][] data_3 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 3, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_3 = {
    { 0, 0, 0, 0 },
    { 0, 3, 3, 0 },
    { 0, 5, 5, 5 },
    { 0, 0, 0, 0 } };
  inputData.add(data_3);
  inputForm.add(form_3);
  
  // 2: Healthcare
  Integer[][] data_2 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 2, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_2 = {
    { 0, 3, 3, 3 },
    { 0, 3, 3, 3 },
    { 0, 3, 3, 3 },
    { 0, 0, 0, 0 } };
  inputData.add(data_2);
  inputForm.add(form_2);
  
  // 3: Eldercare
  Integer[][] data_1 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 4, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_1 = {
    { 0, 0, 0, 0 },
    { 0, 3, 3, 0 },
    { 0, 1, 1, 1 },
    { 0, 0, 0, 0 } };
  inputData.add(data_1);
  inputForm.add(form_1);
  
  // 4: Retail
  Integer[][] data_4 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 7, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_4 = {
    { 2, 2, 2, 2 },
    { 2, 2, 2, 2 },
    { 0, 0, 2, 2 },
    { 0, 0, 2, 2 } };
  inputData.add(data_4);
  inputForm.add(form_4);  
  
  // 5: Park
  Integer[][] data_5 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 6, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_5 = {
    { 0, 0, 5, 0 },
    { 0, 0, 0, 0 },
    { 0, 5, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_5);
  inputForm.add(form_5);
  
  // 6: Transit Stop
  Integer[][] data_6 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 5, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_6 = {
    { 0, 6, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_6);
  inputForm.add(form_6);  
  
  // 7: Ped - Path
  Integer[][] data_7 = {
    { 0, 0, 0, 0 },
    { 1, 1, 1, 1 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_7 = {
    { 0, 0, 0, 0 },
    { 6, 6, 6, 6 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_7);
  inputForm.add(form_7);

  // 8: No Definition
  Integer[][] data_8 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_8 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_8);
  inputForm.add(form_8);

  // 9: Housing
  Integer[][] data_9 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_9 = {
    { 0, 0, 0, 0 },
    { 0, 1, 1, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_9);
  inputForm.add(form_9);
  
  // 10: POB
  Integer[][] data_10 = {
    { 0, 0, 0, 4 },
    { 4, 4, 4, 4 },
    { 4, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_10 = {
    { 0, 0, 0, 6 },
    { 6, 6, 6, 6 },
    { 6, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_10);
  inputForm.add(form_10);

  // 11: No Definition
  Integer[][] data_11 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_11 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_11);
  inputForm.add(form_11);
  
  // 12: Elevated Path
  Integer[][] data_12 = {
    { 0, 0, 0, 0 },
    { 5, 5, 5, 5 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_12 = {
    { 2, 0, 0, 2 },
    { 6, 6, 6, 6 },
    { 2, 0, 0, 2 },
    { 2, 0, 0, 2 } };
  inputData.add(data_12);
  inputForm.add(form_12);
  
  // 13: Crossing
  Integer[][] data_13 = {
    { 0, 2, 0, 0 },
    { 2, 2, 2, 2 },
    { 0, 2, 0, 0 },
    { 0, 2, 0, 0 } };
  Integer[][] form_13 = {
    { 0, 6, 0, 0 },
    { 6, 6, 6, 6 },
    { 0, 6, 0, 0 },
    { 0, 6, 0, 0 } };
  inputData.add(data_13);
  inputForm.add(form_13);
  
  // 14: Delete
  Integer[][] data_14 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_14 = {
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 },
    { 4, 4, 4, 4 } };
  inputData.add(data_14);
  inputForm.add(form_14);
  
  // 15: No Definition
  Integer[][] data_15 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  Integer[][] form_15 = {
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 },
    { 0, 0, 0, 0 } };
  inputData.add(data_15);
  inputForm.add(form_15);
}

void changeMode(){ 
  planningMode=toggle(planningMode);
  showForm=toggle(showForm); //default=on in planning mode
  showBuffer=toggle(showBuffer); //default=on in planning mode
  showPaths=toggle(showPaths); //default=off in planning mode
  showSwarm=toggle(showSwarm); //default=off in planning mode
}
