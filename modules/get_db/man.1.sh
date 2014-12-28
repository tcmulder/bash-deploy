.TH GET DB 1
.SH NAME
get db \- gets database from the server
.SH SYNOPSIS
.B get db
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B get db
gets a mysqldump of the database from the specified server and places it in the db/ directory.
.SH OPTIONS
.TP
.BR \-s \fR
Identify the target server.