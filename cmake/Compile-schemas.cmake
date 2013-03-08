
SET (FOLDER "/usr/share/glib-2.0/schemas")
execute_process (COMMAND test -w ${FOLDER} RESULT_VARIABLE PERM_OK)
message ("Compile permissions: ${FOLDER} ${PERM_OK}")

IF (${PERM_OK} EQUAL 0)
    execute_process (COMMAND glib-compile-schemas ${FOLDER})
ENDIF ()
