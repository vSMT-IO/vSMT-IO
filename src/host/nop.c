#include <unistd.h>

int main(void)
{
  while(1){
	asm volatile ("nop;nop;nop;nop;nop;nop;nop;nop");
  }
}
