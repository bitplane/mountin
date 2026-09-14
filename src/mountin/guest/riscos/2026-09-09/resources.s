        GET     Hdr:ListOpts
        GET     Hdr:Macros
        GET     Hdr:System
        GET     Hdr:ModHand
        GET     Hdr:ResourceFS
        GET     Hdr:Services

        AREA    |MountinResources$$Code|, CODE, READONLY

Module_BaseAddr
        DCD     0
        DCD     MountinResources_Init - Module_BaseAddr
        DCD     MountinResources_Final - Module_BaseAddr
        DCD     MountinResources_Service - Module_BaseAddr
        DCD     MountinResources_Title - Module_BaseAddr
        DCD     MountinResources_Help - Module_BaseAddr
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     MountinResources_Flags - Module_BaseAddr

MountinResources_Title
        DCB     "MountinResources", 0
MountinResources_Help
        DCB     "Mountin resources", 9, "0.01", 0
        ALIGN
MountinResources_Flags
        DCD     ModuleFlag_32bit

MountinResources_Init
        STMFD   sp!, {lr}
        ADR     r0, MountinResources_Data
        SWI     XResourceFS_RegisterFiles
        LDMFD   sp!, {pc}

MountinResources_Final
        STMFD   sp!, {lr}
        ADR     r0, MountinResources_Data
        SWI     XResourceFS_DeregisterFiles
        LDMFD   sp!, {pc}

MountinResources_Service
        TEQ     r1, #Service_ResourceFSStarting
        BEQ     MountinResources_Reregister
        MOV     pc, lr

MountinResources_Reregister
        STMFD   sp!, {r0, lr}
        ADR     r0, MountinResources_Data
        MOV     lr, pc
        MOV     pc, r2
        LDMFD   sp!, {r0, pc}

MountinResources_Data
        BIN     resources.bin
        ALIGN

        END
