ArrayList<Float> xp = new ArrayList<Float> ();
ArrayList<Float> yp = new ArrayList<Float> ();
ArrayList<Float> xp1 = new ArrayList<Float> ();
ArrayList<Float> yp1 = new ArrayList<Float> ();

float [][] connection;
float [][] connection1;

ArrayList<Float> xpath = new ArrayList<Float> ();
ArrayList<Float> ypath = new ArrayList<Float> ();
ArrayList<Float> xpath1 = new ArrayList<Float> ();
ArrayList<Float> ypath1 = new ArrayList<Float> ();

float dist[];
float dist1[];


float radius = 30;
float squre =30;

float reclen = 30;
float rechei = 10;


float[] CircleObsX ={400};
float[] CircleObsY ={400};
float[] CircleObsRad = {80};

float[] CShapeRad ={0};
float[] CShapeSquare ={0};

float[] rectangleObsX = {120,100,400,700,250,300,550,720,640,530,420,170,670,200};
float[] rectangleObsY = {430,730,730,730,650,580,500,580,520,250,150,250,80,360};
float[] rectangleObsLen = {240,10,10,10,10,500,10,160,10,540,500,10,10,70};
float[] rectangleObsHei = {10,140,140,140,140,10,300,10,130,10,10,210,150,10};

//void closeRoad() {
//  if (mousePressed == true) {
//    rectangleObsX[0] = 160;
//    rectangleObsLen[0] = 320;
//  }
//}

void setup() {
  size(800,800);
  background(255);
  
  for (int i=0;i<CircleObsRad.length;i++) {
    CShapeRad[i] =CircleObsRad[i]+radius; 
    CShapeSquare[i] =CircleObsRad[i]+squre*1.41;
  }
  
  xp.add(40.0);
  yp.add(760.0);
  xp.add(760.0);
  yp.add(40.0);
  
  xp1.add(600.0);
  yp1.add(40.0);
  xp1.add(760.0);
  yp1.add(760.0);
  
  PRM(0);
  nodeNumber=xpath.size()-1;
  PRM(1);
  nodeNumber1=xpath1.size()-1;
}

void PRM(int choice) {
  if (choice ==0) {
    setupPoints(0);
    connectPoints(0);
    lineCircleCollision(0);
    for (int i=0;i<rectangleObsX.length;i++) {
      lineRecCollision(rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i],0);
    }
    int[] parent= Dijkstra(0);
    while (dist[1] == 1000000) {
      setupPoints(0);
      connectPoints(0);
      lineCircleCollision(0);
      for (int i=0;i<rectangleObsX.length;i++) {
      lineRecCollision(rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i],0);
    }
      parent= Dijkstra(0);
    }
    setupPath(parent,0);
  }
  
  if (choice ==1) {
    setupPoints(1);
    connectPoints(1);
    lineCircleCollision(1);
    for (int i=0;i<rectangleObsX.length;i++) {
      lineRecCollision(rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i],1);
    }
    int[] parent= Dijkstra(1);
    while (dist1[1] == 1000000) {
      setupPoints(1);
      connectPoints(1);
      lineCircleCollision(1);
      for (int i=0;i<rectangleObsX.length;i++) {
      lineRecCollision(rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i],1);
    }
      parent= Dijkstra(1);
    }
    setupPath(parent,1);
  }
  
}

boolean testRecCollision(float a, float b,float x, float y, float len,float hei) {
  int XCircleNumber =Math.round(len/radius)+1;
  int YCircleNumber =Math.round(hei/radius)+1;
  //float [][] centerX =new float[XCircleNumber][YCircleNumber];
  //float [][] centerY =new float[XCircleNumber][YCircleNumber];
  for (int i=0;i<XCircleNumber;i++) {
    for (int j=0;j<YCircleNumber;j++) {
      float centerX = x-len/2+i*radius;
      float centerY = y-hei/2+j*radius;
      if ( (a-centerX)*(a-centerX)+(b-centerY)*(b-centerY) < radius*radius){
        return true;
      }
    }
  }
  return false;
}

