#include <stdint.h>
#include "msp430fr4133.h"

#define BLINK_CYCLES 500000L

typedef struct REG8{

   uint8_t bit0 : 1;
   uint8_t bit1 : 1;
   uint8_t bit2 : 1;
   uint8_t bit3 : 1;
   uint8_t bit4 : 1;
   uint8_t bit5 : 1;
   uint8_t bit6 : 1;
   uint8_t bit7 : 1;
}REG8;

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT1OUT_t;

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT1DIR_t;

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT1REN_t;

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT2DIR_t;//05

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT2REN_t;//07

typedef volatile union{

    uint8_t all;
    REG8 reg;
}PORT2IN_t;

int main(void){

    PORT1OUT_t * const PORT1OUT = (PORT1OUT_t *) 0x0202;
    PORT1DIR_t * const PORT1DIR = (PORT1DIR_t *) 0x0204;
    PORT1REN_t * const PORT1REN = (PORT1REN_t *) 0x0206;

    PORT2IN_t * const PORT2IN = (PORT2IN_t *) 0x0201;
    PORT2DIR_t * const PORT2DIR = (PORT2DIR_t *) 0x0205;
    PORT2REN_t * const PORT2REN = (PORT2REN_t *) 0x0207;

    //Disable Watchdog
    //WDTPW ... used for for access permission -> overwrite upperbyte
    //WDTHOLD ... Bit 7 : Used to stop WDTCTL
    WDTCTL = WDTPW | WDTHOLD;

    //For Low Power the PMM locks Port OUTPUT
    //LOCKLPM5 ... BIT0 of PM5CTL0: by setting to 0 PMM enables OUTPUT of peripherals
    //PM5CTL0...is one way to access PMM without password
    PM5CTL0 &= ~LOCKLPM5;

    PORT1DIR->all = 0xFF;
    PORT1OUT->all = 0x00;

    PORT2DIR->all = 0x00;
    PORT2REN->all = 0xFF;
    
    for(;;){

        PORT1OUT->reg.bit3 = 1;

        for(int i = 0; i < 5;){

            if(PORT2IN->reg.bit6 == 0){

                i++;
                PORT1OUT->all <<= 1;
                __delay_cycles(BLINK_CYCLES);
            }
        }


    }
}
