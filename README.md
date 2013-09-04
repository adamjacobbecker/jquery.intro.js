jquery.intro.js
===============

looks like this: 

![screenshot](http://cl.ly/image/2k1O3t1V2G3q/Screen%20Shot%202013-09-04%20at%2011.11.05%20AM.png)

jQuery fork of [usablica/intro.js](https://github.com/usablica/intro.js) with a slightly different API. also relies on the bootstrap popover plugin. call it like this:

```javascript
$.intro([
  {
    el: "#new-user-link",
    text: "This is the new user link."
  },
  {
    el: function(){
      // you can also use a function here
      if (window.location.hash === '#comments') {
        return $(".comments");
      } else {
        return $(".something-else");
      }
    },
    text: "That was rad!",
    position: "top" // or 'left' or 'right'. defaults to 'bottom'
  },
  {
    el: "a:eq(0):contains('delete')",
    text: "This link deletes something."
  }
])
```
