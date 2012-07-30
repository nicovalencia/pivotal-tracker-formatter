require 'sinatra'
require 'json'
require 'pivotal-tracker'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV['HTTP_USERNAME'], ENV['HTTP_PASSWORD']]
end

PivotalTracker::Client.token = ENV['TRACKER_API_TOKEN']

get '/' do
  erb :index
end

# return an array of projects
get '/projects' do
  projects = []
  PivotalTracker::Project.all.each do |project|
    projects.push({
      :id => project.id,
      :name => project.name,
      :account => project.account,
      :week_start_day => project.week_start_day,
      :point_scale => project.point_scale,
      :labels => project.labels,
      :velocity_scheme => project.velocity_scheme,
      :iteration_length => project.iteration_length,
      :initial_velocity => project.initial_velocity,
      :current_velocity => project.current_velocity,
      :last_activity_at => project.last_activity_at,
      :use_https => project.use_https,
      :first_iteration_start_time => project.first_iteration_start_time,
      :current_iteration_number => project.current_iteration_number,
    })
  end

  return projects.to_json
end

# return an array of stories for a given project
get '/projects/:id/stories' do
  project = PivotalTracker::Project.find(params[:id])  
  
  stories = []
  project.stories.all.each do |story|
    stories.push({
      :id => story.id,
      :url => story.url,
      :created_at => story.created_at,
      :accepted_at => story.accepted_at,
      :project_id => story.project_id,
      :name => story.name,
      :description => story.description,
      :story_type => story.story_type,
      :estimate => story.estimate,
      :current_state => story.current_state,
      :requested_by => story.requested_by,
      :owned_by => story.owned_by,
      :labels => story.labels,
      :jira_id => story.jira_id,
      :jira_url => story.jira_url,
      :other_id => story.other_id,
      :integration_id => story.integration_id,
      :deadline => story.deadline,
      :attachments => story.attachments
    })
  end

  return stories.to_json
end
