require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { is_expected.to validate_url_of(:url) }

  describe 'methods' do
    context 'is_gist? method' do
      let(:question) { create(:question) }
      let(:link) { create(:link, name: 'link', url: 'https://www.youtube.com', linkable: question) }
      let(:gist) { create(:link, name: 'gist', url: 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c', linkable: question) }

      it 'link is gist' do
        expect(gist).to be_is_gist
      end

      it 'link is not gist' do
        expect(link).to_not be_is_gist
      end
    end
  end
end
