int planningInput[][][] = new int[displayU/4][displayV/4][2];

int planningForm[][];

void copyPlanningForm(){
  for (int i=0;i<form.length;i++){
    for (int j=0;j<form[0].length;j++){
      print(form[i][j]);
    }
  }
}
