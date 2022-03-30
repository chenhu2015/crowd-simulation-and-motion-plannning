CrowdSystem cs;
float[] CircleObsX={450,1150};
float[] CircleObsY ={400,400};
float[] CircleObsRad ={0,0};
float [] RecObsX={800,800,800,800};
float [] RecObsY={185,615,365,425};
float [] RecObsLen ={5,5,200,200};
float [] RecObsHei ={185,185,5,5};
float [] AgentStartX = new float[12];
//{100,120,160,200,100,120,160,200,100,120,160,200,100,120,160,200,1100,1100,1100,1100};
float [] AgentStartY = new float[12];
//{400,420,460,480,300,320,360,380,500,520,560,580,600,620,660,680,700,710,720,730};
float [] AgentGoalX= new float[12];
//{1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,1100,100,100,100,100};
float [] AgentGoalY= new float[12];
//{200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,400,400,400,400};

//float [] AttachStartX = {120};
//float [] AttachStartY = {420};
//float [] AttachGoalX = {1120};
//float [] AttachGoalY = {420};

ArrayList<Float> CShapeX = new ArrayList<Float> ();
ArrayList<Float> CShapeY = new ArrayList<Float> ();
ArrayList<Float> CShapeRad = new ArrayList<Float> ();

float AgentRad = 20;

void setup() {
  size(1600,800);
  background(255);
  for (int i=0;i<12;i++) {
    AgentStartX[i]=100;
    AgentStartY[i]=50+50*i;
    AgentGoalX[i] =1300;
    AgentGoalY[i] = 50+50*i;
  }
  
  //for(int i=12;i<24;i++){
  //  AgentStartX[i]=1100;
  //  AgentStartY[i]=50+50*(i-12);
  //  AgentGoalX[i]=100;
  //  AgentGoalY[i]=50+50*(i-12);
  //}
  
  cs = new CrowdSystem();
  cs.CalculateCShape();
  cs.FindPath();
}

void draw() {
  background(255);
  fill(0,0,0);
  for (int i=0;i<CircleObsX.length;i++) {
    ellipse(CircleObsX[i],CircleObsY[i],2*CircleObsRad[i],2*CircleObsRad[i]);
  }
  
  for (int i=0;i<RecObsX.length;i++) {
    rect(RecObsX[i]-RecObsLen[i],RecObsY[i]-RecObsHei[i],2*RecObsLen[i],2*RecObsHei[i]);
  }
  
  //stroke(255,0,0);
  //fill(255);
  //for (int i=0;i<CShapeX.size();i++) {
  //  ellipse(CShapeX.get(i),CShapeY.get(i),CShapeRad.get(i)*2,CShapeRad.get(i)*2);
  //}
  cs.Display();
}
 
class CrowdSystem {
  ArrayList<Agent> Agents;
  
  CrowdSystem() {
    Agents = new ArrayList<Agent> ();
    for (int i=0;i<AgentStartX.length;i++) {
      Agent a = new Agent(AgentStartX[i],AgentStartY[i],AgentGoalX[i],AgentGoalY[i]);
      Agents.add(a);
    }
  }
  
  
  void CalculateCShape() {
    for (int i=0;i<CircleObsX.length;i++) {
      CShapeX.add(CircleObsX[i]);
      CShapeY.add(CircleObsY[i]);
      CShapeRad.add(CircleObsRad[i]+AgentRad);
    }
    
    for (int i=0;i<RecObsX.length;i++) {
      float X1 = RecObsX[i]-RecObsLen[i];
      float Y1 = RecObsY[i]-RecObsHei[i];
      
      float X2 = RecObsX[i]+RecObsLen[i];
      float Y2 = RecObsY[i]-RecObsHei[i];
      
      float X3 = RecObsX[i]-RecObsLen[i];
      float Y3 = RecObsY[i]+RecObsHei[i];
      
      float X4 = RecObsX[i]+RecObsLen[i];
      float Y4 = RecObsY[i]+RecObsHei[i];
      
      int N = (int ((X2-X1)/(2*AgentRad)) )+1;
      //print(N);
      int M = (int ((Y3-Y2)/(2*AgentRad)) )+1;
      
      for (int j=0;j<N;j++) {
        for (int k=0;k<M;k++) {
          CShapeX.add(X1+j*AgentRad);
          CShapeY.add(Y1+k*AgentRad);
          CShapeRad.add(AgentRad);
        }        
      }
      
      for (int j=0;j<N;j++) {
        for (int k=0;k<M;k++) {
          CShapeX.add(X2-j*AgentRad);
          CShapeY.add(Y2+k*AgentRad);
          CShapeRad.add(AgentRad);
        }        
      }
      
      for (int j=0;j<N;j++) {
        for (int k=0;k<M;k++) {
          CShapeX.add(X3+j*AgentRad);
          CShapeY.add(Y3-k*AgentRad);
          CShapeRad.add(AgentRad);
        }        
      }
      
      for (int j=0;j<N;j++) {
        for (int k=0;k<M;k++) {
          CShapeX.add(X4-j*AgentRad);
          CShapeY.add(Y4-k*AgentRad);
          CShapeRad.add(AgentRad);
        }        
      }     
    }
  }
  
