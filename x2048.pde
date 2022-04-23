// JEU 2048 EN DEVELOPPEMENT ICI :

int[][] square;

Grille grid;
PFont police;
boolean game;

class Grille
{
  int h, w, radius, c, l, space_x, space_y, k;
  
  Grille(int new_h, int new_w, int H_case, int W_case, int rad) // rad = coins arrondis, coeff_k = espace entre les cases
  {
    h = new_h;
    w = new_w;
  	c = H_case;
  	l = W_case;
  	radius = rad;
    space_x = (width-w)/2;
    space_y = (height-h)/2;
	k = 20;
  }

  void refresh_sqr(int column, int line)
  {
  	int x, y;
  	x = ((w-k)/l)*line;
  	y = ((h-k)/c)*column;
  	set_color(square[line][column]);
 	noStroke();
    rect(y+space_y+k,x+space_x+k,(h-k)/c-k,(w-k)/l-k,radius);
	if(square[line][column] != 0)
	{
		if(square[line][column] == 2 || square[line][column] == 4) fill(119,110,101);
		else
			fill(249,246,242);
		textSize(60);
		textAlign(CENTER, CENTER);
		text(square[line][column],y+space_y+((h-k)/c)/2+k/2,x+space_x+((w-k)/l)/2+k/2);
	}
  }
  
  void set_color(int nbr)
  {
	  switch(nbr)
	  {
		case 0:
			fill(204,192,180);  // couleur des carrés vides
			break;
		case 2:
			fill(238,228,218);
			break;
		case 4:
			fill(236,224,200);
			break;
		case 8:
			fill(242,177,121);
			break;
		case 16:
			fill(245,149,99);
			break;
		case 32:
			fill(245,124,95);
			break;
		case 64:
			fill(246,93,59);
			break;
		case 128:
			fill(237,206,115);
			break;
		case 256:
			fill(237,202,98);
			break;
		case 512:
			fill(239,198,82);
			break;
		case 1024:
			fill(235,195,63);
			break;
		case 2048:
			fill(238,194,46);
			break;
		case 4096:
			fill(255,61,61);
			break;
		default:
			fill(255,29,31);
			break;
	  }
  }

	void random_nb()
	{
		int rand_nb, nb_max = 0, alea;
		int[] x_tab, y_tab;
		x_tab = new int[w];
		y_tab = new int[h];
		
		for(int j=0;j<c;j++)
		{
			for(int i=0;i<l;i++)
			{
				if(square[j][i] == 0)
				{
					x_tab[nb_max] = i;
					y_tab[nb_max] = j;
					nb_max++;
				}
			}
		}
		alea = int(random(0,4));
		rand_nb = int(random(0,nb_max));
		if(alea == 3) alea = 4;
		else if(alea != 3) alea = 2;
		
		if(nb_max != 0) square[y_tab[rand_nb]][x_tab[rand_nb]] = alea;
	}
	  
  void setup_disp()
  {
    int x = 0, y = 0;
    if(h == w) k = (int)((w*20)/650);
    fill(189,173,158);
    noStroke();
    rect(space_y,space_x,h,w,radius+2);
    fill(204,192,180);  // couleur des carrés vides
    for(int j=0;j<c;j++)
    {
      for(int i=0;i<l;i++)
      {
        noStroke();
        rect(y+space_y+k,x+space_x+k,(h-k)/c-k,(w-k)/l-k,radius);
        x += (w-k)/l;
      }
      x = 0;
      y += (h-k)/c;
    }
  
  }
  
  void display()
  {
    for(int j=0;j<c;j++)
    {
      for(int i=0;i<l;i++)
      {
		 refresh_sqr(j,i);
      }
    }
  }

}

void setup()
{
	size(650,650);
	police = loadFont("Arial-Bold.vlw");
	textFont(police);
	background(251,248,240);
  game = true;
	grid = new Grille(600,600,4,4,5); // grid classique 4x4
	//the_grid = new grid(600,400,6,4,5,20); // Exemple de grid
	square = new int[grid.c][grid.l];
	for(int j=0;j<grid.c;j++)
	{
		for(int i=0;i<grid.l;i++) square[j][i] = 0;
	}
	
	println("Loading...");
	smooth();
	grid.setup_disp();
	println("PLAY !");

	for(int j=0;j<grid.c;j++)
	{
        for(int i=0;i<grid.l;i++) 
		{
			print(" ");
			print(square[j][i]);
		}
	    println("");
	}
    println("");
	grid.random_nb();
	grid.display();
}

