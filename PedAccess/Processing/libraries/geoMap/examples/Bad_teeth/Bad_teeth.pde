import org.gicentre.geomap.*;

//  Draws a choropleth map of dental health data from gapminder.org.

GeoMap geoMap;
Table tabBadTeeth;
color minColour, maxColour;
float dataMax;

void setup()
{
  size(820, 440);
  noLoop();

  // Read map data.
  geoMap = new GeoMap(10, 10, width-20, height-40, this);
  geoMap.readFile("world");

  // Read dental health data.
  tabBadTeeth = loadTable("badTeeth.csv");

  // Find largest data value so we can scale colours.
  dataMax = 0;
  for (TableRow row : tabBadTeeth.rows())
  {
    dataMax = max(dataMax, row.getFloat(2));
  }

  minColour = color(222, 235, 247);   // Light blue
  maxColour = color(49, 130, 189);    // Dark blue.
}

void draw()
{
  background(255);
  stroke(190);
  strokeWeight(0.5);

  // Draw countries
  for (int id : geoMap.getFeatures().keySet())
  {
    String countryCode = geoMap.getAttributes().getString(id, 2);
    TableRow row = tabBadTeeth.findRow(countryCode, 1);

    if (row != null)       // Table row matches country code
    {
      float normBadTeeth = row.getFloat(2)/dataMax;
      fill(lerpColor(minColour, maxColour, normBadTeeth));
    }
    else                   // No data found in table.
    {
      fill(250);
    }

    geoMap.draw(id); // Draw country
  }

  // Draw title text
  fill(100);
  String title = "Number of bad teeth per 12 year-old child";
  textAlign(LEFT, TOP);
  text(title, 10, height-20);

  // Draw the frame line
  strokeWeight(1);
  noFill();
  rect(10, 10, width-20, height-40);
}

