//nota en player
class Player//Clase Player para inicalizar a sub zero como un objeto, haciendo el código modular
{
  /*
  Para todo el código, cuando una variable tenga (fluidez) al lado, significa que es una variable
  auxiliar para hacer que la transformación sea fluida y no solamente se dibuje la parte del cuerpo
  deseada en su posición final sin tener una transición
  */
  /* Declaración de todas las partes del cuerpo de sub-zero */
   PImage leftArm;//brazo izquierdo
   PImage rightArm;//brazo derecho
   PImage torso;//torso
   PImage head;//cabeza
   PImage leftHam;//muslo izquierdo
   PImage rightHam;//muslo derecho
   PImage leftShin;//espinilla y pie izquierdo
   PImage rightShin;//espinilla y pie derecho
   PImage iceBall;//bola de hielo
   
   /*Variables para la animación de idle*/
   float vertPos=0;
   boolean movingUp = false;


   int xPosition = 0;//variable para saber la posición en X cuando se mueve

   /*Variables para la animación de las piernas cuando caminas*/
   float leftHamPosX=0;
   boolean movingLeftHamRight=false;
   float rightHamRot = 0;
   boolean rotatingRightHam = false;

   /*Variables para la animación del golpe*/
   float punch = 0;
   boolean punching = false;
   boolean translatingPunch = false;
   float translatePunch = 0;
   boolean scalingRightArm = false;
   float scaleRightArm = 1;
   boolean doneScaling = false;
   float scaleCounter=0;
   boolean timingScale = false;

   /*Variables para la animación de patada*/
   float bodyRotation = -50;
   boolean rotatingBody = false;
   float kickCounter=0;

   /*Variables para la animación del poder especial*/
   float fireRot = 0;
   float fireTranslate = 0;
   boolean fireRotating = false;
   boolean fireTranslating = false;
   float ballRot = 0;
   float iceBallX = 0;
   float ballSpeed = 10;
   float iceBallY = 30;
   float startingFrameX=0;
   float startingFrameY=0;

   /*Variables para la buena reproducción de sonidos incidentales*/
   boolean playedFreeze=false;
   boolean playedPunch = false;
   boolean playedKick = false;
  
  Player()
  {
    /* Cargar todas las imagenes asociadas a las variables para cada parte del cuerpo */
    torso = loadImage("torso.png");
    leftArm = loadImage("leftArm.png");
    rightArm = loadImage("rightArm.png");
    leftHam = loadImage("leftHam.png");
    leftShin = loadImage("leftShin.png");
    rightHam = loadImage("rightHam.png");
    rightShin = loadImage("rightShin.png");
    head = loadImage("head.png");
    iceBall = loadImage("ice.png");
  }
  
  /*Función para dibujar la bola de hielo*/
  public void drawIceBall()
  {
   pushMatrix();//iniciar transformaciones
     imageMode(CENTER);//cambiar el pivote de la imagen al centro
     scale(1.3);//cambiar su escala a 1.3
     image(iceBall,0,0);//dibujar la bola en 0,0
     imageMode(CORNER);//cambiar el pivote de las demás imagenes a la esquina
   popMatrix();//terminar transformaciones
  }
  
  /*Dibujar brazo izquierdo*/
  public void drawLeftArm()
  {
    pushMatrix();//iniciar transformaciones
      rotate(radians(45));//rotar 45 grados con respecto al centro
      image(leftArm, 5, 6);//dibujar brzo
    popMatrix();//terminar transformaciones
  }

  /*Dibujar brazo derecho*/
  public void drawRightArm()
  {
    pushMatrix();//iniciar transformaciones
      rotate(radians(335));//rotar brazo 335 grados con respecto al centro
      image(rightArm, 35, 48);
    popMatrix();//terminar transformaciones
  }

  /*Dibujar muslo izquierdo*/
  public void drawLeftHam()
  {
    image(leftHam, -23, 73);
  }

  /*Dibujar espinilla y pie izquierdo*/
  public void drawLeftShin()
  {
    image(leftShin, -40, 120);
  }

  /*Dibujar muslo derecho*/
  public void drawRightHam()
  {
    image(rightHam, 40, 75);
  }

  /*Dibujar espinilla y pie derecho*/
  public void drawRightShin()
  {
    image(rightShin, 61, 106);
  }

