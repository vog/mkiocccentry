/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */

/* JSON parser - bison grammar
 *
 * XXX This is VERY incomplete but the .info.json and .author.json files
 * generated by mkiocccentry do not cause any errors. No parse tree is generated
 * yet and so no verification is done yet either.
 *
 * There are no actions yet. I'm not sure when I will be adding the actions and
 * it's very likely that I won't add all at once.
 *
 * Before the parser can be complete there are still some other things that have
 * to be done. All of this is a work in progress!
 *
 * XXX Once the parser is done test older versions of both bison and flex to see
 * if they can generate the proper code.
 */

/* Section 1: Declarations */

/*
 * We enable verbose error messages during development but once the parser is
 * complete we will disable this as it's very verbose.
 *
 * NOTE: Previously we used the -D option to bison because the %define is not
 * POSIX Yacc portable but we no longer do that because we make use of another
 * feature that's not POSIX Yacc portable that we deem worth it as it produces
 * easier to read error messages.
 */
%define parse.error verbose
/*
 * We enable lookahead correction parser for improved errors
 */
%define parse.lac full


/*
 * We use our struct json (see json.h for its definition) instead of bison
 * %union.
 */
%define api.value.type {struct json}


/*
 * An IOCCC satirical take on bison and flex
 *
 * As we utterly object to the hideous code that bison and flex generate we
 * point it out in an ironic way by changing the prefix yy to ugly_ so that
 * bison actually calls itself ugly. This is satire for the IOCCC (although we
 * still believe that bison generates ugly code)!
 *
 * This means that to access the struct json's union type in the lexer we can do
 * (because the prefix is ugly_ as described above):
 *
 *	ugly_lval.type = ...
 *
 * A negative consequence here is that because of the api.prefix being set to
 * ugly_ there's a typedef that _might_ suggest that _our_ struct json is ugly:
 *
 *	typedef struct json UGLY_STYPE;
 *
 * At first glance this is a valid concern. However we argue that even if this
 * is so the struct might well have to be ugly because it's for a json parser; a
 * json parser necessarily has to be ugly due to the spec: one could easily be
 * forgiven for wondering if the authors of the json specification were on drugs
 * at the time of writing them!
 *
 * Please note that we're _ABSOLUTELY NOT_ saying that they were and we use the
 * term very loosely as well: we do not want to and we are not accusing anyone
 * of being on drugs (we rather find addiction a real tragedy and anyone with an
 * addiction should be treated well and given the help they need) but the fact
 * is that the JSON specification is barmy and those who are in favour of it
 * must surely be in the JSON Barmy Army (otherwise known as the Barmy Army
 * Jointly Staying On Narcotics :-)).
 *
 * Thus as much as we find the specification objectionable we rather feel sorry
 * for those poor lost souls who are indeed in the JSON Barmy Army and we
 * apologise to them in a light and fun way and with hope that they're not
 * terribly humour impaired. :-)
 *
 * BTW: If you want to see all the symbols (re?)defined to something ugly run:
 *
 *	grep -i '#[[:space:]]*define[[:space:]].*ugly_' *.c
 *
 * after generating the files; and if you want to see only what was changed from
 * yy or YY to refer to ugly_ or UGLY_:
 *
 *	grep -i '#[[:space:]]*define[[:space:]]*yy.*ugly_' *.c
 *
 * This will help you find the right symbols should you need them. If (as is
 * likely to happen) the parser is split into another repo for a json parser by
 * itself I will possibly remove this prefix: this is as satire for the IOCCC
 * (though we all believe that the generated code is in fact ugly).
 *
 * WARNING: Although we use the prefix ugly_ the scanner and parser will at
 * times refer to yy and YY and other times refer to ugly_ and UGLY_ (partly
 * because WE refer to ugly_ and UGLY_). So if you're trying to sift through
 * that ugly spaghetti code (which we strongly recommend you do not do as it will
 * likely cause nightmares and massive brain pain) you'll want to check yy/YY as
 * well as ugly_/UGLY_. But really you oughtn't try and go through that code so
 * you need only pay attention to the ugly_ and UGLY_ prefixes (in the *.l and
 * *.y files) which again are satire for the IOCCC. See also the apology in the
 * generated files or directly looking at sorry.tm.ca.h.
 */
%define api.prefix {ugly_}

%{
#include <inttypes.h>
#include <stdio.h>
#include <unistd.h> /* getopt */
#include "jparse.h"

bool output_newline = true;		/* true ==> -n not specified, output new line after each arg processed */
unsigned num_errors = 0;		/* > 0 number of errors encountered */
struct json tree = { 0 };		/* the parse tree */

/* debug information during development */
int ugly_debug = 1;

int token = 0;
%}


