/**
* Touche Entrée : Résolution du jeu
* Fonctionnement :
*   - Cliquez sur l'une des colonnes pour choisir la pièce a bouger
*   - Cliquez ensuite sur la colonne voulue pour déplacer la pièce
*/

ArrayList<Disque> disques;
float t1;
float t2;
float t3;

/*float y1 = 500;
 float y2 = 450;
 float y3 = 400;
 float y4 = 350;
 float y5 = 300;*/


float y;

float[][] listmove = new float[300000][2];
int step=0;

boolean StartClick=true;
boolean EndClick=false;
boolean move=false;

float temp1;
float temp2;

int score = 0;

int nbdisques = 5;

int time=0;

int vitesse = 1;

void settings() {
  size(int(displayWidth/1.5), int(displayHeight/1.5));
}

void setup() {
  rectMode(CENTER);
  disques = new ArrayList<Disque>();
  /*disques.add(new Disque(width/6, 500, 300, 40));
   disques.add(new Disque(width/6, 500-50, 250, 40));
   disques.add(new Disque(width/6, 500-50*2, 200, 40));
   disques.add(new Disque(width/6, 500-50*3, 150, 40));
   disques.add(new Disque(width/6, 500-50*4, 100, 40));*/
  for (int i = 0; i < nbdisques; i++) {
    disques.add(new Disque(width/6, 500-((300)/nbdisques)*i, 300-((200)/nbdisques)*i, 200/nbdisques));
    Disque d = disques.get(i);
    d.c = color(i*(200/nbdisques), i*(200/nbdisques), 255);
  }
  y = 500;
  t1=width/6;
  t2=3*width/6;
  t3=5*width/6;

  resolution(t1, t3, t2, nbdisques);
}

void draw() {
  background(0);



  if ( (mousePressed) && (StartClick)) {
    if (mouseX<width/3) {
      temp1=t1;
    } else if (mouseX>2*width/3) {
      temp1=t3;
    } else {
      temp1=t2;
    }
    changeColor(temp1, color(255, 0, 0));
    StartClick=false;
    EndClick=true;
    mousePressed=false;
  } else if ( (mousePressed) && (EndClick)) {
    if (mouseX<width/3) {
      temp2=t1;
    } else if (mouseX>2*width/3) {
      temp2=t3;
    } else {
      temp2=t2;
    }
    changeColor(temp1, color(0, 0, 255));
    move=true;
    mousePressed=false;
  }


  if (move) {
    moveDisque(temp1, temp2);
    StartClick=true;
    EndClick=false;
    move=false;
  }

  fond();
  manageDisque();
  if (keyCode == ENTER) {
    for (int k = 0; k < vitesse; k++) {
      if (!testFinished()) {
        moveDisque(listmove[time][0], listmove[time][1]); 
        time++;
      } else {
        for (int i = 0; i < disques.size(); i++) {
          Disque d = disques.get(i);
          d.c = color(0, 255, 0);
        }
      }
    }
  } else {
    if (testFinished()) {
      for (int i = 0; i < disques.size(); i++) {
        Disque d = disques.get(i);
        d.c = color(0, 255, 0);
      }
    }
  }
  //print(listmove);
  //noLoop();
}

void manageDisque() {
  for (int i = 0; i < disques.size(); i++) {
    Disque d = disques.get(i);
    d.show();
  }
}

void fond() {
  fill(255);
  noStroke();
  rect(width/6, height/2, width/50, height/2, 100);
  rect(3*width/6, height/2, width/50, height/2, 100);
  rect(5*width/6, height/2, width/50, height/2, 100);

  rect(width/6, 3*height/4, width/4, width/50, 100);
  rect(3*width/6, 3*height/4, width/4, width/50, 100);
  rect(5*width/6, 3*height/4, width/4, width/50, 100);

  textSize(25);
  stroke(255);
  text(score, 50, 50);
}


void moveDisque(float Start, float End) {
  int nb1=-1;
  int nb2=-1;
  float nby=600;
  for (int i = 0; i < disques.size(); i++) {
    Disque d = disques.get(i);
    if (d.x==Start) {
      if (d.y<nby) {
        nb1=i;
        nby=d.y;
      }
    }
  }
  nby = 600;

  for (int i = 0; i < disques.size(); i++) {
    Disque d = disques.get(i);
    if (d.x == End) {
      if (d.y<nby) {
        nby=d.y;
        nb2=i;
      }
    }
  }

  if ( (nb2>= 0) && (nb1>=0) ) {
    Disque d1 = disques.get(nb1);
    Disque d2 = disques.get(nb2);

    if (d1.taillex<d2.taillex) {
      d1.x=End;
      d1.y=d2.y-((300)/nbdisques);
      score+=1;
    }
  } else if (nb1 >= 0) {
    Disque d1 = disques.get(nb1);
    d1.x=End;
    d1.y=y;
    score+=1;
  }
}

void changeColor(float tour, color c) {
  int nb1=-1;
  float nby=600;
  for (int i = 0; i < disques.size(); i++) {
    Disque d = disques.get(i);
    if (d.x==tour) {
      if (d.y<nby) {
        nb1=i;
        nby=d.y;
      }
    }
  }
  if (nb1>=0) {
    Disque d = disques.get(nb1);
    if (c == color(0, 0, 255)) {
      d.c = color(nb1*(200/nbdisques), nb1*(200/nbdisques), 255);
    } else {
      d.c = c;
    }
  }
}


void resolution(float Start, float Int, float End, int nbpiece) {
  if (nbpiece>0) {
    resolution(Start, End, Int, nbpiece-1);
    //moveDisque(Start, End);
    listmove[step][0] = Start;
    listmove[step][1] = End;
    step++;
    resolution(Int, Start, End, nbpiece-1);
  } else {
    //moveDisque(Start, End);
    listmove[step][0] = Start;
    listmove[step][1] = End;
    step++;
  }
}

boolean testFinished() {
  boolean test = true;
  for (int i = 0; i < disques.size(); i++) {
    Disque d = disques.get(i);
    if (d.x!=t3) {
      test = false;
    }
  }

  return test;
}
