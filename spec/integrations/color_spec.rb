# frozen_string_literal: true

require_relative '../spec_helper'

describe ImageCompare::Modes::Color do
  let(:path_1) { image_path 'a' }
  let(:path_2) { image_path 'darker' }
  subject { ImageCompare.compare(path_1, path_2, **options) }

  let(:options) { {mode: :color} }

  context 'with colored image' do
    it 'score around 0.94' do
      expect(subject.send(:score)).to be_within(0.005).of(0.94)
    end

    context 'with custom threshold' do
      subject { ImageCompare.compare(path_1, path_2, **options).match? }

      context 'below score' do
        let(:options) { {mode: :color, threshold: 0.01} }

        it { expect(subject).to be_falsey }
      end

      context 'above score' do
        let(:options) { {mode: :color, threshold: 1} }

        it { expect(subject).to be_truthy }
      end

      context 'with lower threshold' do
        let(:options) { {mode: :color, threshold: 0.1, lower_threshold: 0.09} }
        it {
          expect(subject).to be_falsey }
      end
    end
  end

  context 'with different images' do
    let(:path_2) { image_path 'b' }

    it 'score around 0.0057' do
      expect(subject.send(:score)).to be_within(0.0001).of(0.0057)
    end

    it 'creates correct difference image' do
      expect(subject.difference_image).to eq(ImageCompare::Image.from_file(image_path('color_diff')))
    end

    context 'with high tolerance' do
      let(:options) { {mode: :color, tolerance: 0.1} }

      it 'score around 0.01673' do
        expect(subject.send(:score)).to be_within(0.0001).of(0.01673)
      end
    end
  end
end
