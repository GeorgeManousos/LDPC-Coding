#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp1, *fp2;
    char ch;
    int entries[42][52]; 
    int z_matrix[8][8] = { {2, 4, 8, 16, 32, 64, 128, 256}, {3, 6, 12, 24, 48, 96, 192, 384}, {5, 10, 20, 40, 80, 160, 320}, {7, 14, 28, 56, 112, 224}, {9, 18, 36, 72, 144, 288}, {11, 22, 44, 88, 176, 352}, {13, 26, 52, 104, 208}, {15, 30, 60, 120, 240} }; 
    int i, j, ils, Z;
    
    fp1 = fopen("BG2.csv", "r");
    if (fp1 == NULL) {
        printf("Error opening BG2 file!\n");
        return 1;
    }
    
    
    fp2 = fopen("NR_2_240.txt", "w");
    if (fp2 == NULL) {
        printf("Error opening output file!\n");
        return 1;
    }
    
  
  for(i=0; i<42; i++)
  {
  for(j=0; j<52; j++)     /* initializing all entries with -1 */
  entries[i][j] = -1;
  }
  
  ils = -1; /* indicates an invalid expansion factor Z */
  do
  {
  printf("Enter a valid value for expansion factor Z here: ");
  scanf("%d", &Z);
  for(i=0; i<8; i++)
  {
  for(j=0; j<8; j++)
  {
  /* printf("%d ", z_matrix[i][j]); */
  if(z_matrix[i][j] == Z)
  {
  ils = i;
  break;
  } 
  }
  
  /*printf("\n");*/
  }
  if(Z == 0)
  ils = -1;
  }while(ils == -1);
  
  printf("\nILS is: %d\n", ils);
  
  int words_read_per_row = 0;
  int k = 0;
  int row_index, col_index, vij_value;
  char vij_str[4] = {0};
  
  while((ch = fgetc(fp1)) != EOF)
  {
  
  if(words_read_per_row == 0)
  {
  if(ch == ' ')
  {
  vij_str[k] = 0;
  row_index = atoi(vij_str);
  words_read_per_row++;
  k = 0;
  }
  else
  {
  vij_str[k] = ch;
  k++;
  }
  }
  
  else if(words_read_per_row == 1)
  {
  if(ch == ' ')
  {
  vij_str[k] = 0;
  col_index = atoi(vij_str);
  words_read_per_row++;
  k = 0;
  }
  else
  {
  vij_str[k] = ch;
  k++;
  }
  }
  
  else if(words_read_per_row == (ils+2))
  {
  if(ch == ' ')
  {
  vij_str[k] = 0;
  vij_value = atoi(vij_str);
  entries[row_index][col_index] = vij_value % Z;
  words_read_per_row++;
  k = 0;
  }
  else if(ch == '\n')
  {
  vij_str[k] = 0;
  vij_value = atoi(vij_str);
  entries[row_index][col_index] = vij_value % Z;
  words_read_per_row = 0; /* we change line */
  k = 0;
  }
  else
  {
  vij_str[k] = ch;
  k++;
  }
  }
  
  else
  {
  if(ch == ' ')
  words_read_per_row++;
  else if(ch == '\n')
  words_read_per_row = 0;
  continue;
  }
  
  } 
  
  char str[4]; /* entries as strings */
  
  for(i=0; i<42; i++)
  {
  for(j=0; j<52; j++)
  {
  sprintf(str, "%d", entries[i][j]);
  fputs(str, fp2);
  fputc(' ', fp2);
  }
  fputc('\n', fp2);
  }
  
    fclose(fp1);
    fclose(fp2);

    printf("\nFile created successfully.\n");
    return 0;
}