  /*Dibujar torso*/
  public void drawTorso()
  {
    image(torso, 0, 0);
  }

  /*Dibujar cabeza*/
  public void drawHead()
  {
    image(head, 20, -20);
  }

  /*Función para la animación de idle
  toma como parámetros:
  límite de movimiento
  x donde dibujar al personaje en idle
  y donde dibujar al personaje en idle
  */
  public void idle(int limit, int x)
  {
    /*
    Funcionalidad general de la animación:
    mover todo menos las piernas de arriba hacia abajo constantemente
    */

    /* Código que mantiene al torso moviéndose de arriba a abajo sin parar */
    if (vertPos>=-limit && vertPos<=0) {
      if (vertPos==-limit)
        movingUp = true;
      if (vertPos==0)
        movingUp = false;
      if (movingUp)
        vertPos+=.5;
      else
        vertPos-=.5;//(fluidez)
    }
      pushMatrix();//iniciar transformaciones
        translate(x+xPosition, 0);//trasladar todo el personaje x+xPosition en x y 0 en y
        //x es la posicion inicial y xPosition es cuánto se ha movido el personaje al caminar
        scale(1.2);//escalar todo 1.2 veces en X y Y
        /* Dibujar las partes estáticas*/
        drawLeftHam();
        drawLeftShin();
        drawRightHam();
        drawRightShin();
        /*Dibujar el torso que se va a mover
        Todo lo que se encuentra dentro de pushMatrix() se va a mover hacia arriba y hacia
        abajo constantemente
        */
        pushMatrix();//iniciar transformaciones
          translate(0, -vertPos);//trasladar 0 en x y -vertPos en y.
          //se maneja el negativo por comodidad en cuanto al manejo de coordenadas en processing
          drawTorso();
          drawHead();  
          drawLeftArm();
          drawRightArm();
        popMatrix();//terminar transformaciones 
      popMatrix();//terminar transformaciones
  }

  /*Animación de golpe
  toma como parámetros:
  x donde dibujar al personaje golpeando
  y donde dibujar al personaje golpeando
  */
  public void punch(int x)
  {
    /*
    Funcionalidad general de la animación:
    rotar y trasladar el brazo derecho hasta que esté "estirado" al nivel del hombro
    cerrar el puño
    escalar el brazo de 1 a .5 a 1 para simular el movimiento del golpe
    */

    /*Código que maneja la rotación "suave" del brazo*/
    if (punch>=-50 && punch<=0) {
      if (punch==-50)
        punching = false;
      if (punch==0)
        punching = true;
      if (punching)
        punch-=2.5;//(fluidez)
    }
    
    /* Código que maneja la traslación "suave" del brazo */
     if (translatePunch>=0 && translatePunch<=50) {
      if (translatePunch==0)
        translatingPunch = true;
      if (translatePunch==50)
        translatingPunch = false;
      if (translatingPunch)
        translatePunch+=2.5;//(fluidez)
    }
    /*Las dos funciones anteriores solamente ayudan a que la animación se vea más fluida
    En vez de que el brazo pase directamente a su posición final, hace una transición fluida
    */

    pushMatrix();//iniciar transformaciones
      translate(x+xPosition, 0);//trasladar todo x+xPosition, 0
      scale(1.2);//escalar a 1.2 veces su tamaño
        pushMatrix();//iniciar transformaciones
          translate(-5,translatePunch);//trasladar brazo -5, translatePunch (fluidez)
          rotate(radians(punch));//rotar el brazo punch (fluidez) grados
          if(!punching && !translatingPunch)//si ya se acabó de rotar y trasladar el brazo
          //se empieza la segunda fase de la animación
          {
            /*timing scale es una variable booleana para determinar si ya se acabó de escalar
            el brazo. si no se ha acabado de escalar, la variable scaleRightArm sirve para
            dar fluidez a la escala del brazo*/
            if(!timingScale){
            if (scaleRightArm==1)
              scalingRightArm = true;
            if (scaleRightArm<=.5)
              scalingRightArm = false;
            if (scalingRightArm)
              scaleRightArm-=.05;//(fluidez)
            }
            //el brazo se escala fluidamente de 1 a .5 veces su tamaño
            
             if(!scalingRightArm)//si se terminó de escalar el brazo 
             {
               timingScale = true;//cambiar variable booleana para indicar que se terminó de escalar
               //el brazo
                rightArm = loadImage("rightArmPunch.png");//cambiar sprite de brazo al puño cerrado
                if(scaleRightArm<1){//el brazo se escala de .5 a 1 veces su tamaño
                  scaleRightArm+=.05;//(fluidez)
                }
                 else{//si se terminó de restaurar la escala del brazo
                   if(!playedPunch)//si no se ha reproducido el sonido de golpe
                      {
                       punchSound.cue(0);//reproducir en el tiempo 0
                       punchSound.play();//reproducir golpe
                       playedPunch = true;//ya se reprodujo el golpe
                      }
                   scaleCounter+=.1;//variable para mantener el golpe activo unos cuantos segundos
                   if(scaleCounter>=2){
                  doneScaling = true;//establecer que ya se terminó de escalar al brazo
                  }
                }
             }
             scale(scaleRightArm,1);//aplicar la escala fluida al brazo en x
          }
          drawRightArm();//dibujar brazo derecho con las modificaciones a lo largo de la animación
        popMatrix();//terminar transformaciones
        /*Dibujar las partes del cuerpo estáticas durante el golpe*/
      drawLeftHam();
      drawLeftShin();
      drawRightHam();
      drawRightShin();
      drawTorso();
      drawHead();
      drawLeftArm();
    popMatrix();//terminar transformaciones
    if (!punching && !translatingPunch && !scalingRightArm && doneScaling)
      //si se terminó de hacer la animación del golpe
    {
      pressedX = false;//reiniciar la variable de la tecla apretada
      /*
      Regresar las variables auxiliares a sus valores originales para la siguiente
      llamada a la animación de golpe
      */
      punch = 0;
      translatePunch = 0;
      scaleRightArm = 1;
      rightArm = loadImage("rightArm.png");
      doneScaling = false;
      timingScale = false;
      scaleCounter = 0;
      playedPunch = false;
    }
  }

