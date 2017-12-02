
//TODO: use or write a TIMER class!!

PImage img_logo;
PImage img_start;
PImage img_ok;
PImage img_notOk;
PImage img_cube1;
PImage img_cube2;
PImage img_cube3;
PImage img_gameover;
PImage img_startGame;

PImage img_Bravo;
PImage img_Comp_1;
PImage img_Comp_2;
PImage img_Comp_3;
PImage img_Ret_1;
PImage img_Ret_2;
PImage img_Ret_3;

import processing.sound.*;
SoundFile sound_wrong;
SoundFile sound_right;
SoundFile sound_gameOver;
SoundFile sound_cube;
SoundFile sound_start;

int nbCubes = 0;

boolean gameHasStarted = false;
boolean gameIsRunning = false;

int state = 0;
//0: veille
//1: start -> timer 5 to 0 starts
//2: game starts 3 sec.
//3: select new image
//4: OK -> returns to 2
//5: not OK -> returns to 2
//6: game over first image
//7: game over comparison

int cube = 0;
String dir_path = "/Users/cecilebucher/Projects/Museomix/DataCube/";


int width, height;

import ddf.minim.*;

Minim minim;
AudioPlayer sound_loop;

import processing.video.*;
Movie myMovie;

PFont mono;
void setup() {

  
  noCursor();
  //size(1440,900);
  //width = 1368;
  //height = 768;
  //width = 1280;
  //height = 720;
    width = 1920;
  height = 1080;
  fullScreen();
  
  img_start = loadImage("images/press_to_start.png");
  img_startGame = loadImage("images/catch.png");
  img_ok = loadImage("images/VRAI.png");
  img_notOk = loadImage("images/FAUX.png");
  img_gameover = loadImage("images/GAME_OVER.png");
   
  img_cube1 = loadImage("images/motif_1.png");
  img_cube2 = loadImage("images/motif_2.png");
  img_cube3 = loadImage("images/motif_3.png");
  
  
  img_Bravo = loadImage("images/bravo.png");
  img_Comp_1 = loadImage("images/img_comp_1.png");
  img_Comp_2 = loadImage("images/img_comp_2.png");
  img_Comp_3 = loadImage("images/img_comp_3.png");
  img_Ret_1 = loadImage("images/img_ret_1.png");
  img_Ret_2 = loadImage("images/img_ret_2.png");
  img_Ret_3 = loadImage("images/img_ret_3.png");


  sound_wrong = new SoundFile(this, dir_path + "sounds/wrong.wav");
  sound_right = new SoundFile(this, dir_path + "sounds/right.wav");
  sound_gameOver = new SoundFile(this, dir_path + "sounds/game-over.wav");
  sound_cube = new SoundFile(this, dir_path + "sounds/cube-change.wav");
  sound_start = new SoundFile(this, dir_path + "sounds/bounce3.wav");

  minim = new Minim(this);
  sound_loop = minim.loadFile(dir_path + "sounds/loop.wav");
  sound_loop.loop();    

  //myMovie = new Movie(this, dir_path + "Countdown.mp4"); 
  myMovie = new Movie(this, dir_path + "Countdown_5.mov");
  
  mono = createFont("FONTS/MUSEOMIX.TTF", 32);
  
}


int current_time = 0;
int current_time_cube = 0;
int start_time = 0;
int start_time_cube = 0;
boolean start_anim = false;
int state_anim = 0;
int r = 0;
int total_time_anim = 0;
boolean playingMovie = false;

boolean state_veille = false;

int total_time_switch = 0;
int current_time_switch = 0;
int start_time_switch = 0;
int total_time_logo = 0;
int current_time_logo = 0;
int start_time_logo = 0;

int total_time_end = 0;
int current_time_end = 0;
int start_time_end = 0;
int state_end = 0;

int rand_ending=0;

