rem Bison command
bison -d Parser.y

rem Flex command
flex Parser.l

rem GCC commands
gcc -c lex.yy.c -o lex.yy.o
gcc -c Parser.tab.c -o Parser.tab.o

rem Linking
gcc lex.yy.o Parser.tab.o -o myParser.exe

rem clear (comentario)
rem Run the parser
myParser.exe Ejemplo.xml