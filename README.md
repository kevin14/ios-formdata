# ios-formdata

# 功能
在``iOS``中提供了``Formdata``的``API``

使用``swift``语言

提供多文件上传功能

# API
### init
``init(url : NSURL , cachePolicy : NSURLRequestCachePolicy , timeoutInterval : NSTimeInterval , method:String = "POST")``

实例一个Form并且设置其url，缓存策略，超时时间以及请求方法，请求方法默认为POST


``init(url : NSURL , method:String = "POST")``

实例一个``Form``并且设置其``url``，请求方法，请求方法默认为``POST``

注：此方法``cachePolicy`` 为 ``NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData``，并且 ``timeoutInterval`` 为 ``2.0``

### append
``append(key : String , value : String)``

添加表单字段

### appendFile
``appendFile(key : String , filePath : NSURL!)``

添加文件

### send
``send(callback:((response:NSURLResponse! , dataObject:NSData!, error:NSError!) -> Void))``

发送请求，回调函数的参数分别为``response``,返回数据以及错误


# 示例
```
let url:NSURL? = NSURL(string: "http://localhost:3000/test")

var formdata = FormData(url: url!)
var filePath:NSURL = NSBundle.mainBundle().URLForResource("app", withExtension: "js")!
var jpgPath:NSURL = NSBundle.mainBundle().URLForResource("jacob", withExtension: "jpg")!
formdata.append(key: "hello", value: "world")
formdata.appendFile(key: "app", filePath: filePath)
formdata.appendFile(key: "jacob", filePath: jpgPath)
formdata.send({
    (response , dataObject , error) -> Void in
    var result = NSString(data: dataObject, encoding: NSUTF8StringEncoding)!
    println(result)
})
```



