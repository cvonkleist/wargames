#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
	char server[20] = "wwwsearch.bing.com";
	int result_count;
	char query[20];
	char command[100];
	char buffer[10000];
	FILE *fp = NULL;

	printf("type a search string that gets exactly 1,337 results\n> ");
	scanf("%s", &query);

	sprintf(command, "curl -s http://%s/search?q=%s", server, query);
	printf("executing command: %s\n", command);

	fp = popen(command, "r");
	if (fp == NULL) {
		printf("command failed\n");
		exit(1);
	}

	fread(buffer, 1, 9999, fp);
	if(strstr(buffer, "1,337 results") == NULL)
		printf("FAIL");
	else
		system("/bin/sh");

	return 0;
}
