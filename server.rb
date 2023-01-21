require 'sinatra'
require_relative 'caption_capture'

get '/' do
  erb :index
end

post '/video' do
  @video_id = params['video_id']
  @language = params['language']

  @capture = CaptionCapture.new(@video_id)
  @captions = @capture.fetch(@language)
  @video_url = @capture.video_url
  @words = @captions.split(' ').sort

  @word_counts = @words.tally
    .select { |k, v| v >= 3 } # only show words used at least 3 times
    .sort_by { |k, v| v }
    .reverse

  erb :show
end
