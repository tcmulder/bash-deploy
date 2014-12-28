.TH PUT_TAR 1
.SH NAME
put tar \- puts a tar file of code on the server
.SH SYNOPSIS
.B put tar
[\fB\-o\fR \fIORIGINSERVERNAME\fR]
[\fB\-s\fR \fISERVERNAME\fR]
.SH DESCRIPTION
.B put tar
puts a gzipped tar file of the origin server's code onto the specified server at that the root of the website for that server.
It then connects via ssh and cds to that file's location on the server.
.SH OPTIONS
.TP
.BR \-o \fR
Identify the origin server.
.TP
.BR \-s \fR
Identify the target server.