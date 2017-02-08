

// Import processing video library (it must be installed first)
import processing.video.*;

// cam is an object of class "Capture", it implements video camera functions.
Capture cam;

// Variables to store capture width and height
int captureWidth, captureHeight;

// Step to generate matrix points and its limits.
float step, stepMax, stepMin;



void setup() {
  
  // We select a window size to fit 2 images
  size(1280, 480);

  // Set capture's width and height
  captureWidth = 640;
  captureHeight = 480;
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, captureWidth, captureHeight, cameras[0]);
    cam.start();     
  } 
  
  // Initialize step value and its limits
  step = 10;
  stepMax = 100;
  stepMin = 2;
  
  rectMode(CENTER);
}

void draw() {

  // We set a white background
  background(255);
  
  // Check if video graphic card has a new frame available for processing
  if (cam.available() == true) {
    cam.read();
  }
  
  // We display sample Image in the left half of the window
  image(cam, 0, 0, captureWidth, captureHeight);
  
  // We set black fill and no stroke for drawing
  fill(0);
  noStroke();
  
  // The image is sampled at step values in a matrix  
  for (int i = 0; i < captureWidth; i += step) {
    for (int j  = 0; j < captureHeight; j+= step) {
      
      // We store actual pixel's color in colorPixel
      color colorPixel = cam.get(i, j);
      // We calculate brightness for actual pixel
      float brightness = brightness(colorPixel);
      // We calculate a radio depending of brightness
      float radio = map(brightness, 255, 0, 0, step);
      
      // We draw a circle on the right half of the window with 'radio' dimensions
      //ellipse(captureWidth + i, j, radio, radio);
      
             
  pushMatrix();
    translate(captureWidth + i, j); 
    rotate(PI/4);
    rect(0, 0, radio, radio);
  popMatrix();
       
    }
  }
  
  // Instructions are displayed in window
  drawInstructions();

}


// Function to draw instructions in window
void drawInstructions() {

  // Set white color
  fill(255);
  // Set text size (check also textFont)
  textSize(14);
  // Draw instructions in screen");
  text("Press <+>/<-> to change step size.", 10, 20);
  text("Press <S> to save image file.", 10, 40);
  text("Step: " + int(step), 10, 60);

  text("Press <Q> to quit.", 10, height - 20);

}



// The keyPressed() function is called once every 
// time a key is pressed. The key that was pressed 
// is stored in the 'key' variable.

void keyPressed() {

  // CHECK KEY PRESSED
  
  // Check if '+' has been pressed. If so, then increment step. 
  if (key == '+') step ++;
  // Check if '-' has been pressed. If so, then decrement step. 
  else if (key == '-') step--;
  // Check if "S" has been pressed. If so, then save actual frame to file.
  else if ((key == 's') || (key == 'S')) saveFrame("data/dot_effect_####.png");
  // Check if "Q" has been pressed. If so, then quit program.
  else if ((key == 'q') || (key == 'Q')) exit();  
  
  // CHECK STEP LIMITS
  
  // Check that step is not higher than maximum level
  if (step > stepMax) step = stepMax;
  // Check that step is not lower than minimum level
  else if (step < stepMin) step = stepMin;
  
}