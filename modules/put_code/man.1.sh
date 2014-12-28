.TH PUT_CODE 1
.SH NAME
put code \- puts code on the server via rsync
.SH SYNOPSIS
.B put code
[\fB\-o\fR \fIORIGINSERVERNAME\fR]
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B put code
unzips the origin code and performs an rsync with the specified server using the dry run option.
After outputing what the results would have been, it asks if it should perform the rsync without the
dry run option and does so if requested.
.SH OPTIONS
.TP
.BR \-o \fR
Identify the origin server.
.TP
.BR \-s \fR
Identify the target server.