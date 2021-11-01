(function(){function runningInNode(){return((typeof require)=="function"&&(typeof exports)=="object"&&(typeof module)=="object"&&(typeof __filename)=="string"&&(typeof __dirname)=="string")}if(!runningInNode()){if(!this.Tautologistics){this.Tautologistics={}}else{if(this.Tautologistics.NodeHtmlParser){return}}this.Tautologistics.NodeHtmlParser={};exports=this.Tautologistics.NodeHtmlParser}var ElementType={Text:"text",Directive:"directive",Comment:"comment",Script:"script",Style:"style",Tag:"tag"};function Parser(handler,options){this._options=options?options:{};if(this._options.includeLocation==undefined){this._options.includeLocation=false}this.validateHandler(handler);this._handler=handler;this.reset()}Parser._reTrim=/(^\s+|\s+$)/g;Parser._reTrimComment=/(^\!--|--$)/g;Parser._reWhitespace=/\s/g;Parser._reTagName=/^\s*(\/?)\s*([^\s\/]+)/;Parser._reAttrib=/([^=<>\"\'\s]+)\s*=\s*"([^"]*)"|([^=<>\"\'\s]+)\s*=\s*'([^']*)'|([^=<>\"\'\s]+)\s*=\s*([^'"\s]+)|([^=<>\"\'\s\/]+)/g;Parser._reTags=/[\<\>]/g;Parser.prototype.parseComplete=function Parser$parseComplete(data){this.reset();this.parseChunk(data);this.done()};Parser.prototype.parseChunk=function Parser$parseChunk(data){if(this._done){this.handleError(new Error("Attempted to parse chunk after parsing already done"))}this._buffer+=data;this.parseTags()};Parser.prototype.done=function Parser$done(){if(this._done){return}this._done=true;if(this._buffer.length){var rawData=this._buffer;this._buffer="";var element={raw:rawData,data:(this._parseState==ElementType.Text)?rawData:rawData.replace(Parser._reTrim,""),type:this._parseState};if(this._parseState==ElementType.Tag||this._parseState==ElementType.Script||this._parseState==ElementType.Style){element.name=this.parseTagName(element.data)}this.parseAttribs(element);this._elements.push(element)}this.writeHandler();this._handler.done()};Parser.prototype.reset=function Parser$reset(){this._buffer="";this._done=false;this._elements=[];this._elementsCurrent=0;this._current=0;this._next=0;this._location={row:0,col:0,charOffset:0,inBuffer:0};this._parseState=ElementType.Text;this._prevTagSep="";this._tagStack=[];this._handler.reset()};Parser.prototype._options=null;Parser.prototype._handler=null;Parser.prototype._buffer=null;Parser.prototype._done=false;Parser.prototype._elements=null;Parser.prototype._elementsCurrent=0;Parser.prototype._current=0;Parser.prototype._next=0;Parser.prototype._location=null;Parser.prototype._parseState=ElementType.Text;Parser.prototype._prevTagSep="";Parser.prototype._tagStack=null;Parser.prototype.parseTagAttribs=function Parser$parseTagAttribs(elements){var idxEnd=elements.length;var idx=0;while(idx<idxEnd){var element=elements[idx++];if(element.type==ElementType.Tag||element.type==ElementType.Script||element.type==ElementType.style){this.parseAttribs(element)}}return(elements)};Parser.prototype.parseAttribs=function Parser$parseAttribs(element){if(element.type!=ElementType.Script&&element.type!=ElementType.Style&&element.type!=ElementType.Tag){return}var tagName=element.data.split(Parser._reWhitespace,1)[0];var attribRaw=element.data.substring(tagName.length);if(attribRaw.length<1){return}var match;Parser._reAttrib.lastIndex=0;while(match=Parser._reAttrib.exec(attribRaw)){if(element.attribs==undefined){element.attribs={}}if(typeof match[1]=="string"&&match[1].length){element.attribs[match[1]]=match[2]}else{if(typeof match[3]=="string"&&match[3].length){element.attribs[match[3].toString()]=match[4].toString()}else{if(typeof match[5]=="string"&&match[5].length){element.attribs[match[5]]=match[6]}else{if(typeof match[7]=="string"&&match[7].length){element.attribs[match[7]]=match[7]}}}}}};Parser.prototype.parseTagName=function Parser$parseTagName(data){if(data==null||data==""){return("")}var match=Parser._reTagName.exec(data);if(!match){return("")}return((match[1]?"/":"")+match[2])};Parser.prototype.parseTags=function Parser$parseTags(){var bufferEnd=this._buffer.length-1;while(Parser._reTags.test(this._buffer)){this._next=Parser._reTags.lastIndex-1;var tagSep=this._buffer.charAt(this._next);var rawData=this._buffer.substring(this._current,this._next);var element={raw:rawData,data:(this._parseState==ElementType.Text)?rawData:rawData.replace(Parser._reTrim,""),type:this._parseState};var elementName=this.parseTagName(element.data);if(this._tagStack.length){if(this._tagStack[this._tagStack.length-1]==ElementType.Script){if(elementName.toLowerCase()=="/script"){this._tagStack.pop()}else{if(element.raw.indexOf("!--")!=0){element.type=ElementType.Text;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Text){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep+element.raw;element.raw=element.data=""}}}}else{if(this._tagStack[this._tagStack.length-1]==ElementType.Style){if(elementName.toLowerCase()=="/style"){this._tagStack.pop()}else{if(element.raw.indexOf("!--")!=0){element.type=ElementType.Text;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Text){var prevElement=this._elements[this._elements.length-1];
if(element.raw!=""){prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep+element.raw;element.raw=element.data=""}else{prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep}}else{if(element.raw!=""){element.raw=element.data=element.raw}}}}}else{if(this._tagStack[this._tagStack.length-1]==ElementType.Comment){var rawLen=element.raw.length;if(element.raw.charAt(rawLen-2)=="-"&&element.raw.charAt(rawLen-1)=="-"&&tagSep==">"){this._tagStack.pop();if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Comment){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=(prevElement.raw+element.raw).replace(Parser._reTrimComment,"");element.raw=element.data="";element.type=ElementType.Text}else{element.type=ElementType.Comment}}else{element.type=ElementType.Comment;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Comment){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=prevElement.raw+element.raw+tagSep;element.raw=element.data="";element.type=ElementType.Text}else{element.raw=element.data=element.raw+tagSep}}}}}}if(element.type==ElementType.Tag){element.name=elementName;var elementNameCI=elementName.toLowerCase();if(element.raw.indexOf("!--")==0){element.type=ElementType.Comment;delete element["name"];var rawLen=element.raw.length;if(element.raw.charAt(rawLen-1)=="-"&&element.raw.charAt(rawLen-2)=="-"&&tagSep==">"){element.raw=element.data=element.raw.replace(Parser._reTrimComment,"")}else{element.raw+=tagSep;this._tagStack.push(ElementType.Comment)}}else{if(element.raw.indexOf("!")==0||element.raw.indexOf("?")==0){element.type=ElementType.Directive}else{if(elementNameCI=="script"){element.type=ElementType.Script;if(element.data.charAt(element.data.length-1)!="/"){this._tagStack.push(ElementType.Script)}}else{if(elementNameCI=="/script"){element.type=ElementType.Script}else{if(elementNameCI=="style"){element.type=ElementType.Style;if(element.data.charAt(element.data.length-1)!="/"){this._tagStack.push(ElementType.Style)}}else{if(elementNameCI=="/style"){element.type=ElementType.Style}}}}}}if(element.name&&element.name.charAt(0)=="/"){element.data=element.name}}if(element.raw!=""||element.type!=ElementType.Text){if(this._options.includeLocation&&!element.location){element.location=this.getLocation(element.type==ElementType.Tag)}this.parseAttribs(element);this._elements.push(element);if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive&&element.data.charAt(element.data.length-1)=="/"){this._elements.push({raw:"/"+element.name,data:"/"+element.name,name:"/"+element.name,type:element.type})}}this._parseState=(tagSep=="<")?ElementType.Tag:ElementType.Text;this._current=this._next+1;this._prevTagSep=tagSep}if(this._options.includeLocation){this.getLocation();this._location.row+=this._location.inBuffer;this._location.inBuffer=0;this._location.charOffset=0}this._buffer=(this._current<=bufferEnd)?this._buffer.substring(this._current):"";this._current=0;this.writeHandler()};Parser.prototype.getLocation=function Parser$getLocation(startTag){var c,l=this._location,end=this._current-(startTag?1:0),chunk=startTag&&l.charOffset==0&&this._current==0;for(;l.charOffset<end;l.charOffset++){c=this._buffer.charAt(l.charOffset);if(c=="\n"){l.inBuffer++;l.col=0}else{if(c!="\r"){l.col++}}}return{line:l.row+l.inBuffer+1,col:l.col+(chunk?0:1)}};Parser.prototype.validateHandler=function Parser$validateHandler(handler){if((typeof handler)!="object"){throw new Error("Handler is not an object")}if((typeof handler.reset)!="function"){throw new Error("Handler method 'reset' is invalid")}if((typeof handler.done)!="function"){throw new Error("Handler method 'done' is invalid")}if((typeof handler.writeTag)!="function"){throw new Error("Handler method 'writeTag' is invalid")}if((typeof handler.writeText)!="function"){throw new Error("Handler method 'writeText' is invalid")}if((typeof handler.writeComment)!="function"){throw new Error("Handler method 'writeComment' is invalid")}if((typeof handler.writeDirective)!="function"){throw new Error("Handler method 'writeDirective' is invalid")}};Parser.prototype.writeHandler=function Parser$writeHandler(forceFlush){forceFlush=!!forceFlush;if(this._tagStack.length&&!forceFlush){return}while(this._elements.length){var element=this._elements.shift();switch(element.type){case ElementType.Comment:this._handler.writeComment(element);break;case ElementType.Directive:this._handler.writeDirective(element);break;case ElementType.Text:this._handler.writeText(element);break;default:this._handler.writeTag(element);break}}};Parser.prototype.handleError=function Parser$handleError(error){if((typeof this._handler.error)=="function"){this._handler.error(error)}else{throw error}};function DefaultHandler(callback,options){this.reset();this._options=options?options:{};if(this._options.ignoreWhitespace==undefined){this._options.ignoreWhitespace=false
}if(this._options.verbose==undefined){this._options.verbose=true}if(this._options.enforceEmptyTags==undefined){this._options.enforceEmptyTags=true}if((typeof callback)=="function"){this._callback=callback}}DefaultHandler._emptyTags={area:1,base:1,basefont:1,br:1,col:1,frame:1,hr:1,img:1,input:1,isindex:1,link:1,meta:1,param:1,embed:1};DefaultHandler.reWhitespace=/^\s*$/;DefaultHandler.prototype.dom=null;DefaultHandler.prototype.reset=function DefaultHandler$reset(){this.dom=[];this._done=false;this._tagStack=[];this._tagStack.last=function DefaultHandler$_tagStack$last(){return(this.length?this[this.length-1]:null)}};DefaultHandler.prototype.done=function DefaultHandler$done(){this._done=true;this.handleCallback(null)};DefaultHandler.prototype.writeTag=function DefaultHandler$writeTag(element){this.handleElement(element)};DefaultHandler.prototype.writeText=function DefaultHandler$writeText(element){if(this._options.ignoreWhitespace){if(DefaultHandler.reWhitespace.test(element.data)){return}}this.handleElement(element)};DefaultHandler.prototype.writeComment=function DefaultHandler$writeComment(element){this.handleElement(element)};DefaultHandler.prototype.writeDirective=function DefaultHandler$writeDirective(element){this.handleElement(element)};DefaultHandler.prototype.error=function DefaultHandler$error(error){this.handleCallback(error)};DefaultHandler.prototype._options=null;DefaultHandler.prototype._callback=null;DefaultHandler.prototype._done=false;DefaultHandler.prototype._tagStack=null;DefaultHandler.prototype.handleCallback=function DefaultHandler$handleCallback(error){if((typeof this._callback)!="function"){if(error){throw error}else{return}}this._callback(error,this.dom)};DefaultHandler.prototype.isEmptyTag=function(element){var name=element.name.toLowerCase();if(name.charAt(0)=="/"){name=name.substring(1)}return this._options.enforceEmptyTags&&!!DefaultHandler._emptyTags[name]};DefaultHandler.prototype.handleElement=function DefaultHandler$handleElement(element){if(this._done){this.handleCallback(new Error("Writing to the handler after done() called is not allowed without a reset()"))}if(!this._options.verbose){delete element.raw;if(element.type=="tag"||element.type=="script"||element.type=="style"){delete element.data}}if(!this._tagStack.last()){if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive){if(element.name.charAt(0)!="/"){this.dom.push(element);if(!this.isEmptyTag(element)){this._tagStack.push(element)}}}else{this.dom.push(element)}}else{if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive){if(element.name.charAt(0)=="/"){var baseName=element.name.substring(1);if(!this.isEmptyTag(element)){var pos=this._tagStack.length-1;while(pos>-1&&this._tagStack[pos--].name!=baseName){}if(pos>-1||this._tagStack[0].name==baseName){while(pos<this._tagStack.length-1){this._tagStack.pop()}}}}else{if(!this._tagStack.last().children){this._tagStack.last().children=[]}this._tagStack.last().children.push(element);if(!this.isEmptyTag(element)){this._tagStack.push(element)}}}else{if(!this._tagStack.last().children){this._tagStack.last().children=[]}this._tagStack.last().children.push(element)}}};var DomUtils={testElement:function DomUtils$testElement(options,element){if(!element){return false}for(var key in options){if(key=="tag_name"){if(element.type!="tag"&&element.type!="script"&&element.type!="style"){return false}if(!options["tag_name"](element.name)){return false}}else{if(key=="tag_type"){if(!options["tag_type"](element.type)){return false}}else{if(key=="tag_contains"){if(element.type!="text"&&element.type!="comment"&&element.type!="directive"){return false}if(!options["tag_contains"](element.data)){return false}}else{if(!element.attribs||!options[key](element.attribs[key])){return false}}}}}return true},getElements:function DomUtils$getElements(options,currentElement,recurse,limit){recurse=(recurse===undefined||recurse===null)||!!recurse;limit=isNaN(parseInt(limit))?-1:parseInt(limit);if(!currentElement){return([])}var found=[];var elementList;function getTest(checkVal){return(function(value){return(value==checkVal)})}for(var key in options){if((typeof options[key])!="function"){options[key]=getTest(options[key])}}if(DomUtils.testElement(options,currentElement)){found.push(currentElement)}if(limit>=0&&found.length>=limit){return(found)}if(recurse&&currentElement.children){elementList=currentElement.children}else{if(currentElement instanceof Array){elementList=currentElement}else{return(found)}}for(var i=0;i<elementList.length;i++){found=found.concat(DomUtils.getElements(options,elementList[i],recurse,limit));if(limit>=0&&found.length>=limit){break}}return(found)},getElementById:function DomUtils$getElementById(id,currentElement,recurse){var result=DomUtils.getElements({id:id},currentElement,recurse,1);return(result.length?result[0]:null)},getElementsByTagName:function DomUtils$getElementsByTagName(name,currentElement,recurse,limit){return(DomUtils.getElements({tag_name:name},currentElement,recurse,limit))
},getElementsByTagType:function DomUtils$getElementsByTagType(type,currentElement,recurse,limit){return(DomUtils.getElements({tag_type:type},currentElement,recurse,limit))}};function inherits(ctor,superCtor){var tempCtor=function(){};tempCtor.prototype=superCtor.prototype;ctor.super_=superCtor;ctor.prototype=new tempCtor();ctor.prototype.constructor=ctor}exports.Parser=Parser;exports.DefaultHandler=DefaultHandler;exports.ElementType=ElementType;exports.DomUtils=DomUtils})();

