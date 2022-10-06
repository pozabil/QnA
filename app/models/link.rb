class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  before_validation :before_validation_smart_formatting_url

  validates :name, :url, presence: true
  validate :validate_url_format

  def self.format_url(url)
    if url.present?
      url = url.strip
      url = 'http://' + url unless url.match?(/^https?/i)
    end
    url
  end

  private

  def before_validation_smart_formatting_url
    self.url = self.class.format_url(url)
  end

  def validate_url_format
    errors.add(:url, I18n.t('errors.messages.invalid')) unless valid_url?(url)
  end

  def valid_url?(url)
    return false if url.blank?
    uri = URI(url)
    uri.scheme && ['http', 'https'].include?(uri.scheme) &&
      uri.host && uri.host.split('.').size > 1 && uri.host.split('.').all?(&:present?)
  rescue URI::BadURIError, URI::InvalidURIError
    false
  end
end
