/* Hey EMACS -*- linux-c -*- */
/* $Id: tilp_core.h 1125 2005-05-24 18:09:19Z julien $ */

/*  TiLP - Ti Linking Program
 *  Copyright (C) 1999-2005  Romain Lievin
 *
 *  This program is free software you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifndef __TILP_CALCS__
#define __TILP_CALCS__

#include <stdio.h>
#include <glib.h>

#include "tilp_core.h"

static gchar* calc;
static gchar* cable;
static gchar** array;
static gchar** flist;
static gint use_gui;
extern int working_mode;

static GOptionEntry entries[] = 
{
	{ "calc", 0, 0, G_OPTION_ARG_STRING, &calc, "Hand-held model", NULL },
	{ "cable", 0, 0, G_OPTION_ARG_STRING, &cable, "Link cable model", NULL },
	{ "port", 0, 0, G_OPTION_ARG_INT, &options.cable_port, "Link cable port", NULL },
	{ "timeout", 0, 0, G_OPTION_ARG_INT, &options.cable_timeout, "Link cable timeout", NULL },
	{ "delay", 0, 0, G_OPTION_ARG_INT, &options.cable_delay, "Link cable delay", NULL },
	{ "no-gui", 0, 0, G_OPTION_ARG_NONE, &use_gui, "Does not use GUI", NULL },
	{ G_OPTION_REMAINING, 0, 0, G_OPTION_ARG_FILENAME_ARRAY, &array, "filename(s)", NULL },
	{ NULL }
};

void tilp_cmdline_version(void)
{
	fprintf(stdout, _("TiLP - Version %s, (C) 1999-2005 Romain Lievin\n"), TILP_VERSION);
#ifdef __BSD__
	fprintf(stdout, _("FreeBSD port, (c) 2003-2004 Tijl Coosemans\n"));
#endif
#ifdef __MACOSX__
	fprintf(stdout, _("Mac OS X port Version %s (%s), (C) 2001-2003 Julien Blache <jb@tilp.info>\n"), TILP_OSX_VERSION, SVN_REV);
#endif
	fprintf(stdout, _("THIS PROGRAM COMES WITH ABSOLUTELY NO WARRANTY\n"));
	fprintf(stdout, _("PLEASE READ THE DOCUMENTATION FOR DETAILS\n"));
    fprintf(stdout, _("built on %s %s\n"), __DATE__, __TIME__);
}

int tilp_cmdline_scan(int argc, char **argv)
{
	GOptionContext* context;
	GError *error = NULL;

	// parse command line
	context = g_option_context_new ("- Ti Linking Program");
	g_option_context_add_main_entries(context, entries, ""/*GETTEXT_PACKAGE*/);
	g_option_context_set_help_enabled(context, TRUE);
	g_option_context_set_ignore_unknown_options(context, FALSE);
	g_option_context_parse(context, &argc, &argv, &error);
	g_option_context_free(context);

	// convert name to value
	if(calc != NULL)
	{
		options.calc_model = ticalcs_string_to_model(calc);
		g_free(cable);
	}

	// convert name to value
	if(cable != NULL)
	{
		options.cable_model = ticalcs_string_to_model(cable);
		g_free(calc);
	}

	// are files passed ?
	if(array != NULL)
	{
		gchar **p, **q;
		gint len;

		working_mode = MODE_CMD;

		// check whether path is local or absolute
		for(p = array, len = 0; *p != NULL; p++, len++);

		flist = g_malloc0((len + 1) * sizeof(gchar *));

		// rebuild a list of file with full path
		for(p = array, q = flist; *p != NULL; p++, q++)
		{
			if (!g_path_is_absolute(*p))
				*q = g_strconcat(g_get_current_dir(), G_DIR_SEPARATOR_S, *p, NULL);
			else
				*q = g_strdup(*p);
		}

		// build a pseudo file selection for TiLP
		for(q = flist; *q != NULL; q++)
		{
			TilpFileEntry* fe = g_malloc0(sizeof(TilpFileEntry));

			fe->name = g_strdup(*q);
			local_win.selection = g_list_prepend(local_win.selection, fe);
		}

		g_strfreev(array);
		g_strfreev(flist);
	}

	// use GUI ?
	if(use_gui)
		working_mode |= MODE_GUI;
	else
		working_mode &= ~MODE_GUI;

	return 0;
}

/*
  This function send files passed on the command line and place them in
  the ClistWin linked list.
  Manage file type, calculator detection and some other things...
*/
int tilp_cmdline_send(void)
{
	TilpFileInfo *fi;
	int last = options.confirm;
	gchar *ext = NULL;
	
	if (clist_win.selection == NULL)
		return -1;

	// Check for a valid file
	fi = (TilpFileInfo *) (g_list_first(clist_win.selection))->data;
	ext = tifiles_get_extension(fi->name);
	if (ext == NULL) {
		printl(2, _
			      ("Invalid filename. There is no extension !\n"));
		exit(-1);
	}

	// Determine calculator type and override current settings
	options.lp.calc_type = tifiles_which_calc_type(fi->name);
	ticalc_set_calc(options.lp.calc_type, &ti_calc);

	// Send file(s)
	if (g_list_length(clist_win.selection) == 1) {

		// One file
		if (tifiles_is_a_flash_file(fi->name)) {
			if (!g_strcasecmp
			    (ext, tifiles_flash_app_file_ext()))
				tilp_calc_send_flash_app(fi->name);

			else if (!g_strcasecmp
				 (ext, tifiles_flash_os_file_ext()))
				tilp_calc_send_flash_os(fi->name);
		} else if (tifiles_is_a_regular_file(fi->name)) {
			options.confirm = FALSE;	// remove dirlist
			tilp_calc_send_var(0);
			options.confirm = last;
			return 0;
		} else if (tifiles_is_a_backup_file(fi->name)) {
			tilp_calc_send_backup(fi->name);
		} else {
			fprintf(stdout, _("Unknown file type.\n"));
		}
	} else {

		// More than one file
		if (clist_win.selection != NULL) {
			options.confirm = FALSE;
			tilp_calc_send_var(0);
			options.confirm = last;
			return 0;
		}
	}
	return 0;
}

#endif

#endif