/* TO DO
 *
 * Fix Exclusive Veronoi Zones even when store cannot serve
 * Make Store Order Capacity more "balanced"
 *
 */

import java.util.*;

ArrayList<Facility> facilitiesList = new ArrayList<Facility>();
DeliveryMatrix deliveryMatrix = new DeliveryMatrix();

float demandSupplied;
float sumTotalCost;
int HISTOGRAM_DIVISIONS = 30;
float[] histogram = new float[HISTOGRAM_DIVISIONS];
float histogramMax;

void updateOutput() { 
  initHistogram();
  clearOutputData();
  
  // 1. Calucate All Delivery Costs
  // 2. Sort All Delivery Costs
  // 3. Allocate Deliveries until each facility (a) runs out of supply or (b) runs out of demand
  calcDeliveryCost();
  assignDeliveries();
  
  aggregate();
  histogramMax = histogramMax();
}

void initHistogram() {
  for (int i=0; i<histogram.length; i++) {
    histogram[i] = 0;
  }
}

void addToHistogram(float cost, float demand) {
  float interval = MAX_DELIVERY_COST_RENDER/histogram.length;
  for (int i=0; i<histogram.length; i++) {
    if (cost > i*interval && cost < (i+1)*interval) {
      histogram[i] += demand;
      break;
    }
  }
}

float histogramMax() {
  float max = Float.NEGATIVE_INFINITY;
  for (int i=0; i<histogram.length; i++) {
    max = max(max, histogram[i]);
  }
  return max;
}

void updateFacilitiesList() {
  facilitiesList.clear();
  for (int u=0; u<gridU; u++) {
    for (int v=0; v<gridV; v++) {
      switch (facilities[u][v] ){
        // Facility(int ID, int u, int v, int maxOrderSize, int maxFleetSize, int maxShifts, boolean delivers, boolean pickup)
        case 1: // IMN
          facilitiesList.add(new Facility(1, u, v, 2000, 10, 2, true,  false));
          break;
        case 2: // LARGE STORE
          //facilitiesList.add(new Facility(2, u, v,   200, 10, 2, true,  true));
          facilitiesList.add(new Facility(2, u, v,   800, 10, 2, true,  true));
          break;
        case 3: // SMALL STORE
          //facilitiesList.add(new Facility(3, u, v,   200, 10, 2, true,  true));
          facilitiesList.add(new Facility(3, u, v,   40, 10, 2, true,  true));
          break;
        case 4: // SPOKE
          facilitiesList.add(new Facility(4, u, v,   40,  0, 2, false, true));
          break;
        case 5: // SMALL LOCKER
          facilitiesList.add(new Facility(5, u, v,   10,  0, 3, false, true));
          break;
        case 6: // LARGE LOCKER
          facilitiesList.add(new Facility(6, u, v,   20,  0, 3, false, true));
          break;
        case 7: // REMOTE
          facilitiesList.add(new Facility(7, u, v,  120,  0, 3, false, true));
          break;
      }
    }
  }
}

// Populate a list of all possible deliveries
void calcDeliveryCost() {
  
  // clear list of potential Deliveries
  deliveryMatrix.clearDeliveries();
  
  // Cycle through each Facility
  for (int i=0; i<facilitiesList.size(); i++) {
    Facility current = facilitiesList.get(i);
    current.clearOrders();
    
    // Cycle through each pixel
    for (int u=0; u<gridU; u++) {
      for (int v=0; v<gridV; v++) {
        
        // Cost = A*distance/sqrt(density) + B
        float distance = gridSize*sqrt(sq(u - current.u) + sq(v - current.v)); // KM
        float density = dailyDemand(pop[u][v]);
        float currentCost = distance / sqrt(density);
        
        deliveryMatrix.addDelivery(u, v, currentCost, i);
        
      }
    }
  }
  
  // Sorts the cells to which one might deliver by cost, lowest to highest
  deliveryMatrix.greedySort();
}

