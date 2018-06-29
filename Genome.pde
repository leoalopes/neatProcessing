import java.util.ArrayList;
import java.util.Map;

class Genome{
  ArrayList<ConnectionGene> connections = new ArrayList();
  ArrayList<NodeGene> nodes = new ArrayList();
  float fitness = 0;
  
  Genome(){}
  
  Genome(ArrayList<ConnectionGene> connections, ArrayList<NodeGene> nodes){
    this.connections = connections;
    this.nodes = nodes;
  }
  
  Genome cpy(){
    ArrayList<ConnectionGene> connectionsClone = new ArrayList();
    for(ConnectionGene con : connections){
      connectionsClone.add(con.cpy());
    }
    ArrayList<NodeGene> nodesClone = new ArrayList();
    for(NodeGene node : nodes){
      nodesClone.add(node.cpy());
    }
    Genome newGen = new Genome(connectionsClone, nodesClone);
    //Genome newGen = new Genome(connections, nodes); //testar multiplas mutações no mesmo genoma
    newGen.fitness = fitness;
    return newGen;
  }
  
  float calculateExcess(Genome gen){
    int max1 = 0;
    int max2 = 0;
    
    for(ConnectionGene cg : connections){
      if(cg.innovation > max1){
        max1 = cg.innovation;
      }
    }
    for(ConnectionGene cg : gen.connections){
      if(cg.innovation > max2){
        max2 = cg.innovation;
      }
    }
    
    if(max1 > max2){
      return max1 - max2;
    } else {
      return max2 - max1;
    }
  }
  
  float calculateDisjoints(Genome gen){
    int max1 = 0;
    int max2 = 0;
    
    for(ConnectionGene cg : connections){
      if(cg.innovation > max1){
        max1 = cg.innovation;
      }
    }
    for(ConnectionGene cg : gen.connections){
      if(cg.innovation > max2){
        max2 = cg.innovation;
      }
    }
    
    Map<Integer, ConnectionGene> map1 = new HashMap();
    Map<Integer, ConnectionGene> map2 = new HashMap();
    
    for(ConnectionGene cg : connections){
      map1.put(cg.innovation, cg);
    }
    for(ConnectionGene cg : gen.connections){
      map2.put(cg.innovation, cg);
    }
    
    float disjoints = 0;    
    float max=0;
    if(max1 > max2){
      max = max1;
    } else {
      max = max2;
    }
    for(int i=1; i<max; i++){
      if(map1.get(i) != null && map2.get(i) == null && max2 > i){
        disjoints++;
      } else if(map1.get(i) == null && map2.get(i) != null && max1 > i){
        disjoints++;
      }
    }
    
    return disjoints;
  }
  
  float calculateWeightDifference(Genome gen){
    float weightSum = 0;
    float weightCount = 0;
    for(ConnectionGene cg1 : connections){
      for(ConnectionGene cg2 : gen.connections){
        if(cg1.innovation == cg2.innovation){
          weightSum += abs(cg1.weight - cg2.weight);
          weightCount++;
          break;
        }
      }
    }
    
    return weightSum / weightCount;
  }
}
