/* Simple, software licensing test.
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

#include	"License-C.h"
#include	<stdio.h>

extern void GSInitializeProcess(int, char**, char**);

int
main(int argc, char **argv, char **envp)
{
  GSInitializeProcess(argc, argv, envp);
  printf("%s", LicenseSetup(0,0,0,0));
  printf("%d", LicenseValid(1));
  return 0;
}
