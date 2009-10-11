#ifndef	INCLUDED_LICENSE_H
#define	INCLUDED_LICENSE_H	1

/** Simple, software licensing class.
   Copyright (C) 1993, 1994, 1995, 1996 Free Software Foundation, Inc.

   Written by:  Richard Frith-Macdonald <rfm@gnu.org>
   Date:	August 2009

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 3 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02111 USA.

<title>License documentation</title>
<chapter>
  <heading>The License class</heading>
  <section>
    <heading>What is the License class?</heading>
    <p>
      The License class provides a simple framework for GNUstep program to
      encapsulate copyright and licensing information within the
      NSUserDefaults system so that a 'customer' is not able to use the
      licensed program outsiode the terms of tis license without being
      aware of the fact.<br />
      The class allows you to create/access an instance representing the
      current license terms of the product, and gives a message which can
      be displayed to let the custoemr know what those license terms are.<br />
      This instance can also check that the program is running on the
      host (or hosts) it is licensed for, and can check that the license
      has not expired.<br />
      Each license has a 'key' ... a simple hash of the various pieces of
      information forming the license, which is used to detect tampering
      with the license ... making it impossible for a customer to accidentally
      change the recorded license terms.<br />
      The current license instance is updated dynamically in response to
      user defaults changes, so you can update the license of a running
      program, extending the license expiry without the program having to
      stop when the license expires.
    </p>
    <p>
      The class uses a few settings which are normally
      specified programmatically using setter methods (the author,
      copyright date, copyright owner, and license terms) but which may
      be overridden using NSUserDefaults (see the description of the
      individual setter methods for details).<br />
      Most of the license settings are obtained from the NSUserDefaults
      system however:
    </p>
    <deflist>
      <term>LicenseEndUser</term>
      <desc>A name or short description of the company or organisation
	(or individual) licensed to run the product.
      </desc>
      <term>LicenseExpires</term>
      <desc>The date at which the license expires.
	This is in YYYY-MM-DD format.
      </desc>
      <term>LicenseHosts</term>
      <desc>A comma separated list of host names and/or ip addresses on which
	the product is licensed to run.  This may be a single host or may be
	left undefined (in which case the product may run on any host).
      </desc>
      <term>LicenseKey</term>
      <desc> The license key for this license (set using the 'license' utility).
      </desc>
      <term>LicenseLocation</term>
      <desc>A short description of the location (company premises etc) where
	the product is licensed to run.
      </desc>
      <term>LicenseNumber</term>
      <desc>An arbitrary identifier for the license ... this may be used to
	keep track of which licenses are installed with each customer.
      </desc>
      <term>LicenseServer</term>
      <desc>A shoit derscription of the type of machine on which the
	licensed product is expected to run.
      </desc>
      <term>LicenseType</term>
      <desc>The name (and perhaps version information) for the product
	covered by this licenses.
      </desc>
      <term>LicenseUser</term>
      <desc>The legal entity to which the product is licensed.
      </desc>
    </deflist>
  </section>
  <heading>Typical usage</heading>
  <section>
<example>
  [License setCopyright: @"2003-2009"];
  [License setOwner: @"Widget Producers Inc."];
  [License setTerms: myTermsAndConditions];

  ...

  license = [License currentLicense];
  GSPrintf(stdout, @"%@", [license message]);
  if ([license isValid] == NO
    || [[license expires] timeIntervalSinceNow] &lt; 0.0)
    {
      exit(1);
    }
</example>
  </section>
  <heading>The license utility</heading>
  <section>
    <p>The <code>license</code> utility is a simple utility to generate a
      license key for a product.
    </p>
    <p>Before the utility is run, you need to set up all the license
    information in the user defaults system.  You then run the utility
    with the name of the licensed program as its argument, and it will
    read the information, generate a key, and store it in the user
    defaults system for the licensed application.
    </p>
    <p>eg. if you have set up license defaults for 'MyProgram', you would
    simply type:
    </p>
    <example>
license MyProgram
    </example>
    <p>and a license key would be created in the 'MyProgram' domain.<br />
    You could then type:
    </p>
    <example>
defaults write MyProgram | fgrep ' License' &gt; MyProgram.license
    </example>
    <p>to save the license information in a file which could be copied to
    a customer's system and used as input to the <code>defaults</code>
    command in order to set up the license there.
    </p>
  </section>
</chapter>

   $Date: 2009-10-06 22:50:33 +0100 (Tue, 06 Oct 2009) $ $Revision: 28779 $
 */ 

#import	<Foundation/Foundation.h>

@interface	License : NSObject
{
@private
  NSString		*_lEndUser;
  NSString		*_lExpires;
  NSString		*_lHosts;
  NSString		*_lKey;
  NSString		*_lLocation;
  NSString		*_lNumber;
  NSString		*_lServer;
  NSString		*_lType;
  NSString		*_lUser;
  NSString		*_authors;
  NSString		*_copyr;
  NSDate		*_expires;
  NSString		*_generated;
  NSMutableString	*_message;
  NSString		*_owner;
  NSString		*_terms;
  BOOL			_valid;
}

/** Returns the currently active license as an autoreleased object.
 */
+ (License*) currentLicense;

/** Internal method to update the current license if necessary.<br />
 * This is called whenever user defaults change, causing the current active
 * license to be set to represent the latest information.<br />
 * Programs which run 24 hours a day, seven days a week, can therefore have
 * their licenses updated without any need for the program to stop.
 */
+ (void) checkForChanges: (NSNotification*)n;


/** Sets the default authors to be listed for the licensed product.<br />
 * This may be overridden by the LicenseAuthors user default.<br />
 * If this is not set, the product has no authors.
 */
+ (void) setAuthors: (NSString*)s;

/** Sets the default copyright date for the licensed product.<br />
 * This may be overridden by the LicenseCopyright user default.<br />
 * If not set, this is assumed to be '2009'
 */
+ (void) setCopyright: (NSString*)s;

/** Do not use this method ... is is provided for the 'licence' utility.
 */
+ (void) setDomain: (NSString*)s;

/** Sets the default copyright owner for the licensed product.<br />
 * This may be overridden by the LicenseOwner user default.<br />
 * If not set, the owner is assumed to be the Free Software Foundation
 */
+ (void) setOwner: (NSString*)s;

/** Sets the default terms and conditions for the licensed product.<br />
 * This may be overridden by the LicenseTerms user default.<br />
 * If this is not set, the product is assumed to be licensed under the
 * Lesser GNU Public License.
 */
+ (void) setTerms: (NSString*)s;

/** Returns whether the receiver is the current active license.<br />
 * A license may stop being the active license if user defaults are
 * changed, so code which saves a License instance should call this
 * method immediately before using that saved instance, and if the
 * method returns NO, they should call +currentLicense to get an up to
 * date instance.
 */
- (BOOL) active;

/** Return the date/time at which this license expires, or nil if it
 * is not a valid license.
 */
- (NSDate*) expires;

/** Return the key generated for this license.
 * Do not use this method ... is is provided for the 'licence' utility.
 */
- (NSString*) generated;

/** Returns the descriptive license text and any error messages if the
 * license has expired or has no expiry date.
 */
- (NSString*) message;

/** Returns YES if the license is valid.
 */
- (BOOL) valid;
@end

#endif
