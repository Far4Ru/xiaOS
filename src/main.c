void setPixel (int, int, char);
void drawSquare(int, int, int, int, char);
void drawCircle(int, int, int,char);

int start() {
	int i,j,ni,nj, y = 0;
    //char k = 0xAA12B2;
	char *k= (char*) 0x10000;
	//char *k= (char*) 0xFFEF;
	//1536*864
	k+=130;
	for(i=200; i>0; i--){
		for(j = 0; j<400;j++){
			setPixel(j,i,*k);
			k++;
		}
	}
	drawSquare(540,300,100,100,0x0F);
	
	//drawCircle(100,100,20,0x0F);
	while(1);
	return 0;
}

void setPixel(int x, int y, char color) {
	char *p=(char*) 0xFD000000;
	p+=((y*640)+x);
	*p=color;
}

void drawSquare(int x, int y, int sizeX, int sizeY, char color){
	for(int i=0;i<sizeX;i++){
		for(int j=0;j<sizeY;j++){
			setPixel(x+i,y+j,color);
		}
	}
}

void drawCircle(int _x, int _y, int radius,char color)
{
	int x = 0, y = radius, gap = 0, delta = (2 - 2 * radius);
	while (y >= 0)
	{
		setPixel(_x + x, _y + y, color);
		setPixel(_x + x, _y - y, color);
		setPixel(_x - x, _y - y, color);
		setPixel(_x - x, _y + y, color);
		gap = 2 * (delta + y) - 1;
		if (delta < 0 && gap <= 0)
		{
			x++;
			delta += 2 * x + 1;
			continue;
		}
		if (delta > 0 && gap > 0)
		{
			y--;
			delta -= 2 * y + 1;
			continue;
		}
		x++;
		delta += 2 * (x - y);
		y--;
	}
}