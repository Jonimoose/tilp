/*  TiLP - Linking program for TI calculators
*  Copyright (C) 2001-2002 Julien BLACHE <jb@technologeek.org>
*
*  Cocoa GUI for Mac OS X
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

#include <libticables/cabl_def.h>

#include "cocoa_structs.h"

#include "../src/struct.h"
#include "../src/intl.h"
#include "../src/defs.h"

extern struct cocoa_objects_ptr *objects_ptr;

extern struct ticalc_info_update info_update;

#import <Cocoa/Cocoa.h>

#import "SheetsController.h"

@implementation SheetsController

// we could use NSbeep(); on some boxes (dlgboxEntry maybe ?)
// and also request the user attention (ie. the app's icon will jump on the screen)
// see requestUserAttention()

- (void)awakeFromNib
{
#ifdef OSX_DEBUG
  fprintf(stderr, "sheets => got awakeFromNib\n");
#endif

  // Init instance pointer
  objects_ptr->mySheetsController = self;
}


- (void)showCurrentPBar
{
  if (pbarWindow != nil)
  {
    [NSApp beginSheet:pbarWindow
       modalForWindow:[myBoxesController keyWindow]
        modalDelegate:nil
       didEndSelector:nil
          contextInfo:nil];
    
    [NSApp endSheet:pbarWindow];
  }
}

- (void)hideCurrentPBar
{
  if (pbarWindow != nil)
  {
    [pbarWindow orderOut:self];
  }
}


- (void)msgSheet:(NSString *)message title:(NSString *)title
{
  [self hideCurrentPBar];

#ifdef TILP_USES_SHEETS
  NSBeginAlertSheet(title, nil, nil, nil, [myBoxesController keyWindow], nil, nil, nil, nil, message);
#else
  NSRunAlertPanel(title, message, @"OK", nil, nil);
#endif

  [self showCurrentPBar];
}

/* user boxes */

- (int)user1Sheet:(NSString *)title message:(NSString *)message button1:(NSString *)button1
{
#ifndef TILP_USES_SHEETS
  NSModalSession session;
#endif

  NSRect textFrame;
  NSSize newSize;
  
  [self hideCurrentPBar];

  [user1Text setStringValue:message];

  // begin window resizing
  [user1Text sizeToFit];

  textFrame = [user1Text frame];

  newSize.height = 88 + textFrame.size.height;
  newSize.width = (360 > textFrame.size.width) ? 400 : (40 + textFrame.size.width);

  [user1Window setContentSize:newSize];

  textFrame.origin.x = 20;
  textFrame.origin.y = 68;

  [user1Text setFrame:textFrame];
  // end of window resizing
  
  [user1Button setTitle:button1];

  [user1Window setExcludedFromWindowsMenu:YES];

#ifdef TILP_USES_SHEETS
  [NSApp beginSheet:user1Window
     modalForWindow:[myBoxesController keyWindow]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];

  [NSApp runModalForWindow:user1Window];

  [NSApp endSheet:user1Window];
#else
  [user1Window setTitle:title];

  session = [NSApp beginModalSessionForWindow:user1Window];

  [user1Window makeKeyAndOrderFront:self];

  for (;;)
  {
    if([NSApp runModalSession:session] != NSRunContinuesResponse)
      break;
  }

  [NSApp endModalSession:session];
#endif

  [user1Window orderOut:self];

  [self showCurrentPBar];

  return objects_ptr->user1_return;
}

- (int)user2Sheet:(NSString *)title message:(NSString *)message button1:(NSString *)button1 button2:(NSString *)button2
{
#ifndef TILP_USES_SHEETS
  NSModalSession session;
#endif

  NSRect textFrame;
  NSSize newSize;

  objects_ptr->user2_return = 0;

  [self hideCurrentPBar];

  [user2Text setStringValue:message];


  // begin window resizing
  [user2Text sizeToFit];

  textFrame = [user2Text frame];

  newSize.height = 88 + textFrame.size.height;
  newSize.width = (360 > textFrame.size.width) ? 400 : (40 + textFrame.size.width);

  [user2Window setContentSize:newSize];

  textFrame.origin.x = 20;
  textFrame.origin.y = 68;

  [user2Text setFrame:textFrame];
  // end of window resizing

  [user2Button1 setTitle:button1];
  [user2Button2 setTitle:button2];

  [user2Window setExcludedFromWindowsMenu:YES];

#ifdef TILP_USES_SHEETS
  [NSApp beginSheet:user2Window
     modalForWindow:[myBoxesController keyWindow]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];

  [NSApp runModalForWindow:user2Window];

  [NSApp endSheet:user2Window];
#else
  [user2Window setTitle:title];

  session = [NSApp beginModalSessionForWindow:user2Window];

  [user2Window makeKeyAndOrderFront:self];

  for (;;)
  {
    if([NSApp runModalSession:session] != NSRunContinuesResponse)
      break;
  }

  [NSApp endModalSession:session];
#endif

  [user2Window orderOut:self];

  [self showCurrentPBar];

  return objects_ptr->user2_return;
}

