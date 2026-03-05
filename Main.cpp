#include "easm.h"
#include "MipsDisplay.hpp"
#include <memory>
#include <cstdlib>
#include <iostream>

static MipsDisplay* gDisplay = nullptr;

extern "C"
#ifdef _WIN32
__declspec(dllexport)
#endif
ErrorCode handleSyscall(uint32_t* regs, void* mem, MemoryMap* mem_map)
{
    (void)mem;
    (void)mem_map;
    
    switch (regs[Register::v0])
    {
        case 100:  // Start Engine
            if (!gDisplay)
            {
                gDisplay = new MipsDisplay();
                gDisplay->RunEngine();
            }
            return ErrorCode::Ok;

        case 101:  // Set Pixel
            if (gDisplay)
                gDisplay->SetDisplayPixel(
                    regs[Register::a0],
                    regs[Register::a1],
                    regs[Register::a2]
                );
            return ErrorCode::Ok;

        case 102:  // Refresh
            if (gDisplay)
                gDisplay->Flush();
            return ErrorCode::Ok;

        case 103:  // Clear
            if (gDisplay)
                gDisplay->ClearScreen(regs[Register::a0]);
            return ErrorCode::Ok;

        case 104:  // Get Key
            if (gDisplay) {
                regs[Register::v0] = gDisplay->GetLastKey();
                //  pausa para no saturar 
                gDisplay->Sleep(5);
            } else {
                regs[Register::v0] = 0;
            }
            return ErrorCode::Ok;

        case 105:  // Exit Graphics
            if (gDisplay)
            {
                gDisplay->StopEngine();
                delete gDisplay;
                gDisplay = nullptr;
            }
            return ErrorCode::Ok;
            
        default:
            return ErrorCode::SyscallNotImplemented;
    }
}