  void FindPath() {
    for (int i=0;i<Agents.size();i++) {
      Agents.get(i).CreatePath();
    }
  }
  
  void Display() {
     for (int i=0;i<Agents.size();i++) {
      ArrayList<Float> x = Agents.get(i).GetPathX();
      ArrayList<Float> y = Agents.get(i).GetPathY();
      //for (int j=0;j<x.size()-1;j++) {
      //  line(x.get(j),y.get(j),x.get(j+1),y.get(j+1));
      //}
      fill(0,0,0);
      ellipse(Agents.get(i).StartX, Agents.get(i).StartY,AgentRad,AgentRad);
      ellipse(Agents.get(i).GoalX,Agents.get(i).GoalY,AgentRad,AgentRad);
      
      //print("Agent is "+ i+" ");
      Agents.get(i).CalculatePosition();
      
      Agent a = Agents.get(i);
        for (int k=0;k<Agents.size();k++) {
          if (i !=k) {
            float SquareDistance = (a.CurrentX-Agents.get(k).CurrentX)*(a.CurrentX-Agents.get(k).CurrentX)+ (a.CurrentY-Agents.get(k).CurrentY)*(a.CurrentY-Agents.get(k).CurrentY);
            if (SquareDistance<(2*AgentRad+10)*(2*AgentRad+10) ) {
              float VecX=a.CurrentX-Agents.get(k).CurrentX;
              float VecY=a.CurrentY-Agents.get(k).CurrentY;
              a.CalculateVelocity(sqrt(SquareDistance),VecX,VecY);
              //println(SquareDistance);
            }
          }
        }
        //for (int k=0;k<CShapeX.size();k++) {
        //  float SquareDistance = (a.CurrentX-CShapeX.get(k))*(a.CurrentX-CShapeX.get(k)) + (a.CurrentY-CShapeY.get(k))*(a.CurrentY-CShapeY.get(k));
        //  if (SquareDistance< (CShapeRad.get(k)+10)*(CShapeRad.get(k)+10) ) {
        //    float VecX=a.CurrentX-CShapeX.get(k);
        //    float VecY=a.CurrentY-CShapeY.get(k);
        //    a.CalculateVelocity(sqrt(SquareDistance),VecX,VecY);
        //  }
        //}
        Agents.get(i).PathSmooth();
        
      fill(255,255,255);
      ellipse(Agents.get(i).CurrentX,Agents.get(i).CurrentY,AgentRad,AgentRad);
      }          
    }       
   }



class Agent {
  float StartX;
  float StartY;
  float GoalX;
  float GoalY;
  
  float CurrentX;
  float CurrentY;
  
  ArrayList<Float> PathX;
  ArrayList<Float> PathY;
  ArrayList<Float> MapX;
  ArrayList<Float> MapY;
  
  float [][] Connection;
  
  boolean Finded;
  float Dist[];
  int[] parent;
  
  int NodeNumber;
  
  float Velocity =2;
  float VelocityX;
  float VelocityY;
  
  //ArrayList<Float> AttachX;
  //ArrayList<Float> AttachY;
  //ArrayList<Float> AttachVelocityX;
  //ArrayList<Float> AttachVelocityY;
  
