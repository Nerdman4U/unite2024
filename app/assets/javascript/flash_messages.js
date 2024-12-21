(function(){
var notifiers, showErrorsInResponse, showFlashMessages;

notifiers = {
  success: 'success',
  error: 'error',
  alert: 'block',
  notice: 'info'
};

toastr = {
  info: function(msg) {
    $('.unobtrusive-flash-container').append('<div class="alert alert-dismissable alert-info"><button class="close" data-dismiss="alert" type="button" name="button">&times;</button><h1>'+msg+'</h1></div>')
  },
  success: function(msg) {
    $('.unobtrusive-flash-container').append('<div class="alert alert-dismissable alert-success"><button class="close" data-dismiss="alert" type="button" name="button">&times;</button><h1>'+msg+'</h1></div>')
  },
  alert: function(msg) {
    $('.unobtrusive-flash-container').append('<div class="alert alert-dismissable alert-block"><button class="close" data-dismiss="alert" type="button" name="button">&times;</button><h1>'+msg+'</h1></div>')
  },
  error: function(msg) {
    $('.unobtrusive-flash-container').append('<div class="alert alert-dismissable alert-error"><button class="close" data-dismiss="alert" type="button" name="button">&times;</button><h1>'+msg+'</h1></div>')
  }
}

showFlashMessages = function(jqXHR) {
  var flash;
  if (!jqXHR || !jqXHR.getResponseHeader) return;
  flash = jqXHR.getResponseHeader('X-Flash');
  flash = JSON.parse(flash);
  return _.each(flash, function(message, key) {
    return toastr[notifiers[key]](message);
  });
};

showErrorsInResponse = function(jqXHR) {
  var error, response;
  if (!jqXHR || !jqXHR.responseJSON || !jqXHR.responseJSON.errors) return;
  response = jqXHR.responseJSON;
  error = _.map(response.errors, function(messages, property) {
    return _.map(messages, function(x) {
      return "" + property + " " + x;
    }).join("<br />");
  });
  return toastr.error(error, "ERROR");
};

$(function() {
  return $(document).ajaxComplete(function(event, xhr, settings) {
    showFlashMessages(xhr);
    showErrorsInResponse(xhr);
    result = 0;
    if (xhr.responseJSON) result = xhr.responseJSON.errors;
    return result;
  });
});
})(this)
