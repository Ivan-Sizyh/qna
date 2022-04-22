shared_examples_for 'API Add Link' do
  it 'returns list of links' do
    expect(links_response.size).to eq 2
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |attr|
      expect(links_response.first[attr]).to eq link.send(attr).as_json
    end
  end
end