  Agent(float X1,float Y1, float X2, float Y2) {
    StartX=X1;
    StartY=Y1;
    GoalX=X2;
    GoalY=Y2;
    
    CurrentX=StartX;
    CurrentY=StartY;
    
    //AttachX = new ArrayList<Float> ();
    //AttachY = new ArrayList<Float> ();
    //AttachVelocityX = new ArrayList<Float> ();
    //AttachVelocityY = new ArrayList<Float> ();
    //for (int i=0;i<AttachStartX.length;i++) {
    //  AttachX.add(AttachStartX[i]);
    //  AttachY.add(AttachStartY[i]); 
    //  AttachVelocityX = new ArrayList<Float> ();
    //  AttachVelocityY = new ArrayList<Float> ();
    //}
    
    PathX = new ArrayList<Float> ();
    PathY = new ArrayList<Float> ();
    MapX = new ArrayList<Float> ();
    MapY = new ArrayList<Float> ();
    MapX.add(StartX);
    MapY.add(StartY);
    MapX.add(GoalX);
    MapY.add(GoalY);
    Finded = false;
  }
  
  ArrayList<Float> GetPathX() {
    return PathX;
  }
  
  ArrayList<Float> GetPathY() {
    return PathY;
  }
  
  
  void CreatePath() {
    while (Finded == false) {
      CreatePoints();
      ConnectPoints();
      LineCollision();
      parent=Dijkstra();
    }
    SetUpPath(parent);
    NodeNumber=PathX.size()-1;
  }
  
  void CreatePoints() {
    int GenerateRate=50;
    for (int i=0;i<GenerateRate;i++) {
      float a = 1200*random(1);
      float b = 800*random(1);
      if (PointCollision(a,b) == false) {
        MapX.add(a);
        MapY.add(b);
      }
    }
  }
  
  boolean PointCollision(float a,float b) {
   for (int i=0;i<CShapeX.size();i++) {
      if ( (a-CShapeX.get(i))*(a-CShapeX.get(i))+(b-CShapeY.get(i))*(b-CShapeY.get(i))<CShapeRad.get(i)*CShapeRad.get(i)) {
        return true;
      }
    }
    return false;
  }
  
  void ConnectPoints() {
    Connection = new float[MapX.size()][MapX.size()];
    for (int i=0;i<MapX.size();i++) {
      for (int j=0;j<MapY.size();j++) {
        if (i !=j) {
          float g = (MapX.get(i) - MapX.get(j)) * (MapX.get(i) - MapX.get(j)) + (MapY.get(i) - MapY.get(j)) * (MapY.get(i) - MapY.get(j));
          if ( g <200*200) {
            
            Connection[i][j] =sqrt(g);
            Connection[j][i] =sqrt(g);
            
          }
        }
      }
    }
  }
  
  void LineCollision() {
    for (int i=0;i<Connection.length;i++) {
      for (int j=0;j<Connection[0].length;j++) {
        if (Connection[i][j] >0) {
          for (int k=0;k<CShapeX.size();k++) {
            float M1 = MapX.get(i) - CShapeX.get(k);
            float N1 = MapY.get(i) - CShapeY.get(k);
            float M2 = MapX.get(i) - MapX.get(j);
            float N2 = MapY.get(i) - MapY.get(j);
            float M3 = MapX.get(j) - CShapeX.get(k);
            float N3 = MapY.get(j) - CShapeY.get(k);
            
            float a = M1*M2+N1*N2;
            float b = (-M2)*(M3) + (-N2)*(N3);
            float leng = sqrt(M2*M2+N2*N2);
            M2=M2/leng;
            N2=N2/leng;
            float dot = M1*M2+ N1*N2;
            float distance = M1*M1+N1*N1 - dot*dot;
            
            if (distance < CShapeRad.get(k)*CShapeRad.get(k) && a*b>0) {
              Connection[i][j] =-1;
              Connection[j][i] =-1;
            }
          }
        }
      }
    }
  }
  
  int[] Dijkstra() {
    Dist = new float[MapX.size()];
    boolean sptSet[] = new boolean[MapX.size()];
    int parent[] = new int[MapX.size()];
    
    for (int i=0;i<MapX.size();i++) {
      Dist[i]=1000000;
      sptSet[i] = false;
      parent[i] = -1;
    }
    
    Dist[0]=0;
    parent[0]=0;
    
    for (int count=0;count<MapX.size()-1;count++) {
      int u = minDistance(Dist,sptSet);
      sptSet[u] = true;
      
      for (int v=0;v<MapX.size();v++) {
        
        //normal UCS
        if (!sptSet[v] && Connection[u][v] !=0 && Connection[u][v] !=-1
            && Dist[u] !=1000000 && Dist[u]+Connection[u][v] <Dist[v]) {
              Dist[v]=Dist[u]+Connection[u][v];
              parent[v] = u;
            }
            
        //normal A*
        //if (!sptSet[v] && Connection[u][v] !=0 && Connection[u][v] !=-1
        //    && Dist[u] !=1000000 && (Dist[u]+Connection[u][v]+sqrt((MapX.get(u)-GoalX)*(MapX.get(u)-GoalX)+(MapY.get(u)-GoalY)*(MapY.get(u)-GoalY)) <Dist[v]) ){
        //      Dist[v]=Dist[u]+Connection[u][v]+sqrt( (MapX.get(u)-GoalX)*(MapX.get(u)-GoalX)+(MapY.get(u)-GoalY)*(MapY.get(u)-GoalY) );
        //      parent[v] = u;
        //    }
      }  
    }
    
    if (Dist[1] !=1000000) {
      Finded = true;
    }
    
    return parent;
  }
  
