class NodeGene{  
  int type;
  int id;
  float value = 0;
  
  public NodeGene(int type, int id) {
    this.type = type;
    this.id = id;
  }
  
  NodeGene cpy(){
    return new NodeGene(type, id);
  }
}

class ConnectionGene{
  int inNode;
  int outNode;
  float weight;
  boolean expressed;
  int innovation;
  
  ConnectionGene(int inNode, int outNode, float weight, boolean expressed, int innovation){
    this.inNode = inNode;
    this.outNode = outNode;
    this.weight = weight;
    this.expressed = expressed;
    this.innovation = innovation;
  }
  
  ConnectionGene(int inNode, int outNode, int innovation){
    this.inNode = inNode;
    this.outNode = outNode;
    this.innovation = innovation;
  }
  
  ConnectionGene cpy(){
    return new ConnectionGene(inNode, outNode, weight, expressed, innovation);
  }
}

static class InnovationGenerator{
  static int innNumber = 0;
  
  static int getInnovation(){
    innNumber++;
    return innNumber;
  }
}
