class Target{//clase target
  float posY = 0;//posición en Y
  float posX = 800;//posición en X
  PImage target;//imagen del target
  boolean movingUp;//boolean para saber si se está moviendo hacia arriba
  boolean drawable = true;//boolean para saber si ya se golpeó al target
  Target(){
   target = loadImage("target.png");//constructor carga la imagen del target
  } 
  
  public void moveTarget(){//función para mover el target
  
  /* Este pedazo de código hace que el target se mueva hacia arriba hasta llegar al límite
     de la pantalla, al llegar cambia su dirección y se matiene "rebotando" entre el límite
     superior e inferior de la pantalla*/
    if (posY>=0 && posY<=600) {
      if (posY==600)
        movingUp = true;
      if (posY==0)
        movingUp = false;
      if (movingUp)
        posY-=5;
      else
        posY+=5;
    }
    if(drawable){//si no se ha golpeado al target
    pushMatrix();//aplicar las transformaciones lineales dentro de push y pop
    translate(posX,posY);//trasladar el target posX en x y posY en y
    //pos X es constante pero posY irá cambiado para rebotar entre los límites
    image(target,0,0,50,50);
    popMatrix();//terminar de aplicar las transformaciones lineales
    }
  }
  
  public void setDrawable(boolean draw)//función pública para cambiar drawable. esto sirve para poder reinicar
  //el target después de haberlo golpeado
  {
   drawable = draw; 
  }
  public float getX()//función para obtener la posición en X
  {
   return posX; 
  }
  
  public float getY()//función para obtener la posición en Y
  {
   return posY; 
  }
  
  public boolean getDrawable()//función para obtener la cualidad de drawable
  {
   return drawable; 
  }
}


