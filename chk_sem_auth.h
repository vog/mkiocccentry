/*
 * chk_sem_auth - check .author.json semantics
 *
 * "Because grammar and syntax alone do not make a complete language." :-)
 *
 * The concept of this file was developed by:
 *
 *	chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
 *
 * This file was auto-generated by:
 *
 *	make chk_sem_auth.h
 */


#if !defined(INCLUDE_CHK_SEM_AUTH_H)
#    define  INCLUDE_CHK_SEM_AUTH_H


/*
 * json_sem - JSON semantics support
 */
#include "json_sem.h"


#if !defined(SEM_AUTH_LEN)

#define SEM_AUTH_LEN (40)

extern struct json_sem sem_auth[SEM_AUTH_LEN+1];

extern bool chk_affiliation(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_author_handle(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_author_number(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_default_handle(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_email(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_github(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_location_code(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_location_name(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_name(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_past_winner(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_twitter(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_url(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_author_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_contest(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_contest_id(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_IOCCC_year(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_author_count(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_authors(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_chkentry_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_entry_num(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_fnamchk_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_UTC(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_timestamp(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_formed_timestamp_usec(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_min_timestamp(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_mkiocccentry_version(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_no_comment(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_tarball(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_test_mode(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);
extern bool chk_timestamp_epoch(struct json const *node,
	unsigned int depth, struct json_sem *sem, struct json_sem_val_err **val_err);

#endif /* SEM_AUTH_LEN */


#endif /* INCLUDE_CHK_SEM_AUTH_H */
