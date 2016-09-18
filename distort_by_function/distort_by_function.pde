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

public int pixelFrom2d(int xloc, int yloc)
{
  int pixelNum = yloc * width + xloc;
  return pixelNum;
}

public int[] twoDFromPixel(int pixelNum)
{
  float rowLocation = pixelNum / width;
  int rowNum = int(floor(rowLocation));
  int colNum = (pixelNum % width);
  int[] twoDLocation = new int[] {colNum, rowNum};
  return twoDLocation;
}
  
 
void setup()
{
  size(1920, 1080, P3D);
  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  timeSize = in.bufferSize();
  sampleRate = in.sampleRate();
  movie = new Movie(this, "G:\\clips\\leader.mp4");
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
    horizontalTweak = int(frequencyBands[4]*20);
    verticalTweak = int(frequencyBands[2]);
  
  //the movie
  image(movie, 0, 0, width, height);
  loadPixels();
  int[] oldPixels = pixels.clone();
  for (int location = 0; location < pixels.length ; location += 1)
  {
     pixels[location] = translatePixel(location, oldPixels, pixels);
  }                    
  updatePixels();
  movie.loop();
  shown += 1;
}

color translatePixel(int pixelLocation, color[] sourcePixels, color[] destinationPixels)
{
    int newPixelLocation = floor(sin(pixelLocation));
    if (newPixelLocation < 0)
    {
      newPixelLocation = 1;
    }
    else if (newPixelLocation > sourcePixels.length -1)
    {
      newPixelLocation = sourcePixels.length -1 ;
    }
    return sourcePixels[newPixelLocation];
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