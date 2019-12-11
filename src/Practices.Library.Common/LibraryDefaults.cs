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

using System.Globalization;
using System.Text;

namespace NetowlsStudio.Practices.FoundationLibrary.Common
{
    /// <summary> 提供了类库默认选项相关的方法。 </summary>
    public static class LibraryDefaults
    {
        /// <summary> 默认的文化区域标识。 </summary>
        public const int DefaultCultureId = 0x804;

        /// <summary> 默认的文化区域名称。 </summary>
        public const string DefaultCultureName = "zh-CN";

        /// <summary> 默认的日期格式化字符串。 </summary>
        public const string DefaultDateFormat = "yyyy-MM-dd";

        /// <summary> 默认的日期时间格式化字符串。 </summary>
        public const string DefaultDateTimeFormat = "yyyy-MM-dd HH:mm:ss";

        /// <summary> 默认的文化区域。 </summary>
        /// <seealso cref="System.Globalization.CultureInfo" />
        /// <seealso cref="DefaultCultureId" />
        public static readonly CultureInfo DefaultCulture = new CultureInfo(DefaultCultureId);

        /// <summary> 默认的编码。 </summary>
        /// <seealso cref="System.Text.Encoding" />
        /// <seealso cref="System.Text.Encoding.UTF8" />
        /// <seealso cref="System.Text.UTF8Encoding" />
        public static readonly Encoding DefaultEncoding = Encoding.UTF8;
    }
}