shared_examples_for 'API Add Comment' do
  it 'returns list of comments' do
    expect(comments_response.size).to eq 2
  end

  it 'returns all public fields' do
    %w[id text created_at updated_at].each do |attr|
      expect(comments_response.first[attr]).to eq comment.send(attr).as_json
    end
  end
end
