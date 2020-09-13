//
// Copyright (C) 2018-2019  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// Patch idea and source bytes by Functor
//#############################################################
//# Purpose: Fix delay for act files with big number of frames#
//#          CRenderObject_virt28                             #
//#############################################################

function FixActDelay()
{
    // step 1
    var code =
        "D9 5D AB " +                 // 0 fstp [ebp+actIndex]
        "F3 0F 10 45 AB " +           // 3 movss xmm0, [ebp+actIndex]
        "0F 57 C9 " +                 // 8 xorps xmm1, xmm1
        "0F 2F C8 " +                 // 11 comiss xmm1, xmm0
        "F3 0F 11 45 AB " +           // 14 movss [ebp+actIndex], xmm0
        "72 AB " +                    // 19 jb short loc_9A2388
        "57 " +                       // 21 push edi
        "8B CB " +                    // 22 mov ecx, ebx
        "E8 ";                        // 24 call CActRes_GetDelay
    var actIndexOffset1 = 2;
    var actIndexOffset2 = 7;
    var actIndexOffset3 = 18;
    var patchOffset = 19;

    var offset = exe.findCode(code, PTYPE_HEX, true, "\xAB");
    if (offset === -1)
        return "Failed in step 1 - pattern not found";

    var index1 = exe.fetchUByte(offset + actIndexOffset1);
    var index2 = exe.fetchUByte(offset + actIndexOffset2);
    var index3 = exe.fetchUByte(offset + actIndexOffset3);

    if (index1 != index2 || index2 != index3)
    {
        return "Failed in step 1 - found different act indexes";
    }

    exe.replace(offset + patchOffset, "90 90", PTYPE_HEX);
    return true;
}
