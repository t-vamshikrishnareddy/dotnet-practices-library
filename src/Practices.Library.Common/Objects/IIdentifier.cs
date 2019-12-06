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
    /// <summary>定义了标识符信息的接口。</summary>
    public interface IIdentifier
    {
        /// <summary>标识符。</summary>
        /// <value>设置或获取 <see cref="object"/> 类型的对象实例，用于表示标识符。</value>
        object Id { get; set; }
    }

    /// <summary>定义了泛型的标识符信息的接口。</summary>
    /// <typeparam name="T">标识符类型</typeparam>
    /// <seealso cref="IIdentifier"/>
    public interface IIdentifier<T> : IIdentifier
    {
        /// <summary><typeparamref name="T"/> 类型的标识符。</summary>
        /// <value>设置或获取 <typeparamref name="T"/> 类型的对象实例或值，用于表示标识符。</value>
        /// <seealso cref="IIdentifier.Id"/>
        new T Id { get; set; }
    }
}