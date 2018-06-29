import java.util.Map;

class Population{
  ArrayList<Genome> gens;
  ArrayList<Genome> newGens = new ArrayList();
  ArrayList<Specie> species = new ArrayList();
  Map<Genome, Specie> speciesMap = new HashMap();
  int size;
  int generation = 0;
  int lastInput;
  int lastOutput;
  
  Population(int size, Genome firstOne, int lastInput, int lastOutput){
    gens = new ArrayList();
    this.size = size;
    this.lastInput = lastInput;
    this.lastOutput = lastOutput;
    
    createFirstPopulation(firstOne);
  }
  
  Population(ArrayList<Genome> gens, int size, int lastInput, int lastOutput){
    this.gens = gens;
    this.size = size;
    this.lastInput = lastInput;
    this.lastOutput = lastOutput;
  }
  
  Population(){
  }
  
  void sortSpecies(){
    speciesMap = new HashMap();
    ArrayList<Specie> removedSpecies = new ArrayList();
    for(Specie s : species){
      boolean exists = s.reset();
      if(!exists)
        removedSpecies.add(s);
    }
    species.removeAll(removedSpecies);
    
    float c1 = 1;
    float c2 = 1;
    float c3 = 0.5;
    float dt = 3;
    
    for(Genome g : gens){
      boolean found = false;
      float n = 1;
      for(Specie s : species){
        if(s.mascot.nodes.size() >= 20 || g.nodes.size() >= 20){
          if(s.mascot.nodes.size() > g.nodes.size())
            n = s.mascot.nodes.size();
          else
            n = g.nodes.size();
        }
        float excessCount = g.calculateExcess(s.mascot);
        float disjointCount = g.calculateDisjoints(s.mascot);
        float weightDifference = g.calculateWeightDifference(s.mascot);
        float value = (c1*excessCount)/n + (c2*disjointCount)/n + c3*weightDifference;
        if(value <= dt){
          found = true;
          s.members.add(g);
          speciesMap.put(g, s);
        }
      }
      if(!found){
        ArrayList<Genome> list = new ArrayList();
        list.add(g);
        Specie newSpecie = new Specie(g, list);
        species.add(newSpecie);
        speciesMap.put(g, newSpecie);
      }
    }
  }
  
  void naturalSelection(){
    //create first population on pop constructor
    //sort species after create the population, reset species everytime you will create a population, when creating new species set the genome as mascot
    //reset and sort species after the mutation in this method
    
    for(Genome gen : gens){
      gen.fitness = Fitness.calculate(gen) / (float)((Specie)speciesMap.get(gen)).members.size();
      speciesMap.get(gen).addFitness(gen.fitness);
    }
    
    newGens = new ArrayList();
    
    //best on new gen
    for(Specie s : species){
      Genome best = new Genome();
      for(Genome gen : s.members){
        if(gen.fitness > best.fitness){
          best = gen.cpy();
        }
      }
      newGens.add(best);
    }
    
    while(newGens.size() < size){
      //select specie
      Genome child;
      Specie s = selectSpecie();
      
      //select parents
      Genome parent1 = selectParent(s);
      Genome parent2 = selectParent(s);
      
      printArray(parent1.connections);
      printArray(parent2.connections);
      
      //create new
      child = crossover(parent1, parent2);
    
      //mutate ps: on mutation check if innovation number has to be incremented
      mutate(child);
      
      //add to next gen
      newGens.add(child);
    }
    
    gens = newGens;
    newGens = new ArrayList();
    
    //sort new generation species
    sortSpecies();
    generation++;
  }
  
  Specie selectSpecie(){
    float fitnessSum = 0f;
    for(Specie s : species){
      fitnessSum += s.totalFitness;
    }
    
    if(fitnessSum > 0){
      float select = random(0, fitnessSum);
      float sum = 0;
      for(Specie s : species){
        sum += s.totalFitness;
        if(select <= sum){
          return s;
        }
      }
    }
    
    throw new Error("Nenhuma espécie encontrada");
  }
  
  Genome selectParent(Specie s){
    float fitnessSum = 0f;
    for(Genome gen : s.members){
      fitnessSum += gen.fitness;
    }
    
    if(fitnessSum > 0){
      float select = random(0, fitnessSum);
      float sum = 0;
      for(Genome gen : s.members){
        sum += gen.fitness;
        if(select <= sum){
          if(gen.connections.size() == 0){
            //criar debug method na class Genome
            //descobrir por que nao ha conexoes
          }
          return gen;
        }
      }
    }
    
    throw new Error("Nenhum indivíduo encontrado na espécie");
  }
  
