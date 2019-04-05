#include <stdlib.h>
#include <stdio.h>

char *option_invalid  = NULL;
char *option_file_in  = NULL;
char *option_file_out = NULL;

FILE *file_in_descriptor  = NULL;
FILE *file_out_descriptor = NULL;

void exception_handler(int code) {
    switch (code) {
        case 0:
            break;
        case 10001:
            printf("Error (10001): No option recognized.\n");
            printf("Please specify at least one valid option.\n");
            break;
        case 10002:
            printf("Error (10002): Invalid option: %s\n", option_invalid);
            break;
        case 10003:
            printf("Error (10003): No input Binary file specified.\n");
            break;
        case 10004:
            printf("Error (10004): Cannot open file: %s\n", option_file_in);
            break;
        case 10005:
            printf("Error (10005): Cannot create file: %s\n", option_file_out);
            break;
        default:
            break;
    }

    if (file_in_descriptor  != NULL) {
        fclose(file_in_descriptor);
    }
    if (file_out_descriptor != NULL) {
        fclose(file_out_descriptor);
    }
    exit(0);
}

int main(int argc, char **argv) {
 
    int i=0,j=0;
    unsigned char temp1,temp2,temp3,temp4;
    unsigned int option_flag = 0;

    while (argc > 0) {
        if (**argv == '-') {
            (*argv) ++;
            switch (**argv) {
                case 'f':
                    option_flag |= 0x4;
                    argv ++;
                    option_file_in = *argv;
                    argc --;
                    break;
                case 'o':
                    option_flag |= 0x8;
                    argv ++;
                    option_file_out = *argv;
                    argc --;
                    break;
                default:
                    option_flag |= 0x1;
                    (*argv) --;
                    option_invalid = *argv;
                    break;
            }
        }
        argv ++;
        argc --;
    }


    file_in_descriptor = fopen(option_file_in, "rb");
    if (file_in_descriptor == NULL) {
        exception_handler(10004);
    }

    file_out_descriptor = fopen(option_file_out, "w");
    if (file_out_descriptor == NULL) {
        exception_handler(10005);
    }


    
    while (!feof(file_in_descriptor)) {
         
            fscanf(file_in_descriptor, "%c", &temp1);
            fscanf(file_in_descriptor, "%c", &temp2);
            fscanf(file_in_descriptor, "%c", &temp3);
            fscanf(file_in_descriptor, "%c", &temp4);

            if(!feof(file_in_descriptor))
            {
             fprintf(file_out_descriptor, "%02x", temp1);
             fprintf(file_out_descriptor, "%02x", temp2);
             fprintf(file_out_descriptor, "%02x", temp3);
             fprintf(file_out_descriptor, "%02x", temp4);
             fprintf(file_out_descriptor, "\n");
            }
             


    }

    exception_handler(0);
    return 0;
}

