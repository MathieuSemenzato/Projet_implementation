#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Define the special DDR address (replace this with the actual address)
#define DDR_SPECIAL_ADDRESS ((volatile uint32_t*)0x20000000)

volatile int Image[480][640];
volatile int FFT[500]; //range of frequency: 0-2000Hz, step=4Hz
int FFT_treated[500]; //range of frequency: 0-2000Hz, step=4Hz

// takes the value of FFT[500], find the max knowing the min is 0 and scale it on a range between 0 and 400 and write it in FFT_treated[500]
void FFT_to_img(){
    int max = 0;
    int i;
    for(i=0; i<500; i++){
        if(FFT[i]>max){
            max = FFT[i];
        }
    }
    for(i=0; i<500; i++){
        FFT_treated[i] = (FFT[i]*400)/max;
    }
}

void init_FFT(){
    int i;
    for(i=0; i<500; i++){
        FFT[i] = i;//rand()%1000;
    }
}

void reset_background(){
    int i,j;
    for(i=0; i<480; i++){
        for(j=0; j<640; j++){
            Image[i][j] = 0;
        }
    }
}
//Write white pixels to the shape of a x and y axis
void init_background(){
    int i,j;
    for(i=20; i<460; i++){
        Image[i][18] = 0xFFF;
        Image[i][19] = 0xFFF;
        Image[i][20] = 0xFFF;
    }
    for(j=20; j<620; j++){
        Image[460][j] = 0xFFF;
        Image[461][j] = 0xFFF;
        Image[462][j] = 0xFFF;
    }
}

void draw_graph(){
    int i,j;
    for(i=0; i<500; i++){
        Image[20+400-FFT_treated[i]][20+i]=0xFFF;
        Image[20+401-FFT_treated[i]][20+i]=0xFFF;
        Image[20+402-FFT_treated[i]][20+i]=0xFFF;
    }
}

// Function to read, modify, and write values in DDR
void modifyDDRValue(int index, uint32_t modification) {
    // Check if the index is within bounds (assuming each element is 32 bits)
    if (index < 0 || index >= 30) {
        // Handle out-of-bounds error
        return;
    }

    // Read the original value from DDR
    uint32_t originalValue = DDR_SPECIAL_ADDRESS[index];

    // Apply modifications
    uint32_t modifiedValue = originalValue + modification;

    // Write the modified value back to DDR
    DDR_SPECIAL_ADDRESS[index] = modifiedValue;
}

void print_image(){
    int i,j;
    for(i=0; i<480; i++){
        for(j=0; j<640; j++){
            if(Image[i][j]==0xFFF)printf("■");
            else printf(" ");
        }
        printf("\n");
    }
}

int main() {
    srand(time(NULL));
    while(1){
        
        init_FFT();
        
        FFT_to_img();
        
        reset_background();
        
        init_background();
        
        draw_graph();
        
        //print_image();
    }
    return 0;
}