prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=@CMAKE_INSTALL_PREFIX@
libdir=@GTK_LIBDIR@
includedir=@CMAKE_INSTALL_PREFIX@/include
target=x11

libitmages_binary_version=@PACKAGE_VERSION@
libitmages_host=@CMAKE_HOST_SYSTEM_PROCESSOR@-@CMAKE_HOST_SYSTEM@

Name: @PROJECT@
Description: Library for GTK-based GUI for uploader to image hosting
Version: @PACKAGE_VERSION@
Requires: gtk+-@GTKVER@ atk cairo gdk-pixbuf-2.0 gio-2.0 pangoft2
Libs: -L@GTK_LIBDIR@ -l@LIBNAME@
Cflags: -I@CMAKE_INSTALL_PREFIX@/include -I@CMAKE_INSTALL_PREFIX@/include/@PROJECT@
