# java_doc
相关知识整理

1.反射中，Class.forName和ClassLoader区别

   装载：通过累的全限定名获取二进制字节流，将二进制字节流转换成方法区中的运行时数据结构，在内存中生成Java.lang.class对象； 
   链接：执行下面的校验、准备和解析步骤，其中解析步骤是可以选择的； 
　 校验：检查导入类或接口的二进制数据的正确性；（文件格式验证，元数据验证，字节码验证，符号引用验证） 
   准备：给类的静态变量分配并初始化存储空间； 
   解析：将常量池中的符号引用转成直接引用； 
   初始化：激活类的静态变量的初始化Java代码和静态Java代码块，并初始化程序员设置的变量值。
   
   分析 Class.forName()和ClassLoader.loadClass
   
   Class.forName(className)方法，内部实际调用的方法是  Class.forName(className,true,classloader);
   第2个boolean参数表示类是否需要初始化，  Class.forName(className)默认是需要初始化。
   一旦初始化，就会触发目标对象的 static块代码执行，static参数也也会被再次初始化。
    
   ClassLoader.loadClass(className)方法，内部实际调用的方法是  ClassLoader.loadClass(className,false);
   第2个 boolean参数，表示目标对象是否进行链接，false表示不进行链接，由上面介绍可以，
   不进行链接意味着不进行包括初始化等一些列步骤，那么静态块和静态对象就不会得到执行。
   
   