  /*Animación de patada
  toma como parámetros:
  x donde dibujar al personaje pateando
  y donde dibujar al personaje pateando
  */
  public void kick (int x)
  {
    /*
    Funcionalidad general de la animación:
    rotar y trasladar el cuerpo para simular que el personaje se hace hacia atrás
    rotar y trasladar la pierna derecha para simular el movimiento de patada
    */

    /*Código que maneja la transición fluida de la rotación del cuerpo al patear*/
    if (bodyRotation>=-60 && bodyRotation<=-50) {
      if (bodyRotation==-50)
        rotatingBody = true;
      if (bodyRotation==-60)
        rotatingBody = false;
      if (rotatingBody)
        bodyRotation-=1;//(fluidez)
    }
    pushMatrix();//iniciar transformaciones
      translate(x+xPosition,0);//trasladar x+xPosition, 0
      scale(1.2);//escalar 1.2 veces su tamaño
      
      pushMatrix();//iniciar transformaciones
        translate(-75,80);//trasladar la pierna derecha -75,80
        rotate(radians(bodyRotation));//rotar pierna derecha de manera fluida
        drawRightHam();
        drawRightShin();
      popMatrix();//terminar transformaciones
      
      pushMatrix();//iniciar transformaciones
        translate(-15,60);//trasladar brazo derecho -15,60
        rotate(radians(300));//rotar brazo derecho 300 grados
        rightArm = loadImage("rightArmPunch.png");//cambiar el sprite del brazo al puño cerrado
        drawRightArm();
      popMatrix();//terminar transformaciones
      
      pushMatrix();//iniciar transformaciones
        rotate(radians(350));//rotar resto del cuerpo 350 grados
        translate(-25,0);//trasladar resto del cuerpo -25,0
        drawTorso();
        drawHead();
        drawLeftArm();
        drawLeftHam();
      popMatrix();//terminar transformaciones
      drawLeftShin();//la espinilla izquierda se mantiene estática
    popMatrix();//terminar transformaciones 
    
    if(!rotatingBody)//si se terminó de rotar el cuerpo
    {
      if(!playedKick)//si no se ha reproducido el sonido de patada
        {
         kickSound.cue(0);//reroducir sonido en tiempo 0
         kickSound.play();//reproducir
         playedKick = true;//ya se reprodujo la patada
        }
      kickCounter++;//variable auxiliar para mantener la patada activa unos segundos
      if(kickCounter>=20)
      {
        pressedZ = false;//reiniciar la variable de tecla apretada
        /* regresar las variables auxiliares a sus valores originales */
        playedKick = false;
        bodyRotation = -50; 
        rightArm = loadImage("rightArm.png");
        kickCounter=0;
      }
    }
  }
 
