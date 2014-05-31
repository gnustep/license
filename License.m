/* Simple, software licensing class.
   Copyright (C) 2009 Free Software Foundation, Inc.

   Written by:  Richard Frith-Macdonald <rfm@gnu.org>
   Date:	August 2009

   This library is free software; you can redistribute it and/or
   modify it under the _terms of the GNU Lesser General Public
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
 */ 

#import	"License.h"

@implementation	License

static NSRecursiveLock	*licenseLock = nil;
static License	*currentLicense = nil;
static NSString	*domain = nil;
static NSString	*defAuthors = nil;
static NSString	*defCopyright = nil;
static NSString	*defOwner = nil;
static NSString	*defTerms = nil;

+ (void) checkForChanges: (NSNotification*)n
{
  License	*l;

  l = [self new];
  if ([l valid] == YES)
    {
      [licenseLock lock];
      if ([l isEqual: currentLicense] == NO)
	{
	  ASSIGN(currentLicense, l);
	}
      [licenseLock unlock];
    }
  [l release];
}

+ (License*) currentLicense
{
  License	*license;

  [licenseLock lock];
  if (nil == currentLicense)
    {
      currentLicense = [License new];
    }
  license = [currentLicense retain];
  [licenseLock unlock];
  return [license autorelease];
}

+ (void) initialize
{
  if (licenseLock == nil)
    {
      licenseLock = [NSRecursiveLock new];
      [[NSNotificationCenter defaultCenter]
	addObserver: self
	selector: @selector(checkForChanges:)
	name: NSUserDefaultsDidChangeNotification
	object: nil];
      defAuthors = nil;
      defCopyright = @"2009";
      defOwner = @"Free Software Foundation Inc";
      defTerms = 
@"\n"
@"Warning: This computer program is protected by _copyright law and\n"
@"international treaties. Unauthorised reproduction or distribution\n"
@"of this program, or any portion of it, may result in severe civil\n"
@"and criminal penalties, and be prosecuted to the maximum extent\n"
@"possible under the law.\n"
@"\n"
@"This library is free software; you can redistribute it and/or\n"
@"modify it under the _terms of the GNU Lesser General Public\n"
@"License as published by the Free Software Foundation; either\n"
@"version 3 of the License, or (at your option) any later version.\n"
@"\n"
@"This library is distributed in the hope that it will be useful,\n"
@"but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
@"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU\n"
@"Library General Public License for more details.\n"
@"\n"
@"You should have received a copy of the GNU Lesser General Public\n"
@"License along with this library; if not, write to the Free\n"
@"Software Foundation, Inc., 51 Franklin Street, Fifth Floor,\n"
@"Boston, MA 02111 USA.\n";
    }
}

+ (void) setAuthors: (NSString*)s
{
  [licenseLock lock];
  s = [s copy];
  [defAuthors release];
  defAuthors = s;
  [licenseLock unlock];
}

+ (void) setCopyright: (NSString*)s
{
  [licenseLock lock];
  s = [s copy];
  [defCopyright release];
  defCopyright = s;
  [licenseLock unlock];
}

+ (void) setDomain: (NSString*)s
{
  [licenseLock lock];
  s = [s copy];
  [domain release];
  domain = s;
  [licenseLock unlock];
}

+ (void) setOwner: (NSString*)s
{
  [licenseLock lock];
  s = [s copy];
  [defOwner release];
  defOwner = s;
  [licenseLock unlock];
}

+ (void) setTerms: (NSString*)s
{
  [licenseLock lock];
  s = [s copy];
  [defTerms release];
  defTerms = s;
  [licenseLock unlock];
}

- (BOOL) active
{
  return (self == currentLicense) ? YES : NO;
}

- (void) dealloc
{
  [_copyr release];
  [_expires release];
  [_generated release];
  [_lEndUser release];
  [_lExpires release];
  [_lHosts release];
  [_lKey release];
  [_lLocation release];
  [_lNumber release];
  [_lServer release];
  [_lType release];
  [_lUser release];
  [_message release];
  [_owner release];
  [_terms release];
  [super dealloc];
}

- (NSDate*) expires
{
  return _expires;
}

- (NSString*) generated
{
  return _generated;
}

- (NSUInteger) hash
{
  return [_lKey hash];
}

