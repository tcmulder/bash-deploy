.TH PUT_DB 1
.SH NAME
put db \- puts the database onto the live server
.SH SYNOPSIS
.B put db
[\fB\-o\fR \fIORIGINSERVERNAME\fR]
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B put db
upon request drops the live database tables and imports the new database from the specified server's launch_db.sql file.
.SH OPTIONS
.TP
.BR \-o \fR
Identify the origin server.
.TP
.BR \-s \fR
Identify the target server.