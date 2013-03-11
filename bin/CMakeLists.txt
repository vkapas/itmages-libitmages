


# Attach/detach unity extension

IF (WITH_UNITY)
    SET (HasUnity "  ")
    SET (UNITY_VAPI "unity")
    SET (UNITY_VALA "unity-launcher.vala")
    SET (UNITY_LIBS ${UNITY_LIBRARIES})
    SET (UNITY_INCLUDES ${UNITY_INCLUDE_DIRS})
    INCLUDE_DIRECTORIES (${UNITY_INCLUDE_DIRS} ${UNITY_LIBRARIES})
    MESSAGE ("-- Build with Unity extension")
ELSE ()
    SET (HasUnity "//")
    SET (UNITY_VAPI "")
    SET (UNITY_VALA "")
    SET (UNITY_LIBS "")
    SET (UNITY_INCLUDES "")
    MESSAGE ("-- Build without Unity extension")
ENDIF ()

CONFIGURE_FILE (
                    ${CMAKE_CURRENT_SOURCE_DIR}/main.vala.in
                    ${CMAKE_CURRENT_SOURCE_DIR}/main.vala
                )


INCLUDE_DIRECTORIES (
                        ${GTK_INCLUDE_DIRS}
                        ${GLIB_INCLUDE_DIRS}
                        ${GEXIV2_INCLUDE_DIRS}
                        ${UNITY_INCLUDES}
                        ${CMAKE_SOURCE_DIR}/src
                   )




#
# Set Vala sorces for generate C sources
#

VALA_PRECOMPILE(
    VALA_C
        main.vala
        ${UNITY_VALA}
    PACKAGES
        gio-2.0
        gdk-pixbuf-2.0
        gtk+-${GTKVER}
        ${PROJECT}
        gexiv2
        ${UNITY_VAPI}
    OPTIONS
        --thread
        --disable-warnings
        --vapidir=${CMAKE_BINARY_DIR}/vapi
        
)


#
# Build executable
#
#
SET (CMAKE_C_FLAGS "-include${CMAKE_SOURCE_DIR}/config.h -include${CMAKE_BINARY_DIR}/include/${PROJECT}.h")

#                        ${GTK_LIBRARIES}
#                        ${GLIB_LIBRARIES}
#                        ${GEXIV2_LIBRARIES}
#                        ${UNITY_LIBS}
INCLUDE_DIRECTORIES (
                        ${GTK_INCLUDE_DIRS}
                        ${GLIB_INCLUDE_DIRS}
                        ${GEXIV2_INCLUDE_DIRS}
                        ${UNITY_INCLUDES}
                        ${CMAKE_BINARY_DIR}/
                        ${CMAKE_BINARY_DIR}/src
                        ${CMAKE_BINARY_DIR}/include
                    )

ADD_EXECUTABLE (${EXECUTABLE} ${VALA_C})


TARGET_LINK_LIBRARIES (${EXECUTABLE} ${CMAKE_BINARY_DIR}/src/${PROJECT}.so ${UNITY_LIBS})

#
# Installation
SET (CMAKE_INSTALL_PREFIX "/usr")

INSTALL (
            PROGRAMS
            ${CMAKE_BINARY_DIR}/bin/${EXECUTABLE}
            DESTINATION
            /usr/bin
        )

INSTALL (
            FILES
            ${CMAKE_SOURCE_DIR}/pixmaps/${EXECUTABLE}.png
            DESTINATION
            /usr/share/pixmaps
        )

INSTALL (
            FILES
            ${CMAKE_SOURCE_DIR}/data/${EXECUTABLE}.desktop
            DESTINATION
            /usr/share/applications
        )

###
