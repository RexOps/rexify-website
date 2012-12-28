(function() {
   $(document).ready(function() {
      var to_move = 724;
      if($.browser.msie) {
         $("#nav_img").css("float", "left");
         to_move = 730;
      }
      if($.browser.opera) {
         $("#nav_img").css("float", "left");
      }

      function slide_left() {

         $("#bilderlinie").animate({"left": "-=" + to_move}, 2000, function() {
                  if(parseInt($("#bilderlinie").css("left")) < -1650) {
                     window.setTimeout(function() { slide_right(); }, 7000);
                  }
                  else {
                     window.setTimeout(function() { slide_left(); }, 7000);
                  }
               });

      }

      function slide_right() {
         $("#bilderlinie").animate({"left": "+=" + to_move}, 2000, function() {
                  if(parseInt($("#bilderlinie").css("left")) == 0) { 
                     window.setTimeout(function() { slide_left(); }, 7000);
                  }
                  else {
                     window.setTimeout(function() { slide_right(); }, 7000);
                  }
               
               });
      }

      window.setTimeout(function() { slide_left(); }, 5000);
   });
})();