- (id) init
{
  NSUserDefaults	*defs;
  NSMutableString	*combined;
  NSData		*digest;
  NSArray		*list;
  BOOL			excludeAuthors = NO;
  BOOL			excludeCopyright = NO;
  BOOL			excludeOwner = NO;
  BOOL			excludeTerms = NO;

  [licenseLock lock];

  defs = [NSUserDefaults standardUserDefaults];
  list = [[defs searchList] copy];

  /* If we are to use a specific domain, set it as the search list.
   */
  if (domain != nil)
    {
      [defs setSearchList: [NSArray arrayWithObject: domain]];
    }

  _message = [NSMutableString new];

  /* The following four values may be set programatically or from the
   * defaults system.  If they are set from the defaults system then
   * they need to be included in the hashed key (to make sure they are
   * not altered) otherwise they must NOT be part of the hashed key
   * because that woudl stop the license utility from being able to
   * generate a correct key.
   */
  _authors = [[defs stringForKey: @"LicenseAuthors"] copy];
  _copyr = [[defs stringForKey: @"LicenseCopyright"] copy];
  _owner = [[defs stringForKey: @"LicenseOwner"] copy];
  _terms = [[defs stringForKey: @"LicenseTerms"] copy];

  if (_authors == nil)
    {
      _authors = [defAuthors copy];
      excludeAuthors = YES;
    }
  if (_copyr == nil)
    {
      _copyr = [defCopyright copy];
      excludeCopyright = YES;
    }
  if (_owner == nil)
    {
      _owner = [defOwner copy];
      excludeOwner = YES;
    }
  if (_terms == nil)
    {
      _terms = [defTerms copy];
      excludeTerms = YES;
    }

  _lEndUser = [[defs stringForKey: @"LicenseEndUser"] copy];
  _lExpires = [[defs stringForKey: @"LicenseExpires"] copy];
  _lHosts = [[defs stringForKey: @"LicenseHosts"] copy];
  _lKey = [[defs stringForKey: @"LicenseKey"] copy];
  _lLocation = [[defs stringForKey: @"LicenseLocation"] copy];
  _lNumber = [[defs stringForKey: @"LicenseNumber"] copy];
  _lServer = [[defs stringForKey: @"LicenseServer"] copy];
  _lType = [[defs stringForKey: @"LicenseType"] copy];
  _lUser = [[defs stringForKey: @"LicenseUser"] copy];

  if (domain != nil)
    {
      [defs setSearchList: list];
    }
  [list release];
  [licenseLock unlock];

  if ([_lExpires length] > 0)
    {
      NSString	*t = [_lExpires stringByAppendingString: @" 23:59:59"];

      _expires = [[NSCalendarDate dateWithString: t
				  calendarFormat: @"%Y-%m-%d %H:%M:%S"] copy];
    }
  else
    {
      _expires = nil;
    }

  combined = [[NSMutableString alloc] initWithString: @"Seed"];
  if (_lUser != nil)
    {
      [combined appendString: _lUser];
    }
  else
    {
      [_message appendString: @"This product is not licensed to anyone.\n\n\n"];
      return self;
    }
  if (_lNumber != nil)
    {
      [combined appendString: _lNumber];
    }
  else
    {
      [_message appendString: @"This product has no license number.\n\n\n"];
      return self;
    }

  if (_expires == nil)
    {
      [_message appendString: @"This product has no expiry set.\n\n\n"];
      return self;
    }

  if (_lEndUser != nil)
    {
      [combined appendString: _lEndUser];
    }
  if (_lLocation != nil)
    {
      [combined appendString: _lLocation];
    }
  if (_lServer != nil)
    {
      [combined appendString: _lServer];
    }
  if (_lType != nil)
    {
      [combined appendString: _lType];
    }
  if (_lExpires != nil)
    {
      [combined appendString: _lExpires];
    }
  if (_lHosts != nil)
    {
      [combined appendString: _lHosts];
    }

  if (_authors != nil && excludeAuthors == NO)
    {
      [combined appendString: _authors];
    }
  if (_copyr != nil && excludeCopyright == NO)
    {
      [combined appendString: _copyr];
    }
  if (_owner != nil && excludeOwner == NO)
    {
      [combined appendString: _owner];
    }
  if (_terms != nil && excludeTerms == NO)
    {
      [combined appendString: _terms];
    }

  /*
   * Take an md5 digest and shrink it down to eight hex digits.
   */
  digest = [[combined dataUsingEncoding: NSUTF8StringEncoding] md5Digest];
  RELEASE(combined);
  if ([digest length] == 16)
    {
      const unsigned char	*ptr = (const unsigned char*)[digest bytes];
      unsigned char		buf[4];
      unsigned			i;

      for (i = 0; i < 4; i++)
	{
	  buf[i] = ptr[i];
	  buf[i] ^= ptr[i+4];
	  buf[i] ^= ptr[i+8];
	  buf[i] ^= ptr[i+12];
	}
      digest = [NSData dataWithBytes: buf length: 4];
      _generated
	= [[[digest hexadecimalRepresentation] uppercaseString] retain];
    }

  _valid = [_lKey isEqualToString: _generated];

  [_message appendFormat:
    @"\n\n%@ %@\n\n", _owner, _lType];
  if (_authors != nil)
    {
      [_message appendFormat:
        @"Authors: %@\n\n", _authors];
    }
  [_message appendFormat:
    @"Copyright (c) %@ %@.\n", _owner, _copyr];
  [_message appendString:
    @"All rights reserved.\n\n"];

  [_message appendFormat:
    @"This product is licensed to: %@\n", _lUser];
  if ([_lEndUser length] > 0)
    {
      [_message appendFormat: @"  for use at: %@\n", _lEndUser];
    }
  if ([_lLocation length] > 0)
    {
      [_message appendFormat: @"  Location: %@\n", _lLocation];
    }
  if ([_lServer length] > 0)
    {
      [_message appendFormat: @"  Licensed server: %@\n", _lServer];
    }
  [_message appendFormat: @"\n  License number: %@\n", _lNumber];
  if ([_lExpires length] > 0)
    {
      [_message appendFormat: @"  License expiry date: %@\n", _lExpires];
    }
  if (_valid == NO)
    {
      if ([_lKey length] == 0)
	{
	  [_message appendString: @"  Activation code: not found.\n"]; 
	}
      else
	{
	  [_message appendString: @"  Activation code: not valid.\n"];
	}
    }
  else if (_lHosts != nil)
    {
      NSMutableArray	*m;
      unsigned		c;
      NSHost		*h;

      m = [[_lHosts componentsSeparatedByString: @","] mutableCopy];
      m = [m autorelease];
      c = [m count];
      while (c-- > 0)
	{
	  NSString	*s = [[m objectAtIndex: c] stringByTrimmingSpaces];

	  if ([s length] == 0)
	    {
	      [m removeObjectAtIndex: c];
	    }
	  else
	    {
	      NSHost	*h;

	      if (isdigit([s characterAtIndex: 0]))
		{
		  h = [NSHost hostWithAddress: s];
		}
	      else
		{
		  h = [NSHost hostWithName: s];
		}
	      if (h == nil)
		{
		  [m removeObjectAtIndex: c];
		}
	      else
		{
		  [m replaceObjectAtIndex: c withObject: h];
		}
	    }
	}
      h = [NSHost currentHost];
      if (NO == [m containsObject: h])
	{
	  _valid = NO;
          [_message appendString:
	    @"This product is not licensed for the current host.\n\n\n"];
	  return self;
	}
    }
  if ([_expires timeIntervalSinceNow] < 0.0)
    {
      [_message appendString:
	@"This product does not have a valid expiry.\n\n\n"];
      return self;
    }

  [_message appendString: _terms];

  return self;
}

