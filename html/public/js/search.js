(function() {

   $(document).ready(function() {

      $("#q").keyup(function(event) {
         var len = $(this).val().length;

         if(event.keyCode == 27) {
            $(".result_field").hide().html("");
            $("#q").val("");
            return;
         }

         if(len >= 3) {
            // start searching at a length of min. 3 chars
            var search_qry = $("#q").val();
            $(".result_field").load("/search?q=" + search_qry, null, function() {

               $(".search_button").click(function() {
                  $(".result_field").hide().html("");
                  $("#q").val("");
               });

               $(".result_field").show();

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