/*
 * Terminal symbols (token kind)
 *
 * For most of the terminal symbols we use string literals to identify them as
 * this makes it easier to read error messages. This feature is not POSIX Yacc
 * compatible but we've decided that the benefit outweighs this fact.
 */
%token JSON_OPEN_BRACE "{"
%token JSON_CLOSE_BRACE "}"
%token JSON_OPEN_BRACKET "["
%token JSON_CLOSE_BRACKET "]"
%token JSON_COMMA ","
%token JSON_COLON ":"
%token JSON_NULL "null"
%token JSON_TRUE "true"
%token JSON_FALSE "false"
%token JSON_STRING
%token JSON_NUMBER
%token JSON_INVALID_TOKEN


/*
 * Section 2: Rules
 *
 * See https://www.json.org/json-en.html for the JSON specification. We have
 * tried to make the below grammar as close to the JSON specification as
 * possible for those who are familiar with it but there might be some minor
 * differences in order or naming. One that we do not have is whitespace but
 * that's not needed and would actually cause many complications and parsing
 * errors. There are some others we do not need to include as well.
 *
 * XXX All the rules should be here but not all those that need actions have
 * actions. We also don't use the tree though we do refer to it in the
 * parse_json_() functions (some of which might have to change). The actions are
 * very much subject to change!
 */
%%
json:		/* empty */
		| json_element
		;

json_value:	  json_object
		| json_array
		| json_string
		| json_number
		| JSON_TRUE { $$ = *parse_json_bool(ugly_text, &tree); }
		| JSON_FALSE { $$ = *parse_json_bool(ugly_text, &tree); }
		| JSON_NULL { $$ = *parse_json_null(ugly_text, &tree); }
		;

json_object:	JSON_OPEN_BRACE json_members JSON_CLOSE_BRACE
		| JSON_OPEN_BRACE JSON_CLOSE_BRACE { $$ = *json_create_object(); }
		;

json_members:	json_member
		| json_member JSON_COMMA json_members
		;

json_member:	json_string JSON_COLON json_element { $$ = *parse_json_member(&$1, &$3, &tree); }
		;

json_array:	JSON_OPEN_BRACKET json_elements JSON_CLOSE_BRACKET
		| JSON_OPEN_BRACKET JSON_CLOSE_BRACKET { $$ = *json_create_array(); }
		;

json_elements:	json_element
		| json_element JSON_COMMA json_elements
		;

json_element:	json_value
		;

json_string:	JSON_STRING { $$ = *parse_json_string(ugly_text, &tree); }

json_number:	JSON_NUMBER { $$ = *parse_json_number(ugly_text, &tree); }
		;




%%
/* Section 3: C code */

/*
 * XXX - most of main() should be moved to another file - XXX
 */
