#include <REG51.H>

#define LCD_Port P2
#define ADC_Out P1

sbit RS = P3^0;
sbit RW = P3^1;
sbit En = P3^4;
sbit EOC = P3^5;
sbit Start = P3^6;
sbit OE = P3^7;
sbit RL= P0^3;

sbit B1 = P3^2;  // +
sbit B2 = P3^3;  // -

unsigned char ADC_val;
unsigned int Temp_setat = 210;  // 21.0 °C
unsigned int Temp_actual;

void delay(int t);
void LCD_comanda(unsigned char);
void LCD_data(unsigned char);
void display(unsigned char *);
void ADC_cmd();
unsigned int get_temp_x10(unsigned char);
void afiseaza_temp(unsigned int);
void afiseaza_temp_setata();
void debounce();

code unsigned char m1[] = "Temp:";
code unsigned char m2[] = "Setat:";

void main() {
    P1 = 0xFF;  // ADC input
    P2 = 0x00;  // LCD output
    RL = 0; // Oprire RL la initializare

    LCD_comanda(0x38); delay(5);
    LCD_comanda(0x0E); delay(5);
    LCD_comanda(0x01); delay(5);
    LCD_comanda(0x06); delay(5);
	
		LCD_comanda(0x80); display(m1);
		LCD_comanda(0x85); afiseaza_temp(0);
		LCD_comanda(0x89); LCD_data(0xDF); LCD_data('C');
		LCD_comanda(0xC0); display(m2);
		LCD_comanda(0xC6);afiseaza_temp_setata();
		LCD_comanda(0xCA); LCD_data(0xDF); LCD_data('C');
		
    while (1) {
        ADC_cmd();
        Temp_actual = get_temp_x10(ADC_val);
			//pozitionare cursor dupa Temp:
        LCD_comanda(0x85); afiseaza_temp(Temp_actual);
        

        // Control RL
        if (Temp_actual >= Temp_setat + 2)
           RL = 0;
        if (Temp_actual <= Temp_setat - 2)
            RL = 1;

        // Creste temperatura
				while (B1 == 0) {
					if(Temp_setat < 350) Temp_setat +=2;
					LCD_comanda(0xC6);afiseaza_temp_setata();
					delay(5);
				}
				
				// Scade temperatura
				while (B2 == 0) {
					if(Temp_setat > 80) Temp_setat -=2;
					LCD_comanda(0xC6);afiseaza_temp_setata();
					delay(5);
				}
				delay(50);
			}
   }


void delay(int t) {
    unsigned int i, j;
    for (i = 0; i < t; i++)
        for (j = 0; j < 1275; j++);
}

void LCD_comanda(unsigned char cmd) {
    RS = 0; RW = 0;
    LCD_Port = cmd;
    En = 1; delay(5);
    En = 0; delay(5);
}

void LCD_data(unsigned char dat) {
    RS = 1; RW = 0;
    LCD_Port = dat;
    En = 1; delay(2);
    En = 0; delay(2);
}

void display(unsigned char *msgchar) {
    while (*msgchar != 0) {
        LCD_data(*msgchar++);
    }
}

void ADC_cmd() {
    Start = 1; delay(5);
    Start = 0;
    while (EOC == 1) delay(5);
    OE = 1; delay(5);
    ADC_val = ADC_Out;
    delay(5);
    OE = 0;
}

unsigned int get_temp_x10(unsigned char adc_val) {
    float temp = ((float)adc_val * 19.95 / 185) + 8.0;
    return (unsigned int)(temp * 10);
}

void afiseaza_temp(unsigned int val) {
    LCD_data((val / 100) + '0');
    LCD_data(((val / 10) % 10) + '0');
    LCD_data('.');
    LCD_data((val % 10) + '0');
}

void afiseaza_temp_setata() {
    unsigned int val = Temp_setat;

    LCD_data((val / 100) + '0');
    LCD_data(((val / 10) % 10) + '0');
    LCD_data('.');
    LCD_data((val % 10) + '0');
}