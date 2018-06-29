class Specie{
  Genome mascot;
  ArrayList<Genome> members = new ArrayList();
  float totalFitness = 0;
  
  Specie(Genome mascot, ArrayList<Genome> members){
    this.mascot = mascot;
    this.members = members;
  }
  
  void addFitness(float fitness){
    totalFitness += fitness;
  }
  
  boolean reset(){
    if(members.size() > 0){
      mascot = members.get(floor(random(members.size()))).cpy();
      members = new ArrayList();
      totalFitness = 0;
      return true;
    }
    return false;
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
