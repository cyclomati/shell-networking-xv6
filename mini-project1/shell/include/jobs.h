#ifndef JOBS_H
#define JOBS_H

#include <sys/types.h>

/* States */
#define JOB_RUNNING 0
#define JOB_STOPPED 1
#define JOB_DONE    2

typedef struct job {
    int   jobno;          /* job number (1..N, newest increases) */
    pid_t pid;            /* process id */
    char  name[256];      /* command name */
    int   state;          /* JOB_RUNNING / JOB_STOPPED / JOB_DONE */
    struct job *next;     /* linked list */
} job_t;

/* Core job APIs used across the shell */
void add_job(pid_t pid, const char *cmd);
void jobs_list(void);
void jobs_check_and_report(void);
void jobs_kill_all(void);
int  get_last_job_id(void);
void jobs_mark_stopped(pid_t pid, const char *cmd, int *jobno_out);

/* Bring a job to foreground / resume in background (fg/bg builtins) */
int  jobs_fg(int jobno);      /* 0 ok, non-zero => “No such job” */
int  jobs_bg(int jobno);      /* 0 ok, -2 => “Job already running”, other non-zero => “No such job” */

/* E.1 activities: print “[pid] : command_name - State” sorted by name */
void jobs_activities(void);

/* Snapshot helper:
   Fill arr with pointers to currently active (Running/Stopped) jobs, up to max.
   Returns the number stored (<= max). */
int  jobs_snapshot(job_t **arr, int max);

#endif /* JOBS_H */