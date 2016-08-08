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

int horizontalTweak = 20;
int verticalTweak;
int incrementor;
int iteration;

ArrayList<HashMap<String, String>> data = new ArrayList<HashMap<String, String>>();


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
  movie = new Movie(this, "/Users/patricktaylor/Movies/omegaStars.mp4");
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
  for(int audioSampleId = 0; audioSampleId < fft.specSize(); audioSampleId += incrementor)
  {
    iteration += 1;
    incrementor += (5 + iteration * 9);
    float totalForAverage = 0;
    for (int idInRange =0; idInRange < incrementor ; idInRange += 1)
    {
      totalForAverage += fft.getBand(audioSampleId+idInRange);
    }
    frequencyBands[iteration] = totalForAverage/incrementor;
  }
    horizontalTweak = int(frequencyBands[2]*10);
    verticalTweak = horizontalTweak*5;
  
  //the movie
  image(movie, 0, 0, width, height);
  loadPixels();
  int[] oldPixels = pixels.clone();
  for (int pixelId = horizontalTweak; pixelId < pixels.length-horizontalTweak; pixelId += 1) 
  {
    if ((brightness(oldPixels[pixelId]) > 250) &&(pixelId>1))
    {
      for (int placeInRow = -horizontalTweak/2; placeInRow < horizontalTweak/2 ; placeInRow += 1)
      {
        pixels[pixelId + placeInRow - (placeInRow/2)] = oldPixels[pixelId];
        for (int placeInColumn = verticalTweak/2+width; placeInColumn < horizontalTweak/2-width ; placeInColumn += 1)
        {
          pixels[pixelId + placeInRow - (width/2)] = oldPixels[pixelId];
        }
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
     if (horizontalTweak < 100)
     {
       horizontalTweak += 2;
       println(horizontalTweak);
     }
   }
   else
   {
     if (horizontalTweak > 0)
     {
       horizontalTweak -= 2;
       println(horizontalTweak);
     }
   }
}