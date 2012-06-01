class Parser

  def initialize(csv, save_location, options)
    @label = options[:label]
    @csv = csv
    @save_location = save_location
    @stories = []
    @style = File.read("templates/sow/style.css")
    parse()
  end

  def parse

    # load file
    csv = CSV.read(@csv, { :encoding => "UTF-8" })

    # remove headers
    headers = csv.slice!(0)

    # count comment columns
    comment_count = 0
    headers.each do |column|
      comment_count += 1 if column == "Comment"
    end

    # build stories hash
    csv.each do |story|

      # only include label
      next if @label && !story[2].include?(@label)

      item = {
        :id              => story.shift,
        :name            => story.shift,
        :tags            => story.shift,
        :iteration       => story.shift,
        :iteration_start => story.shift,
        :iteration_end   => story.shift,
        :type            => story.shift,
        :points          => story.shift || 0,
        :state           => story.shift,
        :created_at      => story.shift,
        :accepted_at     => story.shift,
        :deadline        => story.shift,
        :requested_by    => story.shift,
        :owned_by        => story.shift,
        :description     => story.shift,
        :url             => story.shift,
        :comments         => [],
        :tasks           => []
      }

      # append comments
      comment_count.times do |i|
        item[:comments].push(story.shift)
      end

      # append tasks
      story.each_slice(2) do |task|
        item[:tasks].push({
          :description => task[0],
          :state      => task[1]
        })
      end

      @stories.push item

    end

  end

  def write(template)
    template ||= "sow"
    begin
      layout = File.read("templates/#{template}/layout.erb")
      output = ERB.new(layout).result(binding)
      File.new(@save_location, "w+").puts output
    rescue Errno::ENOENT
      puts "[x] #{template} is not a valid template."
    end
  end

end

