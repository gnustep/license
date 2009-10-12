#ifndef	INCLUDED_LICENSE_C_H
#define	INCLUDED_LICENSE_C_H	1

/** Simple, software licensing class.
   Copyright (C) 2009 Free Software Foundation, Inc.

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


   $Date: 2009-10-06 22:50:33 +0100 (Tue, 06 Oct 2009) $ $Revision: 28779 $
 */ 


#if	defined(__cplusplus)
extern "C" {
#endif

/** For access by other programming languages, we have a simple C function
 * interface.<br />
 * This function takes authors, copyright, owner and terms as
 * UTF-8  C strings (may be nul pointers) as parameters, and returns the
 * message for the license as a UTF-8 cString.<br />
 * You should only call this function once, and must make sure that the
 * gnustep system has been initialised first (eg by calling the
 * GSInitializeProcess function with argv, argc, and envp as arguments).
 */
extern const char *
LicenseSetup(const char *a, const char *c, const char *o, const char *t);

/** For access by other programming languages, we have a simple C function
 * interface.<br />
 * This function tests to see of the license is currently valid and returns
 * non-zero if it is, zeroi if it isn't.<br />
 * The update argument can be set non-zero if you wish a check to be made to
 * see if the license has been updated in the defaults system.<br />
 * You must call LicenseSetup() before calling this function.
 */
extern int
LicenseValid(int update);

#if	defined(__cplusplus)
}
#endif

#endif
