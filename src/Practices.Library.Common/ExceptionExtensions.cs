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

using NetowlsStudio.Practices.FoundationLibrary.Common.Resources;
using System;

namespace NetowlsStudio.Practices.FoundationLibrary.Common
{
    /// <summary>为 <see cref="Exception"/> 类型提供的扩展方法。</summary>
    public static class ExceptionExtensions
    {
        /// <summary>获取格式化的异常信息。</summary>
        /// <param name="exception">
        /// 派生自 <see cref="Exception"/> 类型的对象实例。
        /// </param>
        /// <param name="scenarioDescription">引发此异常时的情景描述信息。</param>
        /// <returns>
        /// 格式化的异常字符串。
        /// <para>比如：当 *** 时，引发了一个 System.Exception 类型的异常：未知的系统异常。</para>
        /// </returns>
        /// <seealso cref="Exception"/>
        public static string Format(this Exception exception, string scenarioDescription = null)
        {
            if (exception == null) return null;
            return string.IsNullOrWhiteSpace(scenarioDescription)
                ? string.Format(ExceptionStringResources.ExceptionExtensions_Format_WithoutDescription,
                                exception.GetType().AssemblyQualifiedName,
                                exception.Message)
                : string.Format(ExceptionStringResources.ExceptionExtensions_Format,
                                scenarioDescription,
                                exception.GetType().AssemblyQualifiedName,
                                exception.Message);
        }
    }
}