boolean testCollision(float a,float b,int choice) {
  if (choice ==0) {
  for (int i=0;i<CircleObsX.length;i++) {
    if ( (a-CircleObsX[i])*(a-CircleObsX[i])+(b-CircleObsY[i])*(b-CircleObsY[i]) <CShapeRad[i]*CShapeRad[i]) {
      return true;
      }
    }
  
  for (int i=0;i<rectangleObsLen.length;i++) {
    if (testRecCollision(a,b,rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i]) == true) {
      return true;
    }
  }
  return false;
  }
  
  
  else {  
    for (int i=0;i<CircleObsX.length;i++) {
    if ( (a-CircleObsX[i])*(a-CircleObsX[i])+(b-CircleObsY[i])*(b-CircleObsY[i]) <CShapeSquare[i]*CShapeSquare[i]) {
      return true;
      }
    }
  
  for (int i=0;i<rectangleObsLen.length;i++) {
    if (testRecCollision(a,b,rectangleObsX[i],rectangleObsY[i],rectangleObsLen[i],rectangleObsHei[i]) == true) {
      return true;
    }
  }
  return false;    
  }
}

void setupPoints(int choice) {
  if (choice ==0) {
    int generateRate = 50;
    for (int i=0; i<generateRate;i++) {
      float a = 800*random(1);
      float b = 800*random(1);
      if (testCollision(a,b,0) == false) {
        fill(255,0,0);
        ellipse(a,b,5,5);
        xp.add(a);
        yp.add(b);
      }
      else {
        fill(0,225,0);
        ellipse(a,b,5,5);
      }
    }
  }
  
  
  if (choice ==1) {
    int generateRate = 50;
    for (int i=0; i<generateRate;i++) {
      float a = 800*random(1);
      float b = 800*random(1);
      if (testCollision(a,b,1) == false) {
        fill(255,0,0);
        ellipse(a,b,5,5);
        xp1.add(a);
        yp1.add(b);
      }
      else {
        fill(0,225,0);
        ellipse(a,b,5,5);
      }
    }
  }
  
  
  //for (int i=0;i<generateRate;i++) {
  //  print(xp.get(i)+" ");
  //  println(yp.get(i));
  //}
}

void connectPoints(int choice) {
  if (choice ==0) {
    connection = new float[xp.size()][yp.size()];
    for (int i=0;i<xp.size();i++) {
      for (int j=0;j<yp.size();j++) {
        if (i !=j) {
          float l = (xp.get(i)-xp.get(j))*(xp.get(i)-xp.get(j)) + (yp.get(i)-yp.get(j))*(yp.get(i)-yp.get(j));
          if (  l <200*200) {
            connection[i][j] =sqrt(l);
            connection[j][i] =sqrt(l);
          }
        }
      }
    }
  }
  
  else {
    connection1 = new float[xp1.size()][yp1.size()];
    for (int i=0;i<xp1.size();i++) {
      for (int j=0;j<yp1.size();j++) {
        if (i !=j) {
          float l = (xp1.get(i)-xp1.get(j))*(xp1.get(i)-xp1.get(j)) + (yp1.get(i)-yp1.get(j))*(yp1.get(i)-yp1.get(j));
          if (  l <200*200) {
            connection1[i][j] =sqrt(l);
            connection1[j][i] =sqrt(l);
          }
        }
      }
    }
  }
  
  
}
  
  
  //for (int i=0;i<connection.length;i++) {
  //  for (int j=0;j<connection[0].length;j++) {
  //    if(connection[i][j]>0) {
  //      line(xp.get(i),yp.get(i),xp.get(j),yp.get(j));
  //    }
  //  }
  //}

