/* vim: set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab : */
/*
 * chk_validate - validate functions for checking JSON semantics
 *
 * "Because grammar and syntax alone do not make a complete language." :-)
 *
 * The concept of this file was developed by:
 *
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * "Because sometimes even the IOCCC Judges need some help." :-)
 */


#if !defined(INCLUDE_CHK_VALIDATE_H)
#    define  INCLUDE_CHK_VALIDATE_H


/*
 * entry_util - utilities supporting mkiocccentry JSON files
 */
#include "entry_util.h"

/*
 * json_util - general JSON parser utility support functions
 */
#include "json_util.h"

/*
 * json_sem - JSON semantics support
 */
#include "json_sem.h"

/*
 * chk_sem_auth - check .author.json semantics
 */
#include "chk_sem_auth.h"

/*
 * chk_sem_info - check .info.json semantics
 */
#include "chk_sem_info.h"


/*
 * external function declarations
 *
 * Functions not defined in chk_sem_auth.h nor in the chk_sem_info.h include files.
 */


#endif /* INCLUDE_CHK_VALIDATE_H */
