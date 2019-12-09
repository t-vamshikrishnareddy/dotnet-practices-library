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

namespace NetowlsStudio.Practices.FoundationLibrary.Common
{
    public static partial class StringExtensions
    {
        /// <summary>将字符串转换成等效的 <see cref="DateTime"/> 类型值。</summary>
        /// <param name="s">等效的字符串。</param>
        /// <param name="defaultValue">
        /// 当不满足
        /// <see cref="DateTime.TryParse(string, out DateTime)"/> 方法时，返回的默认值。
        /// </param>
        /// <returns><see cref="DateTime"/> 类型值。</returns>
        public static DateTime AsDateTime(this string s, DateTime defaultValue)
        {
            var result = ParseToDateTime(s);
            return result.HasValue ? result.Value : defaultValue;
        }

        /// <summary>将字符串转换成等效的 <see cref="DateTime"/> 类型值。</summary>
        /// <param name="s">等效的字符串。</param>
        /// <returns>
        /// <see cref="DateTime"/> 类型值。
        /// <para>
        /// 当 <paramref name="s"/> 不满足
        /// <see cref="DateTime.TryParse(string, out DateTime)"/>
        /// 方法时，将返回 <c>null</c> 值。
        /// </para>
        /// </returns>
        public static DateTime? AsDateTime(this string s)
        {
            return ParseToDateTime(s);
        }

        /// <summary>将字符串转换成等效的 <see cref="DateTime"/> 类型值。</summary>
        /// <param name="s">等效的字符串。</param>
        /// <param name="func">
        /// 构造返回值的方法。
        /// <para>
        /// <see cref="System.Func{T1, T2, TResult}"/> 类型的委托。
        /// </para>
        /// </param>
        /// <returns><see cref="DateTime"/> 类型值。</returns>
        /// <exception cref="ArgumentNullException">
        /// 当 <paramref name="func"/> 等于 <c>null</c> 时，将引发此类型的异常。
        /// </exception>
        public static DateTime AsDateTime(this string s, Func<string, DateTime?, DateTime> func)
        {
            if (func == null)
                throw new ArgumentNullException(nameof(func));
            return func(s, ParseToDateTime(s));
        }

        /// <summary>
        /// 尝试转换字符串 <paramref name="s"/> 为一个
        /// <see cref="DateTime"/> 类型值。
        /// </summary>
        /// <param name="s">需要装换的字符串。</param>
        /// <returns>
        /// <see cref="DateTime"/> 类型值。
        /// <para>
        /// 当 <paramref name="s"/> 不满足
        /// <see cref="DateTime.TryParse(string, out DateTime)"/>
        /// 方法时，将返回 <c>null</c> 值。
        /// </para>
        /// </returns>
        private static DateTime? ParseToDateTime(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
                return null;
            var result = DateTime.MinValue;
            if (DateTime.TryParse(s, out result)) return result;
            return null;
        }
    }
}