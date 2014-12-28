.TH FAR 1
.SH NAME
far \- performs database find and replace.
.SH SYNOPSIS
.B far
[\fB\-o\fR \fIORIGINSERVERNAME\fR]
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B far
establishes a temporary database, uploads the specified origin database, performs a serialized find and replace from the origin url to the specified server url, performs a mysqldump of the result under the name launch_db.sql, and deletes the temporary database.
.SH OPTIONS
.TP
.BR \-o \fR
Identify the origin server.
.TP
.BR \-s \fR
Identify the target server.