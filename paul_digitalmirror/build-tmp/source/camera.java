import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class camera extends PApplet {



int spacing = 2; 
float r;
float g;
float b;

Capture camera;


public void setup() {
  
  
  rectMode(CENTER);
  
  

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("Couldn't detect any cameras!");
    exit();
  } 

  camera = new Capture(this, cameras[0]);
  camera.start();
}


public void draw() {

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
        


        fill(camera.pixels[index]);

        noStroke();
        if ( (r < 184) && (r > 130) && (g < 130) && (g > 69) && (b < 172) && (b > 72)) {
          rect(x+spacing/2,y+spacing/2, spacing,spacing);
        } else {
          rect(x+spacing/2,y+spacing/2, spacing,spacing);
        }
      }
    }
  }
}


public void keyPressed() {
  if ((key == ENTER) || (key== RETURN)) {
    if (camera.available()) {

      camera.read();
      camera.loadPixels(); 



      r = camera.pixels[1000] >> 16 & 0xFF;
      g = camera.pixels[1000] >> 8 & 0xFF;
      b = camera.pixels[1000] & 0xFF;

      println("Skrrt");

    }
  }
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "camera" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
