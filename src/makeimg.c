#include <stdio.h>
#include <stdlib.h>

void write(FILE *src_file, FILE *out_file) {
    unsigned long int buffer;
    while((buffer = fgetc(src_file)) != EOF) fputc(buffer, out_file);
    fclose(src_file);
}

int main(int argc, char* argv[]) {
	if (argc > 2)
    {
        FILE *boot_file = fopen(argv[1],"rb"), *prog_file = fopen(argv[2],"rb"), *img_file = fopen(argv[3],"rb");
        if((boot_file)&&(prog_file)&&(img_file)) {
                FILE *out_file = fopen("../../th/xiaOS.img", "wb");
                write(boot_file, out_file);
                fseek(out_file, 510, SEEK_SET);
                fputc(0x55, out_file);
                fputc(0xAA, out_file);
				write(prog_file, out_file);
				fseek(out_file, 32256, SEEK_SET);
                write(img_file, out_file);

                puts("File \"xiaOS.img\" is created");
        }
        else puts("Can not open one of the source files");
    }
    else puts("Missing argument\nFirst argument - boot file, second - program file\nBoth with extensions\nDivide by space");
	return 0;
}
