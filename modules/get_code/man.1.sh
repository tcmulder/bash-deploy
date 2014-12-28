.TH GET_CODE 1
.SH NAME
get code \- backs up code from the server
.SH SYNOPSIS
.B get code
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B get code
uses ssh to get a gzipped tar file backup of code from the specified server.
.SH OPTIONS
.TP
.BR \-s \fR
Identify the target server.