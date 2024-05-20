#! /bin/bash
source tests/utils_functions.sh

CC=cc
CFLAGS="-Wall -Wextra -Werror -Wunreachable-code"
INCLUDES="-Iincludes -Ilib/libft/includes -Itests/includes"
LIBRARIES="-Llib/libft -lft"
DEBUG="-g3"
if [[ "$1" == "d" || "$2" == "d" ]]; then
	CFLAGS="$CFLAGS $DEBUG"
	echo -e "\x1b[1;33mDebug mode enabled\x1b[0m"
fi
if [[ "$(uname)" == "Linux" ]]; then
	MANUALLY_ADDED_LIBFT="lib/libft/libft.a"
fi


PARSER_FILES="src/parser/parser.c src/parser/ft_create_tokens.c\
	src/parser/create_tokens_utilities.c src/parser/ft_tokenize_pipe.c\
	tests/src/unit_tests_utils.c"

function run_parser_test_1
{
	for TEST_NUMBER in {1..5};
	do
	$CC $CFLAGS $INCLUDES $LIBRARIES $PARSER_FILES tests/src/test_parser.c -DTEST=$TEST_NUMBER $MANUALLY_ADDED_LIBFT
	if [[ "$(uname)" == "Linux" ]]; then
		run_valgrind parser $TEST_NUMBER
	fi
	./a.out >> tests/logs/result_parser.log
	if [[ $1 -ge 1 && $1 -le 5 ]]; then
		$CC $CFLAGS $INCLUDES $LIBRARIES $PARSER_FILES tests/src/test_parser.c -DTEST=$1 $MANUALLY_ADDED_LIBFT
		echo -e "\x1b[1;33mTest $1 ready for debug\x1b[0m"
	fi
	done
}

function run_parser_test_2
{
	for TEST_NUMBER in {6..10};
	do
	$CC $CFLAGS $INCLUDES $LIBRARIES $PARSER_FILES tests/src/test_parser_2.c -DTEST=$TEST_NUMBER $MANUALLY_ADDED_LIBFT
	if [[ "$(uname)" == "Linux" ]]; then
		run_valgrind parser $TEST_NUMBER
	fi
	./a.out >> tests/logs/result_parser.log
	done
	if [[ $1 -ge 6 && $1 -le 10 ]]; then
		$CC $CFLAGS $INCLUDES $LIBRARIES $PARSER_FILES tests/src/test_parser_2.c -DTEST=$1 $MANUALLY_ADDED_LIBFT
		echo -e "\x1b[1;33mTest $1 ready for debug\x1b[0m"
	fi
}

if [[ $1 != "SOURCE" ]]; then
	check_norminette
	prepare_logs_dir
	make test
	./test
	make -s lib/libft/libft.a
	echo -e "====\t\t\t\t$(date +%d\ %b\ %Y\ @\ %T)\t\t\t\t====" > tests/logs/result_parser.log
	run_parser_test_1
	run_parser_test_2
	# NEXT TESTS TO BE ADDED HERE
		# echo 1&&echo 2
		#	EXPECTED: 1\n2
		# echo "1&&"echo 2
		#	EXPECTED: 1&&echo 2
	echo -e "====\t\t\t\t\tEND of the log\t\t\t\t\t====" >> tests/logs/result_parser.log
	feedback
	$RM a.out
fi