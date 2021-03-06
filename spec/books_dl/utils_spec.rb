describe BooksDL::Utils do
  let(:download_token) { file_fixture('download_token.txt').read }
  let(:url) { 'https://streaming-ebook.books.com.tw/V1.0/Streaming/book/DD0CB3/952170/OEBPS/content.opf' }
  let(:url2) { 'https://streaming-ebook.books.com.tw/V1.0/Streaming/book/DD0CB3/952170/META-INF/container.xml' }

  describe '.hex_to_byte' do
    let(:hex) { 'ABCDEFG987654321' }
    let(:bytes_array) { [171, 205, 239, 0, 135, 101, 67, 33] }

    it 'return empty array when input is nil' do
      return_value = described_class.hex_to_byte(nil)

      expect(return_value).to be_a Array
      expect(return_value).to be_empty
    end

    it 'return byte array correctly' do
      return_value = described_class.hex_to_byte(hex)

      expect(return_value).to be_a Array
      expect(return_value).to eq bytes_array
    end
  end

  describe '.generate_key' do
    let(:decode) { [101, 87, 67, 247, 38, 70, 65, 140, 139, 83, 14, 193, 211, 197, 38, 225, 48, 35, 79, 108, 47, 47, 191, 253, 44, 205, 93, 130, 226, 96, 203, 82] }
    let(:decode2) { [125, 142, 71, 182, 184, 151, 206, 229, 41, 53, 224, 96, 131, 141, 200, 22, 28, 118, 85, 249, 243, 74, 28, 193, 218, 219, 4, 243, 201, 221, 108, 117] }

    it 'return decode bytes array' do
      return_value = described_class.generate_key(url, download_token)

      expect(return_value).to be_a Array
      expect(return_value).to eq decode
    end

    it 'return decode2 bytes array' do
      return_value = described_class.generate_key(url2, download_token)

      expect(return_value).to be_a Array
      expect(return_value).to eq decode2
    end
  end

  describe '.decode_xor' do
    let(:key) { described_class.generate_key(url, download_token) }
    let(:encrypted_content_opf) { file_fixture('encrypted_content.opf').read }
    let(:content_opf) { file_fixture('content.opf').read }

    let(:key2) { described_class.generate_key(url2, download_token) }
    let(:encrypted_container_xml) { file_fixture('encrypted_container.xml').read }
    let(:container_xml) { file_fixture('container.xml').read }

    it 'return decoded content opf' do
      return_value = described_class.decode_xor(key, encrypted_content_opf)

      expect(return_value).to eq content_opf
    end

    it 'return decoded container.xml' do
      return_value = described_class.decode_xor(key2, encrypted_container_xml)

      expect(return_value).to eq container_xml
    end
  end
end
