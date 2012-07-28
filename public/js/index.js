(function(window, $) {

  var PTF = {};

  PTF.init = function() {
    PTF.fetchProjects().done(PTF.buildProjectSelect);
  };

  PTF.fetchProjects = function() {
    return $.ajax({
      url: "/projects",
      type: "GET",
      dataType: "json"
    });
  };

  PTF.buildProjectSelect = function(projects) {
    var $form = $('#js-project-select-form');
    var $select = $form.find('select');
    var $submit = $form.find('input');
    
    $select.empty();
    $submit.attr('disabled', false);

    $.each(projects, function(i, project) {
      var option = $('<option/>', { value: project.id, text: project.name });
      $select.append(option);
    });
  };

  PTF.submitProjectForm = function(e) {
    e.preventDefault();
    var id = $(e.target).find('select').val();

    PTF.loader('show');
    PTF.fetchStories(id).done(function(stories) {
      PTF.loader('hide');
      PTF.buildStoriesView(stories);
      $(e.target).hide();
    });
  };

  PTF.fetchStories = function(id) {
    return $.ajax({
      url: "/projects/" + id + "/stories",
      type: "GET",
      dataType: "json"
    });
  };

  PTF.buildStoriesView = function(stories) {
    console.log(stories);
  };

  PTF.loader = function(action) {
    $('#js-loader')[action]();
  };

  $(document).on('submit', '#js-project-select-form', PTF.submitProjectForm);

  window.PTF = PTF;
  $(document).ready(PTF.init);

})(this, jQuery);
