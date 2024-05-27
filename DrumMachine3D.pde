import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioSample kick;
AudioSample snare;
AudioSample HiClosed;
AudioSample HiOpen;
AudioSample S1, S2, S3, S4, S5, S6, S7, S8;

float[][] vert = {
  {0.0598, 6.7651, 0.0339, 200, 0}, 
  {14.6811, 0.0419, 0.0339, 400, 300}, 
  {-11.2525, 0.0419, 0.0339, 0, 300}, 
  {0.0598, -4.6959, 0.0339, 200, 600}, 
  {22.6590, 3.6296, 0.0075, 600, 0}, 
  {21.9463, 0.0588, -2.1003, 600, 300}, 
  {22.6590, -3.5355, 0.0075, 600, 0}, 
  {0.0866, 0.0198, -3.8651, 200, 300}, 
  {0.0598, 0.0198, 3.8199, 200, 300}, 
  {21.9463, 0.0588, 1.9949, 600, 300}
};

int[][] tri = {
  {3, 1, 9}, 
  {10, 6, 5}, 
  {3, 4, 8}, 
  {1, 3, 8}, 
  {4, 2, 8}, 
  {2, 1, 8}, 
  {1, 2, 9}, 
  {3, 9, 4}, 
  {4, 9, 2}, 
  {7, 6, 10}, 
  {7, 2, 6}, 
  {2, 5, 6}, 
  {2, 10, 5}, 
  {7, 10, 2}
};

float bs = 100;
float bound = 50;
float bound2 = 300;
float rx[] = new float[9];
float ry[] = new float[9];
float rv[] = new float[9];
float speed = 0.2;
//float ry2 = 0;

PImage img;

float[][] h = new float[20][20];

float BGMLevel;

//建物
int a = 1;
int b = 0;
int c = 0;
int d = 1;
float e = 0.8;
float f = 45;
float g = 45;
int state = 0;

void setup()
{
  size(1300, 1300, P3D);
  minim=new Minim(this);
  player=minim.loadFile("p16.wav");
  player.loop();
  kick=minim.loadSample("Kick02_C0.wav");
  //snare=minim.loadSample("Cymatics - Dubstep Snare 6 - G.wav");
  snare=minim.loadSample("snare.mp3");
  HiClosed=minim.loadSample("Cymatics - Master Collection Vol 2 Closed Hihat 1.wav");
  HiOpen=minim.loadSample("Cymatics - G House Open Hi-Hat 1.wav");
  S1=minim.loadSample("1.mp3");
  S2=minim.loadSample("2.mp3");
  S3=minim.loadSample("3.mp3");
  S4=minim.loadSample("4.mp3");
  S5=minim.loadSample("5.mp3");
  S6=minim.loadSample("6.mp3");
  S7=minim.loadSample("7.mp3");
  S8=minim.loadSample("8.mp3");

  for (int i=0; i<rx.length; i++)
  {
    rx[i] = 0;
    ry[i] = 0;
    rv[i] = 0;
  }


  //テクスチャ
  img = loadImage("fish_texture.png");

  for (int i=0; i<20; i++) {
    for (int j=0; j<20; j++) {
      h[i][j] = random(1.0, 12.0);
    }
  }
}

