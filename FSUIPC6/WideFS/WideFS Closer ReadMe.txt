WideFS Closer.exe
=================

This is a small program which, when your WideFS clients are using
Wideclient.exe 6.963 or later, will get them to act as if the
Server has sent a Shut Down notice. If your Wideclient.INI files
are set to allow a shutdown, this will be acted upon. 

For this to operate, all the PCs involved must be using Windows
XP SP1 or any later Windows version, and they must all be in the
same Workgroup. Also, only those Wideclients running with
"ClassInstance=0" will close, because other instances aren't
receiving the Broadcasts -- you need to load and close those
instances using the Run and Close options in the main Client
which has ClassInstance=0.

WideFS Closer can be run from any such PC whether it is also
running WideClient or not -- it can even be running FS, which
is not affected.

This utility is useful to effect a graceful shutdown remotely
when the Server is not running, or when you want to keep it running
but have all the Clients shutdown.

----------------------------
Pete Dowson, 30th April 2012
----------------------------