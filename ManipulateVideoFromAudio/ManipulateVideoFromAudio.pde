import processing.video.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.video.*;

import ddf.minim.*;
 
Minim minim;
AudioInput in;
FFT fft;
Movie movie;

int tweakLevel = 20;


 
void setup()
{
  size(800, 600, P3D);
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());  
  movie = new Movie(this, "/Users/patricktaylor/Movies/omegaStars.mp4");
}
 
void movieEvent(Movie m)
{
  m.read();
}

void draw()
{
  background(0);
  fft.forward(in.mix);
  // graphic EQ looking display
  stroke(128, 200, 0);
  for(int i = 0; i < fft.specSize(); i=i+1)
  {
    //if (fft.getBand(i)<10)
    //{
    //tweakLevel = 20;
    //}
    //else if (fft.getBand(i)>20)
    //{
    //tweakLevel = 100;
    //}
    //else
    //{
    //tweakLevel = 60;
    //}
      
    if (i % 2 == 0)
    {
      line((i+400), height, (i+400), height - fft.getBand(i)*20);
    }
    else
    {
      line((400-i), height, (400-i), height - fft.getBand(i)*20);
    }
  }
  //waveform display
  stroke(255);
  for(int i = 0; i < in.left.size() - 1; i++)
  {
    line(i, 200 + in.left.get(i)*200, i+1, 200 + in.left.get(i+1)*50);
    line(i, 350 + in.right.get(i)*200, i+1, 350 + in.right.get(i+1)*50);
  }
  
  //the movie
  image(movie, 0, 0, width, height);
  loadPixels();
  int[] oldPixels = pixels.clone();
  for (int i = tweakLevel; i < pixels.length-tweakLevel; i += 1) 
  {
    if ((brightness(oldPixels[i]) > 150) &&(i>1))
    {
      for (int j = -tweakLevel/2; j < tweakLevel/2 ; j += 1)
      {
        pixels[i + j] = oldPixels[i];
        float bright;
        color myColor;
        bright = brightness(oldPixels[i]);
        bright += tweakLevel;
        myColor = color(bright);
        pixels[i + j] = myColor;
      }
    }
  }                     
  updatePixels();
  movie.loop();
}
 
void keyPressed()
{
   if  (key == ' ')
   {
     if (tweakLevel < 100)
     {
       tweakLevel += 2;
       println(tweakLevel);
     }
   }
   else
   {
     if (tweakLevel > 0)
     {
       tweakLevel -= 2;
       println(tweakLevel);
     }
   }
}