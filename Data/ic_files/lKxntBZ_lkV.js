/*!CK:1890004249!*//*1380512181,178179105*/

if (self.CavalryLogger) { CavalryLogger.start_js(["Hu2Vb"]); }

__d("UFIFeaturedReplyCommentList",["UFIReplyCommentList"],function(a,b,c,d,e,f){var g=b('UFIReplyCommentList');for(var h in g)if(g.hasOwnProperty(h))j[h]=g[h];var i=g===null?null:g.prototype;j.prototype=Object.create(i);j.prototype.constructor=j;j.__superConstructor__=g;j.getCommentList=function(k,l){};function j(k,l,m){g.call(this,k,l);var n=0,o=m.length;this.updateCommentCount(o);this.addCommentIDs(n,o,m);m.forEach(function(p){this.addComment(p);}.bind(this));}j.prototype.fetchComments=function(k,l,m){};e.exports=j;});