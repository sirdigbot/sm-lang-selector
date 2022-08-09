/**
 * This file is a part of Lanugage Selector.
 *
 * Copyright (C) 2022 SirDigbot (GitHub username)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#pragma semicolon 1
#pragma newdecls required


// Function executed each loop of the count timer
typedef CountTimer_Loop = function Action (int loopCount, any data);

// Function executed when the loop timer ends (error or not)
typedef CountTimer_End = function void (any data, bool error, bool stoppedEarly);


stock Handle CreateCountTimer(
    float interval,
    int maxIterations,
    CountTimer_Loop loopFunc,
    CountTimer_End endFunc,
    any data)
{
    if (maxIterations < 0)
        ThrowError("Count timer must have 1 or more iterations.");

    int flags = TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE | TIMER_DATA_HNDL_CLOSE;

    DataPack pack;
    Handle timer = CreateDataTimer(interval, _CountTimer_InternalLoop, pack, flags);
    pack.WriteCell(0); // Loop count
    pack.WriteCell(data);
    pack.WriteCell(maxIterations);
    pack.WriteFunction(loopFunc);
    pack.WriteFunction(endFunc);

    return timer;
}

Action _CountTimer_InternalLoop(Handle timer, DataPack pack)
{
    // TODO / BUG: This thing will loop forever if anything errors.
    // I don't think theres a fix for that.
    // Ree.

    pack.Reset();
    int loopCount = pack.ReadCell(); //  Exception reported: Data pack operation is out of bounds.
    any data = pack.ReadCell();
    int maxIterations = pack.ReadCell();

    // Don't validate funcs, they're error-checked below
    Function loopFunc = pack.ReadFunction();
    Function endFunc = pack.ReadFunction();

    ++loopCount;
    pack.Reset();
    pack.WriteCell(loopCount);

    Action result;
    int errorCode = SP_ERROR_NONE;
    bool error;
    bool didMaxIterations = loopCount >= maxIterations;

    if (!didMaxIterations)
    {
        // CountTimer_Loop = function Action (int loopCount, any data);
        Call_StartFunction(null, loopFunc);
        Call_PushCell(loopCount);
        Call_PushCell(data);
        errorCode = Call_Finish(result);
        error = errorCode != SP_ERROR_NONE;

        if (error)
            LogError("Failed to execute callback during timer loop. Stopping timer.");
    }

    if (result >= Plugin_Handled || didMaxIterations || error)
    {
        // CountTimer_End = function void (any data, bool error, bool stoppedEarly);
        Call_StartFunction(null, endFunc);
        Call_PushCell(data);
        Call_PushCell(error);
        Call_PushCell(!didMaxIterations);
        if (Call_Finish() != SP_ERROR_NONE)
            LogError("Failed to execute timer end function.");

        return Plugin_Stop;
    }

    return Plugin_Continue;
}