void lineCircleCollision(int choice) {
  if (choice ==0) {
    for (int i=0; i<connection.length;i++) {
      for (int j=0; j<connection[0].length;j++) {
        if (connection[i][j] >0) {
          for (int k=0;k<CircleObsX.length;k++) {
            float m1=xp.get(i) - CircleObsX[k];
            float n1=yp.get(i) - CircleObsY[k];
            float m2=xp.get(i) - xp.get(j);
            float n2=yp.get(i) - yp.get(j);
            float m3= xp.get(j) - CircleObsX[k];
            float n3= yp.get(j) - CircleObsY[k];
            float a = m1*m2+n1*n2;
            float b = (-m2)*m3 + (-n2)*n3;
            float leng = sqrt(m2*m2+n2*n2);
            m2=m2/leng;
            n2=n2/leng;
            float dot =m1*m2+n1*n2 ;
            float distance = m1*m1+n1*n1 - dot*dot;
          
            if (distance < CShapeRad[k]*CShapeRad[k] && a*b >0) {
              connection[i][j]=-1;
              connection[j][i]=-1;
              //stroke(255,0,0);
              //line(xp.get(i),yp.get(i),xp.get(j),yp.get(j));
            }
          }
        }
      }
    }
  }
  
  else {
    
    
    for (int i=0; i<connection1.length;i++) {
      for (int j=0; j<connection1[0].length;j++) {
        if (connection1[i][j] >0) {
          for (int k=0;k<CircleObsX.length;k++) {
            float m1=xp1.get(i) - CircleObsX[k];
            float n1=yp1.get(i) - CircleObsY[k];
            float m2=xp1.get(i) - xp1.get(j);
            float n2=yp1.get(i) - yp1.get(j);
            float m3= xp1.get(j) - CircleObsX[k];
            float n3= yp1.get(j) - CircleObsY[k];
            float a = m1*m2+n1*n2;
            float b = (-m2)*m3 + (-n2)*n3;
            float leng = sqrt(m2*m2+n2*n2);
            m2=m2/leng;
            n2=n2/leng;
            float dot =m1*m2+n1*n2 ;
            float distance = m1*m1+n1*n1 - dot*dot;
          
            if (distance < CShapeSquare[k]*CShapeSquare[k] && a*b >0) {
              connection1[i][j]=-1;
              connection1[j][i]=-1;
              //stroke(255,0,0);
              //line(xp.get(i),yp.get(i),xp.get(j),yp.get(j));
            }
          }
        }
      }
    }
  
  
  }
  
}

