        GET     Hdr:ListOpts
        GET     Hdr:Macros
        GET     Hdr:System
        GET     Hdr:ModHand
        GET     Hdr:HighFSI
        GET     Hdr:FSNumbers
        GET     Hdr:HALEntries
        GET     Hdr:CDFS
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
        ADRL    r0, MountinLauncher_Start
        MOV     r1, #0
        SWI     XOS_AddCallBack
        MOVVC   r0, #0
        MOV     pc, lr

MountinLauncher_Start
MountinLauncher_OpenSerial
        MOV     r0, #&CF                 ; DualSerial SERIAL_OUTPUT
        ADRL    r1, MountinLauncher_Serial
        SWI     XOS_Find
        BVS     MountinLauncher_Reschedule
        MOV     r4, r0
        ADRL    r5, MountinLauncher_Marker
MountinLauncher_WriteMarker
        LDRB    r0, [r5], #1
        CMP     r0, #0
        BEQ     MountinLauncher_CloseMarker
        MOV     r1, r4
        SWI     XOS_BPut
        BVC     MountinLauncher_WriteMarker
MountinLauncher_CloseMarker
        MRS     r0, CPSR
        BIC     r0, r0, #&80
        MSR     CPSR_c, r0
        MOV     r0, #129
        MOV     r1, #100
        MOV     r2, #0
        SWI     XOS_Byte
        ADRL    r0, MountinLauncher_RTSupport
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
        LDR     r0, =&100000
        MOV     r8, #OSHW_CallHAL
        MOV     r9, #EntryNo_HAL_CounterDelay
        SWI     XOS_Hardware
        ADRL    r0, MountinLauncher_DWCDriver
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
        MOV     r0, #129
        MOV     r1, #100
        MOV     r2, #0
        SWI     XOS_Byte
        MOV     r0, #1
        SWI     XCDFS_SetNumberOfDrives
        BVS     MountinLauncher_Reschedule
        ADRL    r5, MountinLauncher_CDModules
MountinLauncher_NextCDModule
        LDRB    r0, [r5]
        CMP     r0, #0
        BEQ     MountinLauncher_CDModulesDone
        MOV     r0, r5
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
MountinLauncher_SkipCDModule
        LDRB    r0, [r5], #1
        CMP     r0, #0
        BNE     MountinLauncher_SkipCDModule
        B       MountinLauncher_NextCDModule
MountinLauncher_CDModulesDone
        MOV     r0, #0
        MOV     r1, r4
        SWI     XOS_Find
        MOV     r0, #FSControl_SelectFS
        MOV     r1, #fsnumber_SDFS
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        MOV     r0, #FSControl_Dir
        ADRL    r1, MountinLauncher_Root
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        ADRL    r0, MountinLauncher_9d
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
        DCB     "Run Resources:$.Mountin.9d -R -p stream!/dev/ttyS0", 0
MountinLauncher_RTSupport
        DCB     "RMLoad Resources:$.Mountin.RTSupport", 0
MountinLauncher_DWCDriver
        DCB     "RMReInit DWCDriver", 0
MountinLauncher_CDModules
        DCB     "RMReInit CDFSDriver", 0
        DCB     "RMReInit CDFSSoftSCSI", 0
        DCB     "RMReInit CDFS", 0
        DCB     0
        ALIGN

        END
