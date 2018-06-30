import java.util.Map;

Population pop;
PFont f;
Genome gen;
int index = 0;

void setup(){
  ArrayList<NodeGene> nodes1 = new ArrayList();
  ArrayList<ConnectionGene> connections1 = new ArrayList();
  ArrayList<NodeGene> nodes2 = new ArrayList();
  ArrayList<ConnectionGene> connections2 = new ArrayList();
  
  //nodes1.add(new NodeGene(1, 1));
  //nodes1.add(new NodeGene(1, 2));
  //nodes1.add(new NodeGene(1, 3));
  //nodes1.add(new NodeGene(3, 4));
  //nodes1.add(new NodeGene(2, 5));

  //connections1.add(new ConnectionGene(1, 4, 0.5f, true, 1));
  //connections1.add(new ConnectionGene(2, 4, -0.5f, false, 2));
  //connections1.add(new ConnectionGene(3, 4, 0.5f, true, 3));
  //connections1.add(new ConnectionGene(2, 5, -0.5f, true, 4));
  //connections1.add(new ConnectionGene(5, 4, 0.5f, true, 5));
  //connections1.add(new ConnectionGene(1, 5, 0.5f, true, 8));
  
  //Genome gen1 = new Genome(connections1, nodes1);

  //nodes2.add(new NodeGene(1, 1));
  //nodes2.add(new NodeGene(1, 2));
  //nodes2.add(new NodeGene(1, 3));
  //nodes2.add(new NodeGene(3, 4));
  //nodes2.add(new NodeGene(2, 5));
  //nodes2.add(new NodeGene(2, 6));
  
  //connections2.add(new ConnectionGene(1, 4, 0.5f, true, 1));
  //connections2.add(new ConnectionGene(2, 4, -0.5f, false, 2));
  //connections2.add(new ConnectionGene(3, 4, 0.5f, true, 3));
  //connections2.add(new ConnectionGene(2, 5, -0.5f, true, 4));
  //connections2.add(new ConnectionGene(5, 4, 0.5f, false, 5));
  //connections2.add(new ConnectionGene(5, 6, 0.5f, true, 6));
  //connections2.add(new ConnectionGene(6, 4, 0.5f, true, 7));
  //connections2.add(new ConnectionGene(3, 5, 0.5f, true, 9));
  //connections2.add(new ConnectionGene(1, 6, 0.5f, true, 10));
  
  //Genome gen2 = new Genome(connections2, nodes2);
  //gen2.fitness = 2f;
  
  nodes1.add(new NodeGene(1, 1));
  nodes1.add(new NodeGene(1, 2));
  nodes1.add(new NodeGene(1, 3));
  nodes1.add(new NodeGene(3, 4));
  
  connections1.add(new ConnectionGene(3, 4, 0.5f, true, InnovationGenerator.getInnovation()));
  
  pop = new Population(100, new Genome(connections1, nodes1), 3, 4);
  
  //gen = pop.crossover(gen1, gen2););
  
  size(1000, 600);
  f = createFont("Arial", 14, true);
}

void draw(){
  background(255);
  Genome gen = new Genome();
  for(Genome g : pop.gens){
    if(g.fitness > gen.fitness){
      gen = g;
    }
  }
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
      ellipse(5*width/10, hids * 40, 20, 20);
      textFont(f, 14); 
      fill(255);
      text(Integer.toString(node.id), 5*width/10-5, hids * 40+5);
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
        yIn = (Integer)hiddens.get(con.inNode)*40;
      }
      
      if(outputs.get(con.outNode)!=null){
        xOut = 4*width/5;
        yOut = (Integer)outputs.get(con.outNode)*100;
      } else if(hiddens.get(con.outNode)!=null){
        xOut = 5*width/10;
        yOut = (Integer)hiddens.get(con.outNode)*40;
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
  float soma = 0f;
  for(ConnectionGene con : gen.connections){
    soma += abs(con.weight);
  }
  println("Geração " + pop.generation + "  -  Melhor fitness: " + gen.fitness + "   Soma: " + soma);
  //for(Specie s : pop.species){
  //  println(s.members.size());
  //}
  delay(1000);
  pop.naturalSelection();
}
