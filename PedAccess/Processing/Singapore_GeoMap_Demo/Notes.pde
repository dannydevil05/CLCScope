/*******
Reading Files
********/
/*
.shp and .dbf have to be in data folder of the sketch
When you do the readFile you don't need the extension because it's agregated from .shp and .dbf 

   //how to print attributes to console
        //geoMap.getAttributes().writeAsTable(25);

//built in contains class to see if point inside 

*/

/*******
Drawing Maps
******/

/*
After you declare the geoMap object you can draw it simply with geoMap.draw() 
    This automatically makes it scale to the canvas
    
You can also draw at a certain coordinate and certain size, but this also scales to given proportions
  geoMap = new GeoMap(10,10,250,250,this); 
*/

/*****
Lots of other things
*****/
/*
You can also pull a lot of things from the visual map itself and the Attribute table

Simple Instructions and Exampls: http://www.gicentre.net/geomap/using
Full API: http://www.staff.city.ac.uk/~jwo/giCentre/geomap/reference/

*/
