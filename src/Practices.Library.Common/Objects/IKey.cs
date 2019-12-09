namespace NetowlsStudio.Practices.FoundationLibrary.Common.Objects
{
    /// <summary>定义了标识名称接口。</summary>
    /// <typeparam name="T">标识名称类型。</typeparam>
    public interface IKey<T>
    {
        /// <summary><typeparamref name="T"/> 类型的标识名称。</summary>
        /// <value>设置或获取 <typeparamref name="T"/> 类型的对象实例或值，用于表示标识名称。</value>
        T Key { get; set; }
    }
}