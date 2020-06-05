#include <unistd.h>

int main(void)
{
  while(1){
	asm volatile ("mov %eax,%eax;");
  }
}
