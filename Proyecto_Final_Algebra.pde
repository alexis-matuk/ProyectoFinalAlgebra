import ddf.minim.*;//importar librería de sonido
Minim bellTower;//objeto Minim para controlar sonidos
AudioPlayer player;//Música de fondo
AudioPlayer fatality;//Sonido cuando le pegas al target
AudioPlayer freeze;//sonido de poder especial
AudioPlayer punchSound;//sonido para golpear
AudioPlayer kickSound;//sonido para patear
Target target;//Declaración de objeto target
Player sub;//Declaración del objeto Player
PImage background;//imagen de fondo
boolean pressedX = false;//booleano para saber si el usuario apretó X
boolean pressedZ = false;//booleano para saber si el usuario apretó Z
boolean pressedSpace = false;//booleano para saber si el usuario apretó espacio
boolean movingLeft = false;//booleano para saber si el usuario apretó izquierda
boolean movingRight = false;//booleano para saber si el usuario apretó derecha

void setup()
{
  size(1000, 600);//pantalla de 1000x600
  sub = new Player();//inicializar player
  target = new Target();//inicializar target
  background = loadImage("bg.png");//inicializar imagen de fondo
  bellTower = new Minim(this);//inicializar controlador de audio
  fatality = bellTower.loadFile("fatality.mp3");//inicializar sonido cuando le pegas al target
  player = bellTower.loadFile("bell.mp3");//inicializar música de fondo
  freeze = bellTower.loadFile("freeze.mp3");//inicializar sonido de poder especial
  punchSound = bellTower.loadFile("punch.mp3");//inicializar sonido de golpe
  kickSound = bellTower.loadFile("kick.mp3");//inicializar sonido de patada
  player.setGain(-2);//volumen de música de fondo
  player.loop();//loop a la música de fondo
}

void draw()
{
  image(background, 0, 0);//dibuja el background cada vez para que no se sobrepongan las imagenes dibujadas
  target.moveTarget();//mover el target constantemente
  translate(width/2, height/2);//cambiar el orígen al centro de la pantalla
  if (pressedX)//si el usuario presionó X
  {
    sub.punch(-300);//secuencia de golpe
  } else if (pressedZ)//si presionó Z
  {
    sub.kick(-300);//secuencia de patada
  } else if (pressedSpace)//si presionó espacio
  {
    sub.fire(-300, target);//secuencia de poder especial
  } else
  {
    if (movingLeft)//si está moviéndose a la izquierda
    {
      sub.moveLeft(-300);//secuencia de caminar hacia la izquierda
    } else if (movingRight)//si está moviéndose a la derecha
    {
      sub.moveRight(-300);//secuencia de caminar hacia la derecha
    } else//si no está apretando nada
      sub.idle(10, -300);//secuencia de idle (movimiento constante del torso)
  }
  if (keyPressed == true)//si se oprimió alguna tecla
  {
    if (key=='x') {//si se presionó x, cambiar pressedX a true
      pressedX=true;
    }
    if (key == 'z')//si se presionó <, cambiar pressedZ a true
    {
      pressedZ = true;
    }
    if (key == ' ')//si se presionó espacio, cambiar pressedSpace a true
    {
      pressedSpace = true;
    }
    if (key == 'r')//si se presionó r, "resetear" el target si ya se destruyó
    {
      target.setDrawable(true);
    }
    if (keyCode == LEFT)//si se presionó flecha izquierda, cambiar movingLeft a true
    {
      movingLeft = true;
    }
    if (keyCode == RIGHT)//si se presionó flecha derecha, cambiar movingRight a true
    {
      movingRight = true;
    }
  }
}



