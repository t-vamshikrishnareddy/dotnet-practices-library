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
    /// <summary> 为 <see cref="byte" /> 和 <see cref="byte" />[] 类型提供的扩展方法。 </summary>
    public static class ByteExtensions
    {
        /// <summary> 使用指定的编码获取字符串。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <param name="encoding">
        /// 编码器。
        /// <para> 派生自 <see cref="System.Text.Encoding" /> 类型的对象实例。 </para>
        /// </param>
        /// <returns> 字符串。 </returns>
        /// <seealso cref="System.Text.Encoding" />
        /// <exception cref="ArgumentNullException"> 当 <paramref name="encoding" /> 等于 <c> null </c> 时，将引发此类型的异常。 </exception>
        public static string GetString(this byte[] data, Encoding encoding)
        {
            return InternalGetString(data, encoding);
        }

        /// <summary> 使用 UTF-8 编码获取字符串。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <returns> 字符串。 </returns>
        /// <seealso cref="System.Text.Encoding.UTF8" />
        /// <seealso cref="System.Text.UTF8Encoding" />
        public static string GetString(this byte[] data)
        {
            return InternalGetString(data, LibraryDefaults.DefaultEncoding);
        }

        /// <summary> 用于检查字节数组是否不等于 <c> null </c> 且 <c> Length </c> 属性大于 0。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <returns> <c> true </c>/ <c> false </c>。 </returns>
        public static bool HasValue(byte[] data)
        {
            return data != null && data.Length > 0;
        }

        /// <summary> 将字节数组转换成 Base64 字符串。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <returns> Base64 字符串。 </returns>
        /// <seealso cref="System.Convert.ToBase64String(byte[])" />
        public static string ToBase64String(this byte[] data)
        {
            return HasValue(data) ? Convert.ToBase64String(data) : null;
        }

        /// <summary> 将字节数组转换成十六进制（双位）字符串。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <param name="lowerCase"> 是否需要小写。如果为 <c> false </c>，则表示返回大写字符串。 </param>
        /// <returns> 十六进制字符串。 </returns>
        /// <seealso cref="System.BitConverter.ToString(byte[])" />
        public static string ToHexString(this byte[] data, bool lowerCase = true)
        {
            if (!HasValue(data))
                return null;
            var hexStr = BitConverter.ToString(data).Replace("-", string.Empty);
            return lowerCase ? hexStr.ToLower() : hexStr.ToUpper();
        }

        /// <summary> 使用指定的编码获取字符串。 </summary>
        /// <param name="data"> 字节数组。 </param>
        /// <param name="encoding">
        /// 编码器。
        /// <para> 派生自 <see cref="System.Text.Encoding" /> 类型的对象实例。 </para>
        /// </param>
        /// <returns> 字符串。 </returns>
        /// <seealso cref="System.Text.Encoding" />
        /// <exception cref="ArgumentNullException"> 当 <paramref name="encoding" /> 等于 <c> null </c> 时，将引发此类型的异常。 </exception>
        private static string InternalGetString(this byte[] data, Encoding encoding)
        {
            if (!HasValue(data)) return null;
            if (encoding == null)
                throw new ArgumentNullException(nameof(encoding));
            return encoding.GetString(data);
        }
    }
}