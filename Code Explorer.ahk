#SingleInstance,Force
CXML:=new XML("cxml")
File:=A_ScriptFullPath
Struct:="ahk.xml"
xx:=new XML("Struct",Struct)
Gui,Color,0,0
global sc,ss
Gui,Font,c0xAAAAAA
sc:=new s("1",{pos:"w800 h500"})
Gui,Add,Edit,x+0 w500 h500
Gui,Add,Button,xm gScan,&Scan File
Gui,Add,StatusBar
sc.2181(0,(FF:=FileOpen(File,"R")).Read())
FF.Close(),SB_SetParts(300,300)
Gui,Show,x600
sc.2025(0)
sc.2029(2)
ss:=new Structure()
ss.AddLanguage(Struct)
ss.ScanFile(File)
return
Escape::
GuiClose:
GuiEscape:
ExitApp
return
Scan:
ss.ScanFile(File)
return
Class Structure{
	Static XML:=new XML("Hold"),LanguageList:=new XML("LanguageList")
	__New(){
		for a,b in StrSplit("Languages,Associate",",")
			this[b]:=[]
		return this
	}AddLanguage(File){
		SplitPath,File,,,Ext
		MyXML:=new XML("test",File)
		Obj:=this.Languages[(Lang:=MyXML.SSN("//FileTypes/@language").text)]:=MyXML
		if(!Node:=this.LanguageList.SSN("//Language[@lang='" Lang "']"))
			Node:=this.LanguageList.Under(this.LanguageList.SSN("//*"),"Language",{lang:Lang})
		for a,b in StrSplit(MyXML.SSN("//FileTypes").text,"|")
			this.LanguageList.Under(Node,"Ext",,Format("{:L}",b))
		Obj.Code:=MyXML.SN("//Code/descendant::*")
	}ScanFile(File){
		SplitPath,File,,,Ext
		Language:=this.LanguageList.SSN("//*[text()='" Format("{:L}",Ext) "']/../@lang").text
		Code:=this.Languages[Language].Code
		CXML:=this.XML,CXML.XML.LoadXML("<hold/>")
		Text:=sc.GetUni()
		while(ww:=Code.Item[A_Index-1],ea:=XML.EA(ww)){
			Index:=A_Index
			Pos:=1,Regex:=RegExReplace(ea.Regex,"\x60n","`n")
			while(RegExMatch(Text,Regex,Found,Pos),Pos:=Found.Pos(1)+Found.Len(0)){
				if(RegExMatch(Found.Text,"\b(" ea.Exclude ")\b")&&ea.Exclude)
					Continue
				if(ww.ParentNode.Nodename="Code"){
					End:=Found.Len(Found.Count())+Found.Pos(Found.Count())
					Start:=StrPut(SubStr(Text,1,Found.Pos(ea.Full?0:"Text")),"UTF-8")-2
					Overall:=SubStr(Text,Found.Pos(ea.Full?0:"Text"),End-Found.Pos(ea.Full?0:"Text"))
					CXML.Add("item",{type:ww.NodeName,start:(Start=1?0:Start),end:(StrPut(Overall,"UTF-8")-1)+Start,text:Found.Text,upper:Format("{:U}",Found.Text)},,1)
				}
			}
		}
		CXML.Transform()
		CXML.Transform()
		GuiControl,,Edit1,% CXML[]
	}
}
Notify(x*){
	Code:=NumGet(x.3+8)
	if Code in 2013,2000,2001,2006,2028,2029
		return
	if(Code=2007){
		SB_SetText((Pos:=sc.2008))
		if(Node:=ss.XML.SSN("//*[@start<='" Pos "' and @end>='" Pos "']"))
			SB_SetText(Node.xml,2),sc.2200(Pos,Node.xml)
		else if(sc.2202)
			sc.2201()
			
	}else if(Code){
		SB_SetText(A_TickCount,2)
	}
}
#Include Lib\Class XML.ahk
#Include Lib\Class Scintilla.ahk
