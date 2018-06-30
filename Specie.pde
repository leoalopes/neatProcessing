class Specie{
  Genome mascot;
  ArrayList<Genome> members = new ArrayList();
  float totalFitness = 0;
  
  Specie(Genome mascot){
    this.mascot = mascot;
    this.members = new ArrayList();
    members.add(mascot);
  }
  
  void addFitness(float fitness){
    totalFitness += fitness;
  }
  
  boolean reset(){
    mascot = members.get(int(random(members.size()-1)));
    members = new ArrayList();
    totalFitness = 0;
    return true;
  }
}

static class Fitness{
  
  static float calculate(Genome gen){
    float weightSum=0;

    for(ConnectionGene con : gen.connections){
      weightSum += abs(con.weight);
    }
      
    float difference = abs(weightSum - 100);
    
    return 1000f/difference;
  }
  
}

static class Mutations{
  static ArrayList<ConnectionGene> innovations = new ArrayList();
  
  static ArrayList<ConnectionGene> getInnovations(){
    return innovations;
  }
  
  static void addInnovations(ConnectionGene newInnovation){
    innovations.add(newInnovation);
  } 
}