  int minDistance(float Dist[],boolean sptSet[]) {
    float min = 1000000;
    int min_index=0;
    
    for (int i=0;i<MapX.size();i++) {
      if (sptSet[i] == false && Dist[i] <=min) {
        min = Dist[i];
        min_index = i;
      }
    }
    return min_index;
  }
  
  void SetUpPath(int[] parent) {
    int node=1;
    PathX.add(MapX.get(node));
    PathY.add(MapY.get(node));
    while (node !=0) {
      node = parent[node];
      PathX.add(MapX.get(node));
      PathY.add(MapY.get(node));
    }
  }
  
  void CalculateVelocity(float Distance,float VecX,float VecY) {
    float mm =VecX/sqrt(VecX*VecX+VecY*VecY);
    float nn =VecY/sqrt(VecX*VecX+VecY*VecY);
    float projection =VelocityX*mm+VelocityY*nn;
    float DeltV = projection*(50-Distance)/20;
    Velocity = Velocity+DeltV;
    //if (Float.isNaN(DeltV)) {
    //    println(VecX,VelocityX,mm,VelocityY,nn,projection,Distance);
    //    println(PathX.get(NodeNumber-1));
    //    println(CurrentX,CurrentY);
    //    println(m,n);
    //    exit();
    //  }
    //println(DeltV);
  }
  
  void PathSmooth()  {
    boolean SeeNextPoint = true;
    if (NodeNumber >1) {
      float NextX = PathX.get(NodeNumber-2);
      float NextY = PathY.get(NodeNumber-2);
      for (int i=0;i<CShapeX.size();i++) {
        float P1 = NextX-CShapeX.get(i);
        float Q1 = NextY-CShapeY.get(i);
        float P2 = NextX-CurrentX;
        float Q2 = NextY-CurrentY;
        float P3 = CurrentX - CShapeX.get(i);
        float Q3 = CurrentY - CShapeY.get(i);
        
        float a =P1*P2 +Q1*Q2;
        float b =(-P2)*(P3) + (-Q2)*(Q3);
        float lennn = sqrt(P2*P2+Q2*Q2);
        P2 = P2/lennn;
        Q2 = Q2/lennn;
        float dot = P1*P2+ Q1*Q2;
        float dita = P1*P1+Q1*Q1 - dot*dot;
        
        if (dita < CShapeRad.get(i)*CShapeRad.get(i) && a*b>0) {
          SeeNextPoint=false;
        }
      }
      
      if (SeeNextPoint ==true) {
        NodeNumber--;
      }
    }
  }
  
  void CalculatePosition() {
    if (NodeNumber>0 && NodeNumber<PathX.size()) {
      float m = PathX.get(NodeNumber-1)-CurrentX;
      float n = PathY.get(NodeNumber-1)-CurrentY;
      //float m1 =CurrentX-PathX.get(NodeNumber);
      //float n1 =CurrentY-PathY.get(NodeNumber);
      float lenn = sqrt(m*m+n*n);
      VelocityX = m/lenn*Velocity;
      VelocityY = n/lenn*Velocity;
      CurrentX = CurrentX+ VelocityX;
      CurrentY = CurrentY+ VelocityY;
      //print("XPosition"+ CurrentX + "yposition" + CurrentY+"\n");
      if (lenn<1) {
        NodeNumber = NodeNumber -1;
      }
      
    Velocity =2;
    VelocityX =m/lenn*Velocity;
    VelocityY =n/lenn*Velocity;
    }
    
  }
  
  //void CalculateAttachPosition() {
    
  //}
}