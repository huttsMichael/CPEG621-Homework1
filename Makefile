infix: infix.tab.o lex.yy.o  
	gcc -o infix lex.yy.o infix.tab.o

lex.yy.o: infix.l
	flex infix.l; gcc -c infix.yy.c

infix.tab.o: infix.y
	bison -d infix.y; gcc -c infix.tab.c

cal: cal.tab.o lex.yy.o  
	gcc -o cal lex.yy.o cal.tab.o

lex.yy.o: cal.l
	flex cal.l; gcc -c lex.yy.c

cal.tab.o: cal.y
	bison -d cal.y; gcc -c cal.tab.c

clean:
	rm -f p2 cal.output *.o cal.tab.c lex.yy.c
