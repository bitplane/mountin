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
        ADRL    r10, MountinLauncher_StageSerial
        ADRL    r5, MountinLauncher_Marker
        BL      MountinLauncher_WriteSerialString
        BVS     MountinLauncher_Reschedule
        MRS     r0, CPSR
        BIC     r0, r0, #&80
        MSR     CPSR_c, r0
        MOV     r0, #129
        MOV     r1, #100
        MOV     r2, #0
        SWI     XOS_Byte
        ADRL    r0, MountinLauncher_RTSupport
        MOV     r10, r0
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
        LDR     r0, =&100000
        MOV     r8, #OSHW_CallHAL
        MOV     r9, #EntryNo_HAL_CounterDelay
        SWI     XOS_Hardware
        ADRL    r0, MountinLauncher_DWCDriver
        MOV     r10, r0
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
        MOV     r0, #129
        MOV     r1, #100
        MOV     r2, #0
        SWI     XOS_Byte
        ADRL    r10, MountinLauncher_StageCDFS
        MOV     r0, #1
        SWI     XCDFS_SetNumberOfDrives
        BVS     MountinLauncher_Reschedule
        ADRL    r5, MountinLauncher_CDModules
MountinLauncher_NextCDModule
        LDRB    r0, [r5]
        CMP     r0, #0
        BEQ     MountinLauncher_CDModulesDone
        MOV     r0, r5
        MOV     r10, r5
        SWI     XOS_CLI
        BVS     MountinLauncher_Reschedule
MountinLauncher_SkipCDModule
        LDRB    r0, [r5], #1
        CMP     r0, #0
        BNE     MountinLauncher_SkipCDModule
        B       MountinLauncher_NextCDModule
MountinLauncher_CDModulesDone
        ADRL    r10, MountinLauncher_StageSDFS
        MOV     r0, #FSControl_SelectFS
        MOV     r1, #fsnumber_SDFS
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        MOV     r0, #FSControl_Dir
        ADRL    r1, MountinLauncher_Root
        MOV     r10, r1
        SWI     XOS_FSControl
        BVS     MountinLauncher_Reschedule
        ADRL    r0, MountinLauncher_9d
        MOV     r10, r0
        SWI     XOS_CLI
MountinLauncher_Reschedule
        BVC     MountinLauncher_Retry
        MOV     r6, r0                  ; Preserve the native error block.
        ADRL    r5, MountinLauncher_ErrorPrefix
        BL      MountinLauncher_WriteSerialString
        MOV     r5, r10
        BL      MountinLauncher_WriteSerialString
        ADRL    r5, MountinLauncher_ErrorSeparator
        BL      MountinLauncher_WriteSerialString
        ADD     r5, r6, #4
        BL      MountinLauncher_WriteSerialString
        ADRL    r5, MountinLauncher_Newline
        BL      MountinLauncher_WriteSerialString
MountinLauncher_Retry
        MOV     r0, #129
        MOV     r1, #10
        MOV     r2, #0
        SWI     XOS_Byte
        B       MountinLauncher_Start

MountinLauncher_WriteSerialString
        Push    "r1-r3,r5,r7-r8,lr"
        MOV     r8, #252                ; Bound the native error message.
MountinLauncher_WriteSerialNext
        LDRB    r7, [r5], #1
        CMP     r7, #0
        BEQ     MountinLauncher_WriteSerialDone
MountinLauncher_WriteSerialByte
        MOV     r0, #3                  ; OS_SerialOp: transmit a byte.
        MOV     r1, r7
        SWI     XOS_SerialOp
        BVS     MountinLauncher_WriteSerialDone
        BCS     MountinLauncher_WriteSerialByte
        SUBS    r8, r8, #1
        BNE     MountinLauncher_WriteSerialNext
MountinLauncher_WriteSerialDone
        Pull    "r1-r3,r5,r7-r8,pc"

MountinLauncher_StageSerial
        DCB     "serial output", 0
MountinLauncher_StageCDFS
        DCB     "CDFS_SetNumberOfDrives", 0
MountinLauncher_StageSDFS
        DCB     "select SDFS", 0
MountinLauncher_ErrorSeparator
        DCB     ": ", 0
MountinLauncher_ErrorPrefix
        DCB     "MOUNTIN-ERROR: ", 0
MountinLauncher_Newline
        DCB     10, 0
MountinLauncher_Root
        DCB     "SDFS::0.$", 0
MountinLauncher_Marker
        DCB     "MOUNTIN-SERIAL1", 10, 0
MountinLauncher_9d
        DCB     "Run Resources:$.Mountin.9d -R -p serial!/dev/ttyS0", 0
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