void lineRecCollision(float x, float y, float len,float hei,int choice) {
  if (choice ==0) {
  int XCircleNumber =Math.round(len/radius)+1;
  int YCircleNumber =Math.round(hei/radius)+1;
  float [][] centerX =new float[XCircleNumber][YCircleNumber];
  float [][] centerY =new float[XCircleNumber][YCircleNumber];
  for (int i=0;i<XCircleNumber;i++) {
    for (int j=0;j<YCircleNumber;j++) {
      centerX[i][j] = x-len/2+i*radius;
      centerY[i][j] = y-hei/2+j*radius;
    }
  }
  
  
  for (int i=0; i<connection.length;i++) {
    for (int j=0; j<connection[0].length;j++) {
      if (connection[i][j] >0) {
        for (int k=0;k<centerX.length;k++) {
          for (int l=0;l<centerX[0].length;l++){
            float m1=xp.get(i) - centerX[k][l];
            float n1=yp.get(i) - centerY[k][l];
            float m2=xp.get(i) - xp.get(j);
            float n2=yp.get(i) - yp.get(j);
            float m3= xp.get(j) - centerX[k][l];
            float n3= yp.get(j) - centerY[k][l];
            float a = m1*m2+n1*n2;
            float b = (-m2)*m3 + (-n2)*n3;
            float leng = sqrt(m2*m2+n2*n2);
            m2=m2/leng;
            n2=n2/leng;
            float dot =m1*m2+n1*n2 ;
            float distance = m1*m1+n1*n1 - dot*dot;
        
            if (distance < radius*radius && a*b >0) {
            connection[i][j]=-1;
            connection[j][i]=-1;
            //stroke(255,0,0);
            //line(xp.get(i),yp.get(i),xp.get(j),yp.get(j));
            }
          }
        }
      }
    }
  }
}

else {
  int XCircleNumber =Math.round(len/radius)+1;
  int YCircleNumber =Math.round(hei/radius)+1;
  float [][] centerX =new float[XCircleNumber][YCircleNumber];
  float [][] centerY =new float[XCircleNumber][YCircleNumber];
  for (int i=0;i<XCircleNumber;i++) {
    for (int j=0;j<YCircleNumber;j++) {
      centerX[i][j] = x-len/2+i*radius;
      centerY[i][j] = y-hei/2+j*radius;
    }
  }
  
  
  for (int i=0; i<connection1.length;i++) {
    for (int j=0; j<connection1[0].length;j++) {
      if (connection1[i][j] >0) {
        for (int k=0;k<centerX.length;k++) {
          for (int l=0;l<centerX[0].length;l++){
            float m1=xp1.get(i) - centerX[k][l];
            float n1=yp1.get(i) - centerY[k][l];
            float m2=xp1.get(i) - xp1.get(j);
            float n2=yp1.get(i) - yp1.get(j);
            float m3= xp1.get(j) - centerX[k][l];
            float n3= yp1.get(j) - centerY[k][l];
            float a = m1*m2+n1*n2;
            float b = (-m2)*m3 + (-n2)*n3;
            float leng = sqrt(m2*m2+n2*n2);
            m2=m2/leng;
            n2=n2/leng;
            float dot =m1*m2+n1*n2 ;
            float distance = m1*m1+n1*n1 - dot*dot;
            
            //check here
            if (distance < radius*radius && a*b >0) {
            connection1[i][j]=-1;
            connection1[j][i]=-1;
            //stroke(255,0,0);
            //line(xp.get(i),yp.get(i),xp.get(j),yp.get(j));
            }
          }
        }
      }
    }
  }
}
  
}

int minDistance(float dist[],boolean sptSet[],int choice) {
  if (choice ==0) {
    float min = 1000000;
    int min_index=0;;
    
    for (int i=0;i<xp.size();i++) {
      if (sptSet[i] == false && dist[i] <=min){
        min = dist[i];
        min_index = i;
      }
    }
    return min_index;
  }
  
  
  else {
    float min = 1000000;
    int min_index=0;;
    
    for (int i=0;i<xp1.size();i++) {
      if (sptSet[i] == false && dist[i] <=min){
        min = dist[i];
        min_index = i;
      }
    }
    return min_index;
  }
}

//void printSolution(float dist[],int parent[]){
//   print("Vertex Distance from Source\n");
//   for (int i = 0; i < xp.size(); i++)
//      println(i+"\t\t"+dist[i]+"\t\t"+"parent is" + parent[i]);
//}

int[] Dijkstra(int choice) {
  if (choice ==0) {
    dist = new float[xp.size()];
    boolean sptSet[] = new boolean[xp.size()];
    int parent[]= new int[xp.size()];
    
    for (int i=0;i<xp.size();i++) {
      dist[i]=1000000;
      sptSet[i] = false;
      parent[i] = -1; //no parent now
    }
    
    dist[0]=0;
    parent[0]=0;
    
    for (int count=0;count<xp.size()-1;count++) {
      int u =minDistance(dist,sptSet,0);
      sptSet[u] = true;
  
      for (int v=0;v<xp.size();v++) {
        if ( !sptSet[v] && connection[u][v] !=0 && connection[u][v] !=-1
             && dist[u] !=1000000 && dist[u]+connection[u][v]< dist[v]) {
               dist[v] =dist[u] + connection[u][v];
               parent[v] = u;
          }
      }
    }
    //printSolution(dist,parent); 
    return parent;
  }
  else {
    
    dist1 = new float[xp1.size()];
    boolean sptSet[] = new boolean[xp1.size()];
    int parent[]= new int[xp1.size()];
    
    for (int i=0;i<xp1.size();i++) {
      dist1[i]=1000000;
      sptSet[i] = false;
      parent[i] = -1; //no parent now
    }
    
    dist1[0]=0;
    parent[0]=0;
    
    for (int count=0;count<xp1.size()-1;count++) {
      int u =minDistance(dist1,sptSet,1);
      sptSet[u] = true;
  
      for (int v=0;v<xp1.size();v++) {
        if ( !sptSet[v] && connection1[u][v] !=0 && connection1[u][v] !=-1
             && dist1[u] !=1000000 && dist1[u]+connection1[u][v]< dist1[v]) {
               dist1[v] =dist1[u] + connection1[u][v];
               parent[v] = u;
          }
      }
    }    
    return parent;
  }
}

