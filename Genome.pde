import java.util.ArrayList;

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
}
