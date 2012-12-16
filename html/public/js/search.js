(function() {

   $(document).ready(function() {

      $("#q").keyup(function(event) {
         var len = $(this).val().length;

         if(len >= 3) {
            // start searching at a length of min. 3 chars
            var search_qry = $("#q").val();
            $(".result_field").load("/search?q=" + search_qry, null, function() {
               $(".result_field").show();
            });
         }
      });

   });

})();
