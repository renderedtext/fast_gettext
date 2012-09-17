class TranslationKey < ActiveRecord::Base
  has_many :translations, :class_name => 'TranslationText', :dependent => :destroy

  accepts_nested_attributes_for :translations, :allow_destroy => true

  validates_uniqueness_of :key
  validates_presence_of :key

  attr_accessible :key, :translations, :translations_attributes

  def self.translation(key, locale)
    return unless translation_key = find_by_key(key)
    return unless translation_text = translation_key.translations.find_by_locale(locale)

    text = translation_text.text

    return text if text.nil?
    return eval(text) if text.at(0) == "[" and text.at(-1) == "]"
  end

  def self.available_locales
    @@available_locales ||= TranslationText.count(:group=>:locale).keys.sort
  end
end
