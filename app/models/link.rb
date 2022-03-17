class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def is_gist?
    url.include?('gist.github.com')
  end
end