void draw()
{
  
}

void keyPressed()
{
  if(!game)
  {
    if(key == 'r' || key == 'R')
      setup();
   return; 
  }
	int nb = 0;
  boolean badKey = false;
	switch(keyCode)
	{
		case RIGHT:
			if(right() == 1) nb = 1;
			break;
		case LEFT:
			if(left() == 1) nb = 1;
			break;
		case UP:
			if(up() == 1) nb = 1;
			break;
		case DOWN:
			if(down() == 1) nb = 1;
			break;
		default:
      badKey = true;
			println("ERREUR TOUCHE");
			break;
			
	}
	print_squares();
  println("---------");
	if(nb != 1 && !badKey) grid.random_nb();
	grid.display();
  game = !gameOver();
  if(!game)
    dispGameOver("Defeat !");
	delay(50);
}

void dispGameOver(String msg)
{
    background(238,194,46, 30);
    fill(255,255,255);
    textSize(74);
    text(msg, width/2, height/4);
    textSize(36);
    text("Press (R) to restart a game", width/2, 3*height/4);
    delay(10);
}

boolean checkNext(int sqr, int c, int l) // renvoie true si il y a un carré du meme numero en haut/droite/gauche/bas
{
  if(c-1 != -1 && square[c-1][l] == sqr)
    return true;
  if(l-1 != -1 && square[c][l-1] == sqr)
    return true;
  if(c+1 != grid.c && square[c+1][l] == sqr)
    return true;
  if(l+1 != grid.l && square[c][l+1] == sqr)
    return true;
  return false;
}

boolean gameOver()
{
  for(int j=0;j<grid.c;j++)
  {
    for(int i=0;i<grid.l;i++)
    {
      if(square[j][i] == 0)
        return false;
      else if(checkNext(square[j][i], j, i))
        return false;
    }
  }
  return true;
}

void print_rand_nb()
{
	if(keyPressed)
	{
		background(255,0,0);
		fill(255,255,255);
		textSize(width/3);
		textAlign(CENTER, CENTER);
		int alea=int(random(0, 4));
		if(alea == 3) alea = 4;
		else if(alea != 3) alea = 2;
		text(alea, width/2, height/2);
		delay(10);
	}
}

void print_squares()
{
	for(int j=0;j<grid.c;j++)
	{
		for(int i=0;i<grid.l;i++) 
		{
			print(" ");
			print(square[j][i]);
		}
		println("");
	}
}

int right()
{
    int pos = grid.l, last_nb = 0, modif = 0;
	int[] line;
	line = new int[grid.l+1];
	
	for(int j=0;j<grid.c;j++)
	{
        for(int i=0;i<grid.l;i++) line[i+1] = square[j][i];
		
		pos = grid.l;
		last_nb = 0;
	
		for(int i=grid.l;i>0;i--)
		{
		    if(line[i] != 0)
            {
                if(line[last_nb] == line[i] && last_nb != 0)
                {
                    line[last_nb] *= 2;
                    line[i] = 0;
                    last_nb--;
                }
                else if(line[i] == line[i-1] && i != 1)
                {
                    line[i] *= 2;
                    if(pos != i)
                    {
                        line[pos] = line[i];
                        line[i] = 0;
                    }
                    line[i-1] = 0;
                    pos --;
                    if(last_nb != 0) last_nb--;
                }
                else if((line[pos] == 0 && line[i] != line[i-1]) || (line[pos]== 0 && i == 1))
                {
                    line[pos] = line[i];
                    line[i] = 0;
                    last_nb = pos;
                    pos--;
                }
                else if(line[i] != line[i-1] && i != 1)
                {
                    pos--;
                    last_nb = i;
                }
            }

		}
		
        for(int i=0;i<grid.l;i++) 
		{
			if(square[j][i] != line[i+1])
			{
				square[j][i] = line[i+1];
				modif++;
			}
		}
		
	}
	
	if(modif == 0) return 1;
	else
		return 0;
	
}

