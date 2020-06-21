
class Move 
{
     float angle = 0;
     int x = 0;
     int y = 0;
     int z = 0;
     int direction;
     boolean animating = false;
     boolean finished = false;
     
     //Move Constructor
     //Coordinates and direction describe what move depends on
     Move(int x, int y, int z, int direction) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.direction = direction;
     }
     
     //Copy function returns current new object as the current object
     Move copy()
     {
       return new Move(x, y, z, direction);
     }
     
     //reverse function used to reverse the sequence in the opposite direction (End -> Beginning)
     void reverse()
     {
       direction *= -1;
     }
     
     //Start function begins animation
     void start() 
     {
      animating = true;
      finished = false;
      this.angle = 0;
     }
     
     
     //return true if animation has reached final step in sequence
     boolean finished() 
     {
       return finished;
     }
     
     //updates the orientation angle of each cube 
     //with respect to the axis it is on
     void update() 
     {
       if (animating) 
       {
         angle += direction * speed;
         if (abs(angle) > HALF_PI) 
         {
           angle = 0;
           animating = false;
           finished = true;
           if (abs(z) > 0) 
           {
             turnZ(z, direction);
           } 
           
           else if (abs(x) > 0) 
           {
             turnX(x, direction); 
           } 
           
           else if (abs(y) > 0) 
           {
             turnY(y, direction); 
           }
         }
       }
     }
}
