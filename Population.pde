Snake[] getNextSnakeGenes(){
  Snake[] chosensnakes = new Snake[passingsnakes];
  int[] scores = new int[numofsnakes];//[i][0] = score  [i][1] = which snake it belongs to
  for(int i = 0; i < numofsnakes; i++){//foreach snake
    scores[i] = snakes[i].score;
  }
  ArrayList<Integer> scorenumberpool = new ArrayList<Integer>();
  for(int i = 0; i < numofsnakes; i++){//create scoring number pool for each scoring number
    boolean newnum = true;
    for(int x = 0; x < scorenumberpool.size(); x++){
      if(scores[i] == scorenumberpool.get(x))//is it already in list?
        newnum = false;
    }
    if(newnum)//if not in list
      scorenumberpool.add(scores[i]);
  }
  int max = 0;
  for(int i = 0; i < scorenumberpool.size(); i++){//get max val
    if(scorenumberpool.get(i) > max)
      max = scorenumberpool.get(i);
  }
  int scoretotal = 0;
  for(int i = 0; i < scorenumberpool.size(); i++){//get score total
    scoretotal += scorenumberpool.get(i);
  }
  int[] scoreprizearray = new int[scoretotal];
  int aryindex = 0;
  for(int i = 0; i < scorenumberpool.size(); i++){//fill array with values
    int poolnum = scorenumberpool.get(i);
    for(int x = 0; x < poolnum; x++){
      scoreprizearray[aryindex] = poolnum;
      aryindex++;
    }
  }
  maxscore = max;
  boolean maxfound = false;
  for(int i = 0; i < snakes.length && !maxfound; i++){//get max index
    if(snakes[i].score == max){
      max = i;
      maxfound = true;
    }
  }
  int[] scorechoices = new int[passingsnakes];
  for(int i = 0; i < passingsnakes; i++){//for each score choice
    int rand = 0;
    rand = (int)random(0, scoreprizearray.length - 1);
    scorechoices[i] = scoreprizearray[rand];
  }
  chosensnakes[0] = snakes[max];
  for(int i = 1; i < passingsnakes; i++){
    ArrayList<Integer> snakeswithscorei = new ArrayList<Integer>();
    for(int x = 0; x < numofsnakes; x++){
      if(scorechoices[i] == scores[x])
        snakeswithscorei.add(x);//add index of snake
    }
    int rint = (int)random(0, snakeswithscorei.size() - 1);
    chosensnakes[i] = snakes[snakeswithscorei.get(rint)];//snake = the random scoring snake form
  };
  return chosensnakes;
}
void PostGeneration(){
  Snake[] parents = getNextSnakeGenes();
  for(Snake s : snakes){
    if(s.slength > longestsnake)
      longestsnake = s.slength;
    if(s.applesfound > maxapples)
      maxapples = s.applesfound;
  }
  for(int i = 0; i < passingsnakes; i++){//all parents will survive for next gen with their own genes
    snakes[i].weights = parents[i].weights;
    snakes[i].Reset();
  }
  for(int i = 1; i < numofsnakes; i++){
    snakes[i].Reset();
    snakes[i].weights = Mutate(parents[i % passingsnakes].weights, weightconfig);//gets genes of parents for babies but has chance of mutation
    if(!showbestonly)
      snakes[i].selected = true;
  }
  snakes[0].selected = true;
  /*print("\nweights = {");
  for(int x = 0; x < snakes[0].weights.length; x++){
    print("{");
    for(int i = 0; i < snakes[0].weights[x].length; i++)
      print(snakes[0].weights[x][i] + ", ");
    print("}, ");
  }*/
  println("---------------------------------------------\nMax Score: " + maxscore + 
  "\nMost Apples Found: " + maxapples + 
  "\nTotal apples found: " + gentotalapples + 
  "\n\nLongest Snake: " + longestsnake + 
  "\nSnakes starved: " + genstarvedsnakes + 
  "\n\nGeneration: " + batch + 
  "\n---------------------------------------------");
  gentotalapples = 0;
  genstarvedsnakes = 0;
  maxapples = 0;
  longestsnake = 0;
}