void assignDeliveries() {
  int u, v, facilityIndex;
  float cost, demand;
  String[] split;
  
  demandSupplied = 0;
  
  // Cycle through every possible delivery in the list
  for (int i=0; i<deliveryMatrix.size(); i++) {
    
    // Assign current values from Info String
    split = split(deliveryMatrix.get(i), ",");
    cost = float(split[0]);
    u = int(split[1]);
    v = int(split[2]);
    demand = dailyDemand(pop[u][v]);
    facilityIndex = int(split[3]);
    
    // Checks if cell is already Allocated AND if Facility has Capacity
    if (!cellAllocated[u][v] && !facilitiesList.get(facilityIndex).atCapacity) {
      deliveryCost[u][v] = cost;
      totalCost[u][v] = cost*demand;
      allocation[u][v] = facilityIndex+1;
      
      demandSupplied += demand;
      addToHistogram(cost, demand);
      
      facilitiesList.get(facilityIndex).addOrders(demand);
      cellAllocated[u][v] = true;
    }
  }
}

//void checkCapacity() {
//  for (int i=0; i<facilitiesList.size(); i++) {
//    println("#" + i + ", ID = " + facilitiesList.get(i).ID + ", orders = " + facilitiesList.get(i).orders + "/" + facilitiesList.get(i).maxOrderSize + ": " + facilitiesList.get(i).atCapacity);
//  }
//}

void aggregate() {
  sumTotalCost = 0;
  for (int u=0; u<gridU; u++) {
    for (int v=0; v<gridV; v++) {
      if (totalCost[u][v] >= 0) {
        sumTotalCost += totalCost[u][v];
      }
    }
  }
}

int[][] allocationVehicles() {
  int[][] allocation = new int[gridU][gridV];
  return allocation;
}

class Facility {
  
  int ID;
  int maxOrderSize; // Daily
  int maxFleetSize; // Daily
  int maxShifts;    // Daily
  boolean delivers;
  boolean pickup;
  boolean atCapacity;
  int u, v;
  float orders;
  
  
  Facility(int ID, int u, int v, int maxOrderSize, int maxFleetSize, int maxShifts, boolean delivers, boolean pickup) {
    this.ID = ID;
    this.u = u;
    this.v = v;
    this.maxOrderSize = maxOrderSize;
    this.maxFleetSize = maxFleetSize;
    this.maxShifts = maxShifts;
    this.delivers = delivers;
    this.pickup = pickup;
    this.atCapacity = false;
    this.orders = 0;
  }
  
  void addOrders(float orders) {
    this.orders += orders;
    if (this.orders >= maxOrderSize) atCapacity = true;
  }
  
  void clearOrders() {
    this.orders = 0;
    atCapacity = false;
  }
}

class DeliveryMatrix {
  
  ArrayList<String> deliveryInfo;
  
  DeliveryMatrix() {
    deliveryInfo = new ArrayList<String>();
  }
  
  void addDelivery(int u, int v, float cost, int facilityIndex) {
    
    String info = "";
    
    if (cost >= 0 && cost < 10) {
      info += "00000";
    } else if (cost >= 10 && cost < 100) {
      info += "0000";
    } else if (cost >= 100 && cost < 1000) {
      info += "000";
    } else if (cost >= 1000 && cost < 10000) {
      info += "00";
    } else if (cost >= 10000 && cost < 100000) {
      info += "0";
    } else {
      // Do nothing
    }
    
    info += cost + "," + u + "," + v + "," + facilityIndex;
    deliveryInfo.add(info);
  }
  
  void clearDeliveries() {
    deliveryInfo.clear();
  }
  
  void greedySort() {
    Collections.sort(deliveryInfo);
  }
  
  int size() {
    return deliveryInfo.size();
  }
  
  String get(int i) {
    return deliveryInfo.get(i);
  }
}
  
  
