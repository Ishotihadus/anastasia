# frozen_string_literal: true

require_relative 'anastasia/version'

module Anastasia
  def self.convert(data)
    convert_internal(data, [], {})
  end

  def self.convert_internal(data, pos, ret)
    data.each do |k, v|
      if k.start_with?(';')
        append(k[1..], pos, v, ret)
      else
        convert_internal(v, pos + k.split('.'), ret)
      end
    end

    ret
  end

  def self.append(lang, pos, value, ret)
    pos = pos.dup
    ret = (ret[lang] ||= {})
    ret = (ret[pos.shift] ||= {}) while pos.count >= 2
    append_value(lang, pos[0], value, ret)
  end

  def self.append_value(lang, key, value, ret)
    case value
    when String
      ret[key] = value
    when Array
      ret[key] = value.join(no_space_language?(lang) ? '' : ' ')
    when Hash
      value.each do |k, v|
        key_with_context = k == '_' ? key : "#{key}_#{k}"
        append_value(lang, key_with_context, v, ret)
      end
    end
  end

  NO_SPACE_LANGUAGES = %w[ja zh].freeze

  def self.no_space_language?(lang)
    lang = lang.split('-').first.downcase
    NO_SPACE_LANGUAGES.include?(lang)
  end
end