- (BOOL) isEqual: (id)other
{
  License	*o = (License*)other;

  if (other == self)
    {
      return YES;
    }
  if ([other isKindOfClass: [License class]] == NO)
    {
      return NO;
    }
  if (_valid != o->_valid
    || [_lKey isEqualToString: o->_lKey] == NO
    || [_expires isEqual: o->_expires] == NO)
    {
      return NO;
    }
  return YES;
}

- (NSString*) message
{
  return [[_message copy] autorelease];
}

- (BOOL) valid
{
  return _valid;
}
@end

const char *
LicenseSetup(const char *a, const char *c, const char *o, const char *t)
{
  static char		buf[BUFSIZ*10];
  NSAutoreleasePool	*pool = [NSAutoreleasePool new];
  License		*l;
  NSString		*s;

  if (a != 0)
    {
      s = [NSString stringWithUTF8String: a];
      [License setAuthors: s];
    }
  if (c != 0)
    {
      s = [NSString stringWithUTF8String: c];
      [License setCopyright: s];
    }
  if (o != 0)
    {
      s = [NSString stringWithUTF8String: o];
      [License setOwner: s];
    }
  if (t != 0)
    {
      s = [NSString stringWithUTF8String: t];
      [License setTerms: s];
    }
  l = [License currentLicense];
  strncpy(buf, [[l message] UTF8String], sizeof(buf) - 1);
  buf[sizeof(buf) - 1] = '\0';
  [pool release];
  return buf;
}

extern int
LicenseValid(int update)
{
  NSAutoreleasePool	*pool = [NSAutoreleasePool new];
  License		*l;
  int			ok;

  ok = 1;
  if (update)
    {
      NSUserDefaults	*defs;

      defs = [NSUserDefaults standardUserDefaults];
      [defs synchronize];
    }
  l = [License currentLicense];
  if ([l valid] == NO)
    {
      ok  = 0;
    }
  else if ([[l expires] timeIntervalSinceNow] <= 0.0)
    {
      ok = 0;
    }
  [pool release];
  return ok;
}
