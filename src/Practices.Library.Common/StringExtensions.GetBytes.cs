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

using System;
using System.Text;

namespace NetowlsStudio.Practices.FoundationLibrary.Common
{
    public static partial class StringExtensions
    {
        /// <summary>使用指定的编码获取字符串 <paramref name="s"/> 的字节数组。</summary>
        /// <param name="s">字符串。</param>
        /// <param name="encoding">
        /// 编码器。
        /// <para>派生自 <see cref="System.Text.Encoding"/> 类型的对象实例。</para>
        /// </param>
        /// <returns>字节数组。</returns>
        /// <seealso cref="System.Text.Encoding"/>
        /// <exception cref="ArgumentNullException">
        /// 当 <paramref name="encoding"/> 等于 <c>null</c> 时，将引发此类型的异常。
        /// </exception>
        public static byte[] GetBytes(this string s, Encoding encoding)
        {
            return InternalGetBytes(s, encoding);
        }

        /// <summary>
        /// 使用 UTF-8 编码获取字符串 <paramref name="s"/> 的字节数组。
        /// </summary>
        /// <param name="s">字符串。</param>
        /// <returns>字节数组。</returns>
        /// <seealso cref="System.Text.Encoding"/>
        /// <seealso cref="System.Text.Encoding.UTF8"/>
        /// <seealso cref="System.Text.UTF8Encoding"/>
        /// <seealso cref="LibraryDefaults.DefaultEncoding"/>
        public static byte[] GetBytes(this string s)
        {
            return InternalGetBytes(s, LibraryDefaults.DefaultEncoding);
        }

        /// <summary>使用指定的编码获取字符串 <paramref name="s"/> 的字节数组。</summary>
        /// <param name="s">字符串。</param>
        /// <param name="encoding">
        /// 编码器。
        /// <para>派生自 <see cref="System.Text.Encoding"/> 类型的对象实例。</para>
        /// </param>
        /// <returns>字节数组。</returns>
        /// <seealso cref="System.Text.Encoding"/>
        /// <exception cref="ArgumentNullException">
        /// 当 <paramref name="encoding"/> 等于 <c>null</c> 时，将引发此类型的异常。
        /// </exception>
        private static byte[] InternalGetBytes(string s, Encoding encoding)
        {
            if (string.IsNullOrEmpty(s)) return null;
            if (encoding == null)
                throw new ArgumentNullException(nameof(encoding));
            return encoding.GetBytes(s);
        }
    }
}