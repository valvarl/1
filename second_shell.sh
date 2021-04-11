# valvarl & valsof

message="# valvarl & valsof\n\necho \\\"// valvarl & valsof\n\n#include <stdio.h>\n\nint main()\n{\nprintf(\\\\\\\"Hello world!\\\\\\\\n\\\\\\\");\nreturn 0;\n}\n\n\\\" > \\\"123.c\\\"\n\ngcc -Wall 123.c -o 123\n./123\n"

echo "// valvarl & valsof

#include <stdio.h>
#include <stdlib.h>

int main()
{
	char * message = \"$message\";
	char * filename = \"first_shell.sh\";
	FILE *fp;

	if ((fp= fopen(filename, \"w\"))==NULL)
	{
		return -1;
	}
	fputs(message, fp);
	fclose(fp);
	int status = system(\"bash first_shell.sh\");
	return status;
}
" > "321.c"
gcc -Wall 321.c -o 321
./321

