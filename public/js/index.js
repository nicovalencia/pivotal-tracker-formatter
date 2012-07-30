(function(window, $, Handlebars, _) {

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
      PTF.buildProjectView(stories);
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

  PTF.buildProjectView = function(stories) {
    var total_points = _.reduce(stories, function(init, story) {
      return _.isNumber(story.estimate) ? init + story.estimate : init;
    }, 0);

    var finished_stories = _.filter(stories, function(story) {
      return story.current_state === "accepted";
    });

    var finished_points = _.reduce(finished_stories, function(init, story) {
      return _.isNumber(story.estimate) ? init + story.estimate : init;
    }, 0);

    var source = $('#handlebars-project-summary').html();
    var template = Handlebars.compile(source);
    $('header').after(template({finished_points: finished_points, total_points: total_points}));
  };

  PTF.buildStoriesView = function(stories) {
    var source = $('#handlebars-story-group').html();
    var template = Handlebars.compile(source);
    var $stories = $('#js-stories');

    // group stories by state
    var groups = _.groupBy(stories, "current_state");

    // add each story group
    $.each(groups, function(state, stories) {
      $stories.append(template({state: state, stories: stories}));
    });
  };

  PTF.loader = function(action) {
    $('#js-loader')[action]();
  };

  // events
  $(document).on('submit', '#js-project-select-form', PTF.submitProjectForm);

  window.PTF = PTF;
  $(document).ready(PTF.init);

})(this, jQuery, Handlebars, _);



