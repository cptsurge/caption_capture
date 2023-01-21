require 'http'
require 'json'
require 'ox'

class CaptionCapture
  attr_reader :video_id

  def initialize(video_id)
    @video_id = video_id
  end

  def fetch(language_code)
    xml = HTTP.get(caption_track_url(language_code)).to_s
    parsed_xml = Ox.load(xml, mode: :hash_no_attrs)

    parsed_xml[:transcript][:text].join(' ')
  end

  def caption_track_url(language_code)
    track = caption_tracks.find { |track| track[:languageCode] == language_code }
    track[:baseUrl]
  end

  def caption_tracks
    json = HTTP.get(video_url).to_s
      .split('"captions":').last
      .split(',"videoDetails').first

    JSON.parse(json, symbolize_names: true)[:playerCaptionsTracklistRenderer][:captionTracks]
  end

  def video_url
    "https://www.youtube.com/watch?v=#{video_id}"
  end
end
