
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
 
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

-include config.make

PACKAGE_NAME = License
PACKAGE_VERSION = 1.0.0
CVS_MODULE_NAME = gnustep/dev-libs/License
CVS_TAG_NAME = License
SVN_BASE_URL=svn+ssh://svn.gna.org/svn/gnustep/libs
SVN_MODULE_NAME=license

NEEDS_GUI = NO

TOOL_NAME=license
TEST_TOOL_NAME=testLicense
LIBRARY_NAME=License
DOCUMENT_NAME=License

License_INTERFACE_VERSION=1.0

License_OBJC_FILES +=\
	License.m\


License_HEADER_FILES +=\
	License.h\
	License-C.h\

License_AGSDOC_FILES +=\
	License.h\
	License-C.h\

#
# Assume that the use of the gnu runtime means we have the gnustep
# base library and can use its extensions to build License stuff.
#
ifeq ($(OBJC_RUNTIME_LIB),gnu)
APPLE=0
else
APPLE=1
endif

ifeq ($(APPLE),1)
ADDITIONAL_OBJC_LIBS += -lgnustep-baseadd
License_LIBRARIES_DEPEND_UPON = -lgnustep-baseadd
endif

License_HEADER_FILES_INSTALL_DIR = License

license_OBJC_FILES = license.m
license_TOOL_LIBS += -lLicense
license_LIB_DIRS += -L./$(GNUSTEP_OBJ_DIR)

testLicense_C_FILES = testLicense.c
testLicense_TOOL_LIBS += -lLicense
testLicense_LIB_DIRS += -L./$(GNUSTEP_OBJ_DIR)

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/library.make
include $(GNUSTEP_MAKEFILES)/tool.make
include $(GNUSTEP_MAKEFILES)/test-tool.make
include $(GNUSTEP_MAKEFILES)/documentation.make

-include GNUmakefile.postamble
