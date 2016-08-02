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
float timeSize;
float sampleRate;

int tweakLevel = 20;
int incrementor;
int iteration;

public float getBandWidth()
{
  return (2f/(float)timeSize) * (sampleRate / 2f);
}
 
public int freqToIndex(int freq)
{
  // special case: freq is lower than the bandwidth of spectrum[0]
  if ( freq < getBandWidth()/2 ) return 0;
  // special case: freq is within the bandwidth of spectrum[512]
  if ( freq > sampleRate/2 - getBandWidth()/2 ) return 512;
  // all other cases
  float fraction = (float)freq/(float) sampleRate;
  int i = Math.round(timeSize * fraction);
  return i;
}
 
void setup()
{
  size(800, 600, P3D);
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  timeSize = in.bufferSize();
  sampleRate = in.sampleRate();
  movie = new Movie(this, "/Users/patricktaylor/Movies/antennafundamentalspropagation.mp4");
}
 
void movieEvent(Movie m)
{
  m.read();
}

int shown = 0;
void draw()
{
  float[] frequencyBands = new float[7];
  background(0);
  fft.forward(in.mix);
  // graphic EQ looking display
  stroke(128, 200, 0);
  incrementor = 5;
  iteration = 0;
  for(int i = 0; i < fft.specSize(); i += incrementor)
  {
    iteration += 1;
    incrementor += (5 + iteration * 9);
    float totalForAverage = 0;
    for (int k =0; k < incrementor ; k += 1)
    {
      totalForAverage += fft.getBand(i+k);
    }
    frequencyBands[iteration] = totalForAverage/incrementor;
    //System.out.format("avg=%f\n", totalForAverage/incrementor);

 // DEBUG
if (shown == 50)
{
  System.out.format("iteration: %d average amplitude %f \n", iteration, frequencyBands[iteration]);
}
// END DEBUG

    tweakLevel = int(frequencyBands[1]*3);
      
    //if// (i % 2 == 0)
    //{
//    //  line((i+400), height, (i+400), height - fft.getBand(i)*20);
    }
//    //else
    {
//    //  line((400-i), height, (400-i), height - fft.getBand(i)*20);
    }
//  }
  //waveform display
  //stroke(255);
  //for(int i = 0; i < in.left.size() - 1; i++)
  //{
  //  line(i, 200 + in.left.get(i)*200, i+1, 200 + in.left.get(i+1)*50);
  //  line(i, 350 + in.right.get(i)*200, i+1, 350 + in.right.get(i+1)*50);
  //}
  
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
  shown += 1;
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