jquery.intro.js
===============

jQuery fork of [usablica/intro.js](https://github.com/usablica/intro.js) with a slightly different API. call it like this:

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
    text: "That was rad!"
  },
  {
    el: "a:eq(0):contains('delete')",
    text: "This link deletes something."
  }
])
```