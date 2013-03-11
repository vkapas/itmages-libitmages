

IF (GTK_VERSION EQUAL 3.0  OR GTK_VERSION GREATER 3.0)
    set (gtk3only "  ")
    set (gtk2only "//")
ELSE()
    set (gtk3only "//")
    set (gtk2only "  ")
ENDIF ()



CONFIGURE_FILE (
                    ${CMAKE_CURRENT_SOURCE_DIR}/window.vala.in
                    ${CMAKE_CURRENT_SOURCE_DIR}/window.vala
                )
                
CONFIGURE_FILE (
                    ${CMAKE_CURRENT_SOURCE_DIR}/image-item.vala.in
                    ${CMAKE_CURRENT_SOURCE_DIR}/image-item.vala
                )

#CONFIGURE_FILE (
#                    ${CMAKE_CURRENT_SOURCE_DIR}/utils.vala.in
#                    ${CMAKE_CURRENT_SOURCE_DIR}/utils.vala
#                )
#
#
# Set include dirs
#

#                        ${GTK_LIBRARIES}
#                        ${GLIB_LIBRARIES}
#                        ${GEXIV2_LIBRARIES}
INCLUDE_DIRECTORIES (
                        ${GTK_INCLUDE_DIRS}
                        ${GLIB_INCLUDE_DIRS}
                        ${GEXIV2_INCLUDE_DIRS}
                        ${CMAKE_SOURCE_DIR}/src
                        ${CMAKE_SOURCE_DIR}
                    )


#
#
# Set Vala sorces for generate C sources
#

VALA_PRECOMPILE(
    VALA_C
        button-menu.vala
        config.vala
        dbus.vala
        dialogs.vala
        image-item.vala
        infobar.vala
        pagelogin.vala
        pageproxy.vala
        widget-resize.vala
        widget-rotate.vala
        widget-common.vala
        imaging.vala
        toolbar.vala
        utils.vala
        window.vala
    PACKAGES
        glib-2.0
        posix
# set gtk+-2 if need
        gtk+-3
        gio-2.0
        gexiv2
# set gdk-x11-2 if need
        gdk-x11-3
    OPTIONS
        -C
        --thread
        --disable-warnings
        --header=${CMAKE_BINARY_DIR}/include/${PROJECT}.h
        --internal-header=${CMAKE_BINARY_DIR}/vapi/${PROJECT}_internal.h
    GENERATE_VAPI
        ${CMAKE_BINARY_DIR}/vapi/${PROJECT}
)


#
# Set sources for compiling
#
#

SET (SOURCES ${VALA_C})


#
# Set config.h
#
#
SET (CMAKE_C_FLAGS "-include ${CMAKE_SOURCE_DIR}/config.h")

#
# Build shared library
#
#

ADD_LIBRARY (
                ${LIBNAME}
                SHARED
                ${SOURCES}
            )


TARGET_LINK_LIBRARIES (
                        ${LIBNAME}
                        ${GTK_LIBRARIES}
                        ${GLIB_LIBRARIES}
                        ${GEXIV2_LIBRARIES}
                      )

#
# Installation
#
#

SET (CMAKE_INSTALL_PREFIX "/usr")

INSTALL (
            FILES
            ${CMAKE_BINARY_DIR}/src/${PROJECT}.so
            DESTINATION
            ${GTK_LIBDIR}
        )
        
INSTALL (
            FILES
            ${CMAKE_SOURCE_DIR}/${PROJECT}.pc
            DESTINATION
            /usr/lib/pkgconfig
        )
        
INSTALL (
            FILES
            ${CMAKE_BINARY_DIR}/include/${PROJECT}.h
            DESTINATION
            /usr/include/${PROJECT}
        )
         
INSTALL (
            FILES
            ${CMAKE_BINARY_DIR}/vapi/${PROJECT}.vapi
            DESTINATION
            /usr/share/vala/vapi
        ) 



###