  /*Animación de poder especial
  toma como parámetros:
  x donde dibujar al personaje disparando
  y donde dibujar al personaje disparando
  target para detectar la colisión de la bola de hielo con el blanco
  */
  public void fire(int x, Target target)
  { 
    /*
    Funcionalidad general de la animación:
    trasladar y rotar el brazo hasta que esté estirado hasta el nivel del hombro
    sacar una bola de hielo de la mano que se traslada al borde de la pantalla mientras rota
    detectar colisión con el blanco en movimiento
    */

    if(!playedFreeze){//si no se ha reproducido el sonido de poder especial
      freeze.cue(0);//reproducir en tiempo 0
       freeze.play();//reproducir sonido
       playedFreeze = true;//se reprodujo el sonido de poder especial
    }

    /*Código que maneja la rotación fluida del brazo*/ 
    if (fireRot>=-50 && fireRot<=0) {
      if (fireRot==-50)
        fireRotating = false;
      if (fireRot==0)
        fireRotating = true;
      if (fireRotating)
        fireRot-=5;//(fluidez)
    }
    
    /*Código que maneja la traslación fluida del brazo*/
     if (fireTranslate>=0 && fireTranslate<=50) {
      if (fireTranslate==0)
        fireTranslating = true;
      if (fireTranslate==50)
        fireTranslating = false;
      if (fireTranslating)
        fireTranslate+=5;//(fluidez)
    }
    
    if(!fireTranslating && !fireRotating)
    {//si ya se terminó la animación del brazo
      startingFrameX = iceBallX-x+xPosition;//cambiar el marco de referecia de la posición en x
      /*Esto se hace para detectar la colisión con el marco de referencia
      original. (origen en la esquina superior izquierda)*/
      startingFrameY = iceBallY+300;//cambiar el marco de referecia de la posición en y
      if(abs(target.getX()-startingFrameX)<=50 && target.getDrawable())
      {
         if(abs(target.getY()-startingFrameY)<=25)
         {//colisión con el blanco
         target.setDrawable(false);//borrar el blanco de la pantalla
         if(!fatality.isPlaying())//si no se está reproduciendo el sonido de colisión
           {
               fatality.cue(0);//reproducir en tiempo 0
               fatality.play();//reproducir sonido
           }
         }
      }
      ballRot++;//aumentar ángulo de rotación de la bola de hielo
      iceBallX = iceBallX+ballSpeed;//trasladar bola de hielo hacia la derecha
        pushMatrix();//iniciar transformaciones
        translate(x+iceBallX+150+xPosition,iceBallY);
        //trasladar x+iceBallX+150+xPosition en x para que la bola siempre se dispare con respecto
        //a la posición actual del jugador
        //trasladar y+iceBallY en y para mantener una altura constante
          pushMatrix();//iniciar transformaciones
           scale(1.3);//escalar bola
           rotate(radians(ballRot*10));//rotar bola de hielo
           drawIceBall(); 
          popMatrix();//terminar transformaciones
        popMatrix();//terminar transformaciones
    }
    
    pushMatrix();//iniciar transformaciones
    translate(x+xPosition, 0);//trasladar todo x+xPosition,y
      pushMatrix();//iniciar transformaciones
        scale(1.2);//escalar 1.2 veces
        pushMatrix();//iniciar transformaciones
          translate(-5,fireTranslate);//trasladar brazo derecho -5,fireTranslate (fluidez)
          rotate(radians(fireRot));//rotar brazo derecho fireRot (fluidez) grados
          drawRightArm();
        popMatrix();//terminar transformaciones
        /*Dibujar el resto del cuerpo*/
        drawLeftHam();
        drawLeftShin();
        drawRightHam();
        drawRightShin();
        drawTorso();
        drawHead();
        drawLeftArm();
      popMatrix();//terminar transformaciones 
    popMatrix();//terminar transformaciones
    
    if(iceBallX-x+xPosition>=width)//si la bola salió de la pantalla, se terminó la animación
    {
    iceBallX = 0;//reiniciar posición de la bola
    pressedSpace = false;//reiniciar variable de tecla presionada
    playedFreeze = false;//reiniciar variable de reproducción de sonido
    }
  }
  