int
main(int argc, char **argv)
{
    char const *program = NULL;	    /* our name */
    extern char *optarg;	    /* option argument */
    extern int optind;		    /* argv index of the next arg */
    bool string_flag_used = false;  /* true ==> -S string was used */
    int ret;			    /* libc return code */
    int i;


    /*
     * XXX for development purposes we override the initial json_verbosity_level
     * to JSON_DBG_LEVEL. This is used in json_vdbg() which is called by
     * json_dbg().
     *
     * This variable is used because it means we don't have to see debug
     * information unrelated to json if we don't want to - and it also prevents
     * the problem of other tools having this information printed if they don't
     * want it.
     *
     * On the other hand it also prevents other tools from seeing this
     * information until an option is added to set this level. I chose -J as
     * this seems like a good choice: with the exception of mkiocccentry no
     * other tool uses -j or -J and -J is a good letter for JSON specific
     * options. If mkiocccentry ever will need this option (which I can imagine
     * might well happen) another letter will have to be decided upon possibly
     * for all the tools.
     *
     * NOTE: This debug information is outside of the parser so until debugging
     * information in the parser is disabled you'll still see that upon using
     * jparse.
     *
     * NOTE: Because -s string parses the string at the time of seeing it one
     * must specify -J prior to -s if they want to change the debug level.
     */
    json_verbosity_level = JSON_DBG_LEVEL;
    /*
     * parse args
     */
    program = argv[0];
    while ((i = getopt(argc, argv, "hv:qVns:J:")) != -1) {
	switch (i) {
	case 'h':		/* -h - print help to stderr and exit 0 */
	    usage(2, "-h help mode", program); /*ooo*/
	    not_reached();
	    break;
	case 'v':		/* -v verbosity */
	    /*
	     * parse verbosity
	     */
	    verbosity_level = parse_verbosity(program, optarg);
	    break;
	case 'J': /* -J json_verbosity_level */
	    /*
	     * parse json verbosity level
	     */
	    json_verbosity_level = parse_verbosity(program, optarg);
	    break;
	case 'q':
	    msg_warn_silent = true;
	    ugly_debug = 0;
	    break;
	case 'V':		/* -V - print version and exit */
	    errno = 0;		/* pre-clear errno for warnp() */
	    ret = printf("%s\n", JPARSE_VERSION);
	    if (ret <= 0) {
		warnp(__func__, "printf error printing version string: %s", JPARSE_VERSION);
	    }
	    exit(0); /*ooo*/
	    not_reached();
	    break;
	case 'n':
	    output_newline = false;
	    break;
	case 's':
	    /*
	     * So we don't trigger missing arg. Maybe there's another way but
	     * nothing is coming to my mind right now.
	     */
	    string_flag_used = true;

	    json_dbg(JSON_DBG_LEVEL, __func__, "Calling parse_json_block(\"%s\"):", optarg);
	    /* parse arg as a block of json input */
	    parse_json_block(optarg);
	    break;
	default:
	    usage(2, "invalid -flag or missing option argument", program); /*ooo*/
	    not_reached();
	}
    }

    /* perform IOCCC sanity checks */
    ioccc_sanity_chks();

    /*
     * case: process arguments on command line
     */
    if (argc - optind > 0) {

	/*
	 * process each argument in order
	 */
	for (i=optind; i < argc; ++i) {
	    json_dbg(JSON_DBG_LEVEL, __func__, "Calling parse_json_file(\"%s\"):", argv[i]);
	    parse_json_file(argv[i]);
	}

    } else if (!string_flag_used) {
	usage(2, "-s string was not used and no file specified", program); /*ooo*/
	not_reached();
    }


    /*
     * All Done!!! - Jessica Noll, age 2
     */
    exit(num_errors != 0); /*ooo*/
}

/* ugly_error	- generate an error message for the scanner/parser
 *
 * given:
 *
 *	format	    printf style format string
 *	...	    optional parameters based on the format
 *
 */
void
ugly_error(char const *format, ...)
{
    va_list ap;

    va_start(ap, format);

    /*
     * We use fprintf and vfprintf instead of err() but in the future this might
     * use an error function of some kind, perhaps a variant of jerr() (a
     * variant because the parser cannot provide all the information that the
     * jerr() function expects). In the validation code we will likely use
     * jerr(). It's possible that the function jerr() will change as well but
     * this will be decided after the parser is complete.
     */
    fprintf(stderr, "JSON parser error on line %d: ", ugly_lineno);
    vfprintf(stderr, format, ap);
    fprintf(stderr, "\n");

    va_end(ap);
}

/*
 * XXX - the parse_json_() functions don't yet link the structs into the tree - XXX
 * XXX - the parameters might or might not have to change - XXX
 */


/* parse_json_string - parse a json string
 *
 * given:
 *
 *	string	    - the text that triggered the action
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json with the converted string.
 *
 * NOTE: This function does not return if passed a NULL string.
 *
 * XXX - should this function return if conversion failed ? - XXX
 *
 * TODO add to parse tree if != NULL
 */
struct json *
parse_json_string(char const *string, struct json *ast)
{
    struct json *str = NULL;
    struct json_string *item = NULL;

    /*
     * firewall
     */
    if (string == NULL) {
	err(35, __func__, "passed NULL string");
	not_reached();
    }

    json_dbg(JSON_DBG_LEVEL, __func__, "about to parse string: <%s>", string);
    /*
     * we say that quote == true because the pattern in the lexer will include
     * the '"'s.
     */
    str = json_conv_string_str(string, NULL, true);
    /* paranoia - these tests should never result in an error */
    if (str == NULL) {
        err(36, __func__, "converting JSON string returned NULL: <%s>", string);
        not_reached();
    } else if (str->type != JTYPE_STRING) {
        err(37, __func__, "expected JTYPE_STRING, found type: %s", json_element_type_name(str->type));
        not_reached();
    }
    item = &(str->element.string);
    if (!item->converted) {
	/* XXX should this be a fatal error ? */
	warn(__func__, "couldn't decode string: <%s>", string);
    } else {
        json_dbg(JSON_DBG_LEVEL, __func__, "decoded string: <%s>", item->str);
    }

    /* XXX Are there any other checks that have to be done ? */

    /* TODO add to parse tree if != NULL */
    if (ast != NULL) {
    }

    return str;
}

