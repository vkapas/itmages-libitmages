

SET (EXTENSION itmages-nautilus)


IF (NAUTILUS_VERSION EQUAL 3.0  OR NAUTILUS_VERSION GREATER 3.0)
    SET (NAUGTK 3.0)
ELSE ()
    SET (NAUGTK 2.0)
ENDIF ()

IF (NOT DEFINED EXECUTABLE)
    SET (EXECUTABLE "/usr/share/upload-pictures.png")
ENDIF ()

PKG_CHECK_MODULES (GTK_NUTILUS REQUIRED gtk+-${NAUGTK})
CONFIGURE_FILE (
                    ${CMAKE_CURRENT_SOURCE_DIR}/itmages-extension.c.in
                    ${CMAKE_CURRENT_SOURCE_DIR}/itmages-extension.c
                )

INCLUDE_DIRECTORIES (
                        ${GLIB_INCLUDE_DIRS}
                        ${NAUTILUS_INCLUDE_DIRS}
                        ${GTK_NUTILUS_INCLUDE_DIRS}
                        ${CMAKE_SOURCE_DIR}
                    )

SET (CMAKE_C_FLAGS "-include ${CMAKE_SOURCE_DIR}/config.h")

ADD_LIBRARY (${EXTENSION} SHARED itmages-extension.c)

TARGET_LINK_LIBRARIES (
                        ${EXTENSION} 
                        ${GLIB_LIBRARIES}
                        ${NAUTILUS_LIBRARIES}
                        ${GTK_NUTILUS_LIBRARIES}
                      )


INSTALL (
            FILES
            ${CMAKE_BINARY_DIR}/nautilus/lib${EXTENSION}.so
            DESTINATION
            ${NAUTILUS_LIBDIR}/nautilus/extensions-${NAUGTK}/
        )
