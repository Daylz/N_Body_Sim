import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

ArrayList<Mover> movers = new ArrayList<Mover>();

Attractor a;

final int OFFSET = 150;
final int OBJECTS = 250;

void setup()
{
  size(1080, 1080);
  smooth();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,0);
  //box2d.listenForCollisions();

  for (int i = 0; i < OBJECTS; i++)
  {
    movers.add(new Mover(random(1,2), random(width / 2 + OFFSET, width), random(height / 2 + OFFSET, height), new Vec2(-2, 5), new Vec2(10, 15)));
  }
  
  for (int i = 0; i < OBJECTS; i++)
  {
    movers.add(new Mover(random(1,2),random(0, width / 2 - OFFSET),random(0, height / 2), new Vec2(-5, 2), new Vec2(-15, -10)));
  }
  
  for (int i = 0; i < OBJECTS; i++)
  {
    movers.add(new Mover(random(1,2),random(0, width / 2),random(height / 2 + OFFSET, height), new Vec2(10, 15), new Vec2(-2, 5)));
  }
  
  for (int i = 0; i < OBJECTS; i++)
  {
    movers.add(new Mover(random(1,2),random(width / 2, width),random(0, height / 2 - OFFSET), new Vec2(-15, -10), new Vec2(-5, 2)));
  }
  
  a = new Attractor(10,width/2,height/2);
}

void draw() 
{
  background(0);

  box2d.step();

  a.display();

  for (int i = 0; i < movers.size(); i++)
  {
    Vec2 mforce = new Vec2();
    Mover moverA = movers.get(i);
    
    // "planet in the middle"'s attraction
    mforce.addLocal(a.attract(movers.get(i)));
    
    for (int j = 0; j < movers.size(); j++)
    {
      Mover moverB = movers.get(j);
      
      if (moverA != moverB)
      {
        mforce.addLocal(moverB.attract(moverA));
      }      
    }
    
    moverA.applyForce(mforce);     
    moverA.display(); 
  }
}

//requires "box2d.listenForCollisions();" to be uncommented
void beginContact(Contact cp)
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Mover.class && o2.getClass() == Mover.class)
  {
    Mover p1 = (Mover) o1;
    Mover p2 = (Mover) o2;
    
    float area1 = p1.radius * p1.radius * PI;
    float area2 = p2.radius * p2.radius * PI;
    double area3 = area1 + area2;
    
    float newRadius = (float) Math.sqrt(area3 / PI);
    
    p1.updateObject(newRadius);
    p2.delete();
  }
}

void endContact(Contact cp)
{
}