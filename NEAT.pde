import java.util.Map;

Population pop;
PFont f;
int index = 0;

void setup(){
  ArrayList<NodeGene> nodes = new ArrayList();
  ArrayList<ConnectionGene> connections = new ArrayList();
  
  //nodes.add(new NodeGene(1, 1));
  //nodes.add(new NodeGene(1, 2));
  //nodes.add(new NodeGene(1, 3));
  //nodes.add(new NodeGene(3, 4));
  //nodes.add(new NodeGene(3, 5));
  //nodes.add(new NodeGene(2, 6));

  //connections.add(new ConnectionGene(1, 4, 0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(2, 4, -0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(3, 4, 0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(1, 5, -0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(2, 5, 0.5f, false, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(3, 5, 0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(2, 6, 0.5f, true, InnovationGenerator.getInnovation()));
  //connections.add(new ConnectionGene(6, 5, 0.5f, true, InnovationGenerator.getInnovation()));

  nodes.add(new NodeGene(1, 1));
  nodes.add(new NodeGene(1, 2));
  nodes.add(new NodeGene(1, 3));
  nodes.add(new NodeGene(1, 4));
  nodes.add(new NodeGene(3, 5));
  
  connections.add(new ConnectionGene(4, 5, 0.5f, true, InnovationGenerator.getInnovation()));
  
  Genome gen = new Genome(connections, nodes);
  
  pop = new Population(100, gen, 4, 5);
  
  size(1000, 600);
  f = createFont("Arial", 14, true);
}

void draw(){
  Genome gen = pop.gens.get(index);
  background(255);
  Map<Integer, Integer> inputs = new HashMap();
  Map<Integer, Integer> hiddens = new HashMap();
  Map<Integer, Integer> outputs = new HashMap();
  int ins = 1;
  int outs = 1;
  int hids = 1;
  stroke(0);
  for(NodeGene node : gen.nodes){
    if(node.type == 1){
      fill(0, 0, 255);
      ellipse(width/5, ins * 100, 20, 20);
      textFont(f, 14); 
      fill(255);
      text(Integer.toString(node.id), width/5-5, ins * 100+5);
      inputs.put(node.id, ins);
      ins++;
    }
    
    if(node.type == 2){
      fill(0);
      ellipse(5*width/10, hids * 100, 20, 20);
      textFont(f, 14); 
      fill(255);
      text(Integer.toString(node.id), 5*width/10-5, hids * 100+5);
      hiddens.put(node.id, hids);
      hids++;
    }
    
    if(node.type == 3){
      fill(255, 0, 0);
      ellipse(4*width/5, outs * 100, 20, 20);
      textFont(f, 14); 
      fill(255);
      text(Integer.toString(node.id), 4*width/5-5, outs * 100+5);
      outputs.put(node.id, outs);
      outs++;
    }
  }
  
  for(ConnectionGene con : gen.connections){
    if(con.expressed){
      if(con.weight > 0)
        stroke(0, 0, 255);
      else
        stroke(255, 0, 0);
      int xIn = 0;
      int yIn = 0;
      int xOut = 0;
      int yOut = 0;
      
      if(inputs.get(con.inNode)!=null){
        xIn = width/5;
        yIn = (Integer)inputs.get(con.inNode)*100;
      } else if(hiddens.get(con.inNode)!=null){
        xIn = 5*width/10;
        yIn = (Integer)hiddens.get(con.inNode)*100;
      }
      
      if(outputs.get(con.outNode)!=null){
        xOut = 4*width/5;
        yOut = (Integer)outputs.get(con.outNode)*100;
      } else if(hiddens.get(con.outNode)!=null){
        xOut = 5*width/10;
        yOut = (Integer)hiddens.get(con.outNode)*100;
      }
      
      line(xIn+10, yIn, xOut-10, yOut);
      textFont(f, 14); 
      fill(0);
      text(Float.toString(con.weight), (xIn+xOut)/2-10, (yIn+yOut)/2);
      stroke(0);
      fill(0);
      rect(xOut-20, yOut-5, 10, 10);
    }
  }
  delay(1000);
  if(index<99)
    index++;
  else{
    for(ConnectionGene con : Mutations.getInnovations()){
      println(con.innovation + " - " + con.inNode + " " + con.outNode);
    }
    stop();
  }
}
