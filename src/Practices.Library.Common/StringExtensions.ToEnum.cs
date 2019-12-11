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
    public static partial class StringExtensions
    {
        /// <summary> 将字符串 <paramref name="s" /> 转换成 <typeparamref name="TEnum" /> 类型的枚举。 </summary>
        /// <typeparam name="TEnum"> 枚举类型。 </typeparam>
        /// <param name="s"> 与 <typeparamref name="TEnum" /> 类型的枚举等效的字符串。 </param>
        /// <param name="ignoreCase"> 是否忽略字符串 <paramref name="s" /> 的大小写。 </param>
        /// <returns> 枚举类型。 </returns>
        /// <exception cref="InvalidCastException"> 当 <typeparamref name="TEnum" /> 不是一个枚举类型时，将引发此类型的异常。 </exception>
        public static TEnum? AsEnum<TEnum>(this string s, bool ignoreCase = false)
            where TEnum : struct
        {
            return ParseToEnum<TEnum>(s, ignoreCase);
        }

        /// <summary> 将字符串 <paramref name="s" /> 转换成 <typeparamref name="TEnum" /> 类型的枚举。 </summary>
        /// <typeparam name="TEnum"> 枚举类型。 </typeparam>
        /// <param name="s"> 与 <typeparamref name="TEnum" /> 类型的枚举等效的字符串。 </param>
        /// <param name="defaultValue"> 默认值。 </param>
        /// <param name="ignoreCase"> 是否忽略字符串 <paramref name="s" /> 的大小写。 </param>
        /// <returns> 枚举类型。 </returns>
        /// <exception cref="InvalidCastException"> 当 <typeparamref name="TEnum" /> 不是一个枚举类型时，将引发此类型的异常。 </exception>
        public static TEnum AsEnum<TEnum>(this string s, TEnum defaultValue, bool ignoreCase = false)
            where TEnum : struct
        {
            var value = ParseToEnum<TEnum>(s, ignoreCase);
            return value.HasValue ? value.Value : defaultValue;
        }

        /// <summary> 将字符串 <paramref name="s" /> 转换成 <typeparamref name="TEnum" /> 类型的枚举。 </summary>
        /// <typeparam name="TEnum"> 枚举类型。 </typeparam>
        /// <param name="s"> 与 <typeparamref name="TEnum" /> 类型的枚举等效的字符串。 </param>
        /// <param name="func"> 构建 <typeparamref name="TEnum" /> 类型默认值的方法。 </param>
        /// <param name="ignoreCase"> 是否忽略字符串 <paramref name="s" /> 的大小写。 </param>
        /// <returns> 枚举类型。 </returns>
        /// <seealso cref="System.Func{T1, T2, TResult}" />
        /// <exception cref="InvalidCastException"> 当 <typeparamref name="TEnum" /> 不是一个枚举类型时，将引发此类型的异常。 </exception>
        public static TEnum AsEnum<TEnum>(this string s, Func<string, TEnum?, TEnum> func, bool ignoreCase = false)
            where TEnum : struct
        {
            var value = ParseToEnum<TEnum>(s, ignoreCase);
            if (!value.HasValue && func == null)
                throw new ArgumentNullException(nameof(func));
            return value.HasValue ? value.Value : func(s, value);
        }

        /// <summary> 将字符串 <paramref name="s" /> 转换成 <typeparamref name="TEnum" /> 类型的枚举。 </summary>
        /// <typeparam name="TEnum"> 枚举类型。 </typeparam>
        /// <param name="s"> 与 <typeparamref name="TEnum" /> 类型的枚举等效的字符串。 </param>
        /// <param name="ignoreCase"> 是否忽略字符串 <paramref name="s" /> 的大小写。 </param>
        /// <returns> 枚举类型。 </returns>
        /// <exception cref="InvalidCastException"> 当 <typeparamref name="TEnum" /> 不是一个枚举类型时，将引发此类型的异常。 </exception>
        private static TEnum? ParseToEnum<TEnum>(string s, bool ignoreCase = false)
            where TEnum : struct
        {
            if (!typeof(TEnum).IsEnum)
                throw new InvalidCastException(string.Format(ExceptionStringResources.IsNotEnumType, typeof(TEnum).FullName));
            return !string.IsNullOrWhiteSpace(s) && Enum.TryParse<TEnum>(s, ignoreCase, out TEnum value) ? new TEnum?(value) : null;
        }
    }
}