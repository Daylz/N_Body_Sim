class Attractor 
{  
  Body body;
  float r;

  Attractor(float r_, float x, float y)
  {
    r = r_;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    body.createFixture(cs,1);

    body.setUserData(this);
  }

  Vec2 attract(Mover m)
  {
    float G = 75; // Strength of force

    Vec2 pos = body.getWorldCenter();    
    Vec2 moverPos = m.body.getWorldCenter();

    Vec2 force = pos.sub(moverPos);
    float distance = force.lengthSquared();
    distance = constrain(distance,1,10);
    force.normalize();

    float strength = (G * 1 * m.body.m_mass) / (distance);
    force.mulLocal(strength);
    return force;
  }

  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(255);
    stroke(255);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}