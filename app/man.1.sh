.TH ZEN 1
.SH NAME
zen \- runs the zen-deploy script
.SH SYNOPSIS
.B zen
[\fISUBCOMMANDS\fR] [\fIOPTIONS\fR]
.SH DESCRIPTION
.B zen
runs the given subcommand with the given options for the zen-deploy script.
.SH OPTIONS
.TP
.BR "connect" \fR
Connects to a server via SSH. See zen connect -h for full information.
.TP
.BR "far" \fR
Performs serialized find and replace on a database. See zen far -h for full information.
.TP
.BR "get code" \fR
Creates a code backup. See zen get code -h for full information.
.TP
.BR "get db" \fR
Creates a database backup. See zen get db -h for full information.
.TP
.BR "put code" \fR
Uses rsync to push code live. See zen put code -h for full information.
.TP
.BR "put db" \fR
Replaces a live database. See zen put db -h for full information.
.TP
.BR "put tar" \fR
Puts a tar file of code onto a server. See zen put tar -h for full information.
