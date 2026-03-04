#include "easm.h"
#include "MipsDisplay.hpp"
#include <memory>

static std::unique_ptr<MipsDisplay> gDisplay;

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
        // 100 - Start Engine
        case 100:
            if (!gDisplay)
            {
                gDisplay = std::make_unique<MipsDisplay>();
                gDisplay->RunEngine();
            }
            return ErrorCode::Ok;

        // 101 - Set Pixel a0=x, a1=y, a2=color
        case 101:
            if (gDisplay)
                gDisplay->SetDisplayPixel(
                    regs[Register::a0],
                    regs[Register::a1],
                    regs[Register::a2]
                );
            return ErrorCode::Ok;

        // 102 - Refresh
        case 102:
            if (gDisplay)
                gDisplay->Flush();
            return ErrorCode::Ok;

        // 103 - Clear 
        case 103:
            if (gDisplay)
                gDisplay->ClearScreen(regs[Register::a0]);
            return ErrorCode::Ok;

        // 104 - S

        default:
            return ErrorCode::SyscallNotImplemented;
    }
}