/* parse_json_bool - parse a json bool
 *
 * given:
 *
 *	string	    - the text that triggered the action
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json with the converted boolean.
 *
 * NOTE: This function does not return if passed a NULL string or conversion
 * fails.
 */
struct json *
parse_json_bool(char const *string, struct json *ast)
{
    struct json *boolean = NULL;
    struct json_boolean *item = NULL;

    /*
     * firewall
     */
    if (string == NULL) {
	err(38, __func__, "passed NULL string");
	not_reached();
    }

    boolean = json_conv_bool_str(string, NULL);
    /* paranoia - these tests should never result in an error */
    if (boolean == NULL) {
	err(39, __func__, "converting JSON bool returned NULL: <%s>", string);
	not_reached();
    } else if (boolean->type != JTYPE_BOOL) {
        err(40, __func__, "expected JTYPE_BOOL, found type: %s", json_element_type_name(boolean->type));
        not_reached();
    }
    item = &(boolean->element.boolean);
    if (!item->converted) {
	/*
	 * XXX json_conv_bool_str() calls json_conv_bool() which will warn if the
	 * boolean is neither true nor false. We know that this function should never
	 * be called on anything but the strings "true" or "false" and since the
	 * function will abort if NULL is returned we should check if
	 * boolean->converted == true.
	 *
	 * If it's not we abort as there's a serious mismatch between the
	 * scanner and the parser.
	 */
	err(41, __func__, "called on non-boolean string: <%s>", string);
	not_reached();
    } else if (item->as_str == NULL) {
	/* extra sanity check - make sure the allocated string != NULL */
	err(42, __func__, "boolean->as_str == NULL");
	not_reached();
    } else if (strcmp(item->as_str, "true") && strcmp(item->as_str, "false")) {
	/*
	 * extra sanity check - make sure the allocated string is either "true"
	 * or "false"
	 */
	err(43, __func__, "boolean->as_str neither \"true\" nor \"false\"");
	not_reached();
    } else {
	/*
	 * extra sanity checks - convert back and forth as string to bool and
	 * bool to string and make sure everything matches.
	 */
	char const *str = booltostr(item->value);
	bool tmp = false;
	if (str == NULL) {
	    err(44, __func__, "could not convert boolean->value back to a string");
	    not_reached();
	} else if (strcmp(str, item->as_str)) {
	    err(45, __func__, "boolean->as_str != item->value as a string");
	    not_reached();
	} else if ((tmp = strtobool(item->as_str)) != item->value) {
	    err(46, __func__, "mismatch between boolean string and converted value");
	    not_reached();
	} else if ((tmp = strtobool(str)) != item->value) {
	    err(47, __func__, "mismatch between converted string value and converted value");
	    not_reached();
	}
	/* only if we get here do we assume everything is okay */
	json_dbg(JSON_DBG_LEVEL, __func__, "<%s> -> %s", string, booltostr(item->value));
    }

    if (ast != NULL) {
	/* TODO add to parse tree if != NULL */
    }

    return boolean;
}

/* parse_json_null - parse a json null
 *
 * given:
 *
 *	string	    - the text that triggered the action
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json unless conversion fails.
 *
 * NOTE: This function does not return if passed a NULL string or if null
 * becomes NULL :-)
 *
 * XXX - should this function return if conversion failed ? - XXX
 */
struct json *
parse_json_null(char const *string, struct json *ast)
{
    struct json *null = NULL;
    struct json_null *item = NULL;

    /*
     * firewall
     */
    if (string == NULL) {
	err(48, __func__, "passed NULL string");
	not_reached();
    }

    null = json_conv_null_str(string, NULL);

    /*
     * null should not be NULL :-)
     */
    if (null == NULL) {
	err(49, __func__, "null ironically should not be NULL but it is :-)");
	not_reached();
    } else if (null->type != JTYPE_NULL) {
        err(50, __func__, "expected JTYPE_NULL, found type: %s", json_element_type_name(null->type));
        not_reached();
    }
    item = &(null->element.null);
    if (!item->converted) {
	/* XXX should this be a fatal error ? */
	warn(__func__, "couldn't convert null: <%s>", string);
    } else {
        json_dbg(JSON_DBG_LEVEL, __func__, "convert null: <%s> -> null", string);
    }


    if (ast != NULL) {
	/* TODO add to parse tree if != NULL */
    }

    return null;
}



/* parse_json_number - parse a json number
 *
 * given:
 *
 *	string	    - the text that triggered the action
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json.
 *
 * NOTE: This function does not return if passed a NULL string.
 *
 * XXX - should the function return on conversion error ? - XXX
 */
