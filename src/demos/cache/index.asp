<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%><!--#include virtual="/easp/easp.asp" --><%

'注意：此Demo需数据库支持，请设置正常的测试数据库连接并修改下面例子中57行的获取记录集的代码

Easp.Use "Cache"

'清除所有缓存
'Easp.Cache.Clear
'Easp.WE "Cache Cleared."

'不统计缓存总数(Easp.Cache.Count将无法取到Easp缓存总数)
'Easp.Cache.CountEnabled = False

'文件缓存的保存路径(默认为/_cache)
'Easp.Cache.SavePath = "/_cache"
'文件缓存的保存文件扩展名
Easp.Cache.FileType = ".cache"

'统一缓存的保存时间，单位为分钟，不设置默认为5分钟
'Easp.Cache.Expires = 5
'或设置为具体的过期时间：
'Easp.Cache.Expires = "2010/04/01 08:00:00"

'缓存字符串到文件缓存
Easp.WN "字符串缓存到文件缓存示例："
Dim tmp
'单独设置某一缓存的过期时间
Easp.Cache("test").Expires = 3
Easp.WN "此缓存的过期时间被设置为: " & Easp.Cache("test").Expires & " 分钟后"
If Easp.Cache("test").Ready Then
'如果缓存存在且没有过期
	tmp = Easp.Cache("test")
	Easp.WN "已读取缓存(test):"
Else
'如果缓存不存在或已过期
	'赋值给缓存对象
	tmp = "<i>测试字符串</i> 保存时间为 (" & Now() & ")"
	Easp.Cache("test") = tmp
	'保存缓存到文件缓存（注意：保存为文件缓存还是内存缓存，区别只有一点，就是使用Save还是SaveApp，它们的获取方式是一样的）
	Easp.Cache("test").Save
	Easp.WN "已保存缓存(test)."
End If
Easp.WN "---------"
Easp.WN tmp
Easp.WN "======================================"

''缓存记录集到文件缓存
'Easp.WN "记录集缓存到文件缓存示例："
'Dim rs
''缓存过期时间为1分钟
'Easp.Cache("test/rs").Expires = 1
'If Easp.Cache("test/rs").Ready Then
'	'读取文件缓存中的记录集(不需要Set)
'	rs = Easp.Cache("test/rs")
'	Easp.WN "已读取缓存(test/rs):"
'Else
'	Set rs = Easp.db.GR("Shop:5","","ID Desc") '这里要换成你自己的数据库相关内容
'	Easp.Cache("test/rs") = rs
'	'保存记录集到文件缓存，如果将记录集保存到内存缓存的话，会自动存为二维数组(GetRows)
'	Easp.Cache("test/rs").Save
'	Easp.WN "已保存缓存(test/rs)."
'End If
'Easp.WN "---------"
'If Easp.Has(rs) Then
'	While Not rs.EOF
'		Easp.WN "【" & rs(0) & "】" & rs(1) & " ( "&rs(2)&" )"
'		rs.MoveNext
'	Wend
'Else
'	Easp.WN "记录集为空"
'End If
'Easp.C(rs)

Easp.WN "======================================"

'缓存Dictionary对象到内存缓存
Easp.WN "字典对象缓存示例："
Dim dict, key
Easp.Cache("test/dict").Expires = 1
If Easp.Cache("test/dict").Ready Then
	dict = Easp.Cache("test/dict")
	Easp.WN "已读取缓存(test/dict):"
Else
	Set dict = Server.CreateObject("Scripting.Dictionary")
	dict.add "a", "aaaaa"
	dict.add "b", "bbbbb"
	Easp.Cache("test/dict") = dict
	'保存到内存缓存用SaveApp
	Easp.Cache("test/dict").SaveApp
	Easp.WN "已保存缓存(test/dict)."
End If
Easp.WN "---------"
'列出字典内容
For Each key In dict
	Easp.WN key & ":" & dict(key)
Next
Easp.C(dict)

Easp.WN "======================================"
'缓存数量
Easp.WN "总共有缓存：" & Easp.Cache.Count & "个"
'遍历缓存名称
Dim caches,ckey : Set caches = Easp.GetApp("Easp_Cache_Count")(1)
For Each ckey In caches
	Easp.WN ckey
Next
Easp.C(caches)

Easp.wn "------------------------------------"
Easp.w "页面执行时间： " & Easp.ScriptTime & " 秒, 共查询数据库： " & Easp.dbQueryTimes & " 次"
Set Easp = Nothing
%>