void draw() {  
  
  textFont(mono);
  
  //image(img_logo,0,0);
  color c = color(0, 0, 0);  // Define color 'c'
  fill(c);
  rect(0, 0, width, height);
  int x = int(width/2.0);
  int y = int(height/2.0);

  if(state == -1){
    start_time_switch = millis();
    state = 0;
  }else if (state == 0) {
    
    total_time_switch = 3000;
    current_time_switch = millis();
    
    if((current_time_switch - start_time_switch) > total_time_switch){
      state_veille = !state_veille;
      start_time_switch = millis();
    }
    
    if(state_veille){
      // shows the logo and the anim
      if (state_anim == 0) {
        total_time_anim = int(random(3000)) + 500;
        start_time = millis();
        int old_r = r;
        r = int(random(3)); 
        if (r == old_r) {
          if (old_r == 0) r = 1;
          else if (old_r == 1) r = 2;
          else if (old_r == 2) r = 0;
        }
        state_anim = 1;
      } else if (state_anim == 1) {
        if (r == 0) image(img_cube1, 0, 0, width,height);
        else if (r == 1) image(img_cube2, 0, 0, width,height);
        else image(img_cube3, 0, 0, width,height);
        current_time = millis();
        if ((current_time - start_time) >= total_time_anim) {
          state_anim = 0;
        }
      }
    }else{
      image(img_start,0,0,width,height);
    }

    textSize(40);
    fill(255, 255, 255);
    //text("PRESS THE BUTTON ON THE STICK TO START THE GAME!",100,50);
  } else if (state == 1) {
    
    gameIsRunning = true;
    
    total_time_logo = 5000;
    current_time_logo = millis();
    
    if (current_time_logo - start_time_logo >= total_time_logo) {
      // starts the count down
      if (!playingMovie) {
        playingMovie = true;
        myMovie.jump(0);
        myMovie.play();
      }
  
      image(myMovie, 0, 0, width, height);
      if (playingMovie && myMovie.time() == myMovie.duration()) {
        state = 2;
        playingMovie = false;
        start_time = millis();
        println("START THE GAME");
      }
      
      textSize(37);
      fill(255, 255, 255);
      //text("CATCH AS FAST AS YOU CAN THE CUBES WITH THE SHOWN PATTERNS!",20,50);
    }else{
       image(img_startGame,0,0,width,height); 
    }
    /*
    current_time = millis();
     textSize(200);
     fill(255, 255, 255);
     if(current_time - start_time >= 6000){
     state = 2;
     start_time = millis();
     }else if(current_time - start_time >= 5000){
     text("1",x,y);
     }else if(current_time - start_time >= 4000){
     text("2",x,y);
     }else if(current_time - start_time >= 3000){
     text("3",x,y);
     }else if(current_time - start_time >= 2000){
     text("4",x,y);
     }else{
     text("5",x,y);
     }
     */
  } else if (state >= 2 && state <= 5) {
    // starts the timer!!! And the game!
    //game
    if (state == 2) {
      // SHOWS THE NEW CUBE TO CATCH
      cube = int(random(3));
      sound_cube.play();
      state = 3;
      gameHasStarted = true;
    } else if (state == 3) {
      if (cube == 0) {
        textSize(40);
        fill(255, 255, 255);
        //text("CUBE 1",x,y);
        image(img_cube1, 0, 0, width,height);
      } else if (cube == 1) {
        textSize(40);
        fill(255, 255, 255);
        //text("CUBE 2",x,y);
        image(img_cube2, 0, 0, width,height);
      } else if (cube == 2) {
        textSize(40);
        fill(255, 255, 255);
        //text("CUBE 3",x,y);
        image(img_cube3, 0, 0, width,height);
      }
    } else if (state == 4) {
      // CUBE HAS BEEN SELECTED
      int total_time = 500;
      textSize(40);
      fill(255, 255, 255);
      //text("OK", x, y+200);
      image(img_ok, 0, 0, width,height);
      current_time_cube = millis();
      if ((current_time_cube - start_time_cube) >= total_time) {
        state = 2;
      }
    } else if (state == 5) {
      // WRONG CUBE HAS BEEN SELECTED
      int total_time = 500;
      textSize(40);
      fill(255, 255, 255);
      //text("WRONG", x, y+200);
      image(img_notOk, 0, 0, width,height);
      current_time_cube = millis();
      if ((current_time_cube - start_time_cube) >= total_time) {
        state = 2;
      }
    }


    //timer
    int total_time = 20000;//60000;
    current_time = millis();
    int t = (total_time - (current_time - start_time))/1000;
    textSize(120);
    fill(255, 255, 255);
    text(str(t), width-250, height-50);
    if ((current_time - start_time) >= total_time) {
      state = 6;
      start_time = millis();
    }
  } else if (state == 6) {
    gameHasStarted = false;
    sound_gameOver.play();
    state = 7;
  } else if (state == 7) {
    //game over
    int total_time = 2000;
    textSize(100);
    fill(255, 255, 255);
    //text("GAME OVER", 200, 200);
    image(img_gameover,0,0,width,height);
    current_time = millis();
    if (current_time - start_time >= total_time) {
      state = 8;
      state_end =0;
      start_time_end = millis();
    }
  } else if (state == 8) {
    
    
    current_time_end = millis();
    
    
    
    if(state_end == 0){ // BRAVO
      total_time_end = 8000;
      start_time_end = millis();
      state_end = 1;
      int old_r = rand_ending;
        rand_ending = int(random(3)); 
        if (rand_ending == old_r) {
          if (old_r == 0) rand_ending = 1;
          else if (old_r == 1) rand_ending = 2;
          else if (old_r == 2) rand_ending = 0;
        }
    }else if(state_end == 1){ 

      fill(255, 255, 255);
      textSize(70  );
      //text(str(nbCubes) + " CUBES", width/2.0 - 200, height/2.0 + 80);
      //text(str(nbCubes) + " CUBES", width/2.0 - 100, height/2.0 + 85);
      text(str(nbCubes) + " CUBES", width/2.0 - 140, height/2.0 + 125);
      image(img_Bravo,0,0,width,height);
      if (current_time_end - start_time_end >= total_time_end){
         state_end = 2; 
      }
    }else if(state_end == 2){ // COMPARAISON
      total_time_end = 11000;
      start_time_end = millis();
      state_end = 3;
    }else if(state_end == 3){ 
      textSize(48);
      fill(255, 255, 255);
      //text("COMPARAISON", 200, 200);
      if (current_time_end - start_time_end >= total_time_end){
         state_end = 4; 
      }
      image(img_Comp_1,0,0,width,height);
      /*
      if(rand_ending == 0){image(img_Comp_1,0,0,width,height);}
      else if(rand_ending == 1){image(img_Comp_2,0,0,width,height);}
      else if(rand_ending == 2){image(img_Comp_3,0,0,width,height);}
      */
    }else if(state_end == 4){ // RETOURNEMENT
      start_time_end = millis();
      state_end = 5;
    }else if(state_end == 5){ 
      textSize(100);
      fill(255, 255, 255);
      //text("RETOURNEMENT", 200, 200);
      image(img_Ret_1,0,0,width,height);
      if (current_time_end - start_time_end >= total_time_end){
        state = -1;
        gameIsRunning = false;
      }
      /*
      if(rand_ending == 0){image(img_Ret_1,0,0,width,height);}
      else if(rand_ending == 1){image(img_Ret_2,0,0,width,height);}
      else if(rand_ending == 2){image(img_Ret_3,0,0,width,height);}
      */
    }
    /*
    int total_time = 5000;
    textSize(40);
    fill(255, 255, 255);
    text("GAME OVER comparison", x, y);
    text("nb cubes " + str(nbCubes), x, y+200);
    current_time = millis();
    if (current_time - start_time >= total_time) {
      state = -1;
      gameIsRunning = false;
    }*/
  }
  
  /*
        textSize(70);
      fill(255, 255, 255);
      text(str(nbCubes) + " CUBES", width/2.0 - 140, height/2.0 + 125);
      image(img_Bravo,0,0,width,height);
      */
}

void checkCube(int c) {
  if (c == cube) {
    state = 4;
    start_time_cube = millis();
    nbCubes++;
    sound_right.play();
  } else {
    state = 5;
    start_time_cube = millis();
    sound_wrong.play();
  }
}

void keyPressed() {
  if (key == 's' || key == 'f') { // button start
    println("simulate button start");
    if(!gameIsRunning){
      state = 1;
      start_time_logo = millis();
      sound_start.play();
      nbCubes = 0;
    }
  } else if (key == 'w'){
    println("simulate pattern A");
    if (gameHasStarted) {
      checkCube(0);
    } else {
      sound_right.play();
    }
  } else if (key == 'g'){
    println("simulate pattern B");
    if (gameHasStarted) {
      checkCube(1);
    } else {
      sound_right.play();
     }
  } else if (key == 'd') {
    println("simulate pattern C");
    if (gameHasStarted) {
      checkCube(2);
    } else {
      sound_right.play();
    }
  }
} 

void movieEvent(Movie m) {
  m.read();
}