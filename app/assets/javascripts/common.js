var init_datetimepciker;
init_datetimepciker = function() {
  return function() {
    return $(".form_datetime").datetimepicker({
      // locale: "ja",
      format: "YYYY/MM/DD HH:mm"
      // sideBySide: true
    });
  };
};
$(document).ready(function() {
  return init_datetimepciker();
});
$(document).on("ready page:load", init_datetimepciker());
