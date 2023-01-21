require 'google/cloud/translate'

class Translator
  attr_reader :client

  def initialize(credentials_path)
    @client ||= Google::Cloud::Translate.translation_service do |config|
      config.credentials = credentials_path
    end
  end

  def translate(contents, from:, to:)
    request = Google::Cloud::Translate::V3::TranslateTextRequest.new(
      parent: 'projects/caption-capture-375416',
      contents: contents.respond_to?(:to_ary) ? contents.to_ary : [contents],
      source_language_code: from,
      target_language_code: to
    )

    client.translate_text(request)
      .translations
      .map(&:translated_text)
  end
end
