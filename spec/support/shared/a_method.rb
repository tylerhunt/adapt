shared_examples_for "a method" do
  let(:response) do
    use_cached_requests(:scope => response_fixture, :record => :new) do
      json = service.request(
        described_class.name.split(/::/).last,
        described_class::Request.new(request_attributes)
      ).body

      described_class::Response.new.from_json(json)
    end
  end
end
