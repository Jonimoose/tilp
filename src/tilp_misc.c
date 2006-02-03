/* Hey EMACS -*- linux-c -*- */
/* $Id$ */

/*  TiLP - Ti Linking Program
 *  Copyright (C) 1999-2005  Romain Lievin
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "tilp_core.h"

#ifdef __WIN32__
#define snprintf _snprintf
#endif				

/* Change the current drive (Win32 only) */
#ifndef __MACOSX__
int tilp_drive_change(char drive_letter)
{
#ifdef __WIN32__
	gchar *s;
	snprintf(local.cwdir, 8, "%c:\\", (char) drive_letter);

	s = g_strdup(local.cwdir);
	if (tilp_chdir(s) == -1) 
	{
		gif->msg_box1(_("Error"), _("Unable to change directory."));
	}
	g_free(s);
#else				
	gif->msg_box1(_("Information"), _("This function is not available in the Win version."));

#endif				
	return 0;
}
#endif

int tilp_tifiles_ungroup(void)
{
	GList *sel;
	gchar *src_file;
	gchar *dst_file;

	if (!tilp_clist_selection_ready())
		return -1;

	for(sel = local.selection; sel; sel = sel->next)
	{
		FileEntry *f = (FileEntry *) sel->data;
		gchar *utf8;
		gchar *dirname;

		utf8 = gif->msg_entry(_("Create new directory"), _("Directory where files will be ungrouped: "), _("ungrouped"));
		if (utf8 == NULL)
			return -1;

		dirname = g_filename_from_utf8(utf8, -1, NULL, NULL, NULL);
		g_free(utf8);

		if(!strcmp(dirname, ".") || !strcmp(dirname, ""))
		{
			gif->msg_box1(_("Error"), _("You can't ungroup in this folder."));
			return -1;
		}
	   
		if(tilp_file_mkdir(dirname))
		{
		   g_free(dirname);
		   return -1;
		}

		src_file = g_strconcat(g_get_current_dir(), G_DIR_SEPARATOR_S, f->name, NULL);
		tilp_file_chdir(dirname);
		
		dst_file = g_strconcat(g_get_current_dir(), G_DIR_SEPARATOR_S, f->name, NULL);
		tilp_file_copy(src_file, dst_file);
		
		tifiles_ungroup_file(dst_file, NULL);
		tilp_chdir("..");

		g_free(dirname);
		g_free(src_file);
		g_free(dst_file);
	}

	return 0;
}

int tilp_tifiles_group(void)
{
	GList *sel;
	char **array;
	gchar *grpname;
	gchar *dst_file;
	int i;
	FileEntry *f = NULL;

	if (!tilp_clist_selection_ready())
		return -1;

	if (g_list_length(local.selection) < 2) 
	{
		gif->msg_box1(_("Error"), _("You must select at least 2 files.\n\n"));
		return -1;
	}

	grpname = gif->msg_entry(_("Group files"), _("Group name: "), _("group"));
	if (grpname == NULL)
		return -1;

	array = (char **) g_malloc0((g_list_length(local.selection) + 1) * sizeof(char *));
	
	for(sel = local.selection, i = 0; sel; sel = sel->next, i++)
	{
		f = (FileEntry *) sel->data;
		array[i] = g_strconcat(g_get_current_dir(), G_DIR_SEPARATOR_S, f->name, NULL);
	}
	
	dst_file = g_strconcat(g_get_current_dir(), G_DIR_SEPARATOR_S, grpname,
			".", tifiles_fext_of_group(tifiles_file_get_model(f->name)), NULL);
		
	g_free(grpname);
	tifiles_group_files(array, dst_file);
	g_strfreev(array);

	return 0;
}
