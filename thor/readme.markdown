# Pivotal Tracker Formatter

PTF reads Pivotal Tracker export CSVs and uses custom templates to format the data into reportable material. This is an internal tool I use for SOW creation and project status reports.

![Output](http://github.com/nicovalencia/pivotal-tracker-formatter/raw/master/screen-shot.png "Output")

### Setup

Clone the repository and install gems: `bundle install`

Use Thor to format csv exports:

    thor ptf:format SOURCE_FILE OUTPUT_FILE

Optionally pass custom template name/folder (defaults -> sow):

    thor ptf:format SOURCE_FILE OUTPUT_FILE -t sow

### TODO

  - Export template as PDF
  - Create new templates
  - Create web interface with Pivotal Tracker API integration

