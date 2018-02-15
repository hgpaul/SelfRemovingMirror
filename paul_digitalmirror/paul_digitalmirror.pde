/*
Digital Mirror - Self-Removing Mirror
Henry Paul 2018
*/
import processing.video.*;

int spacing = 2; 
int centerpix;
float r;
float g;
float b;
float roffset = 0;
float goffset = 0;
float boffset = 0;

Capture camera;


void setup() {
  //set for my camera resolution, which is a palsy 640x480
  size(640, 480);
  
  //determine the index of the center pixel
  centerpix = ((width/2)-1) + (height/2)*width;

  
  rectMode(CENTER);
  
  

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("Couldn't detect any cameras :(");
    exit();
  } 

  camera = new Capture(this, cameras[0]);
  camera.start();
}


void draw() {

  if (camera.available()) {
    background(255);

    camera.read();
    camera.loadPixels(); 
    
    for (int y=0; y<height; y+=spacing) {
      for (int x=0; x<width; x+=spacing) {

        int index = (width-x-1) + y*width;
        
        
        r = camera.pixels[index] >> 16 & 0xFF;
        g = camera.pixels[index] >> 8 & 0xFF;
        b = camera.pixels[index] & 0xFF;
        
        //update image to offsets determined by white balance test
        camera.pixels[index] = color((r + roffset), (g + goffset), (b + boffset));
        updatePixels();
        
        //get new pixel values
        r = camera.pixels[index] >> 16 & 0xFF;
        g = camera.pixels[index] >> 8 & 0xFF;
        b = camera.pixels[index] & 0xFF;
        


        fill(camera.pixels[index]);
        noStroke();
        
        //if pixels are within a certain color range, don't draw them
        if ( (r < 255) && (r > 175) && (g < 225) && (g > 120) && (b < 220) && (b > 120)) {
          //do nothing!
        } else {
          rect(x+spacing/2,y+spacing/2, spacing,spacing);
        }
      }
    }
  }
}

//adjusts white balance by hitting enter or return
void keyPressed() {
  if ((key == ENTER) || (key== RETURN)) {

    camera.read();
    camera.loadPixels(); 
    

    roffset = 255 - (camera.pixels[centerpix] >> 16 & 0xFF);
    goffset = 255 - (camera.pixels[centerpix] >> 8 & 0xFF);
    boffset = 255 - (camera.pixels[centerpix] & 0xFF);

    println("White balance adjusted.");

  }
}