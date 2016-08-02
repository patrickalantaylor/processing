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

 
void setup()
{
  size(800, 600, P3D);
 
  minim = new Minim(this);
 
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  movie = new Movie(this, "/Users/patricktaylor/Movies/antennafundamentalspropagation.mp4");
  movie.loop();

}
 
void movieEvent(Movie m)
{
  m.read();
}
void draw()
{
background(0);
  // first perform a forward fft on one of song's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(in.mix);
 
  stroke(128, 200, 0);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  for(int i = 0; i < fft.specSize(); i=i+1)
  {
    if (i % 2 == 0)
    {
      if (fft.getBand(i)<10)
      {
      stroke(fft.getBand(i)*10, 0, 0);
      }
      else if (fft.getBand(i)>20)
      {
      stroke(0,fft.getBand(i)*10, 0);
      }
      else
      {
      stroke(0, 0,fft.getBand(i)*10);
      }
      line((i+400), height, (i+400), height - fft.getBand(i)*20);
      

    }
    else
    {
      if (fft.getBand(i)<15)
      {
      stroke(fft.getBand(i), 0, 0);
      }
      else if (fft.getBand(i)>400)
      {
      stroke(0,fft.getBand(i), 0);
      }
      else
      {
      stroke(0, 0,fft.getBand(i));
      }
      line((400-i), height, (400-i), height - fft.getBand(i)*20);
    }
  }
 
  stroke(255);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  for(int i = 0; i < in.left.size() - 1; i++)
  {
    line(i, 200 + in.left.get(i)*200, i+1, 200 + in.left.get(i+1)*50);
    line(i, 350 + in.right.get(i)*200, i+1, 350 + in.right.get(i+1)*50);
  }
    image(movie, 0, 0, width, height);

}
 
void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    }
    else
    {
      in.enableMonitoring();
    }
  }
}