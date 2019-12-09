﻿/*
*******************************************************************************************************************************************************
* MIT License
*
* Copyright © 2006 - 2019 Wang Yucai. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*******************************************************************************************************************************************************
*/

namespace NetowlsStudio.Practices.FoundationLibrary.Common.Objects
{
    /// <summary>定义了标识名称和值的接口。</summary>
    /// <typeparam name="TKey">标识名称类型。</typeparam>
    /// <typeparam name="TValue">值类型。</typeparam>
    /// <seealso cref="IKey{T}"/>
    /// <seealso cref="IValue{T}"/>
    public interface IKeyValue<TKey, TValue> : IKey<TKey>, IValue<TValue>
    {
    }
}