struct json *
parse_json_number(char const *string, struct json *ast)
{
    struct json *number = NULL;
    struct json_number *item = NULL;

    /*
     * firewall
     */
    if (string == NULL) {
	err(51, __func__, "passed NULL string");
	not_reached();
    }
    number = json_conv_number_str(string, NULL);
    /* paranoia - these tests should never result in an error */
    if (number == NULL) {
	err(52, __func__, "converting JSON number returned NULL: <%s>", string);
        not_reached();
    } else if (number->type != JTYPE_NUMBER) {
        err(53, __func__, "expected JTYPE_NUMBER, found type: %s", json_element_type_name(number->type));
        not_reached();
    }
    item = &(number->element.number);
    if (!item->converted) {
	/* XXX should this be a fatal error ? */
	warn(__func__, "couldn't convert number string: <%s>", string);
    } else {
        json_dbg(JSON_DBG_LEVEL, __func__, "convert number string: <%s>", item->as_str);
    }

    if (ast != NULL) {
	/* TODO add to parse tree if != NULL */
    }

    return number;
}


/* parse_json_array - parse a json array
 *
 * given:
 *
 *	string	    - the text that triggered the action
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json.
 *
 * NOTE: This function does not return if passed a NULL string.
 *
 * XXX This function is not finished. All it does now is return a struct json *
 * (which will include a dynamic array) but which right now is actually NULL. It
 * might be that the function will take different parameters as well and the
 * names of the parameters and the function are also subject to change.
 *
 * XXX - should the function return on conversion error ? - XXX
 */
struct json *
parse_json_array(char const *string, struct json *ast)
{
    struct json *array = NULL;

    /*
     * firewall
     */
    if (string == NULL) {
	err(54, __func__, "passed NULL string");
	not_reached();
    }

    /* TODO add parsing of array */

    if (ast != NULL) {
	/* TODO add to parse tree if != NULL */
    }
    return array;
}


/* parse_json_member - parse a json member
 *
 * given:
 *
 *	name	    - the struct json * name of the member
 *	value	    - the struct json * value of the member
 *	ast	    - the tree to link the struct json * into if not NULL
 *
 * Returns a pointer to a struct json.
 *
 * NOTE: This function does not return if passed a NULL name or value.
 *
 * XXX - should the function return on conversion error ? - XXX
 */
struct json *
parse_json_member(struct json *name, struct json *value, struct json *ast)
{
    struct json *member = NULL;
    struct json_member *item = NULL;

    /*
     * firewall
     */
    if (name == NULL || value == NULL) {
	err(55, __func__, "passed NULL name and/or value");
	not_reached();
    }

    member = json_conv_member(name, value);
    /* paranoia - these tests should never result in an error */
    if (member == NULL) {
	err(56, __func__, "converting JSON member returned NULL");
	not_reached();
    } else if (member->type != JTYPE_MEMBER) {
        err(57, __func__, "expected JTYPE_MEMBER, found type: %s", json_element_type_name(member->type));
        not_reached();
    }
    item = &(member->element.member);
    if (!item->converted) {
	/* XXX should this be a fatal error ? */
	warn(__func__, "couldn't convert member");
    } else {
        json_dbg(JSON_DBG_LEVEL, __func__, "converted member");
    }


    if (ast != NULL) {
	/* TODO add to parse tree if != NULL */
    }

    return member;
}

/*
 * usage - print usage to stderr
 *
 * Example:
 *      usage(3, "missing required argument(s), program: %s", program);
 *
 * given:
 *	exitcode        value to exit with
 *	str		top level usage message
 *	program		our program name
 *
 * NOTE: We warn with extra newlines to help internal fault messages stand out.
 *       Normally one should NOT include newlines in warn messages.
 *
 * This function does not return.
 *
 * XXX - this function does not belong in this file - XXX
 */
static void
usage(int exitcode, char const *str, char const *prog)
{
    /*
     * firewall
     */
    if (str == NULL) {
	str = "((NULL str))";
	warn(__func__, "\nin usage(): program was NULL, forcing it to be: %s\n", str);
    }
    if (prog == NULL) {
	prog = "((NULL prog))";
	warn(__func__, "\nin usage(): program was NULL, forcing it to be: %s\n", prog);
    }

    /*
     * print the formatted usage stream
     */
    fprintf_usage(DO_NOT_EXIT, stderr, "%s\n", str);
    fprintf_usage(exitcode, stderr, usage_msg, prog, DBG_DEFAULT, JSON_DBG_LEVEL, JPARSE_VERSION);
    exit(exitcode); /*ooo*/
    not_reached();
}