var MD5=function(string){function RotateLeft(lValue,iShiftBits){return(lValue<<iShiftBits)|(lValue>>>(32-iShiftBits))}function AddUnsigned(lX,lY){var lX4,lY4,lX8,lY8,lResult;lX8=(lX&2147483648);lY8=(lY&2147483648);lX4=(lX&1073741824);lY4=(lY&1073741824);lResult=(lX&1073741823)+(lY&1073741823);if(lX4&lY4){return(lResult^2147483648^lX8^lY8)}if(lX4|lY4){if(lResult&1073741824){return(lResult^3221225472^lX8^lY8)}else{return(lResult^1073741824^lX8^lY8)}}else{return(lResult^lX8^lY8)}}function F(x,y,z){return(x&y)|((~x)&z)}function G(x,y,z){return(x&z)|(y&(~z))}function H(x,y,z){return(x^y^z)}function I(x,y,z){return(y^(x|(~z)))}function FF(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(F(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function GG(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(G(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function HH(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(H(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function II(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(I(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function ConvertToWordArray(string){var lWordCount;var lMessageLength=string.length;var lNumberOfWords_temp1=lMessageLength+8;var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1%64))/64;var lNumberOfWords=(lNumberOfWords_temp2+1)*16;var lWordArray=Array(lNumberOfWords-1);var lBytePosition=0;var lByteCount=0;while(lByteCount<lMessageLength){lWordCount=(lByteCount-(lByteCount%4))/4;lBytePosition=(lByteCount%4)*8;lWordArray[lWordCount]=(lWordArray[lWordCount]|(string.charCodeAt(lByteCount)<<lBytePosition));lByteCount++}lWordCount=(lByteCount-(lByteCount%4))/4;lBytePosition=(lByteCount%4)*8;lWordArray[lWordCount]=lWordArray[lWordCount]|(128<<lBytePosition);lWordArray[lNumberOfWords-2]=lMessageLength<<3;lWordArray[lNumberOfWords-1]=lMessageLength>>>29;return lWordArray}function WordToHex(lValue){var WordToHexValue="",WordToHexValue_temp="",lByte,lCount;for(lCount=0;lCount<=3;lCount++){lByte=(lValue>>>(lCount*8))&255;WordToHexValue_temp="0"+lByte.toString(16);WordToHexValue=WordToHexValue+WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2)}return WordToHexValue}function Utf8Encode(string){string=string.replace(/\r\n/g,"\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c)}else{if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128)}else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128)}}}return utftext}var x=Array();var k,AA,BB,CC,DD,a,b,c,d;var S11=7,S12=12,S13=17,S14=22;var S21=5,S22=9,S23=14,S24=20;var S31=4,S32=11,S33=16,S34=23;var S41=6,S42=10,S43=15,S44=21;string=Utf8Encode(string);x=ConvertToWordArray(string);a=1732584193;b=4023233417;c=2562383102;d=271733878;for(k=0;k<x.length;k+=16){AA=a;BB=b;CC=c;DD=d;a=FF(a,b,c,d,x[k+0],S11,3614090360);d=FF(d,a,b,c,x[k+1],S12,3905402710);c=FF(c,d,a,b,x[k+2],S13,606105819);b=FF(b,c,d,a,x[k+3],S14,3250441966);a=FF(a,b,c,d,x[k+4],S11,4118548399);d=FF(d,a,b,c,x[k+5],S12,1200080426);c=FF(c,d,a,b,x[k+6],S13,2821735955);b=FF(b,c,d,a,x[k+7],S14,4249261313);a=FF(a,b,c,d,x[k+8],S11,1770035416);d=FF(d,a,b,c,x[k+9],S12,2336552879);c=FF(c,d,a,b,x[k+10],S13,4294925233);b=FF(b,c,d,a,x[k+11],S14,2304563134);a=FF(a,b,c,d,x[k+12],S11,1804603682);d=FF(d,a,b,c,x[k+13],S12,4254626195);c=FF(c,d,a,b,x[k+14],S13,2792965006);b=FF(b,c,d,a,x[k+15],S14,1236535329);a=GG(a,b,c,d,x[k+1],S21,4129170786);d=GG(d,a,b,c,x[k+6],S22,3225465664);c=GG(c,d,a,b,x[k+11],S23,643717713);b=GG(b,c,d,a,x[k+0],S24,3921069994);a=GG(a,b,c,d,x[k+5],S21,3593408605);d=GG(d,a,b,c,x[k+10],S22,38016083);c=GG(c,d,a,b,x[k+15],S23,3634488961);b=GG(b,c,d,a,x[k+4],S24,3889429448);a=GG(a,b,c,d,x[k+9],S21,568446438);d=GG(d,a,b,c,x[k+14],S22,3275163606);c=GG(c,d,a,b,x[k+3],S23,4107603335);b=GG(b,c,d,a,x[k+8],S24,1163531501);a=GG(a,b,c,d,x[k+13],S21,2850285829);d=GG(d,a,b,c,x[k+2],S22,4243563512);c=GG(c,d,a,b,x[k+7],S23,1735328473);b=GG(b,c,d,a,x[k+12],S24,2368359562);a=HH(a,b,c,d,x[k+5],S31,4294588738);d=HH(d,a,b,c,x[k+8],S32,2272392833);c=HH(c,d,a,b,x[k+11],S33,1839030562);b=HH(b,c,d,a,x[k+14],S34,4259657740);a=HH(a,b,c,d,x[k+1],S31,2763975236);d=HH(d,a,b,c,x[k+4],S32,1272893353);c=HH(c,d,a,b,x[k+7],S33,4139469664);b=HH(b,c,d,a,x[k+10],S34,3200236656);a=HH(a,b,c,d,x[k+13],S31,681279174);d=HH(d,a,b,c,x[k+0],S32,3936430074);c=HH(c,d,a,b,x[k+3],S33,3572445317);b=HH(b,c,d,a,x[k+6],S34,76029189);a=HH(a,b,c,d,x[k+9],S31,3654602809);d=HH(d,a,b,c,x[k+12],S32,3873151461);c=HH(c,d,a,b,x[k+15],S33,530742520);b=HH(b,c,d,a,x[k+2],S34,3299628645);a=II(a,b,c,d,x[k+0],S41,4096336452);d=II(d,a,b,c,x[k+7],S42,1126891415);c=II(c,d,a,b,x[k+14],S43,2878612391);b=II(b,c,d,a,x[k+5],S44,4237533241);a=II(a,b,c,d,x[k+12],S41,1700485571);d=II(d,a,b,c,x[k+3],S42,2399980690);c=II(c,d,a,b,x[k+10],S43,4293915773);b=II(b,c,d,a,x[k+1],S44,2240044497);
a=II(a,b,c,d,x[k+8],S41,1873313359);d=II(d,a,b,c,x[k+15],S42,4264355552);c=II(c,d,a,b,x[k+6],S43,2734768916);b=II(b,c,d,a,x[k+13],S44,1309151649);a=II(a,b,c,d,x[k+4],S41,4149444226);d=II(d,a,b,c,x[k+11],S42,3174756917);c=II(c,d,a,b,x[k+2],S43,718787259);b=II(b,c,d,a,x[k+9],S44,3951481745);a=AddUnsigned(a,AA);b=AddUnsigned(b,BB);c=AddUnsigned(c,CC);d=AddUnsigned(d,DD)}var temp=WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);return temp.toLowerCase()};

var TranslateApi={currentScript:null,getJSON:function(b,d,h){var g=b+(b.indexOf("?")+1?"&":"?");var c=document.getElementsByTagName("head")[0];var a=document.createElement("script");var f=[];var e="";this.success=h;d.callback="TranslateApi.success";for(e in d){f.push(e+"="+encodeURIComponent(d[e]))}g+=f.join("&");a.type="text/javascript";a.src=g;if(this.currentScript){c.removeChild(currentScript)}c.appendChild(a)},success:null};

(function(){function runningInNode(){return((typeof require)=="function"&&(typeof exports)=="object"&&(typeof module)=="object"&&(typeof __filename)=="string"&&(typeof __dirname)=="string")}if(!runningInNode()){if(!this.Tautologistics){this.Tautologistics={}}else{if(this.Tautologistics.NodeHtmlParser){return}}this.Tautologistics.NodeHtmlParser={};exports=this.Tautologistics.NodeHtmlParser}var ElementType={Text:"text",Directive:"directive",Comment:"comment",Script:"script",Style:"style",Tag:"tag"};function Parser(handler,options){this._options=options?options:{};if(this._options.includeLocation==undefined){this._options.includeLocation=false}this.validateHandler(handler);this._handler=handler;this.reset()}Parser._reTrim=/(^\s+|\s+$)/g;Parser._reTrimComment=/(^\!--|--$)/g;Parser._reWhitespace=/\s/g;Parser._reTagName=/^\s*(\/?)\s*([^\s\/]+)/;Parser._reAttrib=/([^=<>\"\'\s]+)\s*=\s*"([^"]*)"|([^=<>\"\'\s]+)\s*=\s*'([^']*)'|([^=<>\"\'\s]+)\s*=\s*([^'"\s]+)|([^=<>\"\'\s\/]+)/g;Parser._reTags=/[\<\>]/g;Parser.prototype.parseComplete=function Parser$parseComplete(data){this.reset();this.parseChunk(data);this.done()};Parser.prototype.parseChunk=function Parser$parseChunk(data){if(this._done){this.handleError(new Error("Attempted to parse chunk after parsing already done"))}this._buffer+=data;this.parseTags()};Parser.prototype.done=function Parser$done(){if(this._done){return}this._done=true;if(this._buffer.length){var rawData=this._buffer;this._buffer="";var element={raw:rawData,data:(this._parseState==ElementType.Text)?rawData:rawData.replace(Parser._reTrim,""),type:this._parseState};if(this._parseState==ElementType.Tag||this._parseState==ElementType.Script||this._parseState==ElementType.Style){element.name=this.parseTagName(element.data)}this.parseAttribs(element);this._elements.push(element)}this.writeHandler();this._handler.done()};Parser.prototype.reset=function Parser$reset(){this._buffer="";this._done=false;this._elements=[];this._elementsCurrent=0;this._current=0;this._next=0;this._location={row:0,col:0,charOffset:0,inBuffer:0};this._parseState=ElementType.Text;this._prevTagSep="";this._tagStack=[];this._handler.reset()};Parser.prototype._options=null;Parser.prototype._handler=null;Parser.prototype._buffer=null;Parser.prototype._done=false;Parser.prototype._elements=null;Parser.prototype._elementsCurrent=0;Parser.prototype._current=0;Parser.prototype._next=0;Parser.prototype._location=null;Parser.prototype._parseState=ElementType.Text;Parser.prototype._prevTagSep="";Parser.prototype._tagStack=null;Parser.prototype.parseTagAttribs=function Parser$parseTagAttribs(elements){var idxEnd=elements.length;var idx=0;while(idx<idxEnd){var element=elements[idx++];if(element.type==ElementType.Tag||element.type==ElementType.Script||element.type==ElementType.style){this.parseAttribs(element)}}return(elements)};Parser.prototype.parseAttribs=function Parser$parseAttribs(element){if(element.type!=ElementType.Script&&element.type!=ElementType.Style&&element.type!=ElementType.Tag){return}var tagName=element.data.split(Parser._reWhitespace,1)[0];var attribRaw=element.data.substring(tagName.length);if(attribRaw.length<1){return}var match;Parser._reAttrib.lastIndex=0;while(match=Parser._reAttrib.exec(attribRaw)){if(element.attribs==undefined){element.attribs={}}if(typeof match[1]=="string"&&match[1].length){element.attribs[match[1]]=match[2]}else{if(typeof match[3]=="string"&&match[3].length){element.attribs[match[3].toString()]=match[4].toString()}else{if(typeof match[5]=="string"&&match[5].length){element.attribs[match[5]]=match[6]}else{if(typeof match[7]=="string"&&match[7].length){element.attribs[match[7]]=match[7]}}}}}};Parser.prototype.parseTagName=function Parser$parseTagName(data){if(data==null||data==""){return("")}var match=Parser._reTagName.exec(data);if(!match){return("")}return((match[1]?"/":"")+match[2])};Parser.prototype.parseTags=function Parser$parseTags(){var bufferEnd=this._buffer.length-1;while(Parser._reTags.test(this._buffer)){this._next=Parser._reTags.lastIndex-1;var tagSep=this._buffer.charAt(this._next);var rawData=this._buffer.substring(this._current,this._next);var element={raw:rawData,data:(this._parseState==ElementType.Text)?rawData:rawData.replace(Parser._reTrim,""),type:this._parseState};var elementName=this.parseTagName(element.data);if(this._tagStack.length){if(this._tagStack[this._tagStack.length-1]==ElementType.Script){if(elementName.toLowerCase()=="/script"){this._tagStack.pop()}else{if(element.raw.indexOf("!--")!=0){element.type=ElementType.Text;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Text){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep+element.raw;element.raw=element.data=""}}}}else{if(this._tagStack[this._tagStack.length-1]==ElementType.Style){if(elementName.toLowerCase()=="/style"){this._tagStack.pop()}else{if(element.raw.indexOf("!--")!=0){element.type=ElementType.Text;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Text){var prevElement=this._elements[this._elements.length-1];
if(element.raw!=""){prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep+element.raw;element.raw=element.data=""}else{prevElement.raw=prevElement.data=prevElement.raw+this._prevTagSep}}else{if(element.raw!=""){element.raw=element.data=element.raw}}}}}else{if(this._tagStack[this._tagStack.length-1]==ElementType.Comment){var rawLen=element.raw.length;if(element.raw.charAt(rawLen-2)=="-"&&element.raw.charAt(rawLen-1)=="-"&&tagSep==">"){this._tagStack.pop();if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Comment){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=(prevElement.raw+element.raw).replace(Parser._reTrimComment,"");element.raw=element.data="";element.type=ElementType.Text}else{element.type=ElementType.Comment}}else{element.type=ElementType.Comment;if(this._elements.length&&this._elements[this._elements.length-1].type==ElementType.Comment){var prevElement=this._elements[this._elements.length-1];prevElement.raw=prevElement.data=prevElement.raw+element.raw+tagSep;element.raw=element.data="";element.type=ElementType.Text}else{element.raw=element.data=element.raw+tagSep}}}}}}if(element.type==ElementType.Tag){element.name=elementName;var elementNameCI=elementName.toLowerCase();if(element.raw.indexOf("!--")==0){element.type=ElementType.Comment;delete element["name"];var rawLen=element.raw.length;if(element.raw.charAt(rawLen-1)=="-"&&element.raw.charAt(rawLen-2)=="-"&&tagSep==">"){element.raw=element.data=element.raw.replace(Parser._reTrimComment,"")}else{element.raw+=tagSep;this._tagStack.push(ElementType.Comment)}}else{if(element.raw.indexOf("!")==0||element.raw.indexOf("?")==0){element.type=ElementType.Directive}else{if(elementNameCI=="script"){element.type=ElementType.Script;if(element.data.charAt(element.data.length-1)!="/"){this._tagStack.push(ElementType.Script)}}else{if(elementNameCI=="/script"){element.type=ElementType.Script}else{if(elementNameCI=="style"){element.type=ElementType.Style;if(element.data.charAt(element.data.length-1)!="/"){this._tagStack.push(ElementType.Style)}}else{if(elementNameCI=="/style"){element.type=ElementType.Style}}}}}}if(element.name&&element.name.charAt(0)=="/"){element.data=element.name}}if(element.raw!=""||element.type!=ElementType.Text){if(this._options.includeLocation&&!element.location){element.location=this.getLocation(element.type==ElementType.Tag)}this.parseAttribs(element);this._elements.push(element);if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive&&element.data.charAt(element.data.length-1)=="/"){this._elements.push({raw:"/"+element.name,data:"/"+element.name,name:"/"+element.name,type:element.type})}}this._parseState=(tagSep=="<")?ElementType.Tag:ElementType.Text;this._current=this._next+1;this._prevTagSep=tagSep}if(this._options.includeLocation){this.getLocation();this._location.row+=this._location.inBuffer;this._location.inBuffer=0;this._location.charOffset=0}this._buffer=(this._current<=bufferEnd)?this._buffer.substring(this._current):"";this._current=0;this.writeHandler()};Parser.prototype.getLocation=function Parser$getLocation(startTag){var c,l=this._location,end=this._current-(startTag?1:0),chunk=startTag&&l.charOffset==0&&this._current==0;for(;l.charOffset<end;l.charOffset++){c=this._buffer.charAt(l.charOffset);if(c=="\n"){l.inBuffer++;l.col=0}else{if(c!="\r"){l.col++}}}return{line:l.row+l.inBuffer+1,col:l.col+(chunk?0:1)}};Parser.prototype.validateHandler=function Parser$validateHandler(handler){if((typeof handler)!="object"){throw new Error("Handler is not an object")}if((typeof handler.reset)!="function"){throw new Error("Handler method 'reset' is invalid")}if((typeof handler.done)!="function"){throw new Error("Handler method 'done' is invalid")}if((typeof handler.writeTag)!="function"){throw new Error("Handler method 'writeTag' is invalid")}if((typeof handler.writeText)!="function"){throw new Error("Handler method 'writeText' is invalid")}if((typeof handler.writeComment)!="function"){throw new Error("Handler method 'writeComment' is invalid")}if((typeof handler.writeDirective)!="function"){throw new Error("Handler method 'writeDirective' is invalid")}};Parser.prototype.writeHandler=function Parser$writeHandler(forceFlush){forceFlush=!!forceFlush;if(this._tagStack.length&&!forceFlush){return}while(this._elements.length){var element=this._elements.shift();switch(element.type){case ElementType.Comment:this._handler.writeComment(element);break;case ElementType.Directive:this._handler.writeDirective(element);break;case ElementType.Text:this._handler.writeText(element);break;default:this._handler.writeTag(element);break}}};Parser.prototype.handleError=function Parser$handleError(error){if((typeof this._handler.error)=="function"){this._handler.error(error)}else{throw error}};function DefaultHandler(callback,options){this.reset();this._options=options?options:{};if(this._options.ignoreWhitespace==undefined){this._options.ignoreWhitespace=false
}if(this._options.verbose==undefined){this._options.verbose=true}if(this._options.enforceEmptyTags==undefined){this._options.enforceEmptyTags=true}if((typeof callback)=="function"){this._callback=callback}}DefaultHandler._emptyTags={area:1,base:1,basefont:1,br:1,col:1,frame:1,hr:1,img:1,input:1,isindex:1,link:1,meta:1,param:1,embed:1};DefaultHandler.reWhitespace=/^\s*$/;DefaultHandler.prototype.dom=null;DefaultHandler.prototype.reset=function DefaultHandler$reset(){this.dom=[];this._done=false;this._tagStack=[];this._tagStack.last=function DefaultHandler$_tagStack$last(){return(this.length?this[this.length-1]:null)}};DefaultHandler.prototype.done=function DefaultHandler$done(){this._done=true;this.handleCallback(null)};DefaultHandler.prototype.writeTag=function DefaultHandler$writeTag(element){this.handleElement(element)};DefaultHandler.prototype.writeText=function DefaultHandler$writeText(element){if(this._options.ignoreWhitespace){if(DefaultHandler.reWhitespace.test(element.data)){return}}this.handleElement(element)};DefaultHandler.prototype.writeComment=function DefaultHandler$writeComment(element){this.handleElement(element)};DefaultHandler.prototype.writeDirective=function DefaultHandler$writeDirective(element){this.handleElement(element)};DefaultHandler.prototype.error=function DefaultHandler$error(error){this.handleCallback(error)};DefaultHandler.prototype._options=null;DefaultHandler.prototype._callback=null;DefaultHandler.prototype._done=false;DefaultHandler.prototype._tagStack=null;DefaultHandler.prototype.handleCallback=function DefaultHandler$handleCallback(error){if((typeof this._callback)!="function"){if(error){throw error}else{return}}this._callback(error,this.dom)};DefaultHandler.prototype.isEmptyTag=function(element){var name=element.name.toLowerCase();if(name.charAt(0)=="/"){name=name.substring(1)}return this._options.enforceEmptyTags&&!!DefaultHandler._emptyTags[name]};DefaultHandler.prototype.handleElement=function DefaultHandler$handleElement(element){if(this._done){this.handleCallback(new Error("Writing to the handler after done() called is not allowed without a reset()"))}if(!this._options.verbose){delete element.raw;if(element.type=="tag"||element.type=="script"||element.type=="style"){delete element.data}}if(!this._tagStack.last()){if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive){if(element.name.charAt(0)!="/"){this.dom.push(element);if(!this.isEmptyTag(element)){this._tagStack.push(element)}}}else{this.dom.push(element)}}else{if(element.type!=ElementType.Text&&element.type!=ElementType.Comment&&element.type!=ElementType.Directive){if(element.name.charAt(0)=="/"){var baseName=element.name.substring(1);if(!this.isEmptyTag(element)){var pos=this._tagStack.length-1;while(pos>-1&&this._tagStack[pos--].name!=baseName){}if(pos>-1||this._tagStack[0].name==baseName){while(pos<this._tagStack.length-1){this._tagStack.pop()}}}}else{if(!this._tagStack.last().children){this._tagStack.last().children=[]}this._tagStack.last().children.push(element);if(!this.isEmptyTag(element)){this._tagStack.push(element)}}}else{if(!this._tagStack.last().children){this._tagStack.last().children=[]}this._tagStack.last().children.push(element)}}};var DomUtils={testElement:function DomUtils$testElement(options,element){if(!element){return false}for(var key in options){if(key=="tag_name"){if(element.type!="tag"&&element.type!="script"&&element.type!="style"){return false}if(!options["tag_name"](element.name)){return false}}else{if(key=="tag_type"){if(!options["tag_type"](element.type)){return false}}else{if(key=="tag_contains"){if(element.type!="text"&&element.type!="comment"&&element.type!="directive"){return false}if(!options["tag_contains"](element.data)){return false}}else{if(!element.attribs||!options[key](element.attribs[key])){return false}}}}}return true},getElements:function DomUtils$getElements(options,currentElement,recurse,limit){recurse=(recurse===undefined||recurse===null)||!!recurse;limit=isNaN(parseInt(limit))?-1:parseInt(limit);if(!currentElement){return([])}var found=[];var elementList;function getTest(checkVal){return(function(value){return(value==checkVal)})}for(var key in options){if((typeof options[key])!="function"){options[key]=getTest(options[key])}}if(DomUtils.testElement(options,currentElement)){found.push(currentElement)}if(limit>=0&&found.length>=limit){return(found)}if(recurse&&currentElement.children){elementList=currentElement.children}else{if(currentElement instanceof Array){elementList=currentElement}else{return(found)}}for(var i=0;i<elementList.length;i++){found=found.concat(DomUtils.getElements(options,elementList[i],recurse,limit));if(limit>=0&&found.length>=limit){break}}return(found)},getElementById:function DomUtils$getElementById(id,currentElement,recurse){var result=DomUtils.getElements({id:id},currentElement,recurse,1);return(result.length?result[0]:null)},getElementsByTagName:function DomUtils$getElementsByTagName(name,currentElement,recurse,limit){return(DomUtils.getElements({tag_name:name},currentElement,recurse,limit))
},getElementsByTagType:function DomUtils$getElementsByTagType(type,currentElement,recurse,limit){return(DomUtils.getElements({tag_type:type},currentElement,recurse,limit))}};function inherits(ctor,superCtor){var tempCtor=function(){};tempCtor.prototype=superCtor.prototype;ctor.super_=superCtor;ctor.prototype=new tempCtor();ctor.prototype.constructor=ctor}exports.Parser=Parser;exports.DefaultHandler=DefaultHandler;exports.ElementType=ElementType;exports.DomUtils=DomUtils})();

var MD5=function(string){function RotateLeft(lValue,iShiftBits){return(lValue<<iShiftBits)|(lValue>>>(32-iShiftBits))}function AddUnsigned(lX,lY){var lX4,lY4,lX8,lY8,lResult;lX8=(lX&2147483648);lY8=(lY&2147483648);lX4=(lX&1073741824);lY4=(lY&1073741824);lResult=(lX&1073741823)+(lY&1073741823);if(lX4&lY4){return(lResult^2147483648^lX8^lY8)}if(lX4|lY4){if(lResult&1073741824){return(lResult^3221225472^lX8^lY8)}else{return(lResult^1073741824^lX8^lY8)}}else{return(lResult^lX8^lY8)}}function F(x,y,z){return(x&y)|((~x)&z)}function G(x,y,z){return(x&z)|(y&(~z))}function H(x,y,z){return(x^y^z)}function I(x,y,z){return(y^(x|(~z)))}function FF(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(F(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function GG(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(G(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function HH(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(H(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function II(a,b,c,d,x,s,ac){a=AddUnsigned(a,AddUnsigned(AddUnsigned(I(b,c,d),x),ac));return AddUnsigned(RotateLeft(a,s),b)}function ConvertToWordArray(string){var lWordCount;var lMessageLength=string.length;var lNumberOfWords_temp1=lMessageLength+8;var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1%64))/64;var lNumberOfWords=(lNumberOfWords_temp2+1)*16;var lWordArray=Array(lNumberOfWords-1);var lBytePosition=0;var lByteCount=0;while(lByteCount<lMessageLength){lWordCount=(lByteCount-(lByteCount%4))/4;lBytePosition=(lByteCount%4)*8;lWordArray[lWordCount]=(lWordArray[lWordCount]|(string.charCodeAt(lByteCount)<<lBytePosition));lByteCount++}lWordCount=(lByteCount-(lByteCount%4))/4;lBytePosition=(lByteCount%4)*8;lWordArray[lWordCount]=lWordArray[lWordCount]|(128<<lBytePosition);lWordArray[lNumberOfWords-2]=lMessageLength<<3;lWordArray[lNumberOfWords-1]=lMessageLength>>>29;return lWordArray}function WordToHex(lValue){var WordToHexValue="",WordToHexValue_temp="",lByte,lCount;for(lCount=0;lCount<=3;lCount++){lByte=(lValue>>>(lCount*8))&255;WordToHexValue_temp="0"+lByte.toString(16);WordToHexValue=WordToHexValue+WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2)}return WordToHexValue}function Utf8Encode(string){string=string.replace(/\r\n/g,"\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c)}else{if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128)}else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128)}}}return utftext}var x=Array();var k,AA,BB,CC,DD,a,b,c,d;var S11=7,S12=12,S13=17,S14=22;var S21=5,S22=9,S23=14,S24=20;var S31=4,S32=11,S33=16,S34=23;var S41=6,S42=10,S43=15,S44=21;string=Utf8Encode(string);x=ConvertToWordArray(string);a=1732584193;b=4023233417;c=2562383102;d=271733878;for(k=0;k<x.length;k+=16){AA=a;BB=b;CC=c;DD=d;a=FF(a,b,c,d,x[k+0],S11,3614090360);d=FF(d,a,b,c,x[k+1],S12,3905402710);c=FF(c,d,a,b,x[k+2],S13,606105819);b=FF(b,c,d,a,x[k+3],S14,3250441966);a=FF(a,b,c,d,x[k+4],S11,4118548399);d=FF(d,a,b,c,x[k+5],S12,1200080426);c=FF(c,d,a,b,x[k+6],S13,2821735955);b=FF(b,c,d,a,x[k+7],S14,4249261313);a=FF(a,b,c,d,x[k+8],S11,1770035416);d=FF(d,a,b,c,x[k+9],S12,2336552879);c=FF(c,d,a,b,x[k+10],S13,4294925233);b=FF(b,c,d,a,x[k+11],S14,2304563134);a=FF(a,b,c,d,x[k+12],S11,1804603682);d=FF(d,a,b,c,x[k+13],S12,4254626195);c=FF(c,d,a,b,x[k+14],S13,2792965006);b=FF(b,c,d,a,x[k+15],S14,1236535329);a=GG(a,b,c,d,x[k+1],S21,4129170786);d=GG(d,a,b,c,x[k+6],S22,3225465664);c=GG(c,d,a,b,x[k+11],S23,643717713);b=GG(b,c,d,a,x[k+0],S24,3921069994);a=GG(a,b,c,d,x[k+5],S21,3593408605);d=GG(d,a,b,c,x[k+10],S22,38016083);c=GG(c,d,a,b,x[k+15],S23,3634488961);b=GG(b,c,d,a,x[k+4],S24,3889429448);a=GG(a,b,c,d,x[k+9],S21,568446438);d=GG(d,a,b,c,x[k+14],S22,3275163606);c=GG(c,d,a,b,x[k+3],S23,4107603335);b=GG(b,c,d,a,x[k+8],S24,1163531501);a=GG(a,b,c,d,x[k+13],S21,2850285829);d=GG(d,a,b,c,x[k+2],S22,4243563512);c=GG(c,d,a,b,x[k+7],S23,1735328473);b=GG(b,c,d,a,x[k+12],S24,2368359562);a=HH(a,b,c,d,x[k+5],S31,4294588738);d=HH(d,a,b,c,x[k+8],S32,2272392833);c=HH(c,d,a,b,x[k+11],S33,1839030562);b=HH(b,c,d,a,x[k+14],S34,4259657740);a=HH(a,b,c,d,x[k+1],S31,2763975236);d=HH(d,a,b,c,x[k+4],S32,1272893353);c=HH(c,d,a,b,x[k+7],S33,4139469664);b=HH(b,c,d,a,x[k+10],S34,3200236656);a=HH(a,b,c,d,x[k+13],S31,681279174);d=HH(d,a,b,c,x[k+0],S32,3936430074);c=HH(c,d,a,b,x[k+3],S33,3572445317);b=HH(b,c,d,a,x[k+6],S34,76029189);a=HH(a,b,c,d,x[k+9],S31,3654602809);d=HH(d,a,b,c,x[k+12],S32,3873151461);c=HH(c,d,a,b,x[k+15],S33,530742520);b=HH(b,c,d,a,x[k+2],S34,3299628645);a=II(a,b,c,d,x[k+0],S41,4096336452);d=II(d,a,b,c,x[k+7],S42,1126891415);c=II(c,d,a,b,x[k+14],S43,2878612391);b=II(b,c,d,a,x[k+5],S44,4237533241);a=II(a,b,c,d,x[k+12],S41,1700485571);d=II(d,a,b,c,x[k+3],S42,2399980690);c=II(c,d,a,b,x[k+10],S43,4293915773);b=II(b,c,d,a,x[k+1],S44,2240044497);
a=II(a,b,c,d,x[k+8],S41,1873313359);d=II(d,a,b,c,x[k+15],S42,4264355552);c=II(c,d,a,b,x[k+6],S43,2734768916);b=II(b,c,d,a,x[k+13],S44,1309151649);a=II(a,b,c,d,x[k+4],S41,4149444226);d=II(d,a,b,c,x[k+11],S42,3174756917);c=II(c,d,a,b,x[k+2],S43,718787259);b=II(b,c,d,a,x[k+9],S44,3951481745);a=AddUnsigned(a,AA);b=AddUnsigned(b,BB);c=AddUnsigned(c,CC);d=AddUnsigned(d,DD)}var temp=WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);return temp.toLowerCase()};

var TranslateApi={currentScript:null,getJSON:function(b,d,h,i){var g=b+(b.indexOf("?")+1?"&":"?");var c=document.getElementsByTagName("head")[0];var a=document.createElement("script");var f=[];var e="";this.success=h;d.callback="TranslateApi.success";for(e in d){f.push(e+"="+encodeURIComponent(d[e]))}g+=f.join("&");a.type="text/javascript";a.src=g;a.onerror=i;if(this.currentScript){c.removeChild(currentScript)}c.appendChild(a)},success:null};

function getBrowserLanguage(){if(window.navigator.language.toLocaleLowerCase()=="zh-cn"){return"zh"}if(window.navigator.language.toLocaleLowerCase()=="en"){return"en"}if(window.navigator.language.toLocaleLowerCase()=="jp"){return"ja"}if(window.navigator.language.toLocaleLowerCase()=="fra"){return"fr"}if(window.navigator.language.toLocaleLowerCase()=="kor"){return"ko"}return"cht"}
    
    
    
MAX_REQUEST_LEN = 50;
var queryDict = [];
var cacheDict =[];
var packetDict = [];
var translatedDict = [];
var originDict = [];
var from = 'auto';
var to = '';

function walkParserDom(doms) {
    for (var i in doms) {
        if (doms[i].type == 'text') {
            var text = replaceChar(doms[i].data);
            text = text.replace(/(\n)+|(\r\n)+/g, '');
            text = text.replace(/(^\s*)|(\s*$)/g, '');
            text = escape(text).replace(/(%26nbsp%3B)/g, '20%');
            text = unescape(text);
    
            if(text && !hasChar(text)) {
                if (cacheDict.indexOf(text) == -1) {
                    cacheDict.push(text);
                    packetDict.push(text);
                    if ( packetDict.length == MAX_REQUEST_LEN || text.length >= 10 ) {
                        queryDict.push(packetDict);
                        packetDict = [];
                    }
                }
            }
        } else if (doms[i].type == 'tag') {
            walkParserDom(doms[i].children);
        }
    }
}

function hasChar(text) {
    var filter = ['=', '►', '▼', '◄', '★', '☆', '✘', '›', '', ''];

    if (text.indexOf('{') >= 0 && text.indexOf('}') >= 0 && text.indexOf('=') >= 0) {
        return true;
    }

    if (text == '\n') {
        return true;
    }
    
    if (text == '\r\n') {
        return true;
    }

    for (var i = 0; i < filter.length; i++) {
        if (text.indexOf(filter[i]) >= 0) {
            return true;
        }
    }

    return false;
}

function replaceChar(text) {
    var keywords = {
        '…': "...",
        '&amp': '&',
        '&amp;': '&',
        '&gt;': '>',
        '&nbsp;': ' ',
        '&;': '&'
    };

    for (var keyword in keywords) {
        text = text.replace(keyword, keywords[keyword]);
    }
    
    return text;
}

function enumChildNodes(parentNode, dicts) {
    var node = parentNode.firstChild;
    
    if (node != null) {
        while (node != null) {
            if (node.nodeType == 3) {
                node.nodeValue = node.nodeValue.replace(/(\n)+|(\r\n)+/g, '')
                node.nodeValue = node.nodeValue.replace(/(^\s*)|(\s*$)/g, '');
                node.nodeValue = escape(node.nodeValue).replace(/(%A0)/g, '20%');
                node.nodeValue = unescape(node.nodeValue);
                
                // for (var i = 0; i < node.nodeValue.length; i++) {
                //     if (node.nodeValue[i].charCodeAt() == 160) {
                //         var kg = node.nodeValue.substring(i, i + 1);
                //         node.nodeValue = node.nodeValue.replace(kg, ' ');
                //     }
                // }

                var dst = dicts[node.nodeValue];

                if (typeof dst === 'undefined' || dst.length === 0 || dst === 'null') {
                    var next = node.nextSibling;
                    node = next;
                    continue;
                }

                var trans = document.createElement("trans");
                trans.setAttribute('data-src', node.nodeValue);
                trans.setAttribute('data-dst', dicts[node.nodeValue]);
                trans.textContent = dst;
                parentNode.insertBefore(trans, node);
                var next = node.nextSibling;
                parentNode.removeChild(node);
                node = next;

                continue;
            }
        
            enumChildNodes(node, dicts);
            node = node.nextSibling;
        }
    }
}

var handler = new Tautologistics.NodeHtmlParser.DefaultHandler(function (error, dom) {
    if (!error) {
        walkParserDom(dom);
        var totalComplateCallback = queryDict.length;
        var url = "http://api.fanyi.baidu.com/api/trans/vip/translate";
        var appid = '20170510000046859';
        var key = 'fAcUl6k8uI_m0b2QQ9DY';

        for (var i = 0; i < queryDict.length; i++) {
            for (var j = 0; j < queryDict[i].length; j++) {
                originDict[queryDict[i][j]] = queryDict[i][j];
                translatedDict[queryDict[i][j]] = queryDict[i][j];
            }

            var query = queryDict[i].join('\n').replace(/(^\n)|(\n$)/g, '');
            var salt = (new Date).getTime();
            var sign = MD5(appid + query + salt +key);

            TranslateApi.getJSON(url, {
                'appid': appid,
                'key': key,
                'q': query,
                'from': from,
                'to':to,
                'salt': salt,
                'sign': sign
            }, function(response) {
                for (var i = 0; i < response.trans_result.length; i++) {
                    translatedDict[response.trans_result[i].src] = response.trans_result[i].dst;
                }
    
                --totalComplateCallback;
    
                if ( totalComplateCallback == 0 ) {
                    enumChildNodes(document.body, translatedDict);
                }
            },function() {
                console.log('load url error');
                --totalComplateCallback

                if ( totalComplateCallback == 0 ) {
                    enumChildNodes(document.body, translatedDict);
                }
            });
        }
    }
});


MAX_REQUEST_LEN = 20;
var queryDict = [];
var cacheDict =[];
var packetDict = [];
var translatedDict = [];
var translateStatus = false;

function walkParserDom(doms) {
    for (var i in doms) {
        if (doms[i].type == 'text') {
            var text = replaceChar(doms[i].data);
            text = text.replace(/(\n)+|(\r\n)+/g, '');
            text = text.replace(/(^\s*)|(\s*$)/g, '');
            text = escape(text).replace(/(%26nbsp%3B)/g, '20%');
            text = unescape(text);
    
            if(text && !hasChar(text)) {
                if (cacheDict.indexOf(text) == -1) {
                    cacheDict.push(text);
                    packetDict.push(text);
                    if ( packetDict.length == MAX_REQUEST_LEN ) {
                        queryDict.push(packetDict);
                        packetDict = [];
                    } 
                }
            }
        } else if (doms[i].type == 'tag') {
            walkParserDom(doms[i].children);
        }
    }
}

function hasChar(text) {
    var filter = ['=', '►', '▼', '◄', '★', '☆', '✘', '›', '', ''];

    if (text.indexOf('{') >= 0 && text.indexOf('}') >= 0 && text.indexOf('=') >= 0) {
        return true;
    }

    if (text == '\n') {
        return true;
    }
    
    if (text == '\r\n') {
        return true;
    }

    for (var i = 0; i < filter.length; i++) {
        if (text.indexOf(filter[i]) >= 0) {
            return true;
        }
    }

    return false;
}

function replaceChar(text) {
    var keywords = {
        '…': "...",
        '&amp': '&',
        '&amp;': '&',
        '&gt;': '>',
        '&nbsp;': ' ',
        '&;': '&'
    };

    for (var keyword in keywords) {
        text = text.replace(keyword, keywords[keyword]);
    }
    
    return text;
}

function enumChildNodes(parentNode, dicts) {
    var node = parentNode.firstChild;
    
    if (node != null) {
        while (node != null) {
            if (node.nodeType == 3) {
                node.nodeValue = node.nodeValue.replace(/(\n)+|(\r\n)+/g, '')
                node.nodeValue = node.nodeValue.replace(/(^\s*)|(\s*$)/g, '');
                node.nodeValue = escape(node.nodeValue).replace(/(%A0)/g, '20%');
                node.nodeValue = unescape(node.nodeValue);
                
                // for (var i = 0; i < node.nodeValue.length; i++) {
                //     if (node.nodeValue[i].charCodeAt() == 160) {
                //         var kg = node.nodeValue.substring(i, i + 1);
                //         node.nodeValue = node.nodeValue.replace(kg, ' ');
                //     }
                // }

                var dst = dicts[node.nodeValue];

                if (typeof dst === 'undefined' || dst.length === 0 || dst === 'null') {
                    var next = node.nextSibling;
                    node = next;
                    continue;
                }

                var trans = document.createElement("trans");
                trans.setAttribute('data-src', node.nodeValue);
                trans.setAttribute('data-dst', dicts[node.nodeValue]);
                trans.textContent = dst;
                parentNode.insertBefore(trans, node);
                var next = node.nextSibling;
                parentNode.removeChild(node);
                node = next;

                continue;
            }
        
            enumChildNodes(node, dicts);
            node = node.nextSibling;
        }
    }
}

var handler = new Tautologistics.NodeHtmlParser.DefaultHandler(function (error, dom) {
    if (!error) {
        walkParserDom(dom);

        var totalComplateCallback = queryDict.length;
        var url = "http://api.fanyi.baidu.com/api/trans/vip/translate";
        var appid = '20170513000047304';
        var key = 'uZeXnPVkpPrURFgf4Ju9';

        for (var i = 0; i < queryDict.length; i++) {
            for (var j = 0; j < queryDict[i].length; j++) {
                translatedDict[queryDict[i][j]] = queryDict[i][j];
            }


            var query = queryDict[i].join('\n').replace(/(^\n)|(\n$)/g, '');
            var salt = (new Date).getTime();
            var sign = MD5(appid + query + salt +key);

            TranslateApi.getJSON(url, {
                'appid': appid,
                'key': key,
                'q': query,
                'from': from,
                'to': to,
                'salt': salt,
                'sign': sign
            }, function(response) { 
                for (var i = 0; i < response.trans_result.length; i++) {
                    translatedDict[response.trans_result[i].src] = response.trans_result[i].dst;
                }
    
                --totalComplateCallback;
    
                if ( totalComplateCallback == 0 ) {
                    enumChildNodes(document.body, translatedDict);
                    // document.querySelector('.translator-widget-loading').style.display = 'none';
                }
            }, function() {
                                 console.log('loading translate url error!');alert(document.body.innerHTML);

                --totalComplateCallback;
                
                if ( totalComplateCallback == 0 ) {
                    enumChildNodes(document.body, translatedDict);
                    // document.querySelector('.translator-widget-loading').style.display = 'none';
                }
            });
        }
    }
});

	to = getBrowserLanguage();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        (function(){
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            (new Tautologistics.NodeHtmlParser.Parser(handler)).parseComplete(document.body.innerHTML);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         })()