- (int)user3Sheet:(NSString *)title message:(NSString *)message button1:(NSString *)button1 button2:(NSString *)button2 button3:(NSString *)button3
{
#ifndef TILP_USES_SHEETS
  NSModalSession session;
#endif

  NSRect textFrame;
  NSSize newSize;
  
  [self hideCurrentPBar];

  [user3Text setStringValue:message];

  // begin window resizing
  [user3Text sizeToFit];

  textFrame = [user3Text frame];

  newSize.height = 88 + textFrame.size.height;
  newSize.width = (360 > textFrame.size.width) ? 400 : (40 + textFrame.size.width);

  [user3Window setContentSize:newSize];

  textFrame.origin.x = 20;
  textFrame.origin.y = 68;

  [user3Text setFrame:textFrame];
  // end of window resizing  
  
  [user3Button1 setTitle:button1];
  [user3Button2 setTitle:button2];
  [user3Button3 setTitle:button3];

  [user3Window setExcludedFromWindowsMenu:YES];

#ifdef TILP_USES_SHEETS
  [NSApp beginSheet:user3Window
     modalForWindow:[myBoxesController keyWindow]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];

  [NSApp runModalForWindow:user3Window];

  [NSApp endSheet:user3Window];
#else
  [user3Window setTitle:title];

  session = [NSApp beginModalSessionForWindow:user3Window];

  [user3Window makeKeyAndOrderFront:self];

  for (;;)
  {
    if([NSApp runModalSession:session] != NSRunContinuesResponse)
      break;
  }

  [NSApp endModalSession:session];
#endif

  [user3Window orderOut:self];

  [self showCurrentPBar];

  return objects_ptr->user3_return;
}

/* dialog box w/entry field */

- (NSString *)dlgboxEntry:(NSString *)title message:(NSString *)message content:(NSString *)content
{
#ifndef TILP_USES_SHEETS
  NSModalSession session;
#endif

  NSRect textFrame;
  NSSize newSize;
  
  if ([dlgboxentryWindow isVisible])
    return NULL;

  [dlgboxentryEntry setStringValue:content];
  [dlgboxentryEntry selectText:nil];
  [dlgboxentryText setStringValue:message];

  // begin window resizing
  [dlgboxentryText sizeToFit];

  textFrame = [dlgboxentryText frame];

  newSize.height = 88 + textFrame.size.height;
  newSize.width = (260 > textFrame.size.width) ? 300 : (40 + textFrame.size.width);

  [dlgboxentryWindow setContentSize:newSize];

  // I'm unsure whether I need to do the same with dlgboxentryEntry and dlgboxentryText...
  
  textFrame.origin.x = 20;
  textFrame.origin.y = 90;

  [dlgboxentryText setFrame:textFrame];
  // end of window resizing

  [dlgboxentryWindow setExcludedFromWindowsMenu:YES];

#ifdef TILP_USES_SHEETS
  [NSApp beginSheet:dlgboxentryWindow
     modalForWindow:[myBoxesController keyWindow]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];

  [NSApp runModalForWindow:dlgboxentryWindow];

  [NSApp endSheet:dlgboxentryWindow];
#else
  [dlgboxentryWindow setTitle:title];

  session = [NSApp beginModalSessionForWindow:dlgboxentryWindow];

  [dlgboxentryWindow makeKeyAndOrderFront:self];

  for (;;)
  {
    if([NSApp runModalSession:session] != NSRunContinuesResponse)
      break;
  }

  [NSApp endModalSession:session];
#endif

  [dlgboxentryWindow orderOut:self];

  return objects_ptr->dlgbox_data;
}

/* pbars */

- (void)pbarType2:(NSString *)message
{
  [self hideCurrentPBar];

  pbar_text = pbar2Text;

  [pbar2Text setStringValue:message];

  [pbar2Window setExcludedFromWindowsMenu:YES];

  [pbar2PBar setUsesThreadedAnimation:YES];
  [pbar2PBar startAnimation:self];

  [NSApp beginSheet:pbar2Window
     modalForWindow:[myBoxesController keyWindow]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];

  [NSApp endSheet:pbar2Window];

  [self showCurrentPBar];
}

