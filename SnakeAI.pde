int squaresize = 25;
int mapsize = 1000;//40 by 40
int lbound = -1;
int rbound = 40;
int numofsnakes = 10000;
int[] weightconfig = {320, 40};//put number of connections for each layer
int[] netconfig ={10, 4};//each hidden layer + final - num of neurons
int passingsnakes  = 6;//num of snakes that survive to pass genes
Snake[] snakes = new Snake[numofsnakes];
int batch = 1;
boolean manual = false;
boolean wasman = false;
int bestsnake = 0;
int delay = 0;
int genstarvedsnakes = 0;
int gentotalapples = 0;
int longestsnake = 4;
int maxapples = 0;
int maxscore = 0;
boolean showbestonly = false;
//float[][] globalbestweights;
//int globalmaxscore = 0;
void setup() {//runs once at start
 size(1000, 1000);
 background(0);
  for(int x = 0; x < mapsize; x+=squaresize) {//columns
    for(int y = 0; y < mapsize; y+=squaresize) {//rows
      fill(100);//background color
      rect( x, y, squaresize, squaresize );
    }
  }
  for(int i = 0; i < snakes.length; i++){
    snakes[i] = new Snake();//init snakes
    snakes[i].selected = true;
  }
  snakes[0].selected = true;
}
void draw(){
  if(!manual){
    boolean snakesarealive = false;
    for(Snake s : snakes){
      if(s.dead && s.hasapple)
        s.RemovePresence();
    }
    for(Snake s : snakes){
      if(!s.dead){
        s.Move(MLMove(s.GetInputs(), s.weights));
        if(s.moves > (200 + s.applesfound * 100)){
          genstarvedsnakes++;
          s.dead = true;
          s.RemovePresence();
        }else
          snakesarealive = true;
      }
    }
    if(!snakesarealive){//if all snakes are dead
      ResetPlain();
      for(Snake s : snakes){
        s.SetScore();
      }
      PostGeneration();
      snakesarealive = true;
      batch++;
      if(wasman){
        manual = true;
        wasman = false;
      }
    }
    delay(delay);
    fill(255,220,70);
    for(int i = 0; i < snakes[0].slength; i++)
      rect(squaresize * snakes[0].pos[0][i], squaresize * snakes[0].pos[1][i], squaresize, squaresize);
  }
}
void mousePressed(){
  boolean snakesarealive = false;
  for(Snake s : snakes){
    if(!s.dead){
      s.Move(MLMove(s.GetInputs(), s.weights));
      if(s.moves > (200 + s.applesfound * 500))
        s.dead = true;
      else
        snakesarealive = true;
    }
  }
  if(!snakesarealive){//if all snakes are dead
    ResetPlain();
    for(Snake s : snakes){
      s.SetScore();
      s.Reset();
    }
    PostGeneration();
    snakesarealive = true;
    batch++;
  }
  Snake s = snakes[0];
  int temp = 1;
  println("Headpos = (" + s.headpos[0] + ", " + s.headpos[1] + ")");
  println("Apple pos = (" + s.a.pos[0] + ", " + s.a.pos[1] + ")");
  for(int i : s.GetInputs()){//only wall
    println(temp + ": " + i);
    temp++;
  }
  fill(255,220,70);
    for(int i = 0; i < snakes[0].slength; i++)
      rect(squaresize * snakes[0].pos[0][i], squaresize * snakes[0].pos[1][i], squaresize, squaresize);
  println("\n");
  
}
void keyPressed() {
  if (key == CODED) {
      if (keyCode == UP){
        if(delay != 0)
          delay -= 25;
      }else if(keyCode == DOWN)
        delay += 25;
      else if(keyCode == LEFT)
        manual = true;
      else if(keyCode == RIGHT)
        manual = false;
      else if(keyCode == RIGHT)
        manual = false;
  }
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      print("\nweights = {");
        for(int x = 0; x < snakes[0].weights.length; x++){
          print("{");
          for(int i = 0; i < snakes[0].weights[x].length; i++)
            print(snakes[0].weights[x][i] + ", ");
          print("}, ");
        }
        println("\n");
    }else if(key == 's' || key == 'S') {
      if(showbestonly){
        for(Snake s : snakes){
          s.selected = true;
        }
        showbestonly = false;
      }else{
        for(Snake s : snakes){
          s.selected = false;
        }
        showbestonly = true;
      }
    }
  }
}
void ResetPlain(){
  for(int x = 0; x < mapsize; x+=squaresize) {//columns
    for(int y = 0; y < mapsize; y+=squaresize) {//rows
      fill(100);//background color
      rect( x, y, squaresize, squaresize );
    }
  }
}
