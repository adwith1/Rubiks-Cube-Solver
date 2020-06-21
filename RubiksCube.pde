//install PeasyCam library and import it to project to center the cube
//this library supports a fluent mouse-camera interaction

import peasy.*;

PeasyCam cam;

int dimensions = 3; 
float speed = 0.2;
Cubie[] cube = new Cubie[dimensions*dimensions*dimensions];

//represents all possible moves that can be made
//all 12 moves are assigned in an array and can be accessed by an index
Move[] allMoves = new Move[]{
  new Move(0,1,0,1),
  new Move(0,1,0,-1),
  new Move(0,-1,0,1),
  new Move(0,-1,0,-1),
  new Move(1,0,0,1),
  new Move(1,0,0,-1),
  new Move(-1,0,0,1),
  new Move(-1,0,0,-1),
  new Move(0,0,0,1),
  new Move(0,0,0,-1),
  new Move(0,0,-1,1),
  new Move(0,0,-1,-1),
};

//arraylist used to store the sequence of moves
ArrayList<Move> sequence = new ArrayList<Move>();

//counts the total number of steps taken
int counter = 0;

//represents the current state of the animation
//set to true after spacevar click
boolean started = false;
Move currentMove;

void setup() {
  //size(600, 600, P3D); //meant for a small frame, can adjust dimensions
  fullScreen(P3D); 
  
  cam = new PeasyCam(this, 400);
  int index = 0;
  
  //triple nested for loop represents orientation of each cubie
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        PMatrix3D matrix = new PMatrix3D(); //PMatrix3D is a class used to describe a 3D object in java
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);
        index++;
      }
    }
  }

  //set to complete 120 moves
  for(int i = 0; i < 60; i++) {
    int r = int(random(allMoves.length));
    Move mo = allMoves[r];
    sequence.add(mo);
  }
  
  //gets the total number of moves in a sequence and stored in currentMove
  currentMove = sequence.get(counter);

  //Copies the sequence and then performs reversal to slove the cube
  for(int i = sequence.size()-1; i >= 0; i--) {
    Move nextMove = sequence.get(i).copy();
    nextMove.reverse(); //reverse is meant to perform the reversal of the sequence
    sequence.add(nextMove);
  }
  
}

//functions for each rotation around specifed axis

void turnZ(int index, int dir) {
  for (int i = 0; i < cube.length; i++) {
    Cubie qb = cube[i];
    if (qb.z == index) {
      PMatrix2D matrix = new PMatrix2D();
      matrix.rotate(dir*HALF_PI);
      matrix.translate(qb.x, qb.y);
      qb.update(round(matrix.m02), round(matrix.m12), round(qb.z)); //Z-Coordinate
      qb.turnFacesZ(dir);
    }
  }
}

void turnY(int index, int dir) {
  for (int i = 0; i < cube.length; i++) {
    Cubie qb = cube[i];
    if (qb.y == index) {
      PMatrix2D matrix = new PMatrix2D();
      matrix.rotate(dir*HALF_PI);
      matrix.translate(qb.x, qb.z);
      qb.update(round(matrix.m02), qb.y, round(matrix.m12)); //Y-Coordinate
      qb.turnFacesY(dir);
    }
  }
}

void turnX(int index, int dir) {
  for (int i = 0; i < cube.length; i++) {
    Cubie qb = cube[i];
    if (qb.x == index) {
      PMatrix2D matrix = new PMatrix2D();
      matrix.rotate(dir*HALF_PI);
      matrix.translate(qb.y, qb.z);
      qb.update(qb.x, round(matrix.m02), round(matrix.m12)); //X-Coordinate
      qb.turnFacesX(dir);
    }
  }
}



//sets up the environment of the cube within the video
void draw() {
  background(51); 

  //show what step you are on with a counter
  fill(255);
  textSize(32);
  text(counter, 100, 100);
  
    //perform sequence of rotations after the spacevar has be pressed
    currentMove.update();
    if(currentMove.finished())
    {
     if (counter < sequence.size()-1) 
     {
       counter++;
       currentMove = sequence.get(counter);
       currentMove.start();
     }
    }
  
  
  scale(50); //scales the cube in the window
  for (int i = 0; i < cube.length; i++) 
  {
    push(); //saves the current drawing styles and transformation
    
    //Determine what the orientation is and check what cube needs to be oriented on a specific access
    if(abs(cube[i].z) > 0 && cube[i].z == currentMove.z)
    {
      rotateZ(currentMove.angle);
    }
    
    else if(abs(cube[i].x) > 0 && cube[i].x == currentMove.x)
    {
      rotateX(currentMove.angle);
    }
    
    else if(abs(cube[i].y) > 0 && cube[i].y == currentMove.y)
    {
      rotateY(-currentMove.angle);
    }
    
    
    cube[i].show(); //shows updated cube
    pop(); //restores the save setting
  }
}
