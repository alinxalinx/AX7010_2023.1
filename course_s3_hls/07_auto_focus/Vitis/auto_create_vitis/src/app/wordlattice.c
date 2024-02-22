extern unsigned char acyahei32[];
extern short int tahoma26_offset[];
extern char tahoma26_dat[];
extern const unsigned int alinxicon[];

int setIcon_alinx(unsigned int *region, int w, char isClear)
{
	for(int v=0;v<48;v++)
	{
		if(isClear)
		{
			for(int h=0;h<48;h++)
			{
				region[v*w+h] = 0;
			}
		}
		else
		{
			for(int h=0;h<48;h++)
			{
				region[v*w+h] = alinxicon[v*48+h];
			}
		}
	}
	return 0;
}

int setGbk_32x32(int index, unsigned int *region, int w, unsigned int a, unsigned int b)
{
	int pos_s = index*128;

	for(int v=0;v<4;v++)
	{
		for(int h=0;h<32;h++)
		{
			region[(v*w)+h] = b;
		}
	}
	for(int v=36;v<40;v++)
	{
		for(int h=0;h<32;h++)
		{
			region[(v*w)+h] = b;
		}
	}
	for(int v=4;v<36;v++)
	{
		for(int h=0;h<4;h++)
		{
			for(int n=0;n<8;n++)
			{
				if(acyahei32[pos_s]&(1<<(7-n)))
				{
					region[(v*w)+(h*8)+n] = a;
				}
				else
				{
					region[(v*w)+(h*8)+n] = b;
				}
			}
			pos_s++;
		}
	}
	return 32;
}

int setTahoma26(int index, unsigned int *region, int w, unsigned int a, unsigned int b)
{
	int pos_s = tahoma26_offset[index] * 5;
	int character_w = tahoma26_offset[index+1]-tahoma26_offset[index];

	for(int h=0;h<character_w;h++)
	{
		for(int v=0;v<5;v++)
		{
			for(int n=0;n<8;n++)
			{
				if(tahoma26_dat[pos_s]&(1<<(7-n)))
				{
					region[((v*8+n)*w)+h] = a;
				}
				else
				{
					region[((v*8+n)*w)+h] = b;
				}
			}
			pos_s++;
		}
	}
	return character_w;
}

int uArgbPrintf(const char *str, unsigned int *region, int w, unsigned int a, unsigned int b)
{
	int pos_t = 0;
	int index;
	unsigned char *pStr = (unsigned char *)str;

	while(1)
	{
		if(pStr[0] == '\0')
		{
			break;
		}
		if((pStr[0] >= 0xa1) && (pStr[1] >= 0xa1))
		{
			index = (pStr[0]-0xa1)*94+pStr[1]-0xa1;
			pos_t += setGbk_32x32(index, region+pos_t, w, a, b);
			pStr += 2;
		}
		else
		{
			if(pStr[0] >= ' ')
			{
				index = pStr[0] - ' ';
				pos_t += setTahoma26(index, region+pos_t, w, a, b);
			}
			pStr++;
			continue;
		}
	}
	return 0;
}