  /*Animación para caminar
  toma como parámetros:
  x donde dibujar al personaje caminando
  y donde dibujar al personaje caminando
  */
  public void walkRight(int x)
  {
    /*
    Funcionalidad general de la animación:
    trasladar la pierna izquierda y rotar la derecha para simular el movimento de las piernas
    al caminar
    realizar el mismo movimiento de idle para el torso
    */

    /*Código que maneja la traslación fluida de la pierna izquierda*/
    if (leftHamPosX>=-10 && leftHamPosX<=0) {
      if (leftHamPosX==-10)
        movingLeftHamRight = true;
      if (leftHamPosX==0)
        movingLeftHamRight = false;
      if (movingLeftHamRight)
        leftHamPosX+=.5;
      else
        leftHamPosX-=.5;//(fluidez)
    }
    //el código anterior mantiene la pierna izquierda moviéndose a los lados dentro de un límite
    
     /* Código que mantiene al torso moviéndose de arriba a abajo sin parar */
    if (vertPos>=-10 && vertPos<=0) {
      if (vertPos==-10)
        movingUp = true;
      if (vertPos==0)
        movingUp = false;
      if (movingUp)
        vertPos+=.5;
      else
        vertPos-=.5;//(fluidez)
    }
    //el código anterior mantiene al torso movíendose de arriba a abajo dentro de un límite

    /*Código que maneja la rotación fluida de la pierna derecha*/
    if (rightHamRot>=0 && rightHamRot<=5) {
      if (rightHamRot==0)
        rotatingRightHam = true;
      if (rightHamRot==5)
        rotatingRightHam = false;
      if (rotatingRightHam)
        rightHamRot+=.25;
      else
        rightHamRot-=.25;//(fluidez)
    }
    //el código anterior mantiene la pierna derecha rotando dentro de un límite

    pushMatrix();//iniciar transformaciones
      translate(x, 0);//trasladar todo x,0
      scale(1.2);//escalar 1.2 veces
      pushMatrix();//iniciar transformaciones
        translate(-leftHamPosX, 0);//trasladar pierna izquierda -leftHamPosX (fluidez),0
        drawLeftHam();
        drawLeftShin();
      popMatrix();//terminar transformaciones
      pushMatrix();//iniciar transformaciones
        rotate(radians(rightHamRot));//rotar pierna derecha rightHamRot (fluidez) grados
        drawRightHam();
        drawRightShin();
      popMatrix();//terminar transformaciones
      pushMatrix();//iniciar transformaciones
        translate(0, -vertPos);//trasladar 0,-verPos (fluidez) la parte superior del cuerpo
        drawTorso();
        drawHead();  
        drawLeftArm();
        drawRightArm();
      popMatrix();//terminar transformaciones
    popMatrix();//terminar transformaciones
  }

  /*Función para caminar a la derecha
  toma como parámetros:
  x donde dibujar al personaje caminando
  y donde dibujar al personaje caminando
  */
  public void moveRight(int x)
  {
    xPosition+=3;//aumentar 3 unidades a la posición en X cuando se llame la función
    pushMatrix();//iniciar transformaciones
      translate(xPosition, 0);//trasladar al personaje xPosition,0
      walkRight(x);//animación de caminar
    popMatrix();//terminar transformaciones 
    movingRight = false;//cuando termina la función ya no se está caminando a la derecha
  }

  /*Función para caminar a la izquierda
  toma como parámetros:
  x donde dibujar al personaje caminando
  y donde dibujar al personaje caminando
  */
  public void moveLeft(int x)
  {
    xPosition-=3;//restar 3 unidades a la posición en X cuando se llame la función
    pushMatrix();//iniciar transformaciones
      translate(xPosition, 0);//trasladar al personaje xPosition,0
      walkRight(x);//animación de caminar
    popMatrix();//terminar transformaciones 
    movingLeft = false;//cuando termina la función ya no se está caminando a la izquierda
  }

}

