class TrailPixel
{
  protected Vec2 pos = new Vec2();
  protected color col = color (0);
  
  TrailPixel(Vec2 pos, color col)
  {
    this.pos = pos;
    this.col = col;
  }
  
  Vec2 getPos()
  {
    return pos;
  }
  
  color getColor()
  {
    return col;
  }
}