#include <unistd.h>

int main(void)
{
  int i = 0;
  while(i != 1){
	asm volatile ("nop");
  }
}
