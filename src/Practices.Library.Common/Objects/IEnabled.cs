/*
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
    /// <summary>定义了是否启用的状态接口。</summary>
    /// <typeparam name="T">用于标识是否启用的状态类型。</typeparam>
    public interface IEnabled<T>
    {
        /// <summary>启用禁用状态值。</summary>
        /// <value>设置或获取 <typeparamref name="T"/> 类型的对象实例或值，用于表示启用禁用状态值。</value>
        T EnabledState { get; set; }

        /// <summary>用于校验是否处于启用状态。</summary>
        /// <returns>如果处于启用状态，则返回 <c>true</c>；否则返回 <c>false</c>。</returns>
        bool IsEnabled();
    }

    /// <summary>定义了是否启用的状态接口。</summary>
    /// <seealso cref="IEnabled{T}"/>
    public interface IEnabled : IEnabled<bool>
    {
    }
}