- (void)pbarType1
{
  if (pbar1 != nil)
    return;

  pbar1 = pbar1PBar;
  pbar_rate = pbar1Rate;

  pbarWindow = pbar1Window;

  [pbar1Window setExcludedFromWindowsMenu:YES];

  [self showCurrentPBar];
}

- (void)pbarType3
{
  if (pbar1 != nil)
    return;

  pbar1 = pbar3PBar1;
  pbar2 = pbar3PBar2;
  pbar_rate = pbar3Rate;

  pbarWindow = pbar3Window;

  [pbar3Window setExcludedFromWindowsMenu:YES];

  [self showCurrentPBar];
}

- (void)pbarType4:(NSString *)message
{
  if (pbar1 != nil)
    return;

  pbar1 = pbar4PBar;
  pbar_rate = pbar4Rate;
  pbar_text = pbar4Text;

  pbarWindow = pbar4Window;

  [pbar4Window setExcludedFromWindowsMenu:YES];

  [pbar4Text setStringValue:message];

  [self showCurrentPBar];
}

- (void)pbarType5:(NSString *)message
{
  if (pbar1 != nil)
    return;

  pbar1 = pbar5PBar1;
  pbar2 = pbar5PBar2;
  pbar_rate = pbar5Rate;
  pbar_text = pbar5Text;

  pbarWindow = pbar5Window;

  [pbar5Text setStringValue:message];

  [pbar5Window setExcludedFromWindowsMenu:YES];

  [self showCurrentPBar];
}


// destroy pbars

- (void)destroyPbar
{
  if ([pbar1Window isVisible])
  {
    [pbar1Window orderOut:self];
    pbarWindow = nil;
  }

  if ([pbar2Window isVisible])
  {
    [pbar2Window orderOut:self];
    [pbar2PBar stopAnimation:self];
  }

  if ([pbar3Window isVisible])
  {
    [pbar3Window orderOut:self];
    pbarWindow = nil;
  }

  if ([pbar4Window isVisible])
  {
    [pbar4Window orderOut:self];
    pbarWindow = nil;
  }

  if ([pbar5Window isVisible])
  {
    [pbar5Window orderOut:self];
    pbarWindow = nil;
  }

  // reset the pbars, in case the transfer has crashed
  if (pbar1 != nil)
  {
    [pbar1 setDoubleValue:0.0];
    [pbar1 displayIfNeeded];
  }

  if (pbar2 != nil)
  {
    [pbar2 setDoubleValue:0.0];
    [pbar2 displayIfNeeded];
  }

  if (pbar_rate != nil)
  {
    [pbar_rate setStringValue:@"Rate : 0.00 KB/s"];
  }

  if (pbar_text != nil)
  {
    [pbar_text setStringValue:@""];
  }

  pbar1 = nil;
  pbar2 = nil;
  pbar_rate = nil;
  pbar_text = nil;

  // reset, in case the transfer has crashed
  info_update.percentage = 0.0;
  info_update.prev_percentage = 0.0;
}

// this is the refresh part of the stuff :-)

// in cocoa_refresh.m
extern TicableDataRate *dr;

- (void)refreshPbar1
{
  static gfloat rate;

  if(pbar1 != nil)
  {
    // refresh only if necessary
    if((info_update.percentage - info_update.prev_percentage) < 0.05) // was 0.01 originally on OS X, 0.05  in GTK code
    {
      if((info_update.percentage - info_update.prev_percentage) < 0)
        info_update.prev_percentage = info_update.percentage;
      else
        return;
    }
    else
      info_update.prev_percentage = info_update.percentage;

    // old code
    //rate = info_update.count / ((float)(clock() - info_update.start_time)/CLOCKS_PER_SEC);

    rate = dr->count/toCURRENT(dr->start);

    // set pbar value and textField text

    [pbar1 setDoubleValue:(double)(info_update.percentage * 100)];
    [pbar_rate setStringValue:[NSString stringWithFormat:@"Rate : %3.2f KBytes/s", (rate / 1000)]];

    // not needed
    //[pbar1 displayIfNeeded];
    //[pbar_rate displayIfNeeded];
  }
}

- (void)refreshPbar2
{
  if(pbar2 != nil)
  {
    // refresh only if necessary, not too often (works well with 0.01, too, but consumes CPU I guess)
    if((info_update.main_percentage - info_update.prev_main_percentage) < 0.05)
      return;
    else
      info_update.prev_main_percentage = info_update.main_percentage;

    [pbar2 setDoubleValue:(double)(info_update.main_percentage * 100)];

    [pbar2 displayIfNeeded];
  }
}

- (void)refreshLabel
{
  if (pbar_text == nil)
    return;

  [pbar_text setStringValue:[NSString stringWithCString:info_update.label_text]];
  [pbar_text displayIfNeeded];
}

@end
