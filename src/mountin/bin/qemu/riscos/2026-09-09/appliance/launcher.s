        GET     Hdr:ListOpts
        GET     Hdr:Macros
        GET     Hdr:System
        GET     Hdr:ModHand
        GET     Hdr:HighFSI
        GET     Hdr:FSNumbers
        AREA    |MountinLauncher$$Code|, CODE, READONLY

Module_BaseAddr
        DCD     MountinLauncher_Enter - Module_BaseAddr
        DCD     MountinLauncher_Init - Module_BaseAddr
        DCD     0
        DCD     0
        DCD     MountinLauncher_Title - Module_BaseAddr
        DCD     MountinLauncher_Help - Module_BaseAddr
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     MountinLauncher_Flags - Module_BaseAddr

MountinLauncher_Title
        DCB     "MountinLauncher", 0
MountinLauncher_Help
        DCB     "Mountin launcher", 9, "0.01", 0
        ALIGN
MountinLauncher_Flags
        DCD     ModuleFlag_32bit

MountinLauncher_Init
        MOV     r0, #0
        CMP     r0, r0
        MOV     pc, lr

MountinLauncher_Enter
MountinLauncher_Start
MountinLauncher_OpenSerial
        MOV     r0, #&CF                 ; DualSerial SERIAL_OUTPUT
        ADR     r1, MountinLauncher_Serial
        SWI     XOS_Find
        BVS     MountinLauncher_Reschedule
        MOV     r4, r0
        ADR     r5, MountinLauncher_Marker
MountinLauncher_WriteMarker
        LDRB    r0, [r5], #1
        CMP     r0, #0
        BEQ     MountinLauncher_CloseMarker
        MOV     r1, r4
        SWI     XOS_BPut
        BVC     MountinLauncher_WriteMarker
MountinLauncher_CloseMarker
        MOV     r0, #0
        MOV     r1, r4
        SWI     XOS_Find
        MOV     r0, #FSControl_SelectFS
        MOV     r1, #fsnumber_SDFS
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        MOV     r0, #FSControl_Dir
        ADR     r1, MountinLauncher_Root
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        ADR     r0, MountinLauncher_9d
        SWI     XOS_CLI
MountinLauncher_Reschedule
        MOV     r0, #129
        MOV     r1, #10
        MOV     r2, #0
        SWI     XOS_Byte
        B       MountinLauncher_Start

MountinLauncher_Root
        DCB     "SDFS::0.$", 0
MountinLauncher_Serial
        DCB     "devices:$.serial1", 0
MountinLauncher_Marker
        DCB     "MOUNTIN-SERIAL1", 10, 0
MountinLauncher_9d
        DCB     "Run Resources:$.Mountin.9d -d -R -p stream!/dev/ttyS0 .", 0
        ALIGN

        END