int left()
{
    int pos = grid.l, last_nb = 0, modif = 0;
	int[] line;
	line = new int[grid.l+2];
	
	for(int j=0;j<grid.c;j++)
	{
        for(int i=0;i<grid.l;i++) line[i+1] = square[j][i];
		
		pos = 1;
		last_nb = 0;
	
		for(int i=1;i<grid.l+2;i++)
		{
		    if(line[i] != 0)
            {
                if(line[last_nb] == line[i] && last_nb != 0)
                {
                    line[last_nb] *= 2;
                    line[i] = 0;
                    last_nb++;
                }
                else if(line[i] == line[i+1] && i != grid.l)
                {
                    line[i] *= 2;
                    if(pos != i)
                    {
                        line[pos] = line[i];
                        line[i] = 0;
                    }
                    line[i+1] = 0;
                    pos++;
                    if(last_nb != 0) last_nb++;
                }
                else if((line[pos] == 0 && line[i] != line[i+1]) || (line[pos]== 0 && i == grid.l))
                {
                    line[pos] = line[i];
                    line[i] = 0;
                    last_nb = pos;
                    pos++;
                }
                else if(line[i] != line[i+1] && i != grid.l)
                {
                    pos++;		 // 1 et i = 2;
                    last_nb = i; // 0
                }
            }

		}
		
        for(int i=0;i<grid.l;i++)
		{
			if(square[j][i] != line[i+1])
			{
				square[j][i] = line[i+1];
				modif++;
			}
		}
	}
	
	if(modif == 0) return 1;
	else
		return 0;
}

int up()
{
    int pos = grid.l, last_nb = 0, modif = 0;
	int[] line;
	line = new int[grid.l+2];
	
	for(int j=0;j<grid.c;j++)
	{
        for(int i=0;i<grid.l;i++) line[i+1] = square[i][j];
		
		pos = 1;
		last_nb = 0;
	
		for(int i=1;i<grid.l+2;i++)
		{
		    if(line[i] != 0)
            {
                if(line[last_nb] == line[i] && last_nb != 0)
                {
                    line[last_nb] *= 2;
                    line[i] = 0;
                    last_nb++;
                }
                else if(line[i] == line[i+1] && i != grid.l)
                {
                    line[i] *= 2;
                    if(pos != i)
                    {
                        line[pos] = line[i];
                        line[i] = 0;
                    }
                    line[i+1] = 0;
                    pos++;
                    if(last_nb != 0) last_nb++;
                }
                else if((line[pos] == 0 && line[i] != line[i+1]) || (line[pos]== 0 && i == grid.l))
                {
                    line[pos] = line[i];
                    line[i] = 0;
                    last_nb = pos;
                    pos++;
                }
                else if(line[i] != line[i+1] && i != grid.l)
                {
                    pos++;
                    last_nb = i;
                }
            }

		}
		
        for(int i=0;i<grid.l;i++)
		{
			if(square[i][j] != line[i+1])
			{
				square[i][j] = line[i+1];
				modif++;
			}	
		}	
	}
	
	if(modif == 0) return 1;
	else
		return 0;
}

int down()
{
    int pos = grid.l, last_nb = 0, modif = 0;
	int[] line;
	line = new int[grid.l+1];
	
	for(int j=0;j<grid.c;j++)
	{
        for(int i=0;i<grid.l;i++) line[i+1] = square[i][j];
		
		pos = grid.l;
		last_nb = 0;
	
		for(int i=grid.l;i>0;i--)
		{
		    if(line[i] != 0)
            {
                if(line[last_nb] == line[i] && last_nb != 0)
                {
                    line[last_nb] *= 2;
                    line[i] = 0;
                    last_nb--;
                }
                else if(line[i] == line[i-1] && i != 1)
                {
                    line[i] *= 2;
                    if(pos != i)
                    {
                        line[pos] = line[i];
                        line[i] = 0;
                    }
                    line[i-1] = 0;
                    pos --;
                    if(last_nb != 0) last_nb--;
                }
                else if((line[pos] == 0 && line[i] != line[i-1]) || (line[pos]== 0 && i == 1))
                {
                    line[pos] = line[i];
                    line[i] = 0;
                    last_nb = pos;
                    pos--;
                }
                else if(line[i] != line[i-1] && i != 1)
                {
                    pos--;
                    last_nb = i;
                }
            }

		}
		
        for(int i=0;i<grid.l;i++)
		{
			if(square[i][j] != line[i+1])
			{
				square[i][j] = line[i+1];
				modif++;
			}	
		}
	}
	
	if(modif == 0) return 1;
	else
		return 0;
}
