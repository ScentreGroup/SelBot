import java.util.Collections;

File dir; 
File [] files;
PImage fgImg; 
PGraphics pg;
PFont f;
String[] titles;
PImage bgImg;
File devicesDir;
File [] devices;
File deviceScreenshotsDir;
File [] deviceScreenshots;
JSONObject deviceConfig;
String deviceName;
Integer deviceScreenWidth;
Integer deviceScreenX;
Integer deviceScreenY;
Integer deviceFrameWidth;
Integer deviceFrameX;
Integer deviceFrameY;
String folderPath;

void folderSelected(File inputFolder) {
  if (inputFolder == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    folderPath = inputFolder.getAbsolutePath();
    println("User selected " + inputFolder.getAbsolutePath());
  
    titles = loadStrings(folderPath + "/titles.txt");
    bgImg = loadImage(folderPath + "/design/background.png");
    devicesDir= new File(folderPath + "/devices");
    devices = devicesDir.listFiles();
    
    for (int i = 0; i <= devices.length - 1; i++)  {
      if (devices[i].isDirectory()){
        deviceName = devices[i].getName();
        deviceConfig = loadJSONObject(devices[i] +"/config.json");
        deviceScreenWidth = deviceConfig.getInt("screenWidth");
        deviceScreenshotsDir = new File(devices[i] + "/screenshots");
        deviceScreenshots = deviceScreenshotsDir.listFiles();
  
        // Create an arrayList of path strings to alpha sort
        ArrayList<String> imagePaths;
        imagePaths = new ArrayList<String>();
        for (int dsi = 0; dsi <= deviceScreenshots.length - 1; dsi++)  {
            String path = deviceScreenshots[dsi].getAbsolutePath();
           if (path.toLowerCase().endsWith(".jpeg") || path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png")) {
             imagePaths.add(path);
           } 
        }
        Collections.sort(imagePaths, String.CASE_INSENSITIVE_ORDER);
        
        // Loop through imagePaths and create image objects
        ArrayList<PImage> images;
        images = new ArrayList<PImage>();
        PImage image;
        println("\n\n" + deviceName + " screenshots\n");
        for (int si = 0; si <= imagePaths.size() - 1; si++)  {
          String imagePath = imagePaths.get(si);
          println("load " + si + " " + deviceName + " image: " + imagePath);
          image = loadImage(imagePath);
          image.resize(deviceScreenWidth,0);
          images.add(image);
        }
        fgImg = loadImage(devices[i] +"/frame.png");
        fgImg.resize(deviceConfig.getInt("frameWidth"), 0);
        
        // loop through loaded image objects, print final images to png
        println("\nDraw " + images.size() + " images for " + deviceName);
        for (int ti = 0; ti <= images.size() - 1; ti++) {
          println("...");
          // Composite preview image off canvas
          pg = createGraphics(deviceConfig.getInt("outputWidth"), deviceConfig.getInt("outputHeight"));
          pg.beginDraw();
          pg.imageMode(CENTER);
          // Draw Background
          pg.image(bgImg, pg.width/2, pg.height/2);
          // Draw Screenshot
          pg.image(images.get(ti), pg.width/2 + deviceConfig.getInt("screenX"), pg.height/2 + deviceConfig.getInt("screenY"));
          // Draw Title
          pg.textFont(f,deviceConfig.getInt("textSize"));
          pg.textAlign(CENTER);
          pg.text(titles[ti], pg.width/2 - deviceConfig.getInt("frameWidth")/2, deviceConfig.getInt("textY"), deviceConfig.getInt("textWidth"), 300);
          // Draw device frame
          pg.image(fgImg, pg.width/2 + deviceConfig.getInt("frameX"), pg.height/2 + deviceConfig.getInt("frameY"));
          pg.imageMode(CORNER);
          pg.endDraw();
          pg.save(folderPath + "/output/" + deviceName + "/" + "(" + ti + ") " + titles[ti] + ".png");
        }
        println("Done");
      }
    }
    exit();
  }
}

void setup() {
  selectFolder("Select a folder to process:", "folderSelected");
  f = loadFont("fonts/CeraPRO-Bold-60.vlw");
}
 
void draw() {}