$(".dropdown_link").click(function(event) {
   $(this).parent().find(".dropdown_menu").show();
   event.stopPropagation();
   event.preventDefault();
   return false;
});

$("body").click(function() {
   $(".dropdown_menu").hide();
});
