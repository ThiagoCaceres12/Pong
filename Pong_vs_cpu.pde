float x, y, speedX, speedY, maqPos;
int pontosMaq,pontosJogador;
boolean maqDown,maqTocou,jogando;
float diam = 20;
float rectSize = 200;
String tela;

void setup() {
  fullScreen();
  fill(0, 255, 0);
  reset();
  tela = "inicio";
  maqDown = random(0, 1) == 1;
  maqPos = height - (rectSize / 2);
  maqTocou = true;
}

void reset() {
  x = width/2;
  y = height/2;
  
  if(tela=="inicio") {
    speedX = random(3, 15);
    speedY = random(3, 15);
    maqTocou = true;
  }

  if(speedX < 0) {
    speedX = -random(3, 15);
  }
  
  if(speedY < 0) {
    speedY = -random(3, 15);
  }
}

void draw() {
  switch (tela) {
    case "inicio":
      nomeRA();
      break;
    case "jogo":
      jogo();
      break;
  }
}
  
void mouseClicked()
{
  if (tela == "inicio")
  {
    tela = "jogo";
  }
  
  jogando = true; // inicia o jogo
}


void nomeRA(){
  background(0, 0, 0);
  textSize(60);
  fill(255, 255, 255);
  text("Jogo PONG - CPU", 700, 100);
  textSize(30);
  fill(255, 255, 255);
  text("Thiago Cáceres Cordeiro - RA 21122022", 660, 300);
  textSize(80);
  fill(255, 0, 0);
  text("START", 800, 800);
}

/**
 * Este método é responsável por desenhar a mesa
 */
void desenhaMesa() {
  // Define cor da mesa
  background(35,68,137);
  
  // Define a linha de divisão dos oponentes
  strokeWeight(4);
  stroke(0,0,0);
  line(width/2,0,width/2,height); // linha vertical meio de mesa
  
  // Define a linha de ponto e centralização
  strokeWeight(8);
  stroke(255,255,255);
  line(0,height/2,width,height/2); // linha horizontal meio de mesa
}

/**
 * Este método é responsável por desenhar a bola
 */
void desenhaBola() {
  strokeWeight(0);
  fill(254, 215, 155);
  ellipse(x, y, diam, diam);
}

/**
 * Este método é responsável por desenhar a raquete
 */
void desenhaRaquetes() {
  strokeWeight(0);
  fill(240, 84, 85);
  raquete1();
  raquete2();
}

void raquete2() {
  rect(width-30, mouseY-rectSize/2, 10, rectSize); // raquete do jogador
}

void raquete1() {
  if (maqPos >= height + rectSize / 2) {
    maqDown = false;
  } else if (maqPos <= rectSize / 2) {
    maqDown = true;
  }
  
  if (maqDown) {
    maqPos += random(3, 35);
  } else {
    maqPos -= random(3, 35);
  }
  
  rect(20, maqPos - (rectSize/2), 10, rectSize);
}

/**
 * Este método é responsável por realizar os cáculos de fisica (algoritmo) de movimento da bola e da raquetedo jogador
 */
void proximoPasso(){ 
  x += speedX;
  y += speedY;
  
  // se a bola tocar a raquete 2, a direção dela será invertida
  if ( x >= width-30 && x <= width - (diam / 2) && y >= mouseY-rectSize/2 && y <= mouseY+rectSize/2 ) {
    speedX = speedX * -random(1,2);
    maqTocou = false; // diz que o jogador tocou na bola
  }
  
  // se a bola tocar a raquete 1, a direção dela será invertida
  if ( x >= 20 && x <= 30 && y >= maqPos-(rectSize/2) && y <= maqPos+(rectSize/2) ) {
    speedX *= -random(1.1, 2.2);
    speedY *= random(1.1, 2.2);
    x += speedX;
    maqTocou = true; // diz que a maquina tocou na bola
  }

  // se a bola tocar as laterais (top e base) o eixo "y" é invertido
  if ( y > height || y < 0 ) {
    speedY *= -1;
  }
  
  //se passar das raquetes, parar o jogo e calcular os pontos
  if(x >= width + 30 || x <= -30) {
    jogando = false;
    if(maqTocou) {
      pontosMaq++;
    }else{
      pontosJogador++;
    }
    
    imprimePontos();
  }
}

/**
 * Este método é responsável por exibir os pontos marcados
 */
void imprimePontos() {
  /*
    // se hoouver condição para perder ou ganhar deve ser decidido aqui
//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
//import java.awt.Color;
//import java.awt.Graphics;
//import java.awt.event.ActionEvent;
//import java.awt.event.ActionListener;
//import java.awt.event.KeyEvent;
//import java.awt.event.KeyListener;

import javax.swing.JPanel;
//import javax.swing.Timer;

public class PongPanel extends JPanel implements ActionListener, KeyListener {
  private Pong game;
  private Ball ball;
  private Racket player1, player2;
  private int score1, score2;
  
public PongPanel(Pong game) {
  setBackground(Color,WHITE);
  this.game = game;
  ball = new Ball(game);
  player1 = new Racket(game, KeyEvent.VK_UP, KeyEvent. VK_DOWN, game.getWidth()-36);
  player2 = new Racket(game, KeyEvent.VK_W, KeyEvent. VK_S, 20);
  Timer timer = new Timer(5, this);
  timer.start();
  addKeyListener(this);
  setFocusable(true);
}

public Racket getPlayer(int playerNo) {
  if (playerNo = 1)
     return player1;
   else
     return player2;
}

public void increaseScore(int playerNo) {
  if (playerNo == 1)
     score1++;
    else
     score2++;
}

public int getScore(int playerNo) {
  if (playerNo == 1)
    return score1;
   else
    return score2;
}

private void update() {
  ball.update();
  player1.update();
  player2.update();
}

public void actionPerformed(ActionEvent e) {
  update();
  repaint();
}

public void keyPressed(KeyEvent e) {
  player1.pressed(e.getKeyCode());
  player2.pressed(e.getKeyCode());
}

public void keyReleased(KeyEvent e) {
  player1.released(e.getKeyCode());
  player2.released(e.getKeyCode());
}

public void keyTyped(KeyEvent e) {
  ;
}

 @Override
 public void paintComponent(Graphics g) {
  super.paintComponet(g);
  g.drawString(game.getPanel().getScore(1)+ " : "+game.getPanel().getScore(2), game.getWidth()/2, 10);
  ball.paint(g);
  player1.paint(g);
  player2.paint(g);
 }
}
*/  
//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    
}

void jogo(){
  desenhaMesa();
  
  desenhaRaquetes();

  if(jogando){
    desenhaBola();
  
    proximoPasso();
  }
}

void mousePressed() {
  reset();
}
