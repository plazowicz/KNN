/*1364307589,173220389*/

if (self.CavalryLogger) { CavalryLogger.start_js(["vxsWQ"]); }

__d("BirthdayReminder",["Animation","Event","DOM","tx"],function(a,b,c,d,e,f){var g=b('Animation'),h=b('Event'),i=b('DOM'),j=b('tx'),k={registerWallpostHandler:function(l){h.listen(l,'error',function(event,m){i.setContent(l,"Wyst\u0105pi\u0142 b\u0142\u0105d podczas wysy\u0142ania postu.");return false;});},registerCommentHandler:function(l,m){h.listen(l,'error',function(event,n){i.setContent(l,"Wyst\u0105pi\u0142 b\u0142\u0105d podczas dodawania komentarza.");return false;});h.listen(l,'success',function(event,n){i.replace(l,m);new g(m).duration(1000).checkpoint().to('backgroundColor','#FFFFFF').from('borderColor','#FFE222').to('borderColor','#FFFFFF').go();});}};e.exports=k;});