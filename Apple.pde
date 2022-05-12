class Apple{
  int mapsize = 1000;
  int squaresize = 25;
  int[] pos = new int[2];//x, y
  Apple(){
    int[][] tempsnk = {{420},{420}};
    MakeNewApple(tempsnk);
  }
  void MakeNewApple(int[][] snakepos){
    int randx = (int)random(0,40);//0-39
    int randy = (int)random(0,40);//0-39
    boolean found = false;
    while(!found){
      found = true;
      randx = (int)random(0,40);//0-39
      randy = (int)random(0,40);//0-39
      try{
      for(int i = 0; i < snakepos[0].length; i++){
        if(randx == snakepos[0][i] && randy == snakepos[1][i]){
          found = false;
        }
      }
      }catch(Exception e){}
    }
    pos[0] = randx;
    pos[1] = randy;
    //pos[0] = 10;
    //pos[1] = 10;
  }
}