void draw()
{
  background(255);

  float cx = sin(radians(rx[1]*2));

  perspective(
    radians(45), 
    float(width)/float(height), 
    0.1, 2000.0                  
    );
  camera(
    0, cx, 10, 
    0, 0, 0, 
    0, 1, 0   
    );

  // ----- ----- ----- ----- -----
  // 光源の設定

  directionalLight(
    255, 255, 255, 
    -1, -1, -1        
    );

  //ビジュアル
  {
    pushMatrix();
    BGMLevel = (player.left.level()+player.right.level())/2 * bound/2;//拡大

    scale(0.01);
    translate(-300, -300);
    //色
    fill(100-BGMLevel*5, 200+BGMLevel*5, 200+BGMLevel*5);

    //kick
    {
      pushMatrix();
      translate(100, 500);
      rotateX(rx[0]);
      rotateY(ry[0]);
      float radiusL=kick.left.level() * bound;
      float radiusR=kick.right.level() * bound;
      float stereoLevel = (radiusL+radiusR)/2 + bs + BGMLevel;
      box(stereoLevel, stereoLevel, stereoLevel);

      popMatrix();
    }

    //snare
    {
      pushMatrix();
      translate(300, 500);
      rotateX(rx[1]);
      rotateY(ry[1]);
      float radiusL2=snare.left.level() * bound;
      float radiusR2=snare.right.level() * bound;
      float stereoLevel2 = (radiusL2+radiusR2)/2 + bs + BGMLevel;
      box(stereoLevel2, stereoLevel2, stereoLevel2);
      popMatrix();
    }


    //HiClosed
    {
      pushMatrix();
      translate(500, 500);
      rotateX(rx[2]);
      rotateY(ry[2]);
      float stereoLevel3 = (S8.left.level()+S8.right.level())*bound2/2 + bs + BGMLevel;
      box(stereoLevel3, stereoLevel3, stereoLevel3);
      popMatrix();
    }

    //HiOpen
    {
      pushMatrix();
      translate(100, 300);
      rotateX(rx[3]);
      rotateY(ry[3]);
      float stereoLevel4 = (S7.left.level()+S7.right.level())*bound2/2 + bs + BGMLevel;
      box(stereoLevel4, stereoLevel4, stereoLevel4);
      popMatrix();
    }

    {
      pushMatrix();
      translate(300, 300);
      rotateX(rx[4]);
      rotateY(ry[4]);
      float stereoLevel5 = (S1.left.level()+S1.right.level())*bound2/2 + bs + BGMLevel;
      //box(stereoLevel5, stereoLevel5, stereoLevel5);
      scale(stereoLevel5/20);
      int count = (frameCount / 30) % 14;
      count = 14;
      for (int i=0; i<count; i++) {
        beginShape();
        texture(img);

        for (int j=0; j<3; j++) {
          float[] v = vert[tri[i][j] - 1];
          float x = v[0];
          float y = v[1];
          float z = v[2];
          float U = v[3];
          float V = v[4];

          vertex(x, y, z, U, V);
        }
        endShape(CLOSE);
      }
      popMatrix();
    }

    {
      pushMatrix();
      translate(500, 300);
      rotateX(rx[5]);
      rotateY(ry[5]);
      float stereoLevel6 = (S2.left.level()+S2.right.level())*bound2/2 + bs + BGMLevel;
      box(stereoLevel6, stereoLevel6, stereoLevel6);
      popMatrix();
    }

    {
      pushMatrix();
      translate(100, 100);
      rotateX(rx[6]);
      rotateY(ry[6]);
      float stereoLevel7 = (S3.left.level()+S3.right.level())*bound2/2 + bs + BGMLevel;
      box(stereoLevel7, stereoLevel7, stereoLevel7);
      popMatrix();
    }

    {
      pushMatrix();
      translate(300, 100);
      rotateX(rx[7]);
      rotateY(ry[7]);
      float stereoLevel8 = (S4.left.level()+S4.right.level())*bound2/2 + bs + BGMLevel;
      box(stereoLevel8, stereoLevel8, stereoLevel8);
      popMatrix();
    }

    {
      pushMatrix();
      translate(500, 100);
      rotateX(rx[8]);
      rotateY(ry[8]);
      float stereoLevel9 = (S5.left.level()+S5.right.level())*bound2/2 + bs + BGMLevel/2;
      box(stereoLevel9, stereoLevel9, stereoLevel9);
      popMatrix();
    }

    for (int i=0; i<rx.length; i++)
    {
      rx[i] += 0.01;
      ry[i] += 0.01 + rv[i];
      if (rv[i] > 0)
      {
        rv[i] -= 0.002;
      }
    }




    popMatrix();
  }


  //建物
  {
    //noStroke();
    pushMatrix();
    translate(0, 6, -10);
    //rotateY(rx[1]);
    translate(0, 0, 0);
    for (int i=0; i<20; i++) {
      for (int j=0; j<20; j++) {
        pushMatrix();
        a = 1;
        b = 0;
        c = 0;
        d = 1;
        e = 0.8;
        f = 45;
        g = 45;
        if (i % 2 == 0)
        {
          a = -1;
          d = 2;
        }
        if (j % 3 == 0)
        {
          b = 1;
          //g = -45;
          f = 135;
        }
        if (i % 5 == 0)
        {
          c = 1;
        }

        translate(i-10+(cx+e)*10*a*b, -h[i][j]*2-4+a*(cx+e)*10, j-5-20+(cx+e)*c*d*20);
        rotateX(45);
        rotateY(45*state);
        rotateZ(f*state);
        fill(255, 100, 100);
        box(0.5, h[i][j], 0.5);
        popMatrix();
      }
    }
    popMatrix();
  }
}

void keyPressed()
{
  if (key == 'z')
  {
    kick.trigger();
    rv[0] = speed;
  }
  if (key == 'x')
  {
    snare.trigger();
    rv[1] = speed;
  }
  if (key == 'c')
  {
    S8.trigger();
    rv[2] = speed;
  }
  if (key == 'a')
  {
    S7.trigger();
    rv[3] = speed;
  }
  if (key == 's')
  {
    S1.trigger();
    rv[4] = speed;
  }
  if (key == 'd')
  {
    S2.trigger();
    rv[5] = speed;
  }
  if (key == 'q')
  {
    S3.trigger();
    rv[6] = speed;
  }
  if (key == 'w')
  {
    S4.trigger();
    rv[7] = speed;
  }
  if (key == 'e')
  {
    S5.trigger();
    rv[8] = speed;
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}

void mousePressed()
{
  state = (state + 1);
}
