dnl Process this file with autoconf to produce a configure script.
dnl $Id$

# Init.
AC_PREREQ(2.57)
AC_INIT(TiLP, 6.72, [tilp-users@lists.sourceforge.net])

AM_INIT_AUTOMAKE([dist-bzip2])
AM_MAINTAINER_MODE

AC_PREFIX_DEFAULT(/usr)

dnl Files to configure.
AC_CONFIG_SRCDIR([src/main.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([
  Makefile
  build/Makefile
  desktop/Makefile
  glade/Makefile
  help/Makefile
  icons/Makefile
  intl/Makefile
  man/Makefile
  misc/Makefile
  pixmaps/Makefile
  po/Makefile.in
  registry/Makefile
  src/Makefile
  tilp.lsm
  tilp.spec
])

AC_MSG_CHECKING([for something to drink while compiling])
AC_MSG_RESULT([err: no fridge found!])

# Setup libtool.
AC_DISABLE_STATIC
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

# Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
AC_PROG_LN_S
AC_ISC_POSIX
AC_PROG_AWK

# Checks for libraries.
AM_GNU_GETTEXT
AM_GNU_GETTEXT_VERSION(0.13.1)

PKG_CHECK_MODULES(TICABLES, ticables >= 3.8.0)
AC_SUBST(TICABLES_CFLAGS)
AC_SUBST(TICABLES_LIBS)

PKG_CHECK_MODULES(TIFILES, tifiles >= 0.5.7)
AC_SUBST(TIFILES_CFLAGS)
AC_SUBST(TIFILES_LIBS)

PKG_CHECK_MODULES(TICALCS, ticalcs >= 4.5.2)
AC_SUBST(TICALCS_CFLAGS)
AC_SUBST(TICALCS_LIBS)

PKG_CHECK_MODULES(GLIB, glib-2.0 >= 2.0.0)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)

PKG_CHECK_MODULES(GTK, gtk+-2.0 >= 2.0.0)
AC_SUBST(GTK_CFLAGS)
AC_SUBST(GTK_LIBS)

PKG_CHECK_MODULES(GLADE, libglade-2.0 >= 1.99.0)
AC_SUBST(GLADE_CFLAGS)
AC_SUBST(GLADE_LIBS)

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h string.h unistd.h])
AC_CHECK_HEADERS([tilp/ticables.h tilp/ticalcs.h tilp/tifiles.h tilp/macros.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_HEADER_STAT
AC_TYPE_UID_T
AC_TYPE_MODE_T
AC_TYPE_OFF_T
AC_STRUCT_TM

# Checks for library functions.
AC_PROG_GCC_TRADITIONAL
AC_FUNC_MALLOC
AC_TYPE_SIGNAL
AC_FUNC_STAT
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([getcwd memset mkdir strcasecmp strchr strdup strrchr strstr strtol])

# pass some variables to  plugins
tilp_plugin_dir='${libdir}/tilp'
AC_SUBST(tilp_plugin_dir)
tilp_pixmap_dir='${datadir}/tilp/pixmaps'
AC_SUBST(tilp_pixmap_dir)

# Option to allow user to go outside his home directory.
AC_ARG_ENABLE(exit-homedir,
  AC_HELP_STRING([--enable-exit-homedir], [allow user to go outside his home directory]),
  [tilp_cv_enable_exit_homedir=$enableval], [])
AC_CACHE_CHECK([whether to allow user to go outside his home directory],
  [tilp_cv_enable_exit_homedir], [tilp_cv_enable_exit_homedir=no])
if test x$tilp_cv_enable_exit_homedir = xyes; then
  AC_DEFINE(ALLOW_EXIT_HOMEDIR, 1, [Define to 1 to allow user to go outside his home directory.])
fi

# Platform specific tests.
dnl AC_CANONICAL_HOST
case "$host" in
  *-*-mingw*) ARCH="-D__WIN32__ -D__MINGW32__" ;;
  *-*-cygwin) ARCH="-D__WIN32__ -D__CYGWIN__ -mno-cygwin" ;;
  *-*-*bsd*)  ARCH="-D__BSD__" ;;
  *)          ARCH="-D__LINUX__" ;;
esac
CFLAGS="$CFLAGS $ARCH"

# Ensure MSVC-compatible struct packing convention is used when
# compiling for Win32 with gcc.
# What flag to depends on gcc version: gcc3 uses "-mms-bitfields", while
# gcc2 uses "-fnative-struct".
case $host_os in
*mingw*|*cygwin*)
  if test x$GCC = xyes; then
    msnative_struct=''
    AC_MSG_CHECKING([how to get MSVC-compatible struct packing])
    if test -z "$ac_cv_prog_CC"; then
      our_gcc="$CC"
    else
      our_gcc="$ac_cv_prog_CC"
    fi
    case `$our_gcc --version | sed -e 's,\..*,.,' -e q` in
      2.)
        if $our_gcc -v --help 2>/dev/null | grep fnative-struct >/dev/null; then
          msnative_struct='-fnative-struct'
        fi
        ;;
      *)
        if $our_gcc -v --help 2>/dev/null | grep ms-bitfields >/dev/null; then
          msnative_struct='-mms-bitfields'
        fi
        ;;
    esac
    if test x"$msnative_struct" = x ; then
      AC_MSG_RESULT([no way])
      AC_MSG_WARN([produced libraries might be incompatible with MSVC-compiled code])
    else
      CFLAGS="$CFLAGS $msnative_struct"
      AC_MSG_RESULT([${msnative_struct}])
    fi
  fi
  ;;
esac

# Output.
AC_OUTPUT

echo "Now, you can type 'make' and 'make install'."

if test x$tilp_cv_enable_exit_homedir = xyes; then
 echo ""
 echo "The 'exit HOME dir' facility is now enabled as default behaviour."
 echo "Please keep in mind tha this is not secure..."
 echo ""
else
 echo ""
 echo "If you are a single user and you want to move in your filesystem, "
 echo "you can choose to add the '--enable-exit-homedir' option on the"
 echo "'configure' command line."
 echo "By default, it is disabled for security reasons !"
 echo ""
fi