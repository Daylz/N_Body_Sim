import java.util.*;

class Mover
{
  Body body;
  float radius;
  boolean deleted = false;
  LinkedList<TrailPixel> trail = new LinkedList<TrailPixel>();
  int maxTrailLength = 4000;
  
  // trail color
  color from = color(0, 0, 255);
  color to = color(255, 255, 0);
  
  Mover(float radius, float x, float y, Vec2 velX, Vec2 velY)
  {
    this.radius = radius;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    
    bd.position = box2d.coordPixelsToWorld(x, y);
    body = box2d.world.createBody(bd);

    body.setUserData(this);
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(this.radius);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    
    fd.density = 1;
    fd.friction = 0.0;
    fd.restitution = 0.5;

    body.createFixture(fd);

    body.setLinearVelocity(new Vec2(random(velX.x, velX.y),random(velY.x, velY.y)));
    body.setAngularVelocity(random(-1, 1));
  }
  
  void updateObject(float radius)
  {
    this.radius = radius;
    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(this.radius);
    
    Fixture fixture = body.getFixtureList();
    fixture.m_shape = cs;
    
    body.resetMassData();
  }
  
  void applyForce(Vec2 v)
  {
    body.applyForce(v, body.getWorldCenter());
  }
  
  Vec2 attract(Mover m)
  {
    Vec2 pos = body.getWorldCenter();    
    Vec2 moverPos = m.body.getWorldCenter();
    Vec2 force = pos.sub(moverPos);
    float distance = force.lengthSquared();
    distance = constrain(distance,1,25);
    force.normalize();
    float strength = (body.m_mass * 1 * m.body.m_mass) / (distance);
    force.mulLocal(strength);
    return force;
  }
  
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    strokeWeight(this.radius*2);
    stroke(lerpColor(from, to, body.getLinearVelocity().length() / 20));
    point(pos.x, pos.y);
    
    /*trail.addFirst(new TrailPixel(pos, lerpColor(from, to, body.getLinearVelocity().length() / 20)));
    
    // If trail is too 'long' remove the oldest points
    while (trail.size () > maxTrailLength)
      trail.removeLast();
    
    drawTrail();*/
  }
  
  void drawTrail()
  { 
    strokeWeight(5);
    
    if (trail.size() >= 2)
    {      
      TrailPixel currTrailPixel;
      
      for (int i = 0; i < trail.size(); i++)
      {                
        currTrailPixel = trail.get(i);
        stroke(currTrailPixel.getColor());
        point(currTrailPixel.getPos().x, currTrailPixel.getPos().y);        
      }
    }
  }
  
  void delete()
  {
    deleted = true;
  }
  
  void killBody() 
  {
    box2d.destroyBody(body);
  }
}