import processing.video.*;
 
Movie omegaClip;
int tweakLevel = 20;

void setup() {
 
  size(1280, 720);
  omegaClip = new Movie(this, "/Users/patricktaylor/Movies/archiveomega.mp4");
}
 
 
void draw() {
  background(150);
  image(omegaClip, 0, 0, width, height);
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

println(tweakLevel);
                     
  updatePixels();
  omegaClip.loop();
}
 
void movieEvent(Movie m) {
  m.read();
}

void keyPressed()
{
   if  (key == ' ')
   {
     if (tweakLevel < 100)
     {
       tweakLevel += 2;
     }
   }
   else
   {
     if (tweakLevel > 0)
     {
       tweakLevel -= 2;
     }
   }
}