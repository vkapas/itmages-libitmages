


CMAKE_MINIMUM_REQUIRED (VERSION 2.6) 

SET (LIBNAME itmages)
SET (PROJECT libitmages)
SET (EXECUTABLE upload-pictures)

PROJECT (${PROJECT}) 

SET (PACKAGE_NAME ${PROJECT})
SET (GETTEXT_PACKAGE ${LIBNAME})
SET (CMAKE_INSTALL_PREFIX "/usr")
SET (GNOMELOCALEDIR "/usr/share/locale")
SET (PACKAGE_STRING "${PACKAGE_NAME}-${PACKAGE_VERSION}")
FILE (STRINGS ${CMAKE_SOURCE_DIR}/VERSION PACKAGE_VERSION NO_HEX_CONVERSION)
#-------------------------------------------------------------------------------

# Find required packages and modules
FIND_PACKAGE (PkgConfig REQUIRED)
#-------------------------------------------------------------------------------

# Find Unity
PKG_CHECK_MODULES (UNITY QUIET unity)
PKG_CHECK_MODULES (NAUTILUS QUIET libnautilus-extension)

# Set version of GTK+
    IF (NOT DEFINED GTKVER)
        SET (GTKVER 3.0)
    ENDIF ()

    
    IF (NOT DEFINED WITH_UNITY)
        SET (WITH_UNITY ${UNITY_FOUND})
    ENDIF ()


    IF (NOT DEFINED WITH_NAUTILUS)
        SET (WITH_NAUTILUS ${NAUTILUS_FOUND})
    ENDIF ()


    IF (NOT WITH_UNITY OR NOT UNITY_FOUND OR GTKVER LESS 3.0)
        SET (UNITY_FOUND FALSE)
        SET (WITH_UNITY FALSE)
    ENDIF ()


    IF (NOT WITH_NAUTILUS OR NOT NAUTILUS_FOUND)
        SET (NAUTILUS_FOUND FALSE)
        SET (WITH NAUTILUS FALSE)
    ENDIF ()


    IF (WITH_NAUTILUS)
        MESSAGE ("-- Build with Nautilus extension")
    ELSE ()
        MESSAGE ("-- Build without Nautilus extension")
    ENDIF ()
#-------------------------------------------------------------------------------
PKG_CHECK_MODULES (GTK REQUIRED gtk+-${GTKVER})
PKG_CHECK_MODULES (GLIB REQUIRED glib-2.0)
PKG_CHECK_MODULES (GEXIV2 REQUIRED gexiv2)
#-------------------------------------------------------------------------------

# Find Vala
LIST (
        APPEND
        CMAKE_MODULE_PATH 
        ${CMAKE_SOURCE_DIR}/cmake/vala
     )   

FIND_PACKAGE (Vala REQUIRED)
INCLUDE (ValaPrecompile)
MESSAGE (STATUS "Vala version: ${VALA_VERSION}.")
#-------------------------------------------------------------------------------

# Configure files

CONFIGURE_FILE (
                    ${CMAKE_SOURCE_DIR}/config.h.cmake
                    ${CMAKE_SOURCE_DIR}/config.h
               )
CONFIGURE_FILE (
                    ${CMAKE_SOURCE_DIR}/${PROJECT}.pc.cmake
                    ${CMAKE_SOURCE_DIR}/${PROJECT}.pc
               )
CONFIGURE_FILE (
                    ${CMAKE_SOURCE_DIR}/po/application.pot.cmake
                    ${CMAKE_SOURCE_DIR}/po/${GETTEXT_PACKAGE}.pot
               )
CONFIGURE_FILE (
                    ${CMAKE_SOURCE_DIR}/data/application.desktop.cmake
                    ${CMAKE_SOURCE_DIR}/data/${EXECUTABLE}.desktop
               )
EXECUTE_PROCESS (
                    COMMAND
                    cp
                    ${CMAKE_SOURCE_DIR}/pixmaps/application.png
                    ${CMAKE_SOURCE_DIR}/pixmaps/${EXECUTABLE}.png
                )
#-------------------------------------------------------------------------------

# i18n
MESSAGE (STATUS ${CMAKE_SYSTEM_SHARE_DIR})

FIND_PACKAGE (Gettext REQUIRED)

ADD_CUSTOM_COMMAND (
                        OUTPUT
                        ${CMAKE_SOURCE_DIR}/po/${GETTEXT_PACKAGE}.pot
                        COMMAND
                        xgettext
                                ${CMAKE_SOURCE_DIR}/src/*.c
                                -c
                                --keyword=_
                                -o
                                ${CMAKE_SOURCE_DIR}/po/${GETTEXT_PACKAGE}.pot
                                --copyright-holder="ITmages"
                                --msgid-bugs-address="harestomper@gmail.com"
                                --no-wrap
                                --no-location
                                --strict
                                --force-po
                                -j
                        WORKING_DIRECTORY
                        ${CMAKE_SOURCE_DIR}/po/
                    )

FILE (
        GLOB
        _translations
        ${CMAKE_SOURCE_DIR}/po/*.po
     )

GETTEXT_CREATE_TRANSLATIONS (
                                ${CMAKE_SOURCE_DIR}/po/${GETTEXT_PACKAGE}.pot
                                ALL
                                ${_translations}
                            )
#-------------------------------------------------------------------------------

# Add target to build

ADD_SUBDIRECTORY (${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src) 
ADD_SUBDIRECTORY (${CMAKE_SOURCE_DIR}/bin ${CMAKE_BINARY_DIR}/bin)

IF (WITH_NAUTILUS)
    ADD_SUBDIRECTORY(${CMAKE_SOURCE_DIR}/nautilus ${CMAKE_BINARY_DIR}/nautilus)
ENDIF ()
#-------------------------------------------------------------------------------

# Install files

SET (CMAKE_INSTALL_PREFIX "/usr")

INSTALL (
            DIRECTORY
            ${CMAKE_SOURCE_DIR}/icons/
            DESTINATION
            /usr/share/icons/hicolor/64x64/actions
        )

INSTALL (
            FILES
            ${CMAKE_SOURCE_DIR}/data/org.gnome.itmages.library.gschema.xml
            DESTINATION
            /usr/share/glib-2.0/schemas
        )

#
# Post install scripts

INSTALL (SCRIPT "cmake/Compile-schemas.cmake")
INSTALL (SCRIPT "cmake/Update-highcolors.cmake")

#-------------------------------------------------------------------------------