void setupPath(int[] parent,int choice) {
  if(choice ==0) {
  int node=1;
    xpath.add(xp.get(node));
    ypath.add(yp.get(node));
    while(node !=0) {
      //stroke(0,255,0);
      //line(xp.get(node),yp.get(node),xp.get(parent[node]),yp.get(parent[node]) );
      node=parent[node];
      xpath.add(xp.get(node));
      ypath.add(yp.get(node));
    }
  }
  
  else {
     int node=1;
    xpath1.add(xp1.get(node));
    ypath1.add(yp1.get(node));
    while(node !=0) {
      //stroke(0,255,0);
      //line(xp.get(node),yp.get(node),xp.get(parent[node]),yp.get(parent[node]) );
      node=parent[node];
      xpath1.add(xp1.get(node));
      ypath1.add(yp1.get(node));
    }
  
  }
  
  
    //for (int i=0;i<xpath.size();i++) {
    //  print(xpath.get(i)+"   ");
 // }
  //  println();
    //for (int i=0;i<ypath.size();i++) {
    //  print(ypath.get(i)+"   ");
  //}
}

float xPosition=40; float yPosition=760;
int nodeNumber;
float xPosition1=600;float yPosition1=40;
int nodeNumber1;

void calculatePosition(int choice) {
  float velocity =1;
  if (choice ==0) {
    if (nodeNumber>0) {
      float m =xpath.get(nodeNumber-1)-xPosition;
      float n =ypath.get(nodeNumber-1)-yPosition;
      float lenn = sqrt(m*m+n*n);
      float xVelocity= m/lenn*velocity;
      float yVelocity= n/lenn*velocity;
      xPosition = xPosition+xVelocity;
      yPosition = yPosition+yVelocity;
      //println(lenn);
      if (lenn < 1) {
        nodeNumber=nodeNumber-1;
      }
    }
  }
  
  else{
    
     if (nodeNumber1>0) {
      float m =xpath1.get(nodeNumber1-1)-xPosition1;
      float n =ypath1.get(nodeNumber1-1)-yPosition1;
      float lenn = sqrt(m*m+n*n);
      float xVelocity= m/lenn*velocity;
      float yVelocity= n/lenn*velocity;
      xPosition1 = xPosition1+xVelocity;
      yPosition1 = yPosition1+yVelocity;
      //println(lenn);
      if (lenn < 1) {
        nodeNumber1=nodeNumber1-1;
      }
    }
    
    
  }
}

void draw() {
  background(255);
  fill(255,0,0);
  ellipse(40,760,10,10);
  ellipse(760,40,10,10);
  ellipse(600,40,10,10);
  ellipse(760,760,10,10);
  //closeRoad();
  fill(0,0,0);
  for (int i=0;i<CircleObsX.length;i++) {
    ellipse(CircleObsX[i],CircleObsY[i],2*CircleObsRad[i],2*CircleObsRad[i]);
  }
  
   for (int i=0;i<rectangleObsX.length;i++) {
    rect(rectangleObsX[i]-rectangleObsLen[i]/2,rectangleObsY[i]-rectangleObsHei[i]/2,rectangleObsLen[i],rectangleObsHei[i]);
  }
  
  calculatePosition(0);
  fill(255,255,255);
  ellipse(xPosition,yPosition,radius,radius);
  calculatePosition(1);
  fill(255,255,255);
  rect(xPosition1-squre/2,yPosition1-squre/2,squre,squre);
}