  Genome crossover(Genome p1, Genome p2){
    ArrayList<ConnectionGene> newConnections = new ArrayList();
    ArrayList<NodeGene> newNodes = new ArrayList();
    
    //passar matching genes
    for(ConnectionGene con1 : p1.connections){
      for(ConnectionGene con2 : p2.connections){
        if(con1.innovation == con2.innovation){
          if(random(0, 1) <= 0.5){
            newConnections.add(con1.cpy());
          } else {
            newConnections.add(con2.cpy());
          }
        }
      }
    }
    
    //passar excesso, disjoint e nodes do maior fitness
    if(p1.fitness > p2.fitness){
      for(ConnectionGene con1 : p1.connections){
        boolean found = false;
        for(ConnectionGene con2 : newConnections){
          if(con1.innovation == con2.innovation){
            found = true;
          }
        }
        if(!found){
          newConnections.add(con1.cpy());
        }
      }
      
      for(NodeGene ng : p1.nodes){
        newNodes.add(ng.cpy());
      }
      
      return new Genome(newConnections, newNodes);
    } else if(p2.fitness > p1.fitness){
      for(ConnectionGene con1 : p2.connections){
        boolean found = false;
        for(ConnectionGene con2 : newConnections){
          if(con1.innovation == con2.innovation){
            found = true;
          }
        }
        if(!found){
          newConnections.add(con1.cpy());
        }
      }
      
      for(NodeGene ng : p2.nodes){
        newNodes.add(ng.cpy());
      }
      
      return new Genome(newConnections, newNodes);
    } else {
      //caso igual passar excesso, disjoint dos dois e node do maior
      for(ConnectionGene con1 : p1.connections){
        boolean found = false;
        for(ConnectionGene con2 : newConnections){
          if(con1.innovation == con2.innovation){
            found = true;
          }
        }
        if(!found){
          newConnections.add(con1.cpy());
        }
      }
      
      for(ConnectionGene con1 : p2.connections){
        boolean found = false;
        for(ConnectionGene con2 : newConnections){
          if(con1.innovation == con2.innovation){
            found = true;
          }
        }
        if(!found){
          newConnections.add(con1.cpy());
        }
      }
      
      if(p1.nodes.size() > p2.nodes.size()){
        for(NodeGene ng : p1.nodes){
          newNodes.add(ng.cpy());
        }
      } else {
        for(NodeGene ng : p2.nodes){
          newNodes.add(ng.cpy());
        }
      }    
    }
    
    return new Genome(newConnections, newNodes);
  }
  
  void mutate(Genome child){
    float mutateWeightRate = 0.5;
    float addConnectionRate = 0.1;
    float addNodeRate = 0.1;
    float r = random(0, 1);
    float r2 = random(0, 1);
    if(generation==0){
      mutateWeightRate = 0;
      addConnectionRate = 0.5;
      addNodeRate = 0.25;
    }
    
    if(r<=mutateWeightRate){
      println("antes do erro");
      printArray(child.connections);
      ConnectionGene connection = child.connections.get(int(random((float)child.connections.size()-1)));
      println("dps do erro");
      
      float r3 = random(0, 1);
      if(r3 <= 0.8){
        connection.weight = connection.weight*random(-2, 2);
      } else {
        connection.weight = random(-2, 2);
      }
    }
    
    if(r<=addConnectionRate){
      boolean mutated = false;
      int maximumTries = 10;
      do{
        maximumTries--;
        int node = ceil(random((float)child.nodes.size()));
        if(node <= lastInput || node > lastOutput){
          int node2 = ceil(random(lastInput, (float)child.nodes.size()));
          boolean alreadyExists = false;
          boolean possible = true;
          for(ConnectionGene con : child.connections){
            if(con.inNode == node && con.outNode == node2){
              alreadyExists = true;
            }
            if(con.outNode == node && con.inNode == node2){
              possible = false;
            }
          }
          
          if(!alreadyExists && possible){
            //create new connection
            int inNum = 0;
            boolean found = false;
            for(ConnectionGene con : Mutations.getInnovations()){
              if(con.inNode == node && con.outNode == node2){
                inNum = con.innovation;
                found = true;
                break;
              }
            }
            if(!found){
              ConnectionGene innCon = new ConnectionGene(node, node2, InnovationGenerator.getInnovation());
              Mutations.addInnovations(innCon);
              inNum = innCon.innovation;
            }
            
            child.connections.add(new ConnectionGene(node, node2, random(-2, 2), true, inNum));
            mutated = true;
          }
        }
      } while(!mutated && maximumTries > 0);
    }
    
    if(r2<=addNodeRate){
      ConnectionGene connection = child.connections.get(int(random((float)child.connections.size()-1)));
      
      NodeGene newNode = new NodeGene(2, child.nodes.size()+1);
      child.nodes.add(newNode);
      
      int in1 = 0;
      int in2 = 0;
      boolean found1 = false;
      boolean found2 = false;
      for(ConnectionGene con : Mutations.getInnovations()){
        if(con.inNode == connection.inNode && con.outNode == newNode.id){
          in1 = con.innovation;
          found1 = true;
        }
        if(con.inNode == newNode.id && con.outNode == connection.outNode){
          in2 = con.innovation;
          found2 = true;
        }
      }
      if(!found1){
        ConnectionGene innCon = new ConnectionGene(connection.inNode, newNode.id, InnovationGenerator.getInnovation());
        Mutations.addInnovations(innCon);
        in1 = innCon.innovation;
      }
      if(!found2){
        ConnectionGene innCon = new ConnectionGene(newNode.id, connection.outNode, InnovationGenerator.getInnovation());
        Mutations.addInnovations(innCon);
        in2 = innCon.innovation;
      }      
      
      ConnectionGene newCon1 = new ConnectionGene(connection.inNode, newNode.id, 1f, true, in1);
      ConnectionGene newCon2 = new ConnectionGene(newNode.id, connection.outNode, connection.weight, true, in2);
      
      child.connections.add(newCon1);
      child.connections.add(newCon2);
      connection.expressed = false;
    }
  }
  
  void createFirstPopulation(Genome gen){
    while(gens.size() < size){
      Genome child = gen.cpy();
      
      mutate(child);
      
      gens.add(child);
    }
    
    sortSpecies();
    generation++;
  }
}
