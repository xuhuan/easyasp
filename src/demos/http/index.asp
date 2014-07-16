<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%><!--#include virtual="/easp/easp.asp" --><%
Easp.Use "Http"
Dim http, tmp, rule, arr, i
''=========================
''Demo 1 - 最简单的应用(Get)：
'直接获取页面源码
'tmp = Easp.Http.Get("http://easp.lengshi.com/about/")
'Easp.WN Easp.HtmlEncode(tmp)
''=========================

''=========================
''Demo 2 - 最简单的Post：
'Easp.Http.Data = Array("SearchClass:0","SearchKey:我吃西红柿")
'tmp = Easp.Http.Post("http://www.paoshu8.com/Book/Search.aspx")
'Easp.WN Easp.HtmlEncode(tmp)
''=========================

''=========================
''Demo 3 - 通过属性配置：
'Set http = Easp.Http.New()
''http.ResolveTimeout = 20000	'服务器解析超时时间，毫秒，默认20秒
''http.ConnectTimeout = 20000	'服务器连接超时时间，毫秒，默认20秒
''http.SendTimeout = 300000		'发送数据超时时间，毫秒，默认5分钟
''http.ReceiveTimeout = 60000	'接受数据超时时间，毫秒，默认1分钟
'http.Url = "http://www.paoshu8.com/Book/Search.aspx"	'目标URL地址
'http.Method = "POST"  'GET 或者 POST, 默认GET
''目标文件编码，一般不用设置此属性，Easp会自动判断目标地址的编码
''http.CharSet = "gb2312"
'http.Async = False	'异步，默认False，建议不要修改
''数据提交方式一，如果是GET则会附在URL后以参数形式提交：
''http.Data = "SearchClass=0&SearchKey=" & Server.URLEncode("我吃西红柿")
''数据提交方式二，可以用Array参数的方式提交：
'http.Data = Array("SearchClass:0","SearchKey:我吃西红柿")
''http.User = ""	'如果访问目标URL需要用户名
''http.Password = ""	'如果访问目标URL需要密码
'http.Open
'Easp.WE Easp.HtmlEncode(http.Html)
'Set http = Nothing
''=========================

''=========================
''Demo 4 - 获取文件头：
'Easp.Http.Get "http://www.baidu.com"
'tmp = Easp.Http.Headers
'Easp.WN Easp.HtmlEncode(tmp)
''=========================

''=========================
''Demo 5 - 获取文件指定部分内容：
'Dim bookid,bookname,bookdesc,uptime,readlink
'bookid = 1639199
'Easp.Http.Get("http://www.qidian.com/Book/"&bookid&".aspx")
''用SubStr按字符截取部分文本
'bookname = Easp.Http.SubStr("<div class=""title"">"&vbCrLf&" <h1>","</h1>",0)
'bookdesc = Easp.Http.SubStr("</div>"&vbCrLf&" <div class=""txt"">","</div>",0)
''用Find可按正则获取一段文本
'uptime = Easp.Http.Find("更新时间：[\d- :]+")
''用Select可按正则编组选择匹配的部分文本,$0是获取正则匹配的字符串本身
'readlink = Easp.Http.Select("(<a href="")(/BookReader/\d+.aspx)(.+</a>)","$1http://www.qidian.com$2$3")
'Easp.WN "<b>书名：</b>《" & bookname & "》  " & uptime
'Easp.WN "<b>阅读地址：</b>" & readlink
'Easp.WN "<b>内容简介：</b>"
'Easp.WN bookdesc
''=========================

''=========================
''Demo 6 - 获取文件循环部分：
'Easp.Http.Get "http://code.google.com/p/easyasp/updates/list"
'rule = "<span class=""date below-more"" title=""(.+?)""[\s\S]+?>(.+?)</span>[\s\S]+?<span class=""title""><a class=""ot-revision-link"" href=""/p/easyasp/source/detail\?r=(?:\d+?)"">(r\d+?)</a>\n \(([\s\S]+?)\).+>(\w+?)</a></span>"
'arr = Easp.Http.Search(rule)
'Easp.WN "====前5个匹配===="
'For i = 0 To 4
'	Easp.WN "<b>第" & i + 1 & "个匹配项：</b>"
'	Easp.WN Easp.HtmlEncode(arr(i))
'Next
'Easp.WN ""
''还可以用正则来进行更复杂的应用
'Dim Matches, Match
'Set Matches = Easp.RegMatch(Easp.Http.Html,rule)
'Easp.WN "====EasyASP更新日志摘要===="
'For Each Match In Matches
'	If Match.SubMatches(3)<>"[No log message]" Then Easp.WN Easp.Format("<li>{3}, {4} ({5} @ {2})</li>",Match)
'Next
'Set Matches = Nothing
''=========================

''=========================
''Demo 7 - 保存远程图片：
'Easp.Http.Get "http://www.baidu.com"
'tmp = Easp.Http.SaveImgTo_(Easp.Http.Html, "imgatlocal/")
'Easp.WN Easp.HtmlEncode(tmp)
''=========================

'=========================
'Demo 8 - WebService(SOAP1.1)示例：
'获得腾讯QQ在线状态
Dim QQ,xml : QQ = 800010000
tmp = "<?xml version=""1.0"" encoding=""utf-8""?>"
tmp = tmp & "<soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">"
tmp = tmp & "  <soap:Body>"
tmp = tmp & "    <qqCheckOnline xmlns=""http://WebXml.com.cn/"">"
tmp = tmp & "      <qqCode>" & QQ & "</qqCode>"
tmp = tmp & "    </qqCheckOnline>"
tmp = tmp & "  </soap:Body>"
tmp = tmp & "</soap:Envelope>"
Set http = Easp.Http.New
'设置请求头信息的三种方式，其一：
http.RequestHeader("Host") = "www.webxml.com.cn"
'其二：
http.SetHeader "Content-Type:text/xml; charset=utf-8"
'其三：
http.SetHeader Array("Content-Length:" & Len(tmp), "SOAPAction:http://WebXml.com.cn/qqCheckOnline")
http.Data = tmp
tmp = http.Post("http://www.webxml.com.cn/webservices/qqOnlineWebService.asmx?WSDL")
Set http = Nothing
'解析返回数据
Easp.Use "Xml"
Set xml = Easp.Xml.New
xml.Load tmp
tmp = xml("qqCheckOnlineResult").Value
Set xml = Nothing
Select Case tmp
	Case "Y" tmp = "在线"
	Case "N" tmp = "离线"
	Case "E" tmp = "号码错误"
	Case "A" tmp = "商业用户验证失败"
	CAse "V" tmp = "免费用户超过数量"
End Select
Easp.WN "QQ:" & QQ & " (" & tmp & ")"

'=========================

Easp.WN ""
Easp.wn "------------------------------------"
Easp.w "页面执行时间： " & Easp.ScriptTime & " 秒"
Set Easp = Nothing
%>