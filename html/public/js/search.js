(function() {

   $(document).ready(function() {

      $("#q").keyup(function(event) {
         var len = $(this).val().length;

         if(event.keyCode == 27) {
            $(".result_field").hide().html("");
            $("#q").val("");
            return;
         }

         $(".result_field").css("height", "");

         if(len >= 3) {
            // start searching at a length of min. 3 chars
            var search_qry = $("#q").val();
            console.log("qry: " + encodeURIComponent(search_qry));
            $(".result_field").load("/search?q=" + encodeURIComponent(search_qry), null, function() {

               $(".search_button").click(function() {
                  $(".result_field").hide().html("");
                  $("#q").val("");
               });

               var screen_width = $(window).width();
               var start_pos = -500;

               var search_box_left = $("#q").offset().left;
               var search_box_top = $("#q").offset().top;
               var search_box_width = $("#q").width();

               var right_pos = search_box_left + search_box_width;
               var search_width = right_pos - 100 - 20;

               console.log("right_pos: " + right_pos);

               start_pos = 100; //right_pos;

               $(".result_field").css("left", start_pos)
                        .width(search_width)
                        .css("top", search_box_top + $("#q").height()+10);

               $(".result_field").css("visibility", "hidden");
               $(".result_field").show();

               if($(".result_field").height() > $(window).height() - 100) {
                  $(".result_field").height($(window).height() - 100).css("overflow", "auto");
               }

               $(".result_field").css("visibility", "visible");


            });
         }
      });

      Mousetrap.bind("esc", function(e) {
         $(".result_field").hide().html("");
         $("#q").val("");
         return false;
      });
      
      Mousetrap.bind("alt+f", function(e) {
         $("#q").focus();
         return false;
      });

   });

})();
