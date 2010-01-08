/** 
   Copyright (C) 2009 Free Software Foundation, Inc.

   Written by:  Richard Frith-Macdonald <rfm@gnu.org>
   Created: October 2009

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.

   You should have received a copy of the GNU General Public
   License along with this program; see the file COPYINGv3.
   If not, write to the Free Software Foundation,
   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

   */

#include	"License.h"

int
main(int argc, char** argv, char **env)
{
  NSAutoreleasePool	*pool;
  NSUserDefaults	*defs;
  NSProcessInfo		*proc;
  NSArray		*args;
  NSMutableDictionary	*domain;
  NSString		*owner;
  License		*license;
  unsigned		i;

#ifdef GS_PASS_ARGUMENTS
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
//  [NSObject enableDoubleReleaseCheck: YES];
  pool = [NSAutoreleasePool new];
  proc = [NSProcessInfo processInfo];
  if (proc == nil)
    {
      GSPrintf(stderr, @"defaults: unable to get process information!\n");
      [pool release];
      return 1;
    }

  args = [proc arguments];

  for (i = 1; i < [args count]; i++)
    {
      if ([[args objectAtIndex: i] isEqual: @"--help"])
	{
	  GSPrintf(stdout,
@"The 'license' command lets you set a license key for applications.\n\n");
	  return 0;
	}
    }

  i = 1;
  if ([args count] <= i)
    {
      GSPrintf(stderr, @"license: too few arguments supplied!\n");
      [pool release];
      return 1;
    }
  defs = [NSUserDefaults standardUserDefaults];
  if (defs == nil)
    {
      GSPrintf(stderr, @"defaults: unable to access defaults database!\n");
      [pool release];
      return 1;
    }
  /* We don't want this tool in the defaults database - so remove it. */
  [defs removePersistentDomainForName: [proc processName]];

  while (i < [args count])
    {
      owner = [args objectAtIndex: i++];
      domain = [[defs persistentDomainForName: owner] mutableCopy];
      if (domain == nil)
	{
	  domain = [NSMutableDictionary new];
	}
      [License setDomain: owner];
      license = [License new];
      if ([license generated] == nil)
	{
	  GSPrintf(stderr, @"license: %@\n", [license message]);
	  return 1;
	}
      [domain setObject: [license generated] forKey: @"LicenseKey"];
      [license release];
      [defs setPersistentDomain: domain forName: owner];
      [domain release];
      [defs synchronize];
      if ([defs synchronize] == NO)
	{
	  GSPrintf(stderr, @"license: unable to write to defaults database\n");
	  return 1;
	}
      else
	{
	  GSPrintf(stderr, @"license: key set for %@\n", owner);
	}
    }

  [pool release];
  return 0;
}

