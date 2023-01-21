require 'sinatra'
require_relative 'caption_capture'
require_relative 'translator'

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
  @unique_words = @words.uniq

  @translator = Translator.new('creds.json')
  @translations = @translator.translate(@unique_words, from: @language, to: :en)
  @translations_map = @unique_words.zip(@translations).to_h

  @word_counts = @words.tally
    .select { |k, v| v >= 3 } # only show words used at least 3 times
    .select { |k, v| k.length >= 3 } # only show words at least 3 letters long
    .sort_by { |k, v| v }
    .reverse

  erb :show
end
