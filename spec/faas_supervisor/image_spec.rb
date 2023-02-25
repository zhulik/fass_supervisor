# frozen_string_literal: true

RSpec.describe FaasSupervisor::Image do
  subject { described_class.new(image:, image_id:) }

  let(:image) { "ghcr.io/zhulik/fn-dummy:latest" }
  let(:image_id) { "ghcr.io/zhulik/fn-dummy@sha256:7a96ca69409b3dfd94dec43a0d9f3ea7f437dbbe4e8bbee19bd573fe4719c275" }

  describe "#registry" do
    it "returns registry" do
      expect(subject.registry).to eq("ghcr.io")
    end
  end

  describe "#tag" do
    it "returns tag" do
      expect(subject.tag).to eq("latest")
    end
  end

  describe "#digest" do
    it "returns digest" do
      expect(subject.digest).to eq("7a96ca69409b3dfd94dec43a0d9f3ea7f437dbbe4e8bbee19bd573fe4719c275")
    end
  end
end