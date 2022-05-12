class Snake{
  int slength = 4;
  Apple a;
  int[][] pos = {{20,20,20,20},{19,20,21,22}};//([0][0], [1][0]) = head
  int[] lasttailpos = new int[2];
  int[] headpos = {20, 19};//x, y
  boolean justhit = false;
  boolean dead = false;
  boolean hitlastmove = false;//basically, the last position shares with the second to last, and waits for the whole snake to move 1 time before appending
  float [][] weights; 
  int moves = 0;
  int applesfound = 0;
  int score = 0;
  boolean selected = false;
  boolean hasapple = true;
  int headdir = 4;
  ArrayList<Integer> foundspacesx = new ArrayList<Integer>();
  ArrayList<Integer> foundspacesy = new ArrayList<Integer>();
  Snake(){
    a = new Apple();
    Show();
    weights = getWeights();
    //weights = setWeights();
  }
  void Show(){
    if(!dead){
      fill(0,255,0);//alive color = green
      for(int i = 0; i < pos[0].length; i++){
        rect(pos[0][i] * squaresize, pos[1][i] * squaresize, squaresize, squaresize);
      }
      fill(0);//eye color
      rect(pos[0][0] * squaresize + squaresize/5, pos[1][0] * squaresize, squaresize / 5, squaresize / 5);//left eye
      rect(pos[0][0] * squaresize + squaresize/5 * 3, pos[1][0] * squaresize, squaresize / 5, squaresize / 5);//right eye
    }else{
      fill(100, 100, 100);//dead color = gray
      for(int i = 0; i < pos[0].length; i++){
        rect(pos[0][i] * squaresize, pos[1][i] * squaresize, squaresize, squaresize);
      }
    }
  }
  void Move(int direction){//left, right, up, down
    if(hitlastmove){
      Grow();
      hitlastmove = false;
    }
    headpos[0] = pos[0][0];
    headpos[1] = pos[1][0];
    if(direction == 1){//                                                                        left
      if(hitsSelf(pos[0][0] - 1, pos[1][0], 0) || hitsWall(pos[0][0] - 1, pos[1][0])){
        dead = true;
      }
      lasttailpos[0] = pos[0][slength - 1];
      lasttailpos[1] = pos[1][slength - 1];
      fill(100);//trail color
      rect(pos[0][slength - 1] * squaresize, pos[1][slength - 1] * squaresize, squaresize, squaresize); 
      for(int i = slength - 1; i  > 0; i--){// i = length - 1 (index) - last one (-1)
        pos[0][i] = pos[0][i - 1];
        pos[1][i] = pos[1][i - 1];
      }
      pos[0][0] = pos[0][0] - 1;
    }else if(direction == 2){//                                                                   right
      if(hitsSelf(pos[0][0] + 1, pos[1][0], 0) || hitsWall(pos[0][0] + 1, pos[1][0]))
        dead = true;
      lasttailpos[0] = pos[0][slength - 1];
      lasttailpos[1] = pos[1][slength - 1];
      fill(100);
      rect(pos[0][slength - 1] * squaresize, pos[1][slength - 1] * squaresize, squaresize, squaresize);
      for(int i = slength - 1; i  > 0; i--){// i = length - 1 (index) - last one (-1)
        pos[0][i] = pos[0][i - 1];
        pos[1][i] = pos[1][i - 1];
      }
      pos[0][0] = pos[0][0] + 1;
    }else if(direction == 3){//                                                                  up
      if(hitsSelf(pos[0][0], pos[1][0] - 1, 0) || hitsWall(pos[0][0], pos[1][0] - 1))
        dead = true;
      lasttailpos[0] = pos[0][slength - 1];
      lasttailpos[1] = pos[1][slength - 1];
      fill(100);
      rect(pos[0][slength - 1] * squaresize, pos[1][slength - 1] * squaresize, squaresize, squaresize);
      for(int i = slength - 1; i  > 0; i--){// i = length - 1 (index) - last one (-1)
        pos[0][i] = pos[0][i - 1];
        pos[1][i] = pos[1][i - 1];
      }
      pos[1][0] = pos[1][0] - 1;
    }else if(direction == 4){//                                                                   down
      if(hitsSelf(pos[0][0], pos[1][0] + 1, 0) || hitsWall(pos[0][0], pos[1][0] + 1))
        dead = true;
      lasttailpos[0] = pos[0][slength - 1];
      lasttailpos[1] = pos[1][slength - 1];
      fill(100);
      rect(pos[0][slength - 1] * squaresize, pos[1][slength - 1] * squaresize, squaresize, squaresize);
      for(int i = slength - 1; i  > 0; i--){// i = length - 1 (index) - last one (-1)
        pos[0][i] = pos[0][i - 1];
        pos[1][i] = pos[1][i - 1];
      }
      pos[1][0] = pos[1][0] + 1;
    }
    moves++;
    if(selected){
      Show();
      fill(255, 0, 0);
      rect(a.pos[0] * squaresize + (squaresize / 4), a.pos[1] * squaresize + (squaresize / 4), squaresize / 2, squaresize / 2);
    }
    CheckForApple();
    boolean spaceexists = false;
    for(int i = 0; i < foundspacesx.size(); i++){
      if(pos[0][0] == foundspacesx.get(i) && pos[1][0] == foundspacesy.get(i))
        spaceexists = true;
    }
    if(!spaceexists){
      foundspacesx.add(pos[0][0]);
      foundspacesy.add(pos[1][0]);
    }
  }//START COLLISIONS
  boolean hitsSelf(int x, int y, int starting){//if it hits itself
    boolean hits = false;
    for(int i = starting; i < slength; i++){
      if((x == pos[0][i] && y == pos[1][i])){
        hits = true;
      }
    }
    return hits;
  }
  boolean hitsWall(int x, int y){//if it hits the wall
    boolean hits = false;
    for(int i = 0; i < slength; i++){
      if(x == lbound || x == rbound || y == lbound || y == rbound){
        hits = true;
      }
    }
    return hits;
  }
  void CheckForApple(){
    for(int i = 0; i < slength; i++){
      if(pos[0][i] == a.pos[0] && pos[1][i] == a.pos[1]){
        applesfound++;
        gentotalapples++;
        Grow();
        a.MakeNewApple(pos);
        if(selected){
          fill(255, 0, 0);
          rect(a.pos[0] * squaresize + (squaresize / 4), a.pos[1] * squaresize + (squaresize / 4), squaresize / 2, squaresize / 2);
        }
      }
    }
  }//END COLLISIONS
  void Grow(){
    int[][] oldpos = new int[slength][slength];
    for(int i = 0; i < slength; i++){
      oldpos[0][i] = pos[0][i];
      oldpos[1][i] = pos[1][i];
    }
    slength++;
    pos = new int[slength][slength];
    for(int i = 0; i < slength - 1; i++){
      pos[0][i] = oldpos[0][i];
      pos[1][i] = oldpos[1][i];
    }
    pos[0][slength - 1] = lasttailpos[0];
    pos[1][slength - 1] = lasttailpos[1];
  }
  void Reset(){//resets snake without changing weights
    pos = new int[4][4];
    pos[0][0] = 20;
    pos[0][1] = 20;
    pos[0][2] = 20;
    pos[0][3] = 20;
    pos[1][0] = 19;
    pos[1][1] = 20;
    pos[1][2] = 21;
    pos[1][3] = 22;
    slength = 4;
    headdir = 4;
    moves = 0;
    lasttailpos = new int[2];
    foundspacesx = new ArrayList<Integer>();
    foundspacesy = new ArrayList<Integer>();
    headpos[0] = 20;
    headpos[1] = 19;
    justhit = false;
    dead = false;
    hitlastmove = false;
    applesfound = 0;
    a.MakeNewApple(pos);
    hasapple = true;
    if(selected){
      fill(255, 0, 0);
      rect(a.pos[0] * squaresize + (squaresize / 4), a.pos[1] * squaresize + (squaresize / 4), squaresize / 2, squaresize / 2);
    }
    //score = 0;
    selected = false;
  }
  int[] GetInputs(){//gets the snake's vision in 8 directions (udlr and diagonally 4 ways)
    int[] inputs = new int[32];//32 inputs
    int numdone = 0;
    for(int to = 1; to < 4; to++){//1-8 = wall, 9-16 = self, 17-24 = apple
      for(int dir = 0; dir < 8; dir++){
        inputs[numdone] = distTo(dir, to);
        numdone++;
      }
    }
    if(pos[0][0] > pos[0][1]){//if body continues to left
      inputs[numdone] = 1;
      headdir = 1;
    }else if(pos[0][0] < pos[0][1]){//if body continues to right
      inputs[numdone + 1] = 1;
      headdir = 2;
    }else if(pos[1][0] > pos[1][1]){//if body continues to the up
      inputs[numdone + 2] = 1;
      headdir = 3;
    }else if(pos[1][0] < pos[1][1]){//if body continues to down
      inputs[numdone + 3] = 1;
      headdir = 4;
    }else
      print("uh oh");
    numdone += 4;
    if(pos[0][pos[0].length - 1] > pos[0][pos[0].length - 2]){//if tail continues to left
      inputs[numdone] = 1;//was 1 but want it to be more powerful
    }else if(pos[0][pos[0].length - 1] < pos[0][pos[0].length - 2]){//if tail continues to right
      inputs[numdone + 1] = 1;
    }else if(pos[1][pos[1].length - 1] > pos[1][pos[1].length - 2]){//if tail continues to the up
      inputs[numdone + 2] = 1;
    }else if(pos[1][pos[1].length - 1] < pos[1][pos[1].length - 2]){//if tail continues to down
      inputs[numdone + 3] = 1;
    }else
      print("uh oh2\n");
    //inputs[32] = a.pos[0] - pos[0][0];
    //inputs[33] = a.pos[1] - pos[1][0];
    return inputs;
  }
  int distTo(int dir, int to){//to: 1 == wall, 2 == self, 3 == apple   dir: l r u d  tl tr bl br ----- gets distance to a given thing
    int dist = 0;
    boolean hitsedge = false;
    int x = headpos[0];
    int y = headpos[1];
    if(to == 1){//HITS WALL
      switch(dir){//check in that dir
        case 0://l wall
          dist = x;
        break;case 1://r wall
          dist = rbound - x;
        break;case 2://up wall
          dist = y;
        break;case 3://down wall
          dist = rbound - y;
        break;case 4:
          while(x != lbound && y != lbound){//tl
            x--;
            y--;
            dist++;
          }
        break;case 5:
          while(x != rbound && y != lbound){//tr
            x++;
            y--;
            dist++;
          }
        break;case 6:
          while(x != lbound && y != rbound){//bl
            x--;
            y++;
            dist++;
          }
        break;case 7:
          while(x != rbound && y != rbound){//br
              x++;
              y++;
              dist++;
          }
        break;
      }
    }else if(to == 2){//HITS SELF
      switch(dir){//check in that dir
        case 0:
          while(!hitsSelf(x, y, 2) && !hitsedge){//while dn hit wall or self l
            x--;
            if(x == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 1:
          while(!hitsSelf(x, y, 2) && !hitsedge){//r
            x++;
            if(x == rbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 2:
          while(!hitsSelf(x, y, 2) && !hitsedge){//u
            y--;
            if(y == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 3:
          while(!hitsSelf(x, y, 2) && !hitsedge){//d
            y++;
            if(y == rbound)
              hitsedge = true;
            
              dist++;
          }
        break;case 4:
          while(!hitsSelf(x, y, 2) && !hitsedge){//tl
            x--;
            y--;
            if(x == lbound || y == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 5:
        while(!hitsSelf(x, y, 2) && !hitsedge){//tr
            x++;
            y--;
            if(x == rbound || y == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 6:
          while(!hitsSelf(x, y, 2) && !hitsedge){//bl
            x--;
            y++;
            if(x == lbound || y == rbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 7:
          while(!hitsSelf(x, y, 2) && !hitsedge){//br
            x++;
            y++;
            if(x == rbound || y == rbound)
              hitsedge = true;
            else
              dist++;
          }
        break;
      }
    }else{//APPLE 17 - 24
      switch(dir){//check in that dir
        case 0://if apple is on left
          if(x > a.pos[0] && y == a.pos[1]){//if x > apple x and y is same
            dist = x - a.pos[0];
          }else
            hitsedge = true;
        break;case 1://right
          if(x < a.pos[0] && y == a.pos[1]){//if x < apple x and y is same
            dist = a.pos[0] - x;
          }else
            hitsedge = true;
        break;case 2://up
          if(y > a.pos[1] && x == a.pos[0]){//if y > apple y and x is same
            dist = y - a.pos[1];
          }else
            hitsedge = true;
        break;case 3:
        if(y < a.pos[1] && x == a.pos[0]){//if y < apple y and x is same
            dist = a.pos[1] - y;
          }else
            hitsedge = true;
        break;case 4:
          while(!(x == a.pos[0] && y == a.pos[1]) && !hitsedge){//tl
            x--;
            y--;
            if(x == lbound || y == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 5:
        while(!(x == a.pos[0] && y == a.pos[1]) && !hitsedge){//tr
            x++;
            y--;
            if(x == rbound || y == lbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 6:
          while(!(x == a.pos[0] && y == a.pos[1]) && !hitsedge){//bl
            x--;
            y++;
            if(x == lbound || y == rbound)
              hitsedge = true;
            else
              dist++;
          }
        break;case 7:
          while(!(x == a.pos[0] && y == a.pos[1]) && !hitsedge){//br
              x++;
              y++;
              if(x == rbound || y == rbound)
                hitsedge = true;
              else
                dist++;
          }
        break;
      }
    }
    if(hitsedge)
      dist = 0;
    return dist;
  }
  void RemovePresence(){
    fill(100);
    rect(a.pos[0] * squaresize, a.pos[1] * squaresize, squaresize, squaresize);
    hasapple = false;
    for(int i = 0; i < slength; i++)
      rect(pos[0][i] * squaresize, pos[1][i] * squaresize, squaresize, squaresize); 
  }
  void SetScore(){
    //score = moves + foundspacesx.size() * 10 + (applesfound * foundspacesx.size());// + (foundspacesx.size());//score set
    score = moves * 10 + (applesfound * 200);
    if(applesfound > 1)
      score *= applesfound;
  }
}
