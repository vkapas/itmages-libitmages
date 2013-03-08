
SET (FOLDER "/usr/share/icons/highcolor")
execute_process (COMMAND test -w ${FOLDER} RESULT_VARIABLE RERM_OK)
message ("Hicolors permissions: ${FOLDER} ${PERM_OK}")

SET (UPDATER_PROGREMM "gtk-update-icon-cache")


IF (${HAS_UPDATER})

    SET (UPDATER_PROGRAMM "update-icon-cache")
    execute_process (
                        COMMAND test -f "/usr/bin/${UPDATER_PROGRAMM}"
                        RESUL_VARIABLE HAS_UPDATER
                    )
    IF (${HAS_UPDATER})
        SET (PERM_OK 1)
    ELSE () 
        SET (HAS_UPDATER 0)
    ENDIF ()

ELSE ()
    SET (HAS_UPDATER 0)
ENDIF ()


IF (${HAS_UPDATER})
    MESSAGE ("Update icon chashe programm not found")
ELSE ()
    MESSAGE ("Found icon updater ${UPDATER_PROGRAMM}")
ENDIF ()


IF (${PERM_OK} AND ${HAS_UPDATER})
    MESSAGE ("Skeep icon updater")
ELSE ()
    execute_process (COMMAND ${UPDATER_PROGRAMM} ${FOLDER})
ENDIF ()
